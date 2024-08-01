import 'package:get/get.dart';

import '../controllers/calculation_methods_controller.dart';

class CalculationMethodsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalculationMethodsController>(
      () => CalculationMethodsController(),
    );
  }
}
