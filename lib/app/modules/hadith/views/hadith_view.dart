import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:hadith/classes.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/routes/app_pages.dart';

import '../controllers/hadith_controller.dart';

class HadithView extends GetView<HadithController> {
  const HadithView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hadith'),
        centerTitle: true,
      ),
      // body: const Column(
      //   crossAxisAlignment: CrossAxisAlignment.stretch,
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Icon(
      //       FlutterIslamicIcons.community,
      //       size: 50,
      //     ),
      //     Gap(10),
      //     Text(
      //       'Hi ${appName}s',
      //       textAlign: TextAlign.center,
      //       style: TextStyle(
      //         fontSize: 20,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //     Text(
      //       'Hadith is Coming Soon',
      //       textAlign: TextAlign.center,
      //       style: TextStyle(fontSize: 20),
      //     ),
      //   ],
      // ),
      body: GridView(
        padding: const EdgeInsets.all(kPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: kPadding,
          crossAxisSpacing: kPadding,
          // childAspectRatio: 1.8 / 1,
        ),
        children: [
          for (Collection collection in controller.collections)
            Material(
              borderRadius: BorderRadius.circular(kBorderRadius),
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(kBorderRadius),
                highlightColor: Get.theme.primaryColor.withOpacity(.2),
                splashColor: Get.theme.primaryColor.withOpacity(.2),
                onTap: () {
                  Get.toNamed(
                    Routes.HADITH_BOOK_DETAIL,
                    arguments: {
                      "name": collection.name,
                      "engName": collection.collection.first.title,
                      "arName": collection.collection.last.title,
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(kPadding),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Get.theme.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(kBorderRadius),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        collection.collection.last.title,
                        style: Get.textTheme.bodyLarge?.copyWith(
                          fontFamily: arabicFont,
                        ),
                      ),
                      Text(
                        collection.collection.first.title,
                        style: Get.textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      Text(
                        "${collection.totalAvailableHadith}/${collection.totalHadith}",
                        style: Get.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
