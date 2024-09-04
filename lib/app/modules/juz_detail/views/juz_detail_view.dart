import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_pak/app/routes/app_pages.dart';
import '/app/components/verse_container.dart';
import '/app/constants/app_constants.dart';
import '/utils/quran_utils.dart';
import 'package:quran_flutter/quran_flutter.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../controllers/juz_detail_controller.dart';

class JuzDetailView extends GetView<JuzDetailController> {
  const JuzDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<JuzDetailController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          // forceMaterialTransparency: true,
          title: FittedBox(
            child: RichText(
              text: TextSpan(
                text: '${controller.englishJuz} - ',
                style: Get.textTheme.titleLarge?.copyWith(
                  color: Get.theme.appBarTheme.foregroundColor,
                ),
                children: [
                  TextSpan(
                    text: controller.arabicJuz,
                    style: TextStyle(
                      color: Get.theme.appBarTheme.foregroundColor,
                      fontFamily: arabicFont,
                    ),
                  )
                ],
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.QURAN_SETTINGS);
              },
              icon: const Icon(Icons.settings),
            ),
          ],
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Container(
                color: Get.theme.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: kPadding,
                  vertical: kSpacing,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "${controller.juzDetail?.length ?? 0} Surah${controller.juzDetail?.length == 1 ? '' : 's'}",
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: Get.theme.cardColor,
                        ),
                      ),
                    ),
                    Text(
                      '${controller.juzDetail?.length} aya',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Get.theme.cardColor,
                      ),
                    ),
                  ],
                ),
              )),
        ),
        body: controller.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Get.theme.primaryColor,
                ),
              )
            : ListView.builder(
                // padding: const EdgeInsets.symmetric(vertical: kSpacing),
                // shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.juzDetail.length,
                itemBuilder: (BuildContext context, int index) {
                  JuzDetailModel? surahAndVerse = controller.juzDetail[index];
                  return StickyHeader(
                    header: Container(
                      color: Get.theme.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: kPadding,
                        vertical: kSpacing,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "${QuranUtils.getSurahPlace(surahAndVerse.surah.type)}",
                            style: Get.textTheme.bodyMedium?.copyWith(
                              color: Get.theme.cardColor,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${surahAndVerse.surah.nameEnglish} - ${surahAndVerse.surah.name}",
                              textAlign: TextAlign.center,
                              style: Get.textTheme.bodyMedium?.copyWith(
                                color: Get.theme.cardColor,
                              ),
                            ),
                          ),
                          Text(
                            "${surahAndVerse.juzSurahVerses.verseCount} aya",
                            style: Get.textTheme.bodyMedium?.copyWith(
                              color: Get.theme.cardColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    content: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        vertical: kSpacing,
                      ),
                      itemCount: surahAndVerse.surahVerse.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          height: 1,
                          color: Get.theme.splashColor,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        Verse verse = surahAndVerse.surahVerse[index];
                        return VerseContainer(
                          verse: verse,
                        );
                      },
                    ),
                  );
                },
              ),
      );
    });
  }
}
