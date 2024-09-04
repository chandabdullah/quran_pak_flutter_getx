import 'package:get/get.dart';
import 'package:quran_flutter/quran_flutter.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/app/modules/juz_detail/controllers/juz_detail_controller.dart';
import 'package:quran_pak/app/modules/surah_detail/controllers/surah_detail_controller.dart';

class QuranSettingsController extends GetxController {
  double arabicFontSize = MyFontSize.getArabicFontSize();
  double translatedFontSize = MyFontSize.getTranslatedFontSize();

  bool showQuranTranslation = MyQuranTranslation.getShowQuranTranslation();
  QuranLanguage getQuranLanguage = MyQuranTranslation.getTranslationLanguage();

  onShowQuranTranslation(bool val) {
    showQuranTranslation = val;
    MyQuranTranslation.saveShowQuranTranslation(showQuranTranslation);
    update();
    updateSurahAndJuzScreen();
  }

  onTranslationLanguageChange(QuranLanguage? quranLanguage) {
    if (quranLanguage == null) return;
    getQuranLanguage = quranLanguage;
    MyQuranTranslation.saveTranslationLanguage(getQuranLanguage);
    update();
    if (Get.isBottomSheetOpen ?? false) Get.back();
    updateSurahAndJuzScreen();
  }

  onArabicFontChange(double val) {
    arabicFontSize = val;
    MyFontSize.saveArabicFontSize(val);
    update();
    updateSurahAndJuzScreen();
  }

  onTranslatedFontChange(double val) {
    translatedFontSize = val;
    MyFontSize.saveTranslatedFontSize(val);
    update();
    updateSurahAndJuzScreen();
  }

  setDefaultFontSize() {
    arabicFontSize = MyFontSize.defaultArabicFontSize;
    translatedFontSize = MyFontSize.defaultTranslatedFontSize;
    MyFontSize.saveArabicFontSize(arabicFontSize);
    MyFontSize.saveTranslatedFontSize(translatedFontSize);
    update();
    updateSurahAndJuzScreen();
  }

  updateSurahAndJuzScreen() {
    bool isSurahDetailRegistered = Get.isRegistered<SurahDetailController>();
    if (isSurahDetailRegistered) {
      SurahDetailController surahDetailController =
          Get.find<SurahDetailController>();
      surahDetailController.update();
    }
    bool isJuzDetailRegistered = Get.isRegistered<JuzDetailController>();
    if (isJuzDetailRegistered) {
      JuzDetailController juzDetailController = Get.find<JuzDetailController>();
      juzDetailController.update();
    }
  }

  @override
  void onInit() {
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
