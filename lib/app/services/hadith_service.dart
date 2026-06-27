import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

/// ===========================================================================
/// Models
/// ===========================================================================

/// One of the six canonical collections, as listed in the bundled manifest.
class HadithBook {
  final String book; // id, e.g. "bukhari"
  final String nameEn;
  final String nameAr;
  final int total;
  final int sections;
  final String file;

  const HadithBook({
    required this.book,
    required this.nameEn,
    required this.nameAr,
    required this.total,
    required this.sections,
    required this.file,
  });

  factory HadithBook.fromJson(Map<String, dynamic> json) => HadithBook(
        book: json['book'],
        nameEn: json['name_en'],
        nameAr: json['name_ar'],
        total: json['total'] ?? 0,
        sections: json['sections'] ?? 0,
        file: json['file'],
      );
}

/// A "book"/chapter inside a collection (e.g. "Belief", "Knowledge").
class HadithSection {
  final int number;
  final String en;
  final String ar;
  final String ur;
  final int? first;
  final int? last;

  const HadithSection({
    required this.number,
    required this.en,
    required this.ar,
    required this.ur,
    this.first,
    this.last,
  });
}

/// A single hadith with its Arabic text and Urdu/English translations.
class HadithItem {
  final int number; // global number within the collection
  final int? sectionNumber; // owning section/book number
  final String arabic;
  final String urdu;
  final String english;
  final List<String> grades;

  const HadithItem({
    required this.number,
    required this.sectionNumber,
    required this.arabic,
    required this.urdu,
    required this.english,
    required this.grades,
  });

  factory HadithItem.fromJson(Map<String, dynamic> json) => HadithItem(
        number: json['n'],
        sectionNumber: json['b'],
        arabic: json['ar'] ?? '',
        urdu: json['ur'] ?? '',
        english: json['en'] ?? '',
        grades: (json['g'] as List?)?.map((e) => e.toString()).toList() ?? [],
      );
}

/// A fully loaded collection (sections + every hadith), used for browsing.
class HadithCollection {
  final String book;
  final String nameEn;
  final String nameAr;
  final int total;
  final Map<int, HadithSection> sections;
  final List<HadithItem> hadiths;

  const HadithCollection({
    required this.book,
    required this.nameEn,
    required this.nameAr,
    required this.total,
    required this.sections,
    required this.hadiths,
  });

  String sectionName(int? number, {String lang = 'en'}) {
    final s = sections[number];
    if (s == null) return '';
    return switch (lang) {
      'ar' => s.ar,
      'ur' => s.ur,
      _ => s.en,
    };
  }
}

/// A search hit, carrying enough context to render a result row.
class HadithSearchResult {
  final String book; // collection id
  final String bookName; // collection english name
  final HadithItem hadith;
  final String sectionEn;

  const HadithSearchResult({
    required this.book,
    required this.bookName,
    required this.hadith,
    required this.sectionEn,
  });
}

/// ===========================================================================
/// Service
/// ===========================================================================

class HadithService {
  HadithService._();

  static List<HadithBook>? _books;

  /// Small LRU cache of fully-parsed collections for browsing (kept small to
  /// bound memory — each collection can be several MB once decoded).
  static final Map<String, HadithCollection> _cache = {};
  static const int _maxCached = 2;

  /// Loads the manifest listing the six collections.
  static Future<List<HadithBook>> getBooks() async {
    if (_books != null) return _books!;
    final raw = await rootBundle.loadString('assets/hadith/manifest.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    _books = (data['books'] as List)
        .map((e) => HadithBook.fromJson(e as Map<String, dynamic>))
        .toList();
    return _books!;
  }

  /// Loads (and caches) a full collection for browsing. JSON decoding happens
  /// off the UI thread via [compute] to keep scrolling smooth.
  static Future<HadithCollection> loadCollection(String book) async {
    final cached = _cache[book];
    if (cached != null) return cached;

    final raw = await rootBundle.loadString('assets/hadith/$book.json');
    final collection = await compute(_parseCollection, raw);

    // Evict the oldest entry if the cache is full.
    if (_cache.length >= _maxCached && _cache.isNotEmpty) {
      _cache.remove(_cache.keys.first);
    }
    _cache[book] = collection;
    return collection;
  }

  /// Filters an already-loaded collection. Used for fast in-book search.
  /// Matches hadith number, section/book name, or any word in the
  /// Arabic / Urdu / English text.
  static List<HadithItem> searchInCollection(
    HadithCollection collection,
    String query,
  ) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return collection.hadiths;
    final qNum = int.tryParse(q);

    return collection.hadiths.where((h) {
      if (qNum != null && h.number == qNum) return true;
      if (h.arabic.toLowerCase().contains(q)) return true;
      if (h.urdu.toLowerCase().contains(q)) return true;
      if (h.english.toLowerCase().contains(q)) return true;
      final section = collection.sections[h.sectionNumber];
      if (section != null &&
          (section.en.toLowerCase().contains(q) ||
              section.ur.toLowerCase().contains(q) ||
              section.ar.toLowerCase().contains(q))) {
        return true;
      }
      return false;
    }).toList();
  }

  /// Searches across all six collections. Each book is decoded and filtered
  /// inside a background isolate so only the matching rows cross back to the
  /// UI thread (keeps memory and jank low). [limit] caps total results.
  static Future<List<HadithSearchResult>> searchAll(
    String query, {
    int limit = 200,
  }) async {
    final q = query.trim();
    if (q.isEmpty) return [];

    final books = await getBooks();
    final results = <HadithSearchResult>[];

    for (final book in books) {
      if (results.length >= limit) break;
      final raw = await rootBundle.loadString(book.file);
      final matches = await compute(_searchRaw, {
        'raw': raw,
        'query': q,
        'limit': limit - results.length,
      });
      for (final m in matches) {
        results.add(HadithSearchResult(
          book: book.book,
          bookName: book.nameEn,
          sectionEn: (m['sectionEn'] ?? '').toString(),
          hadith: HadithItem.fromJson(m['hadith'] as Map<String, dynamic>),
        ));
      }
    }
    return results;
  }
}

/// ===========================================================================
/// Isolate entry points (top-level, required by [compute])
/// ===========================================================================

HadithCollection _parseCollection(String raw) {
  final data = jsonDecode(raw) as Map<String, dynamic>;

  final sections = <int, HadithSection>{};
  (data['sections'] as Map<String, dynamic>).forEach((key, value) {
    final num = int.tryParse(key);
    if (num == null) return;
    final v = value as Map<String, dynamic>;
    sections[num] = HadithSection(
      number: num,
      en: v['en'] ?? '',
      ar: v['ar'] ?? '',
      ur: v['ur'] ?? '',
      first: v['first'],
      last: v['last'],
    );
  });

  final hadiths = (data['hadiths'] as List)
      .map((e) => HadithItem.fromJson(e as Map<String, dynamic>))
      .toList();

  return HadithCollection(
    book: data['book'],
    nameEn: data['name_en'],
    nameAr: data['name_ar'],
    total: data['total'] ?? hadiths.length,
    sections: sections,
    hadiths: hadiths,
  );
}

List<Map<String, dynamic>> _searchRaw(Map<String, dynamic> args) {
  final data = jsonDecode(args['raw'] as String) as Map<String, dynamic>;
  final q = (args['query'] as String).trim().toLowerCase();
  final qNum = int.tryParse(q);
  final limit = args['limit'] as int;
  final sections = data['sections'] as Map<String, dynamic>;

  final out = <Map<String, dynamic>>[];
  for (final h in (data['hadiths'] as List)) {
    final hadith = h as Map<String, dynamic>;
    final section = sections['${hadith['b']}'] as Map<String, dynamic>?;

    bool matched = qNum != null && hadith['n'] == qNum;
    if (!matched) {
      final ar = (hadith['ar'] ?? '').toString().toLowerCase();
      final ur = (hadith['ur'] ?? '').toString().toLowerCase();
      final en = (hadith['en'] ?? '').toString().toLowerCase();
      final secEn = (section?['en'] ?? '').toString().toLowerCase();
      final secUr = (section?['ur'] ?? '').toString().toLowerCase();
      final secAr = (section?['ar'] ?? '').toString().toLowerCase();
      matched = ar.contains(q) ||
          ur.contains(q) ||
          en.contains(q) ||
          secEn.contains(q) ||
          secUr.contains(q) ||
          secAr.contains(q);
    }

    if (matched) {
      out.add({'hadith': hadith, 'sectionEn': section?['en'] ?? ''});
      if (out.length >= limit) break;
    }
  }
  return out;
}
