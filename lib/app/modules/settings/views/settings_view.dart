import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/app/modules/home/controllers/home_controller.dart';
import 'package:quran_pak/config/theme/my_theme.dart';

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
                        customListTile(
                          icon: FlutterIslamicIcons.solidCommunity,
                          title: "Islamic Madhhab",
                          subtitle: "Shafi, Hanbali, Maliki (Standard)",
                          // iconColor: Colors.deepPurple,
                          iconColor: Get.theme.primaryColor,
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        customListTile(
                          icon: Icons.calculate,
                          title: "Calculation Method",
                          subtitle: "Karachi University, Pakistan",
                          // iconColor: Colors.teal,
                          iconColor: Get.theme.primaryColor,
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        customListTile(
                          icon: FlutterIslamicIcons.solidPrayingPerson,
                          title: "Prayer Time Adjustment",
                          subtitle:
                              "The adjustment will be effective for daily prayer times",
                          // iconColor: Colors.green,
                          iconColor: Get.theme.primaryColor,
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        customListTile(
                          icon: FlutterIslamicIcons.calendar,
                          title: "Hijri Adjustment",
                          subtitle: "Auto",
                          // iconColor: Colors.amber,
                          iconColor: Get.theme.primaryColor,
                          onTap: () {},
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
                        customSwitchListTile(
                          icon: Icons.dark_mode_rounded,
                          title: "Dark Mode",
                          subtitle:
                              MySharedPref.getThemeIsLight() ? "Light" : "Dark",
                          value: !MySharedPref.getThemeIsLight(),
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
                            topRight: Radius.circular(kBorderRadius),
                            topLeft: Radius.circular(kBorderRadius),
                          ),
                        ),
                        const Divider(height: 1),
                        customSwitchListTile(
                          icon: Icons.access_time_filled,
                          title: "Time Format",
                          subtitle: "24 Format",
                          value: false,
                          // iconColor: Colors.orange,
                          iconColor: Get.theme.primaryColor,
                          onChange: (value) {},
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(kBorderRadius),
                            topLeft: Radius.circular(kBorderRadius),
                          ),
                        ),
                        const Divider(height: 1),
                        customListTile(
                          icon: Icons.color_lens,
                          title: "App Color",
                          subtitle: "Default",
                          // iconColor: Colors.teal,
                          iconColor: Get.theme.primaryColor,
                          onTap: () {},
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

  Widget customListTile({
    Function()? onTap,
    required String title,
    required IconData icon,
    String? subtitle,
    Color? iconColor,
    BorderRadius? borderRadius,
    String? trailing,
  }) {
    return ListTile(
      dense: true,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: kSpacing,
        vertical: 0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
      iconColor: iconColor,
      leading: Icon(
        icon,
        size: 25.sp,
      ),
      title: Text(
        title,
        style: Get.textTheme.bodyLarge,
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style: Get.textTheme.bodySmall,
            ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: Get.textTheme.bodySmall,
            ),
          Icon(
            Icons.keyboard_arrow_right_rounded,
            color: Get.theme.hintColor,
          ),
        ],
      ),
    );
  }

  Widget customSwitchListTile({
    required bool value,
    Function(bool)? onChange,
    required String title,
    String? subtitle,
    required IconData icon,
    Color? iconColor,
    BorderRadius? borderRadius,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChange,
      dense: true,
      // onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: kSpacing,
        vertical: 0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
      controlAffinity: ListTileControlAffinity.trailing,
      secondary: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(
        title,
        style: Get.textTheme.bodyLarge,
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style: Get.textTheme.bodyMedium,
            ),
    );
  }
}
