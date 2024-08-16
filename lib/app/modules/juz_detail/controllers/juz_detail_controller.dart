import 'package:get/get.dart';
import 'package:quran_flutter/quran_flutter.dart';

class JuzDetailController extends GetxController {
  bool isLoading = true;

  String? englishJuz = Get.arguments['englishJuz'];
  String? arabicJuz = Get.arguments['arabicJuz'];

  List<JuzDetailModel> juzDetail = [];
  // List<JuzSurahVerses> juzSurahVerses = [];
  // int juzVersesCount = 0;
  // List<Verse> juzVerses = [];

  @override
  void onInit() async {
    isLoading = true;
    update();

    int juz = Get.arguments["juz"];
    List<JuzSurahVerses> juzSurahVerses = Quran.getSurahVersesInJuzAsList(juz);

    for (JuzSurahVerses surahJuz in juzSurahVerses) {
      Map<int, Verse> surahVerse = surahJuz.verses;

      // // var juzVerses = surahJuz.verses.values.toList();
      // // juzVersesCount = juzVersesCount + surahJuz.verseCount;
      // // if ((juzVerses.length) > 100) await 1.delay();

      Surah surah = Quran.getSurah(surahJuz.surahNumber);

      List<Verse> verses = [];
      List<Verse> versesEng = [];

      verses = surahVerse.values.toList();

      for (MapEntry<int, Verse> surahVerse in surahVerse.entries) {
        Verse verseEng = Quran.getVerse(
          surahNumber: surahVerse.value.surahNumber,
          verseNumber: surahVerse.value.verseNumber,
          language: QuranLanguage.english,
        );
        versesEng.add(verseEng);
      }

      JuzDetailModel juzDetailModel = JuzDetailModel(
        juzSurahVerses: surahJuz,
        surah: surah,
        surahVerse: verses,
        surahVerseEng: versesEng,
      );

      juzDetail.add(juzDetailModel);
    }

    // juzDetail = JuzDetailModel(
    //   juzSurahVerses: surahJuz,
    //   surah: surah,
    // );

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

class JuzDetailModel {
  JuzSurahVerses juzSurahVerses;
  Surah surah;
  List<Verse> surahVerse;
  List<Verse> surahVerseEng;

  JuzDetailModel({
    required this.juzSurahVerses,
    required this.surah,
    required this.surahVerse,
    required this.surahVerseEng,
  });
}
