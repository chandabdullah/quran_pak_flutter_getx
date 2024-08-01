part of 'my_shared_pref.dart';

class MyCalculationMethod {
  static final GetStorage _storage = GetStorage();

  static const String _calculationMethodKey = 'calculation_method';

  /// =================================================
  /// Calculation Methods
  /// =================================================

  /// save calculation method
  static void setCalculationMethod(int? methodId) =>
      _storage.write(_calculationMethodKey, methodId);

  /// get calculation method
  static int getCalculationMethodId() {
    int? calculationMethod = _storage.read(_calculationMethodKey);
    if (calculationMethod == null) {
      return defaultCalculationMethod;
    }
    return calculationMethod;
  }

  static CalculationMethod getCalculationMethod() {
    int calculationMethodId =
        _storage.read(_calculationMethodKey) ?? defaultCalculationMethod;
    var response = calculationMethodsModelFromJson(allCalculationMethods);

    int index = response.calculationMethods
        .indexWhere((element) => element.id == calculationMethodId);

    return response.calculationMethods[index];
  }
}
