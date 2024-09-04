import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_flutter/quran_flutter.dart';
import 'package:quran_pak/utils/quran_utils.dart';

class SurahDetailController extends GetxController {
  bool isLoading = true;

  ScrollController scrollController = ScrollController();

  int surahNumber = Get.arguments["surah"];

  // Surah
  Surah? surah;
  List<Verse> surahArabicAya = [];
  List<Verse> surahEnglishAya = [];

  // Juz
  String? englishJuz = Get.arguments['englishJuz'];
  String? arabicJuz = Get.arguments['arabicJuz'];
  List<JuzSurahVerses> juzSurahVerses = [];
  // int juzVersesCount = 0;
  List<Verse> juzVerses = [];

  getSurahDetail() async {
    isLoading = true;
    update();

    // if (Get.arguments["type"] == 'juz') {
    //   int juz = Get.arguments["juz"];
    //   juzSurahVerses = Quran.getSurahVersesInJuzAsList(juz);
    //   for (JuzSurahVerses surahJuz in juzSurahVerses ?? []) {
    //     for (var verse in surahJuz.verses.entries) {
    //       juzVerses.add(verse.value);
    //     }
    //     // juzVerses = juzVerses + surahJuz.verseCount;
    //     // List<MapEntry<int, Verse>> surahVerses =
    //     //     surahJuz.verses.entries.toList();

    //     // for (MapEntry<int, Verse> verse in surahVerses) {
    //     // }

    //     if ((juzVerses.length) > 100) await 1.delay();
    //   }
    // } else {
    surah = Quran.getSurah(surahNumber);
    surahArabicAya = Quran.getSurahVersesAsList(surahNumber);
    surahEnglishAya = Quran.getSurahVersesAsList(
      surahNumber,
      language: QuranLanguage.english,
    );
    if ((surah?.verseCount ?? 0) > 100) await 1.delay();
    // }

    isLoading = false;
    update();

    await 1.delay();

    final double position = calculateScrollPosition(150);

    scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  onPreviousSurah() {
    surahNumber = surahNumber - 1;
    getSurahDetail();
    update();
  }

  onNextSurah() {
    surahNumber = surahNumber + 1;
    getSurahDetail();
    update();
  }

  @override
  void onInit() async {
    await getSurahDetail();

    super.onInit();
  }

  double calculateScrollPosition(int verseIndex) {
    double value = 200.0;
    value += (QuranUtils.showBismillah(surah?.number) ? 50 : 0);
    return verseIndex * value;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
