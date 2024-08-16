import 'package:get/get.dart';

import '../controllers/surah_detail_controller.dart';

class SurahDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SurahDetailController>(
      () => SurahDetailController(),
    );
  }
}
