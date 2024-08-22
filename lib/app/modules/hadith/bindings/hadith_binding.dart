import 'package:get/get.dart';

import '../controllers/hadith_controller.dart';

class HadithBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HadithController>(
      () => HadithController(),
    );
  }
}
