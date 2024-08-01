import 'package:get/get.dart';
import 'package:quran_pak/app/components/custom_loading_overlay.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/app/data/local_data/calculation_methods.dart';
import 'package:quran_pak/app/models/calculation_methods_model.dart';
import 'package:quran_pak/app/modules/home/controllers/home_controller.dart';
import 'package:quran_pak/app/modules/settings/controllers/settings_controller.dart';
import 'package:quran_pak/app/services/api_call_status.dart';

class CalculationMethodsController extends GetxController {
  SettingsController settingsController = Get.find<SettingsController>();
  HomeController homeController = Get.find<HomeController>();

  int? calculationMethodId = MyCalculationMethod.getCalculationMethodId();
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;
  List<CalculationMethod> calculationMethods = <CalculationMethod>[];

  getCalculationMethods() {
    var response = calculationMethodsModelFromJson(allCalculationMethods);
    calculationMethods = response.calculationMethods;
    update();
  }

  onCalculationMethodChange(id) {
    showLoadingOverLay(
        msg: "Saving...",
        asyncFunction: () async {
          return changeCalculationMethod(id);
        });
  }

  Future<void> changeCalculationMethod(int id) async {
    if (calculationMethodId != id) {
      MyCalculationMethod.setCalculationMethod(id);
      settingsController.update();
      await homeController.getPrayerTime();
      homeController.update();
    }
    Get.back();
  }

  @override
  void onInit() {
    getCalculationMethods();
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
