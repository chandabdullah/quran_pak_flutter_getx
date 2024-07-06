import 'package:get/get.dart';

import '../controllers/qibla_direction_controller.dart';

class QiblaDirectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QiblaDirectionController>(
      () => QiblaDirectionController(),
    );
  }
}
