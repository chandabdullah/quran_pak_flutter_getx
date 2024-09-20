import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/data/local_data/tasbih.dart';
import 'package:quran_pak/app/widgets/custom_buttons.dart';

import '../controllers/tasbih_counter_controller.dart';

class TasbihCounterView extends GetView<TasbihCounterController> {
  const TasbihCounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TasbihCounterController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tasbih Counter'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: controller.onPrevious,
                    icon: const Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                  Expanded(
                    child: CarouselSlider(
                      carouselController: controller.carouselController,
                      disableGesture: true,
                      items: [
                        for (Tasbih tasbih in controller.tasbihData)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(kSpacing),
                                  child: FittedBox(
                                    child: Text(
                                      tasbih.arabic,
                                      style: Get.textTheme.titleLarge?.copyWith(
                                        fontFamily: arabicFont,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              FittedBox(
                                child: Text(
                                  tasbih.english,
                                  style: Get.textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                      ],
                      options: CarouselOptions(
                        enableInfiniteScroll: true,
                        aspectRatio: 2.3 / 1,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          controller.resetCount();
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.onNext,
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                    ),
                  ),
                ],
              ),
              const Gap(20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextButton(
                          text: "Target: ${controller.selectedTarget}",
                          onPress: controller.onTargetChange,
                        ),
                        const Gap(10),
                        IconButton(
                          onPressed: controller.resetCount,
                          tooltip: "Reset",
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    const Gap(30),
                    Material(
                      shape: const CircleBorder(),
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: (controller.count.value >=
                                controller.selectedTarget)
                            ? null
                            : controller.increment,
                        customBorder: const CircleBorder(),
                        splashColor: Get.theme.primaryColor.withOpacity(.15),
                        child: Container(
                          height: Get.width,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor.withOpacity(.15),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(kPadding),
                            decoration: BoxDecoration(
                              color: Get.theme.primaryColor.withOpacity(.3),
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(kPadding),
                              decoration: BoxDecoration(
                                color: Get.theme.primaryColor.withOpacity(.45),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(kPadding),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Get.theme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: FittedBox(
                                  child: Text(
                                    "${controller.count}",
                                    style:
                                        Get.textTheme.displayMedium?.copyWith(
                                      color: Get.theme.cardColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
