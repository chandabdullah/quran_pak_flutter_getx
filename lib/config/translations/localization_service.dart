import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/config/translations/ur_PK/ur_pk_translation.dart';

import '../../../app/data/local/my_shared_pref.dart';
import 'ar_SA/ar_SA_translation.dart';
import 'en_US/en_us_translation.dart';

class LocalizationService extends Translations {
  // default language
  // todo change the default language
  static Locale defaultLanguage = supportedLanguages['en']!;

  // supported languages
  static Map<String, Locale> supportedLanguages = {
    'en': const Locale('en', 'US'),
    'ur': const Locale('ur', 'PK'),
    'ar': const Locale('ar', 'SA'),
  };

  static Map<String, String> supportedLanguagesList = {
    "en": "English",
    "ur": "اردو",
    "ar": "العربية",
  };

  static Map<String, TextStyle> supportedLanguagesFontsFamilies = {
    'en': TextStyle(fontFamily: GoogleFonts.dosis().fontFamily),
    'ur': TextStyle(fontFamily: GoogleFonts.notoNastaliqUrdu().fontFamily),
    'ar': TextStyle(fontFamily: arabicFont),
  };

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUs,
        'ur_PK': urPK,
        'ar_SA': arSA,
      };

  /// check if the language is supported
  static isLanguageSupported(String languageCode) =>
      supportedLanguages.keys.contains(languageCode);

  /// update app language by code language for example (en,ar..etc)
  static updateLanguage(String languageCode) async {
    // check if the language is supported
    if (!isLanguageSupported(languageCode)) return;
    // update current language in shared pref
    MyLocale.setCurrentLanguage(languageCode);
    await Get.updateLocale(supportedLanguages[languageCode]!);
  }

  /// check if the language is english
  static bool isItEnglish() =>
      MyLocale.getCurrentLocal().languageCode.toLowerCase().contains('en');

  static String getCurrentLanguageName() {
    String languageCode = MyLocale.getCurrentLocal().languageCode;
    return supportedLanguagesList[languageCode] ?? "English";
  }

  /// get current locale
  static Locale getCurrentLocal() => MyLocale.getCurrentLocal();
}
