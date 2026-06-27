part of 'my_shared_pref.dart';

/// A single saved location in the Quran (surah + verse).
class QuranBookmark {
  final int surah;
  final int verse;
  final String surahName;
  final int savedAt; // millisecondsSinceEpoch

  QuranBookmark({
    required this.surah,
    required this.verse,
    required this.surahName,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
        'surah': surah,
        'verse': verse,
        'surahName': surahName,
        'savedAt': savedAt,
      };

  factory QuranBookmark.fromJson(Map<dynamic, dynamic> json) => QuranBookmark(
        surah: json['surah'],
        verse: json['verse'],
        surahName: json['surahName'] ?? '',
        savedAt: json['savedAt'] ?? 0,
      );
}

/// Persists per-verse bookmarks and the "last read" position for the Quran.
class MyBookmark {
  static final GetStorage _storage = GetStorage();

  static const String _bookmarksKey = 'quran_bookmarks';
  static const String _lastReadKey = 'quran_last_read';

  static String _id(int surah, int verse) => '$surah:$verse';

  // --------------------------------------------------------------------------
  // Bookmarks
  // --------------------------------------------------------------------------

  static List<QuranBookmark> getBookmarks() {
    final raw = _storage.read(_bookmarksKey);
    if (raw is! List) return [];
    final list = raw
        .map((e) => QuranBookmark.fromJson(e as Map))
        .toList()
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return list;
  }

  static bool isBookmarked(int surah, int verse) =>
      getBookmarks().any((b) => b.surah == surah && b.verse == verse);

  static void _save(List<QuranBookmark> bookmarks) {
    _storage.write(
      _bookmarksKey,
      bookmarks.map((e) => e.toJson()).toList(),
    );
  }

  /// Adds or removes a bookmark; returns the new bookmarked state.
  static bool toggleBookmark({
    required int surah,
    required int verse,
    required String surahName,
    required int savedAt,
  }) {
    final bookmarks = getBookmarks();
    final existing = _id(surah, verse);
    final wasBookmarked =
        bookmarks.any((b) => _id(b.surah, b.verse) == existing);

    if (wasBookmarked) {
      bookmarks.removeWhere((b) => _id(b.surah, b.verse) == existing);
      _save(bookmarks);
      return false;
    } else {
      bookmarks.add(QuranBookmark(
        surah: surah,
        verse: verse,
        surahName: surahName,
        savedAt: savedAt,
      ));
      _save(bookmarks);
      return true;
    }
  }

  static void removeBookmark(int surah, int verse) {
    final bookmarks = getBookmarks()
      ..removeWhere((b) => b.surah == surah && b.verse == verse);
    _save(bookmarks);
  }

  // --------------------------------------------------------------------------
  // Last read
  // --------------------------------------------------------------------------

  static void setLastRead({
    required int surah,
    required int verse,
    required String surahName,
    required int savedAt,
  }) {
    _storage.write(
      _lastReadKey,
      QuranBookmark(
        surah: surah,
        verse: verse,
        surahName: surahName,
        savedAt: savedAt,
      ).toJson(),
    );
  }

  static QuranBookmark? getLastRead() {
    final raw = _storage.read(_lastReadKey);
    if (raw is! Map) return null;
    return QuranBookmark.fromJson(raw);
  }
}
