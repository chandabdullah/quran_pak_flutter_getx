library my_share_preferences;

import 'package:adhan/adhan.dart' as adhan;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_pak/app/data/local_data/calculation_methods.dart';
import 'package:quran_pak/app/data/local_data/colors_list.dart';
import 'package:quran_pak/app/data/local_data/islamic_madhhabs.dart';
import 'package:quran_pak/app/data/local_data/midnight_methods.dart';
import 'package:quran_pak/app/models/app_color_model.dart';
import 'package:quran_pak/app/models/calculation_methods_model.dart';
import 'package:quran_pak/app/models/islamic_madhhab_model.dart';
import 'package:quran_pak/app/models/midnight_method_model.dart';
import 'package:quran_pak/utils/color_utils.dart';

part 'my_app_color.dart'; //? App Color
part 'my_dark_mode.dart'; //? Dark Mode
part 'my_coordinates.dart'; //? Coordinates
part 'my_date.dart'; //? Date
part 'my_islamic_madhab.dart'; //? Date
part 'my_calculation_method.dart'; //? Calculation Method
part 'my_time_format.dart'; //? Time
part 'my_prayer_adjustment.dart'; //? Prayer Time Adjustment
part 'my_hijri_adjustment.dart'; //? Hijri Adjustment
part 'my_midnight_method.dart'; //? Midnight

class MySharedPref {
  // get storage
  static late final GetStorage _storage;

  // STORING KEYS
  // static const String _tokenKey = 'token';
  // static const String _userKey = 'user_key';
  // static const String _currentLocalKey = 'current_local';
  // static const String _lightThemeKey = 'is_theme_light';

  /// init get storage services
  static init() async {
    await GetStorage.init();
    _storage = GetStorage();
  }

  static void clearSharePref() => _storage.erase();

  // /// set theme current type as light theme
  // static void setThemeIsLight(bool lightTheme) =>
  //     _storage.write(_lightThemeKey, lightTheme);

  // /// get if the current theme type is light
  // static bool getThemeIsLight() =>
  //     _storage.read(_lightThemeKey) ??
  //     true; // todo set the default theme (true for light, false for dark)

  // /// save current locale
  // static void setCurrentLanguage(String languageCode) =>
  //     _storage.write(_currentLocalKey, languageCode);

  // /// get current locale
  // static Locale getCurrentLocal() {
  //   String? langCode = _storage.read(_currentLocalKey);
  //   // default language is english
  //   if (langCode == null) {
  //     return LocalizationService.defaultLanguage;
  //   }
  //   return LocalizationService.supportedLanguages[langCode]!;
  // }
}
