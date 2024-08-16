part of 'my_shared_pref.dart';

class MyMidnightMethods {
  static final GetStorage _storage = GetStorage();

  static const String _midnightMethodKey = 'midnight_method';

  /// =================================================
  /// Midnight Methods
  /// =================================================

  /// save midnight method
  static void setMidnightMethod(int? methodId) =>
      _storage.write(_midnightMethodKey, methodId);

  /// get midnight method
  static int getMidnightMethodId() {
    int? midnightMethod = _storage.read(_midnightMethodKey);
    if (midnightMethod == null) {
      return defaultMidnightMethod;
    }
    return midnightMethod;
  }

  static MidnightMethod getMidnightMethod() {
    int midnightMethodId =
        _storage.read(_midnightMethodKey) ?? defaultMidnightMethod;
    var response = midnightMethodModelFromJson(allMidnightMethods);

    int index = response.midnightMethods
        .indexWhere((element) => element.id == midnightMethodId);

    return response.midnightMethods[index];
  }
}
