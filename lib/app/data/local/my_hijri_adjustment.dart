part of 'my_shared_pref.dart';

class MyHijriAdjustment {
  static final GetStorage _storage = GetStorage();

  static const String _hijriAdjustmentKey = 'hijri_adjustment';

  /// =================================================
  /// Show notification?
  /// =================================================

  /// save hijri adjustment
  static void setHijriAdjustment(int hijriAdjustment) =>
      _storage.write(_hijriAdjustmentKey, hijriAdjustment);

  /// get hijri adjustment
  static int getHijriAdjustment() {
    int? hijriAdjustment = _storage.read(_hijriAdjustmentKey);
    // default language is english
    if (hijriAdjustment == null) {
      return -1;
    }
    return hijriAdjustment;
  }
}
