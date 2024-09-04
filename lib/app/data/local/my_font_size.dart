part of 'my_shared_pref.dart';

class MyFontSize {
  static final GetStorage _storage = GetStorage();

  static const String _arabicFontSize = 'arabic_font_size';
  static const String _translatedFontSize = 'translated_font_size';

  static saveArabicFontSize(double fontSize) {
    _storage.write(_arabicFontSize, fontSize);
  }

  static double getArabicFontSize() {
    var fontSize = _storage.read(_arabicFontSize);
    if (fontSize == null) return defaultArabicFontSize;
    return fontSize;
  }

  static double get defaultArabicFontSize => .6;
  static double get defaultArabicMultiply => 30;

  static saveTranslatedFontSize(double fontSize) {
    _storage.write(_translatedFontSize, fontSize);
  }

  static double getTranslatedFontSize() {
    var fontSize = _storage.read(_translatedFontSize);
    if (fontSize == null) return defaultTranslatedFontSize;
    return fontSize;
  }

  static double get defaultTranslatedFontSize => .6;
  static double get defaultTranslatedMultiply => 30;
}
