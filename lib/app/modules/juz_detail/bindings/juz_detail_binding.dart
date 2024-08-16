import 'package:get/get.dart';

import '../controllers/juz_detail_controller.dart';

class JuzDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JuzDetailController>(
      () => JuzDetailController(),
    );
  }
}
