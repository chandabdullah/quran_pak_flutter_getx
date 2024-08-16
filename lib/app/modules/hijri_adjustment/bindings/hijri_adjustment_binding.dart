import 'package:get/get.dart';

import '../controllers/hijri_adjustment_controller.dart';

class HijriAdjustmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HijriAdjustmentController>(
      () => HijriAdjustmentController(),
    );
  }
}
