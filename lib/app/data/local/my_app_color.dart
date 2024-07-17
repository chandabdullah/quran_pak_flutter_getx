import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran_pak/app/data/colors_list.dart';
import 'package:quran_pak/app/models/app_color_model.dart';
import 'package:quran_pak/utils/color_utils.dart';

class MyAppColor {
  static final GetStorage _storage = GetStorage();

  static const String _key = 'app_color_id';

  static setAppColor(int id) {
    _storage.write(_key, id);
  }

  static int getAppColorId() {
    int? id = _storage.read(_key);
    if (id == null) return defaultAppColorId;
    return id;
  }

  static AppColor getLightAppColor() {
    int id = getAppColorId();
    var model = appColorModelFromJson(lightColors);
    int index = model.colors.indexWhere((element) => element.id == id);
    if (index >= 0) {
      return model.colors[index];
    }
    return model.colors[0];
  }

  static AppColor getDarkAppColor() {
    int id = getAppColorId();
    var model = appColorModelFromJson(darkColors);
    int index = model.colors.indexWhere((element) => element.id == id);
    if (index >= 0) {
      return model.colors[index];
    }
    return model.colors[0];
  }

  static Color getLightColor() {
    // AppColor appColor = getLightAppColor();
    var model = appColorModelFromJson(lightColors);
    AppColor appColor = model.colors.first;
    return appColor.hexCode.hexToColor();
  }

  static Color getDarkColor() {
    AppColor appColor = getDarkAppColor();
    return appColor.hexCode.hexToColor();
  }

  // static AppColorModel getAppColor(int id){
  // var index = 0;
  // int index = colorsList.indexWhere((element) => element["id"] == id);
  // if(index >=0)
  // Map<String,dynamic> value = colorsList[index];
  // return appColorModelFromJson(str)
  // }
}
