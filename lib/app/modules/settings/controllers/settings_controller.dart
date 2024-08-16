import 'package:get/get.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/app/data/local_data/colors_list.dart';
import 'package:quran_pak/app/models/app_color_model.dart';
import 'package:quran_pak/app/modules/home/controllers/home_controller.dart';
import 'package:quran_pak/config/theme/my_theme.dart';

class SettingsController extends GetxController {
  AppColorModel get colorsList => MyTheme.getThemeIsLight
      ? appColorModelFromJson(lightColors)
      : appColorModelFromJson(darkColors);

  int get getIslamicMadhabId => MyIslamicMadhab.getIslamicMethod().id;
  String get getIslamicMadhab => MyIslamicMadhab.getIslamicMethod().name;

  String get getCalculationMethodName =>
      MyCalculationMethod.getCalculationMethod().name;

  bool get currentTimeFormat => MyTimeFormat.getTimeFormatIs24();

  /// on time format change
  onTimeFormatChange(bool val) {
    // currentTimeFormat = val;
    MyTimeFormat.setTimeFormatIs24(val);
    update();
    HomeController homeController = Get.find<HomeController>();
    homeController.update();
  }

  String getHijriAdjustment() {
    int hijriAdjustment = MyHijriAdjustment.getHijriAdjustment();
    return hijriAdjustment == 0
        ? "Auto"
        : "${hijriAdjustment > 0 ? "+$hijriAdjustment" : hijriAdjustment} days";
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
