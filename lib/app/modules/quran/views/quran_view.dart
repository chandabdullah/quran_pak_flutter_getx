import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:quran/Quran.dart' as quran;
import 'package:quran_flutter/quran_flutter.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';

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
              // radius: BorderRadius.circular(8.0),
              // padding: const EdgeInsets.only(left: 36),
              // borderWidth: 2.0,
              // borderColor: Colors.black,
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
              itemCount: 114,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
              itemBuilder: (BuildContext context, int index) {
                String name = Quran.getSurahNameEnglish(index + 1);
                String arabicName = Quran.getSurahName(index + 1);
                var verse = Quran.getTotalVersesInSurah(index + 1);
                var place = Quran.getSurahType(index + 1);
                return ListTile(
                  leading: Text("${index + 1}"),
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
                      fontFamily: GoogleFonts.amiri().fontFamily,
                    ),
                  ),
                );
              },
            ),
            ListView.separated(
              itemCount: 30,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
              itemBuilder: (BuildContext context, int index) {
                var surah = Quran.getSurahVersesInJuzAsList(index + 1);
                return ListTile(
                  // leading: Text("Juz # ${index + 1}"),
                  minLeadingWidth: 0,
                  title: Text(
                    "Juz # ${index + 1}",
                    style: Get.textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    "${surah.length}",
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Get.theme.primaryColor,
                    ),
                  ),
                  // trailing: Text(
                  //   arabicName,
                  //   style: Get.textTheme.titleLarge?.copyWith(
                  //     color: Get.theme.primaryColor,
                  //     fontFamily: GoogleFonts.amiri().fontFamily,
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
