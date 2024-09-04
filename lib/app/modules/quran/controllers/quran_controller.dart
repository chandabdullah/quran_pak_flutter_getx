import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_flutter/quran_flutter.dart';
import 'package:quran_pak/app/data/local_data/quran_juz.dart';

class QuranController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  TextEditingController searchController = TextEditingController();

  List<Map<String, String>> quranJuz = QuranJuz.quranJuz;
  List<Map<String, String>> filteredQuranJuz = QuranJuz.quranJuz;

  List<Surah> allSurah = [];
  List<Surah> filteredSurah = [];

  // late AnimationController animationController;

  bool showSearch = false;

  getAllSurah() {
    allSurah.clear();
    filteredSurah.clear();
    allSurah.addAll(Quran.getSurahAsList());
    filteredSurah.addAll(Quran.getSurahAsList());
    print("Surah: ${filteredSurah.length}");
    update();
  }

  onSearchClick() {
    showSearch = !showSearch;

    if (!showSearch) {
      restoreSurahAndJuz();
      searchController.text = '';
    }
    // showSearch ? animationController.forward() : animationController.reverse();
    update();
  }

  onInputChange(String text) {
    String searchQuery = text.trim().toLowerCase();
    if (searchQuery.isEmpty) {
      restoreSurahAndJuz();
      return;
    }

    // Juz
    if (tabController.index == 0) {
      filteredSurah = allSurah
          .where((surah) =>
              (surah.name.contains(searchQuery)) ||
              (surah.nameEnglish
                  .replaceAll("-", " ")
                  .toLowerCase()
                  .contains(searchQuery)))
          .toList();
    }

    // Juz
    if (tabController.index == 1) {
      filteredQuranJuz = QuranJuz.quranJuz
          .where((juz) =>
              (juz["english"]?.toLowerCase().contains(searchQuery) ?? false) ||
              (juz["urdu"]?.contains(searchQuery) ?? false))
          .toList();
    }

    update();
  }

  restoreSurahAndJuz() {
    filteredQuranJuz = quranJuz;
    filteredSurah = allSurah;
    update();
  }

  @override
  void onInit() {
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    tabController.addListener(() {
      restoreSurahAndJuz();
      searchController.text = '';
      update();
    });

    getAllSurah();
    // animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(milliseconds: 200),
    // );
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    tabController.removeListener(() {});
    tabController.dispose();
    super.onClose();
  }
}
