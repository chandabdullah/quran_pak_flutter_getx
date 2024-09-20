import 'package:get/get.dart';

import '../controllers/tasbih_counter_controller.dart';

class TasbihCounterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TasbihCounterController>(
      () => TasbihCounterController(),
    );
  }
}
