import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_flutter/quran_flutter.dart';
import 'package:quran_pak/app/components/custom_bottomsheet.dart';
import 'package:quran_pak/app/components/custom_listtile.dart';
import 'package:quran_pak/app/components/verse_container.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/app/widgets/custom_buttons.dart';

import '../controllers/quran_settings_controller.dart';

class QuranSettingsView extends GetView<QuranSettingsController> {
  const QuranSettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuranSettingsController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Settings about Quran'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Translation Settings",
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
                          value: controller.showQuranTranslation,
                          title: "Show translation",
                          subtitle: "Show translation of Quran?",
                          icon: Icons.translate,
                          onChange: controller.onShowQuranTranslation,
                          iconColor: Get.theme.primaryColor,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(kBorderRadius),
                            topLeft: Radius.circular(kBorderRadius),
                          ),
                        ),
                        CustomListTile(
                          iconColor: Get.theme.primaryColor,
                          title: "Translation",
                          // icon: Icons.translate,
                          trailing: controller.getQuranLanguage.name.capitalize,
                          onTap: controller.showQuranTranslation
                              ? () {
                                  showCustomBottomSheet(
                                    context,
                                    title: Text(
                                      "Quran Translation",
                                      style: Get.textTheme.bodyLarge,
                                    ),
                                    content: Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            for (QuranLanguage quranLanguage
                                                in QuranLanguage.values)
                                              RadioListTile<QuranLanguage>(
                                                value: quranLanguage,
                                                groupValue: MyQuranTranslation
                                                    .getTranslationLanguage(),
                                                onChanged: controller
                                                    .onTranslationLanguageChange,
                                                title: Text(
                                                  "${quranLanguage.name.capitalize}",
                                                  style:
                                                      Get.textTheme.titleMedium,
                                                ),
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .trailing,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(kBorderRadius),
                            bottomLeft: Radius.circular(kBorderRadius),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(12),
                Text(
                  "Font Settings",
                  style: Get.textTheme.bodyMedium,
                ),
                const Gap(4),
                Container(
                  padding: const EdgeInsets.all(kSpacing),
                  decoration: BoxDecoration(
                    color: Get.theme.cardColor,
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    border: Border.all(
                      color: Get.theme.splashColor,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Get.theme.splashColor,
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        child: VerseContainer(
                          verse: Quran.getVerse(
                            surahNumber: 1,
                            verseNumber: 2,
                          ),
                          showVerseSymbol: false,
                          arabicFontSize: controller.arabicFontSize *
                              MyFontSize.defaultArabicMultiply,
                          translatedFontSize: controller.translatedFontSize *
                              MyFontSize.defaultTranslatedMultiply,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        "Arabic font size",
                        style: Get.textTheme.bodyMedium,
                      ),
                      const Gap(4),
                      Slider(
                        min: .4,
                        max: 1,
                        value: controller.arabicFontSize,
                        inactiveColor: Get.theme.dividerColor,
                        onChanged: controller.onArabicFontChange,
                      ),
                      Text(
                        "Translated font size",
                        style: Get.textTheme.bodyMedium,
                      ),
                      const Gap(4),
                      Slider(
                        min: .4,
                        max: 1,
                        value: controller.translatedFontSize,
                        inactiveColor: Get.theme.dividerColor,
                        onChanged: controller.onTranslatedFontChange,
                      ),
                      const Gap(8),
                      CustomTextButton(
                        text: "Set Default",
                        onPress: controller.setDefaultFontSize,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
