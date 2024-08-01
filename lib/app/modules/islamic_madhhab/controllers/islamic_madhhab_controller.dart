import 'package:get/get.dart';
import 'package:quran_pak/app/models/islamic_madhhab_model.dart';
import '/app/components/custom_loading_overlay.dart';
import '/app/data/local/my_shared_pref.dart';
import '/app/data/local_data/islamic_madhhabs.dart';
import '/app/modules/home/controllers/home_controller.dart';
import '/app/modules/settings/controllers/settings_controller.dart';
import '/app/services/api_call_status.dart';

class IslamicMadhhabController extends GetxController {
  SettingsController settingsController = Get.find<SettingsController>();
  HomeController homeController = Get.find<HomeController>();

  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  List<IslamicMadhab> islamicMadhhabList = <IslamicMadhab>[];

  getIslamicMadhhabs() {
    var response = islamicMadhabModelFromJson(allIslamicMadhab);
    print(response.islamicMadhab.length);
    islamicMadhhabList = response.islamicMadhab;
    update();
  }

  onIslamicMadhabChange(id) {
    showLoadingOverLay(
        msg: "Saving...",
        asyncFunction: () async {
          return changeIslamicMadhab(id);
        });
  }

  changeIslamicMadhab(id) async {
    MyIslamicMadhab.setIslamicMadhab(id);
    settingsController.update();
    await homeController.getPrayerTime();
    homeController.update();
    Get.back();
  }

  @override
  void onInit() {
    getIslamicMadhhabs();
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
