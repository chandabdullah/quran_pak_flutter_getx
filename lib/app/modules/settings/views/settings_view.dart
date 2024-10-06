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
import 'package:quran_pak/app/services/location_service.dart';
import 'package:quran_pak/config/theme/my_theme.dart';
import 'package:quran_pak/config/translations/localization_service.dart';
import 'package:quran_pak/config/translations/strings_enum.dart';
import 'package:quran_pak/utils/color_utils.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text(Strings.Settings.tr),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  Strings.Calculation.tr,
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
                          title: Strings.IslamicMadhhab.tr,
                          subtitleWidget: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: Strings.Shia.tr,
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
                                  text: Strings.Shafi.tr,
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
                                  text: Strings.Hanbali.tr,
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
                          title: Strings.CalculationMethod.tr,
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
                          title: Strings.PrayerTimeAdjustment.tr,
                          subtitle: Strings
                              .TheAdjustmentWillBeEffectiveForDailyPrayerTimes
                              .tr,
                          // iconColor: Colors.green,
                          iconColor: Get.theme.primaryColor,
                          onTap: () {
                            Get.toNamed(Routes.TIME_ADJUSTMENT);
                          },
                        ),
                        const Divider(height: 1),
                        CustomListTile(
                          icon: FlutterIslamicIcons.calendar,
                          title: Strings.HijriAdjustment.tr,
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
                  Strings.Display.tr,
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
                          title: Strings.TimeFormat.tr,
                          subtitle: Strings.Format24.tr,
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
                          title: Strings.DarkMode.tr,
                          subtitle: MyDarkMode.getThemeIsLight()
                              ? Strings.Light.tr
                              : Strings.Dark.tr,
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
                        const Divider(height: 1),
                        CustomListTile(
                          icon: Icons.language,
                          title: Strings.Language.tr,
                          subtitle:
                              LocalizationService.getCurrentLanguageName(),
                          // iconColor: Colors.teal,
                          iconColor: Get.theme.primaryColor,
                          onTap: () {
                            showCustomBottomSheet(
                              context,
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.language),
                                        const Gap(10),
                                        Text(
                                          Strings.SelectLanguage.tr,
                                          style: Get.textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (Get.isBottomSheetOpen ?? false) {
                                        Get.back();
                                      }
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                              content: Column(
                                children: [
                                  for (var item in LocalizationService
                                      .supportedLanguagesList.entries)
                                    CheckboxListTile(
                                      value: MyLocale.getCurrentLocal()
                                              .languageCode ==
                                          item.key,
                                      onChanged: (val) {
                                        controller.onLanguageChange(item.key);
                                      },
                                      title: Text(item.value),
                                    ),
                                ],
                              ),
                            );
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
                      Strings.Version.tr + " 1.45",
                      style: Get.textTheme.bodySmall,
                    ),
                    Icon(
                      Icons.circle,
                      size: 5,
                      color: Get.theme.disabledColor,
                    ),
                    Text(
                      Strings.Legal.tr,
                      style: Get.textTheme.bodySmall,
                    ),
                    Icon(
                      Icons.circle,
                      size: 5,
                      color: Get.theme.disabledColor,
                    ),
                    Text(
                      Strings.Website.tr,
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
