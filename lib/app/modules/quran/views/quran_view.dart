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
    return GetBuilder<QuranController>(builder: (_) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => AlignTransition(
                alignment: Tween<Alignment>(
                  begin: Alignment.center,
                  end: Alignment.center,
                ).animate(anim),
                // turns: child.key == const ValueKey('icon1')
                //     ? Tween<double>(begin: 1, end: 1).animate(anim)
                //     : Tween<double>(begin: 1, end: 1).animate(anim),
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: controller.showSearch
                  ? TextField(
                      onChanged: controller.onInputChange,
                      cursorColor: Get.theme.appBarTheme.foregroundColor,
                      decoration: InputDecoration(
                        hintText: controller.tabController.index == 0
                            ? "Search Surah..."
                            : "Search Juz...",
                        hintStyle: Get.textTheme.bodySmall?.copyWith(
                          color: Get.theme.appBarTheme.foregroundColor,
                        ),
                      ),
                    )
                  : const Text(
                      'Quran',
                      key: ValueKey('icon2'),
                    ),
            ),
            // title:
            //     controller.showSearch ? const TextField() : const Text('Quran'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) => RotationTransition(
                    turns: child.key == const ValueKey('icon1')
                        ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                        : Tween<double>(begin: 0.75, end: 1).animate(anim),
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: controller.showSearch
                      ? const Icon(
                          Icons.close,
                          key: ValueKey('icon1'),
                        )
                      : const Icon(
                          Icons.search,
                          key: const ValueKey('icon2'),
                        ),
                ),
                onPressed: controller.onSearchClick,
              )
              // IconButton(
              //   onPressed: controller.onSearchClick,
              //   icon: AnimatedIcon(
              //     progress: controller.animationController,
              //     icon: AnimatedIcons.menu_close,
              //   ),
              // ),
            ],
            bottom: TabBar(
              controller: controller.tabController,
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
            controller: controller.tabController,
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
                itemCount: controller.filteredQuranJuz.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 1,
                    color: Get.theme.splashColor,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  var juz = controller.filteredQuranJuz[index];
                  var surah = Quran.getSurahVersesInJuzAsList(index + 1);
                  String englishJuz = juz["english"] ?? "";
                  String arabicJuz = juz["urdu"] ?? "";

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
                    leading: AyaEnd(
                      number: int.parse(
                        juz["juz"]?.toString() ?? "1",
                      ),
                    ),
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
    });
  }
}
