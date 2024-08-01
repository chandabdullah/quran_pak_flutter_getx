import 'package:get/get.dart';

import '../controllers/islamic_madhhab_controller.dart';

class IslamicMadhhabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IslamicMadhhabController>(
      () => IslamicMadhhabController(),
    );
  }
}
