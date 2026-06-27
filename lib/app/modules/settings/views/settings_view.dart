import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/components/custom_bottomsheet.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/app/modules/home/controllers/home_controller.dart';
import 'package:quran_pak/app/routes/app_pages.dart';
import 'package:quran_pak/config/theme/my_theme.dart';
import 'package:quran_pak/config/translations/localization_service.dart';
import 'package:quran_pak/config/translations/strings_enum.dart';

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
          child: ListView(
            padding: const EdgeInsets.all(kPadding),
            children: [
              _header(),
              const Gap(24),
              _sectionLabel(Strings.Calculation.tr),
              const Gap(8),
              _card([
                _tile(
                  icon: FlutterIslamicIcons.solidCommunity,
                  title: Strings.IslamicMadhhab.tr,
                  subtitleWidget: _madhhabSubtitle(),
                  onTap: () => Get.toNamed(Routes.ISLAMIC_MADHHAB),
                ),
                _divider(),
                _tile(
                  icon: Icons.calculate_rounded,
                  title: Strings.CalculationMethod.tr,
                  subtitle: controller.getCalculationMethodName,
                  onTap: () => Get.toNamed(Routes.CALCULATION_METHODS),
                ),
                _divider(),
                _tile(
                  icon: FlutterIslamicIcons.solidPrayingPerson,
                  title: Strings.PrayerTimeAdjustment.tr,
                  subtitle: Strings
                      .TheAdjustmentWillBeEffectiveForDailyPrayerTimes.tr,
                  onTap: () => Get.toNamed(Routes.TIME_ADJUSTMENT),
                ),
                _divider(),
                _tile(
                  icon: FlutterIslamicIcons.calendar,
                  title: Strings.HijriAdjustment.tr,
                  subtitle: controller.getHijriAdjustment(),
                  onTap: () => Get.toNamed(Routes.HIJRI_ADJUSTMENT),
                ),
              ]),
              const Gap(24),
              _sectionLabel(Strings.Display.tr),
              const Gap(8),
              _card([
                _switchTile(
                  icon: Icons.access_time_filled_rounded,
                  title: Strings.TimeFormat.tr,
                  subtitle: Strings.Format24.tr,
                  value: controller.currentTimeFormat,
                  onChanged: controller.onTimeFormatChange,
                ),
                _divider(),
                _switchTile(
                  icon: Icons.dark_mode_rounded,
                  title: Strings.DarkMode.tr,
                  subtitle: MyDarkMode.getThemeIsLight()
                      ? Strings.Light.tr
                      : Strings.Dark.tr,
                  value: !MyDarkMode.getThemeIsLight(),
                  onChanged: (value) {
                    MyTheme.changeTheme();
                    controller.update();
                    Get.find<HomeController>().update();
                  },
                ),
                _divider(),
                _tile(
                  icon: Icons.language_rounded,
                  title: Strings.Language.tr,
                  subtitle: LocalizationService.getCurrentLanguageName(),
                  onTap: () => _showLanguageSheet(context),
                ),
              ]),
              const Gap(28),
              _footer(),
            ],
          ),
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _header() {
    final primary = Get.theme.primaryColor;
    return Container(
      padding: const EdgeInsets.all(kPadding + 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary,
            Color.lerp(primary, Colors.black, .25) ?? primary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: .35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .18),
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            child: const Icon(
              FlutterIslamicIcons.solidMosque,
              color: Colors.white,
              size: 30,
            ),
          ),
          const Gap(kPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  appName,
                  style: Get.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(2),
                Text(
                  "Personalize your prayer & Quran experience",
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: .85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Building blocks
  // ---------------------------------------------------------------------------

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text.toUpperCase(),
        style: Get.textTheme.bodySmall?.copyWith(
          color: Get.theme.primaryColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: Get.theme.splashColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _divider() => Divider(
        height: 1,
        indent: 64,
        color: Get.theme.splashColor,
      );

  Widget _iconChip(IconData icon) {
    final primary = Get.theme.primaryColor;
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: primary.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Icon(icon, color: primary, size: 22),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? subtitleWidget,
    VoidCallback? onTap,
  }) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kSpacing,
            vertical: 12,
          ),
          child: Row(
            children: [
              _iconChip(icon),
              const Gap(kSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Get.textTheme.titleSmall),
                    const Gap(2),
                    subtitleWidget ??
                        Text(
                          subtitle ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: Get.theme.hintColor,
                          ),
                        ),
                  ],
                ),
              ),
              const Gap(8),
              Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Get.theme.hintColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing, vertical: 6),
      child: Row(
        children: [
          _iconChip(icon),
          const Gap(kSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Get.textTheme.titleSmall),
                const Gap(2),
                Text(
                  subtitle,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Get.theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: Get.theme.primaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _madhhabSubtitle() {
    TextStyle? boldIf(bool active) => Get.textTheme.bodySmall?.copyWith(
          color: active ? Get.theme.primaryColor : Get.theme.hintColor,
          fontWeight: active ? FontWeight.bold : null,
        );
    final id = controller.getIslamicMadhabId;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: Strings.Shia.tr, style: boldIf(id == -1)),
          TextSpan(text: "  •  ", style: boldIf(false)),
          TextSpan(text: Strings.Shafi.tr, style: boldIf(id == 0)),
          TextSpan(text: "  •  ", style: boldIf(false)),
          TextSpan(text: Strings.Hanbali.tr, style: boldIf(id == 1)),
        ],
      ),
    );
  }

  Widget _footer() {
    return Column(
      children: [
        Text(
          "Next Level Software",
          textAlign: TextAlign.center,
          style: Get.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Get.theme.hintColor,
          ),
        ),
        const Gap(8),
        Wrap(
          spacing: 10,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text("${Strings.Version.tr} 1.0.2",
                style: Get.textTheme.bodySmall),
            _dot(),
            Text(Strings.Legal.tr, style: Get.textTheme.bodySmall),
            _dot(),
            Text(Strings.Website.tr, style: Get.textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _dot() => Icon(Icons.circle, size: 4, color: Get.theme.disabledColor);

  // ---------------------------------------------------------------------------
  // Language picker
  // ---------------------------------------------------------------------------

  void _showLanguageSheet(BuildContext context) {
    showCustomBottomSheet(
      context,
      title: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.language_rounded),
                const Gap(10),
                Text(Strings.SelectLanguage.tr,
                    style: Get.textTheme.bodyLarge),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              if (Get.isBottomSheetOpen ?? false) Get.back();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: Column(
        children: [
          for (var item in LocalizationService.supportedLanguagesList.entries)
            RadioListTile<String>(
              value: item.key,
              groupValue: MyLocale.getCurrentLocal().languageCode,
              activeColor: Get.theme.primaryColor,
              onChanged: (val) => controller.onLanguageChange(item.key),
              title: Text(item.value),
            ),
        ],
      ),
    );
  }
}
