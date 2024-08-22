import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:quran_flutter/quran_flutter.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/components/aya_end.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/routes/app_pages.dart';

import '../controllers/quran_controller.dart';

class QuranView extends GetView<QuranController> {
  const QuranView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quran'),
          centerTitle: true,
          bottom: TabBar(
            // labelColor: Get.theme.appBarTheme.foregroundColor,
            unselectedLabelColor:
                Get.theme.appBarTheme.foregroundColor?.withOpacity(.7),
            indicatorSize: TabBarIndicatorSize.label,
            indicator: ContainerTabIndicator(
              color: Get.theme.cardColor,
              width: 120,
              height: 40,
              borderWidth: 2,
              borderColor: Get.theme.primaryColor,
              radius: BorderRadius.circular(kBorderRadius),
            ),
            tabs: const [
              Tab(text: "Surah"),
              Tab(text: "Juz"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.separated(
              itemCount: Quran.surahCount,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 1,
                  color: Get.theme.splashColor,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                var surahNumber = index + 1;
                String name = Quran.getSurahNameEnglish(surahNumber);
                String arabicName = Quran.getSurahName(surahNumber);
                var verse = Quran.getTotalVersesInSurah(surahNumber);
                var place = Quran.getSurahType(surahNumber);
                return ListTile(
                  onTap: () {
                    Get.toNamed(
                      Routes.SURAH_DETAIL,
                      arguments: {
                        "surah": index + 1,
                      },
                    );
                  },
                  leading: AyaEnd(number: surahNumber),
                  minLeadingWidth: 0,
                  title: Text(
                    name,
                    style: Get.textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    "$verse Verses | ${place.name}",
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Get.theme.primaryColor,
                    ),
                  ),
                  trailing: Text(
                    arabicName,
                    style: Get.textTheme.titleLarge?.copyWith(
                      color: Get.theme.primaryColor,
                      fontFamily: arabicFont,
                    ),
                  ),
                );
              },
            ),
            ListView.separated(
              itemCount: controller.quranJuz.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 1,
                  color: Get.theme.splashColor,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                var juz = controller.quranJuz[index];
                var surah = Quran.getSurahVersesInJuzAsList(index + 1);
                String englishJuz = juz["english"] ?? "";
                String arabicJuz = juz["arabic"] ?? "";

                return ListTile(
                  onTap: () {
                    Get.toNamed(
                      Routes.JUZ_DETAIL,
                      arguments: {
                        "juz": index + 1,
                        "type": "juz",
                        "englishJuz": englishJuz,
                        "arabicJuz": arabicJuz,
                      },
                    );
                  },
                  leading: AyaEnd(number: index + 1),
                  minLeadingWidth: 0,
                  title: Text(
                    englishJuz,
                    style: Get.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${surah.length} Surah${surah.length == 1 ? '' : 's'}",
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Get.theme.primaryColor,
                    ),
                  ),
                  trailing: Text(
                    arabicJuz,
                    style: Get.textTheme.titleLarge?.copyWith(
                      color: Get.theme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: arabicFont,
                    ),
                  ),
                  // trailing: Text(
                  //   arabicName,
                  //   style: Get.textTheme.titleLarge?.copyWith(
                  //     color: Get.theme.primaryColor,
                  //     fontFamily: arabicFont,
                  //   ),
                  // ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
