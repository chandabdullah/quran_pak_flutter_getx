import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class DuaCategory {
  final String id;
  final String en;
  final String ur;

  const DuaCategory({required this.id, required this.en, required this.ur});

  factory DuaCategory.fromJson(Map<String, dynamic> j) =>
      DuaCategory(id: j['id'], en: j['en'], ur: j['ur']);
}

class Dua {
  final int id;
  final String category;
  final String titleEn;
  final String titleUr;
  final String arabic;
  final String transliteration;
  final String english;
  final String urdu;
  final String reference;

  const Dua({
    required this.id,
    required this.category,
    required this.titleEn,
    required this.titleUr,
    required this.arabic,
    required this.transliteration,
    required this.english,
    required this.urdu,
    required this.reference,
  });

  factory Dua.fromJson(Map<String, dynamic> j) => Dua(
        id: j['id'],
        category: j['category'] ?? '',
        titleEn: j['title_en'] ?? '',
        titleUr: j['title_ur'] ?? '',
        arabic: j['arabic'] ?? '',
        transliteration: j['transliteration'] ?? '',
        english: j['english'] ?? '',
        urdu: j['urdu'] ?? '',
        reference: j['reference'] ?? '',
      );

  /// Lower-cased haystack for searching by title, translation or reference.
  String get searchText =>
      "$titleEn $titleUr $english $urdu $transliteration $reference"
          .toLowerCase();
}

class DuaService {
  DuaService._();

  static List<Dua>? _duas;
  static List<DuaCategory>? _categories;

  static Future<void> _ensureLoaded() async {
    if (_duas != null) return;
    final raw = await rootBundle.loadString('assets/duas.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    _categories = (data['categories'] as List)
        .map((e) => DuaCategory.fromJson(e as Map<String, dynamic>))
        .toList();
    _duas = (data['duas'] as List)
        .map((e) => Dua.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<DuaCategory>> getCategories() async {
    await _ensureLoaded();
    return _categories!;
  }

  static Future<List<Dua>> getDuas() async {
    await _ensureLoaded();
    return _duas!;
  }
}
