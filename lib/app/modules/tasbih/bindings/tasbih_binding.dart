import 'package:get/get.dart';

import '../controllers/tasbih_controller.dart';

class TasbihBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TasbihController>(
      () => TasbihController(),
    );
  }
}
