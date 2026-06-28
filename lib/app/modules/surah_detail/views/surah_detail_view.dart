import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/routes/app_pages.dart';
import 'package:quran_pak/app/widgets/custom_buttons.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '/app/components/verse_container.dart';
import '/utils/quran_utils.dart';
import 'package:quran_flutter/quran_flutter.dart';

import '../controllers/surah_detail_controller.dart';

class SurahDetailView extends GetView<SurahDetailController> {
  const SurahDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SurahDetailController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: FittedBox(
            child: RichText(
              text: TextSpan(
                text: '${controller.surah?.nameEnglish}  ',
                style: Get.textTheme.titleLarge?.copyWith(
                  color: Get.theme.appBarTheme.foregroundColor,
                ),
                children: [
                  TextSpan(
                    text: controller.surah?.name,
                    style: TextStyle(fontFamily: arabicFont),
                  )
                ],
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: "Favourites & bookmark",
              onPressed: () => Get.toNamed(Routes.BOOKMARKS),
              icon: const Icon(Icons.favorite_border_rounded),
            ),
            IconButton(
              onPressed: () => Get.toNamed(Routes.QURAN_SETTINGS),
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: controller.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Get.theme.primaryColor,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _surahHeader(),
                  if (QuranUtils.showBismillah(controller.surah?.number))
                    _bismillah(),
                  Expanded(
                    child: ScrollablePositionedList.builder(
                      itemScrollController: controller.itemScrollController,
                      itemPositionsListener: controller.itemPositionsListener,
                      padding: const EdgeInsets.only(top: 6, bottom: kPadding),
                      itemCount: controller.surahArabicAya.length,
                      itemBuilder: (context, index) => VerseContainer(
                        verse: controller.surahArabicAya[index],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextButton(
                          text: "Previous Surah",
                          onPress: controller.surahNumber <= 1
                              ? null
                              : controller.onPreviousSurah,
                        ),
                        CustomTextButton(
                          text: "Next Surah",
                          onPress: controller.surahNumber >= 114
                              ? null
                              : controller.onNextSurah,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      );
    });
  }

  Widget _surahHeader() {
    final theme = Get.theme;
    return Container(
      margin: const EdgeInsets.fromLTRB(kPadding, kPadding, kPadding, 4),
      padding: const EdgeInsets.all(kPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primaryColor,
            Color.lerp(theme.primaryColor, Colors.black, .25) ??
                theme.primaryColor,
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.surah?.nameEnglish ?? "",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  controller.surah?.meaning ?? "",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: .85),
                  ),
                ),
                const Gap(6),
                Text(
                  '${controller.surah?.verseCount} Verses · '
                  '${QuranUtils.getSurahPlace(controller.surah?.type ?? SurahType.medinan)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: .85),
                  ),
                ),
              ],
            ),
          ),
          Text(
            controller.surah?.name ?? "",
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontFamily: arabicFont,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bismillah() {
    return Container(
      margin: const EdgeInsets.fromLTRB(kPadding, 4, kPadding, 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: kPadding),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Text(
        Quran.bismillah,
        textAlign: TextAlign.center,
        style: Get.textTheme.titleMedium?.copyWith(
          fontFamily: arabicFont,
          height: 1.8,
        ),
      ),
    );
  }
}
