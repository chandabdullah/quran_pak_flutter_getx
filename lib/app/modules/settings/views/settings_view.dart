import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/components/custom_bottomsheet.dart';
import 'package:quran_pak/app/components/custom_listtile.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/data/local_data/colors_list.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/app/modules/home/controllers/home_controller.dart';
import 'package:quran_pak/app/routes/app_pages.dart';
import 'package:quran_pak/config/theme/my_theme.dart';
import 'package:quran_pak/utils/color_utils.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Calculation",
                  style: Get.textTheme.bodyMedium,
                ),
                const Gap(4),
                Container(
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor,
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    border: Border.all(
                      color: Get.theme.splashColor,
                    ),
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Column(
                      children: [
                        CustomListTile(
                          icon: FlutterIslamicIcons.solidCommunity,
                          title: "Islamic Madhhab",
                          subtitleWidget: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Shia",
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                    fontWeight:
                                        controller.getIslamicMadhabId == -1
                                            ? FontWeight.bold
                                            : null,
                                  ),
                                ),
                                TextSpan(
                                  text: ", ",
                                  style: Get.textTheme.bodyMedium,
                                ),
                                TextSpan(
                                  text: "Shafi",
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                    fontWeight:
                                        controller.getIslamicMadhabId == 0
                                            ? FontWeight.bold
                                            : null,
                                  ),
                                ),
                                TextSpan(
                                  text: ", ",
                                  style: Get.textTheme.bodyMedium,
                                ),
                                TextSpan(
                                  text: "Hanbali",
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                    fontWeight:
                                        controller.getIslamicMadhabId == 1
                                            ? FontWeight.bold
                                            : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: controller.getIslamicMadhab,
                          iconColor: Get.theme.primaryColor,
                          onTap: () {
                            Get.toNamed(Routes.ISLAMIC_MADHHAB);
                          },
                        ),
                        const Divider(height: 1),
                        CustomListTile(
                          icon: Icons.calculate,
                          title: "Calculation Method",
                          subtitle: controller.getCalculationMethodName,
                          // iconColor: Colors.teal,
                          iconColor: Get.theme.primaryColor,
                          onTap: () {
                            Get.toNamed(Routes.CALCULATION_METHODS);
                          },
                        ),
                        const Divider(height: 1),
                        CustomListTile(
                          icon: FlutterIslamicIcons.solidPrayingPerson,
                          title: "Prayer Time Adjustment",
                          subtitle:
                              "The adjustment will be effective for daily prayer times",
                          // iconColor: Colors.green,
                          iconColor: Get.theme.primaryColor,
                          onTap: () {
                            Get.toNamed(Routes.TIME_ADJUSTMENT);
                          },
                        ),
                        const Divider(height: 1),
                        CustomListTile(
                          icon: FlutterIslamicIcons.calendar,
                          title: "Hijri Adjustment",
                          subtitle: controller.getHijriAdjustment(),
                          // iconColor: Colors.amber,
                          iconColor: Get.theme.primaryColor,
                          onTap: () {
                            Get.toNamed(Routes.HIJRI_ADJUSTMENT);
                          },
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(kBorderRadius),
                            bottomLeft: Radius.circular(kBorderRadius),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(20),
                Text(
                  "Display",
                  style: Get.textTheme.bodyMedium,
                ),
                const Gap(4),
                Container(
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor,
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    border: Border.all(
                      color: Get.theme.splashColor,
                    ),
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Column(
                      children: [
                        CustomSwitchListTile(
                          icon: Icons.access_time_filled,
                          title: "Time Format",
                          subtitle: "24 Format",
                          value: controller.currentTimeFormat,
                          iconColor: Get.theme.primaryColor,
                          onChange: controller.onTimeFormatChange,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(kBorderRadius),
                            topLeft: Radius.circular(kBorderRadius),
                          ),
                        ),
                        const Divider(height: 1),
                        CustomSwitchListTile(
                          icon: Icons.dark_mode_rounded,
                          title: "Dark Mode",
                          subtitle:
                              MyDarkMode.getThemeIsLight() ? "Light" : "Dark",
                          value: !MyDarkMode.getThemeIsLight(),
                          // iconColor: Colors.indigo,
                          iconColor: Get.theme.primaryColor,
                          onChange: (value) {
                            MyTheme.changeTheme();
                            controller.update();
                            HomeController homeController =
                                Get.find<HomeController>();
                            homeController.update();
                          },

                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(kBorderRadius),
                            bottomLeft: Radius.circular(kBorderRadius),
                          ),
                          //  borderRadius: const BorderRadius.only(
                          //   topRight: Radius.circular(kBorderRadius),
                          //   topLeft: Radius.circular(kBorderRadius),
                          // ),
                        ),
                        // const Divider(height: 1),
                        // CustomListTile(
                        //   icon: Icons.color_lens,
                        //   title: "App Color",
                        //   subtitle: "Default",
                        //   // iconColor: Colors.teal,
                        //   iconColor: Get.theme.primaryColor,
                        //   onTap: () {
                        //     selectAppColor(context);
                        //   },
                        //   borderRadius: const BorderRadius.only(
                        //     bottomRight: Radius.circular(kBorderRadius),
                        //     bottomLeft: Radius.circular(kBorderRadius),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                const Gap(20),
                Text(
                  "Next Level Software",
                  textAlign: TextAlign.center,
                  style: Get.textTheme.bodySmall,
                ),
                const Gap(10),
                Wrap(
                  spacing: 10,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Version 1.45",
                      style: Get.textTheme.bodySmall,
                    ),
                    Icon(
                      Icons.circle,
                      size: 5,
                      color: Get.theme.disabledColor,
                    ),
                    Text(
                      "Legal",
                      style: Get.textTheme.bodySmall,
                    ),
                    Icon(
                      Icons.circle,
                      size: 5,
                      color: Get.theme.disabledColor,
                    ),
                    Text(
                      "Website",
                      style: Get.textTheme.bodySmall,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  selectAppColor(BuildContext context) {
    showCustomBottomSheet(
      context,
      title: Text(
        "App Color",
        style: Get.theme.textTheme.titleLarge,
      ),
      content: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: kPadding,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.colorsList.colors?.length ?? 0,
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
          );
        },
        itemBuilder: (context, index) {
          var colorItem = controller.colorsList.colors?[index];
          var selectedIndex = 0;
          // var selectedIndex = colorsList.indexWhere((element) =>
          //     element["hexCode"] == MyAppColor.getCurrentAppColorHexCode());
          return ListTile(
            leading: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: colorItem?.hexCode.toString().hexToColor(),
                shape: BoxShape.circle,
              ),
            ),
            minLeadingWidth: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                kBorderRadius,
              ),
            ),
            dense: true,
            onTap: () {
              if (Get.isBottomSheetOpen ?? false) {
                Get.back();
              }
              // controller.onColorChange(colorItem["hexCode"]);
            },
            title: Text(
              colorItem?.name ?? "",
            ),
            trailing: index == selectedIndex
                ? Icon(
                    Icons.check,
                    color: Get.theme.primaryColor,
                    size: 20,
                  )
                : null,
          );
        },
      ),
    );
  }
}
