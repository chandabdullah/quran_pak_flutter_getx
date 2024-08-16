import 'package:get/get.dart';
import 'package:quran_pak/app/components/custom_loading_overlay.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/app/modules/home/controllers/home_controller.dart';
import 'package:quran_pak/app/services/payer_name_and_icon.dart';
import 'package:uicons/uicons.dart';

class TimeAdjustmentController extends GetxController {
  HomeController homeController = Get.find<HomeController>();

  final int maxTime = 120;

  List timeAdjustment = [
    {
      "icon": UIcons.regularRounded.moon_stars,
      "title": prayerNamesList[0],
      "time": MyPrayerAdjustment.getFajarTimeAdjustment(),
    },
    {
      "icon": UIcons.regularRounded.sunrise,
      "title": prayerNamesList[1],
      "time": MyPrayerAdjustment.getSunriseTimeAdjustment(),
    },
    {
      "icon": UIcons.regularRounded.sun,
      "title": prayerNamesList[2],
      "time": MyPrayerAdjustment.getDuhurTimeAdjustment(),
    },
    {
      "icon": UIcons.regularRounded.cloud_sun,
      "title": prayerNamesList[3],
      "time": MyPrayerAdjustment.getAsrTimeAdjustment(),
    },
    {
      "icon": UIcons.regularRounded.sunset,
      "title": prayerNamesList[4],
      "time": MyPrayerAdjustment.getMagribTimeAdjustment(),
    },
    {
      "icon": UIcons.regularRounded.moon,
      "title": prayerNamesList[5],
      "time": MyPrayerAdjustment.getIshaTimeAdjustment(),
    },
  ];

  onTimeAdjust(int index, int val) {
    print("Index: $index");
    print("Val: $val");
    print("Max Time: $maxTime");
    print("Submit: ${val - maxTime}");

    timeAdjustment[index]["time"] = val - maxTime;
    update();

    var time = val - maxTime;

    if (index == 0) {
      MyPrayerAdjustment.setFajarTimeAdjustment(time);
    } else if (index == 1) {
      MyPrayerAdjustment.setSunriseTimeAdjustment(time);
    } else if (index == 2) {
      MyPrayerAdjustment.setDuhurTimeAdjustment(time);
    } else if (index == 3) {
      MyPrayerAdjustment.setAsrTimeAdjustment(time);
    } else if (index == 4) {
      MyPrayerAdjustment.setMagribTimeAdjustment(time);
    } else if (index == 5) {
      MyPrayerAdjustment.setIshaTimeAdjustment(time);
    }

    showLoadingOverLay(
        msg: "Saving...",
        asyncFunction: () async {
          return updateHomeData();
        });
  }

  updateHomeData() async {
    await homeController.getPrayerTime();
    homeController.update();
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
