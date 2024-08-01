import 'package:get/get.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/app/data/local_data/colors_list.dart';
import 'package:quran_pak/app/models/app_color_model.dart';
import 'package:quran_pak/config/theme/my_theme.dart';

class SettingsController extends GetxController {
  AppColorModel get colorsList => MyTheme.getThemeIsLight
      ? appColorModelFromJson(lightColors)
      : appColorModelFromJson(darkColors);

  int get getIslamicMadhabId => MyIslamicMadhab.getIslamicMethod().id;
  String get getIslamicMadhab => MyIslamicMadhab.getIslamicMethod().name;

  String get getCalculationMethodName =>
      MyCalculationMethod.getCalculationMethod().name;

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
