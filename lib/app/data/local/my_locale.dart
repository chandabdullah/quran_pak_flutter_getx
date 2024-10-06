part of 'my_shared_pref.dart';

class MyLocale {
  static final GetStorage _storage = GetStorage();

  static const String _currentLocalKey = 'current_local';

  /// save current locale
  static void setCurrentLanguage(String languageCode) =>
      _storage.write(_currentLocalKey, languageCode);

  /// get current locale
  static Locale getCurrentLocal() {
    String? langCode = _storage.read(_currentLocalKey);
    // default language is english
    if (langCode == null) {
      return LocalizationService.defaultLanguage;
    }
    return LocalizationService.supportedLanguages[langCode]!;
  }
}
