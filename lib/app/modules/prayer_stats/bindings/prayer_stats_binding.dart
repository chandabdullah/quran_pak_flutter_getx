import 'package:get/get.dart';

import '../controllers/prayer_stats_controller.dart';

class PrayerStatsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrayerStatsController>(
      () => PrayerStatsController(),
    );
  }
}
