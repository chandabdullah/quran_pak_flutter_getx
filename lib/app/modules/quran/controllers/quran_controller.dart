import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_pak/app/data/local_data/quran_juz.dart';
import 'package:string_similarity/string_similarity.dart';

class QuranController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  List<Map<String, String>> quranJuz = QuranJuz.quranJuz;
  List<Map<String, String>> filteredQuranJuz = QuranJuz.quranJuz;

  // late AnimationController animationController;

  bool showSearch = false;

  onSearchClick() {
    showSearch = !showSearch;
    // showSearch ? animationController.forward() : animationController.reverse();
    update();
  }

  onInputChange(String text) {
    String searchQuery = text.trim().toLowerCase();

    // Juz
    if (tabController.index == 1) {
      if (text.isEmpty) {
        filteredQuranJuz = quranJuz;
        return;
      }

      filteredQuranJuz = QuranJuz.quranJuz
          .where((juz) =>
              // isSimilarTo(juz["english"].toString(), searchQuery)
              //  ||
              // isSimilarTo(juz["urdu"].toString(), searchQuery)
              (juz["english"]?.toLowerCase().contains(searchQuery) ?? false) ||
              (juz["urdu"]?.contains(searchQuery) ?? false))
          .toList();
      // filteredQuranJuz = quranJuz.where(test)
    }

    print("filteredQuranJuz: ${filteredQuranJuz.length}");

    update();
  }

  bool isSimilarTo(String value, String query) {
    double result = StringSimilarity.compareTwoStrings(value, query);
    print("$value: $result");
    return result > 0.2;
  }

  @override
  void onInit() {
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    tabController.addListener(() {
      update();
    });
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
