import 'package:get/get.dart';

import '../controllers/prayer_time_controller.dart';

class PrayerTimeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrayerTimeController>(
      () => PrayerTimeController(),
    );
  }
}
