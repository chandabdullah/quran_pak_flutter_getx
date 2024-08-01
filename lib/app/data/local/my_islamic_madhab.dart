part of 'my_shared_pref.dart';

class MyIslamicMadhab {
  static final GetStorage _storage = GetStorage();

  static const String _islamicMadhabKey = 'islamic_madhab';

  /// =================================================
  /// Islamic Madhab
  /// =================================================

  /// save calculation method
  static void setIslamicMadhab(int? islamicMadhabId) =>
      _storage.write(_islamicMadhabKey, islamicMadhabId);

  /// get calculation method
  static int getIslamicMadhabId() {
    int? islamicMadhabId = _storage.read(_islamicMadhabKey);
    if (islamicMadhabId == null) {
      return defaultIslamicMadhabId;
    }
    return islamicMadhabId;
  }

  static IslamicMadhab getIslamicMethod() {
    int islamicMadhabId =
        _storage.read(_islamicMadhabKey) ?? defaultIslamicMadhabId;
    var response = islamicMadhabModelFromJson(allIslamicMadhab);

    int index = response.islamicMadhab
        .indexWhere((element) => element.id == islamicMadhabId);

    return response.islamicMadhab[index];
  }

  static bool isShiaMadhab() {
    bool isShia = getIslamicMethod().id == -1;
    return isShia;
  }
}
