import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
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
          forceMaterialTransparency: true,
          title: FittedBox(
            child: RichText(
              text: TextSpan(
                text: '${controller.surah?.nameEnglish} - ',
                style: Get.textTheme.titleLarge,
                children: [
                  TextSpan(
                    text: controller.surah?.name,
                    style: TextStyle(
                      fontFamily: GoogleFonts.amiri().fontFamily,
                    ),
                  )
                ],
              ),
            ),
          ),
          centerTitle: true,
          // actions: [
          //   if (controller.isSurah)
          //     IconButton(
          //       onPressed: () {},
          //       icon: const Icon(Icons.headphones_outlined),
          //     ),
          // ],
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
                        controller.surah?.meaning ?? "",
                        style: Get.textTheme.titleMedium?.copyWith(
                          color: Get.theme.cardColor,
                        ),
                      ),
                    ),
                    Text(
                      '${controller.surah?.verseCount} Aya, ${QuranUtils.getSurahPlace(controller.surah?.type ?? SurahType.medinan)}',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Get.theme.cardColor,
                      ),
                    ),
                  ],
                )),
          ),
        ),
        body: controller.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Get.theme.primaryColor,
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: kSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (controller.surah?.number != 1 &&
                        controller.surah?.number != 9)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            Quran.bismillah,
                            textAlign: TextAlign.center,
                            style: Get.textTheme.bodyLarge?.copyWith(
                              fontFamily: GoogleFonts.amiriQuran().fontFamily,
                            ),
                          ),
                          const Gap(10),
                          Divider(
                            color: Get.theme.splashColor,
                          ),
                          const Gap(10),
                        ],
                      ),
                    ListView.separated(
                      itemCount: controller.surahArabicAya.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          color: Get.theme.splashColor,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        Verse arabicAya = controller.surahArabicAya[index];
                        Verse? englishAya = controller.surahEnglishAya[index];
                        // var hideAya = surah.number == 1 && index == 0;
                        return VerseContainer(
                          verse: arabicAya,
                          translatedVerse: englishAya,
                        );
                      },
                    )
                  ],
                ),
              ),
      );
    });
  }
}
