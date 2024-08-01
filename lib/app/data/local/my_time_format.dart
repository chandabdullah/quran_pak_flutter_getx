part of 'my_shared_pref.dart';

class MyTimeFormat {
  static final GetStorage _storage = GetStorage();

  static const String _timeFormatKey = 'time_format';

  /// =================================================
  /// Time Format
  /// =================================================

  /// save Time Format
  static void setTimeFormatIs24(bool is24Format) =>
      _storage.write(_timeFormatKey, is24Format);

  /// get Time Format
  static bool getTimeFormatIs24() {
    bool? is24Format = _storage.read(_timeFormatKey);
    // default language is english
    if (is24Format == null) {
      return false;
    }
    return is24Format;
  }
}
