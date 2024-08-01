import 'package:get/get.dart';

import '../controllers/time_adjustment_controller.dart';

class TimeAdjustmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimeAdjustmentController>(
      () => TimeAdjustmentController(),
    );
  }
}
