part of 'my_shared_pref.dart';

class MyPrayerAdjustment {
  static final GetStorage _storage = GetStorage();

  static const String _fajarTimeAdjustmentKey = 'fajar_time_adjustment';
  static const String _sunriseTimeAdjustmentKey = 'sunrise_time_adjustment';
  static const String _duhurTimeAdjustmentKey = 'duhur_time_adjustment';
  static const String _asrTimeAdjustmentKey = 'asr_time_adjustment';
  static const String _magribTimeAdjustmentKey = 'magrib_time_adjustment';
  static const String _ishaTimeAdjustmentKey = 'isha_time_adjustment';

  /// =================================================
  /// Prayer Time Adjustment
  /// =================================================

  /// -------------- save Fajar TimeAdjustment
  static void setFajarTimeAdjustment(int? adjustmentTime) =>
      _storage.write(_fajarTimeAdjustmentKey, adjustmentTime);

  /// get Fajar TimeAdjustment
  static int getFajarTimeAdjustment() {
    int? adjustmentTime = _storage.read(_fajarTimeAdjustmentKey);
    if (adjustmentTime == null) {
      return 0;
    }
    return adjustmentTime;
  }

  /// -------------- save Sunrise TimeAdjustment
  static void setSunriseTimeAdjustment(int? adjustmentTime) =>
      _storage.write(_sunriseTimeAdjustmentKey, adjustmentTime);

  /// get Sunrise TimeAdjustment
  static int getSunriseTimeAdjustment() {
    int? adjustmentTime = _storage.read(_sunriseTimeAdjustmentKey);
    if (adjustmentTime == null) {
      return 0;
    }
    return adjustmentTime;
  }

  /// -------------- save Duhur TimeAdjustment
  static void setDuhurTimeAdjustment(int? adjustmentTime) =>
      _storage.write(_duhurTimeAdjustmentKey, adjustmentTime);

  /// get Duhur TimeAdjustment
  static int getDuhurTimeAdjustment() {
    int? adjustmentTime = _storage.read(_duhurTimeAdjustmentKey);
    if (adjustmentTime == null) {
      return 0;
    }
    return adjustmentTime;
  }

  /// -------------- save Asr TimeAdjustment
  static void setAsrTimeAdjustment(int? adjustmentTime) =>
      _storage.write(_asrTimeAdjustmentKey, adjustmentTime);

  /// get Asr TimeAdjustment
  static int getAsrTimeAdjustment() {
    int? adjustmentTime = _storage.read(_asrTimeAdjustmentKey);
    if (adjustmentTime == null) {
      return 0;
    }
    return adjustmentTime;
  }

  /// -------------- save Magrib TimeAdjustment
  static void setMagribTimeAdjustment(int? adjustmentTime) =>
      _storage.write(_magribTimeAdjustmentKey, adjustmentTime);

  /// get Magrib TimeAdjustment
  static int getMagribTimeAdjustment() {
    int? adjustmentTime = _storage.read(_magribTimeAdjustmentKey);
    if (adjustmentTime == null) {
      return 0;
    }
    return adjustmentTime;
  }

  /// -------------- save Isha TimeAdjustment
  static void setIshaTimeAdjustment(int? adjustmentTime) =>
      _storage.write(_ishaTimeAdjustmentKey, adjustmentTime);

  /// get Isha TimeAdjustment
  static int getIshaTimeAdjustment() {
    int? adjustmentTime = _storage.read(_ishaTimeAdjustmentKey);
    if (adjustmentTime == null) {
      return 0;
    }
    return adjustmentTime;
  }
}
