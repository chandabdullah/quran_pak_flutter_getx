import 'package:get/get.dart';
import 'package:quran_pak/app/data/colors_list.dart';
import 'package:quran_pak/app/models/app_color_model.dart';
import 'package:quran_pak/config/theme/my_theme.dart';

class SettingsController extends GetxController {
  AppColorModel get colorsList => MyTheme.getThemeIsLight
      ? appColorModelFromJson(lightColors)
      : appColorModelFromJson(darkColors);

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
