part of 'my_shared_pref.dart';

/// A saved verse (the "heart" / favourites list). The user can save many.
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

/// The single "continue reading" mark. There is at most one of these in the
/// whole Quran. It is either:
///  - automatic: silently follows where the reader stops scrolling, or
///  - manual: pinned by the user to a specific verse (auto-detect is paused).
class ContinueMark {
  final int surah;
  final int verse;
  final String surahName;
  final bool isManual;

  ContinueMark({
    required this.surah,
    required this.verse,
    required this.surahName,
    required this.isManual,
  });

  Map<String, dynamic> toJson() => {
        'surah': surah,
        'verse': verse,
        'surahName': surahName,
        'isManual': isManual,
      };

  factory ContinueMark.fromJson(Map<dynamic, dynamic> json) => ContinueMark(
        surah: json['surah'],
        verse: json['verse'],
        surahName: json['surahName'] ?? '',
        isManual: json['isManual'] == true,
      );
}

/// Persists saved verses (favourites) and the single continue-reading mark.
class MyBookmark {
  static final GetStorage _storage = GetStorage();

  static const String _savedKey = 'quran_saved_verses';
  static const String _continueKey = 'quran_continue';

  /// Bumped whenever the continue mark changes, so every visible verse tile
  /// can refresh and only the single current bookmark stays highlighted.
  static final ValueNotifier<int> continueRevision = ValueNotifier(0);
  static void _notify() => continueRevision.value++;

  static String _id(int surah, int verse) => '$surah:$verse';

  // --------------------------------------------------------------------------
  // Saved verses (heart / favourites — many)
  // --------------------------------------------------------------------------

  static List<QuranBookmark> getSavedVerses() {
    final raw = _storage.read(_savedKey);
    if (raw is! List) return [];
    return raw.map((e) => QuranBookmark.fromJson(e as Map)).toList()
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  static bool isSaved(int surah, int verse) =>
      getSavedVerses().any((b) => b.surah == surah && b.verse == verse);

  static void _saveList(List<QuranBookmark> list) {
    _storage.write(_savedKey, list.map((e) => e.toJson()).toList());
  }

  /// Adds/removes a saved verse; returns the new saved state.
  static bool toggleSavedVerse({
    required int surah,
    required int verse,
    required String surahName,
    required int savedAt,
  }) {
    final list = getSavedVerses();
    final id = _id(surah, verse);
    final wasSaved = list.any((b) => _id(b.surah, b.verse) == id);
    if (wasSaved) {
      list.removeWhere((b) => _id(b.surah, b.verse) == id);
      _saveList(list);
      return false;
    }
    list.add(QuranBookmark(
      surah: surah,
      verse: verse,
      surahName: surahName,
      savedAt: savedAt,
    ));
    _saveList(list);
    return true;
  }

  static void removeSavedVerse(int surah, int verse) {
    final list = getSavedVerses()
      ..removeWhere((b) => b.surah == surah && b.verse == verse);
    _saveList(list);
  }

  // --------------------------------------------------------------------------
  // Continue mark (single)
  // --------------------------------------------------------------------------

  static ContinueMark? getContinue() {
    final raw = _storage.read(_continueKey);
    if (raw is! Map) return null;
    return ContinueMark.fromJson(raw);
  }

  /// Updates the auto position as the reader scrolls — but never overrides a
  /// manual mark (manual pins the continue point until the user removes it).
  static void setAutoContinue({
    required int surah,
    required int verse,
    required String surahName,
  }) {
    final current = getContinue();
    if (current != null && current.isManual) return;
    _storage.write(
      _continueKey,
      ContinueMark(
        surah: surah,
        verse: verse,
        surahName: surahName,
        isManual: false,
      ).toJson(),
    );
    // No _notify() here: auto updates happen on every scroll frame and never
    // change verse highlighting (auto is never the manual mark).
  }

  /// Pins the continue mark to a specific verse and turns auto-detect off.
  static void setManualMark({
    required int surah,
    required int verse,
    required String surahName,
  }) {
    _storage.write(
      _continueKey,
      ContinueMark(
        surah: surah,
        verse: verse,
        surahName: surahName,
        isManual: true,
      ).toJson(),
    );
    _notify();
  }

  /// Removes the manual pin and lets auto-detect resume from the same spot.
  static void clearManualMark() {
    final current = getContinue();
    if (current == null) return;
    _storage.write(
      _continueKey,
      ContinueMark(
        surah: current.surah,
        verse: current.verse,
        surahName: current.surahName,
        isManual: false,
      ).toJson(),
    );
    _notify();
  }

  /// True when the given verse is the user's manual continue mark.
  static bool isManualMarkAt(int surah, int verse) {
    final c = getContinue();
    return c != null && c.isManual && c.surah == surah && c.verse == verse;
  }
}
