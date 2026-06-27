import 'package:get/get.dart';

import '../controllers/hadith_search_controller.dart';

class HadithSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HadithSearchController>(
      () => HadithSearchController(),
    );
  }
}
