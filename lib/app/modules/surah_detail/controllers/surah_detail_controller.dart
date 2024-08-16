import 'package:get/get.dart';
import 'package:quran_flutter/quran_flutter.dart';

class SurahDetailController extends GetxController {
  bool isLoading = true;

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

  @override
  void onInit() async {
    isLoading = true;
    update();

    if (Get.arguments["type"] == 'juz') {
      int juz = Get.arguments["juz"];
      juzSurahVerses = Quran.getSurahVersesInJuzAsList(juz);
      for (JuzSurahVerses surahJuz in juzSurahVerses ?? []) {
        for (var verse in surahJuz.verses.entries) {
          juzVerses.add(verse.value);
        }
        // juzVerses = juzVerses + surahJuz.verseCount;
        // List<MapEntry<int, Verse>> surahVerses =
        //     surahJuz.verses.entries.toList();

        // for (MapEntry<int, Verse> verse in surahVerses) {
        // }

        if ((juzVerses.length) > 100) await 1.delay();
      }
    } else {
      surah = Quran.getSurah(Get.arguments["surah"]);
      surahArabicAya = Quran.getSurahVersesAsList(Get.arguments["surah"]);
      surahEnglishAya = Quran.getSurahVersesAsList(
        Get.arguments["surah"],
        language: QuranLanguage.english,
      );
      if ((surah?.verseCount ?? 0) > 100) await 1.delay();
    }

    isLoading = false;
    update();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
