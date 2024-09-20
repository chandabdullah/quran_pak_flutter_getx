import 'package:get/get.dart';

import '../controllers/hadith_book_detail_controller.dart';

class HadithBookDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HadithBookDetailController>(
      () => HadithBookDetailController(),
    );
  }
}
