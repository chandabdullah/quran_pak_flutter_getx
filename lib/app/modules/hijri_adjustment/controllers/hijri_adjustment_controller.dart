import 'package:get/get.dart';
import '/app/components/custom_loading_overlay.dart';
import '/app/data/local/my_shared_pref.dart';
import '/app/modules/home/controllers/home_controller.dart';
import '/app/modules/settings/controllers/settings_controller.dart';

class HijriAdjustmentController extends GetxController {
  var settingsController = Get.find<SettingsController>();
  var homeController = Get.find<HomeController>();

  List<int> hijriAdjustmentList = <int>[-2, -1, 0, 1, 2];

  onHijriAdjustment(int hijriAdjustment) {
    showLoadingOverLay(
        msg: "Saving...",
        asyncFunction: () async {
          return updateHijriAdjustment(hijriAdjustment);
        });
  }

  updateHijriAdjustment(int hijriAdjustment) async {
    MyHijriAdjustment.setHijriAdjustment(hijriAdjustment);
    settingsController.update();
    await homeController.getPrayerTime();
    homeController.update();
    Get.back();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
