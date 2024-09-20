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

  getSurahDetail() async {
    isLoading = true;
    update();

    surah = Quran.getSurah(surahNumber);
    surahArabicAya = Quran.getSurahVersesAsList(surahNumber);

    if ((surah?.verseCount ?? 0) > 100) await .5.delay();

    isLoading = false;
    update();

    // await 1.delay();

    // final double position = calculateScrollPosition(150);

    // scrollController.animateTo(
    //   position,
    //   duration: const Duration(milliseconds: 500),
    //   curve: Curves.easeInOut,
    // );
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
