import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_flutter/quran_flutter.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SurahDetailController extends GetxController {
  bool isLoading = true;

  /// Drives the verse list and lets us jump/scroll to a specific verse.
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  int surahNumber = Get.arguments["surah"];

  /// Optional verse to scroll to on open (e.g. from a bookmark / last read).
  int? targetVerse = Get.arguments["verse"];

  // Surah
  Surah? surah;
  List<Verse> surahArabicAya = [];

  @override
  void onInit() {
    super.onInit();
    itemPositionsListener.itemPositions.addListener(_onScroll);
    getSurahDetail(initialVerse: targetVerse);
  }

  Future<void> getSurahDetail({int? initialVerse}) async {
    isLoading = true;
    update();

    surah = Quran.getSurah(surahNumber);
    surahArabicAya = Quran.getSurahVersesAsList(surahNumber);

    if ((surah?.verseCount ?? 0) > 100) await .3.delay();

    isLoading = false;
    update();

    // Save where the reader is starting, and animate to the target verse.
    _saveLastRead(initialVerse ?? 1);
    if (initialVerse != null && initialVerse > 1) {
      // Wait for the list to lay out before scrolling.
      await .35.delay();
      scrollToVerse(initialVerse);
    }
  }

  /// Animates the list so [verseNumber] (1-based) is near the top.
  void scrollToVerse(int verseNumber) {
    final index = (verseNumber - 1).clamp(0, surahArabicAya.length - 1);
    if (!itemScrollController.isAttached) return;
    itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      alignment: 0.08,
    );
  }

  /// Persist the top-most visible verse as "last read" while scrolling.
  void _onScroll() {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty || surah == null) return;
    final first = positions
        .where((p) => p.itemTrailingEdge > 0)
        .reduce((a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b);
    _saveLastRead(first.index + 1);
  }

  void _saveLastRead(int verse) {
    if (surah == null) return;
    MyBookmark.setLastRead(
      surah: surahNumber,
      verse: verse,
      surahName: surah!.nameEnglish,
      savedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  onPreviousSurah() {
    surahNumber = surahNumber - 1;
    targetVerse = null;
    getSurahDetail();
  }

  onNextSurah() {
    surahNumber = surahNumber + 1;
    targetVerse = null;
    getSurahDetail();
  }

  @override
  void onClose() {
    itemPositionsListener.itemPositions.removeListener(_onScroll);
    super.onClose();
  }
}
