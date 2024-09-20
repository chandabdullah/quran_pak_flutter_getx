import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/data/local_data/tasbih.dart';
import 'package:quran_pak/app/routes/app_pages.dart';

import '../controllers/tasbih_controller.dart';

class TasbihView extends GetView<TasbihController> {
  const TasbihView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasbih'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: TasbihData.tasbihs.length,
          padding: const EdgeInsets.all(kPadding),
          separatorBuilder: (BuildContext context, int index) {
            return const Gap(20);
          },
          itemBuilder: (BuildContext context, int index) {
            Tasbih tasbih = TasbihData.tasbihs[index];
            return Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(kBorderRadius),
                onTap: () {
                  Get.toNamed(Routes.TASBIH_COUNTER, arguments: {
                    "index": index,
                  });
                },
                splashColor: Get.theme.primaryColor.withOpacity(.2),
                highlightColor: Get.theme.primaryColor.withOpacity(.3),
                child: Container(
                  padding: const EdgeInsets.all(kSpacing),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    border: Border.all(
                      color: Get.theme.primaryColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        tasbih.arabic,
                        textAlign: TextAlign.end,
                        style: Get.textTheme.titleLarge?.copyWith(
                          fontFamily: arabicFont,
                          color: Get.theme.primaryColor,
                        ),
                      ),
                      const Gap(10),
                      Text(
                        tasbih.english,
                        style: Get.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
