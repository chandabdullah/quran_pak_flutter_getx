import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "9 Ramadhan 1445 H",
            style: Get.textTheme.bodyLarge?.copyWith(
              color: Get.theme.appBarTheme.iconTheme?.color,
            ),
          ),
          Text(
            "Faisalabad, Pakistan",
            style: Get.textTheme.bodySmall?.copyWith(
              color: Get.theme.appBarTheme.iconTheme?.color,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.toNamed(Routes.SETTINGS);
          },
          icon: const Icon(Icons.settings),
        ),
        const Gap(10),
      ],
      headerWidget: Container(
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          image: DecorationImage(
            image: const NetworkImage(
              "https://www.pngall.com/wp-content/uploads/4/Mosque-PNG-Pic.png",
            ),
            filterQuality: FilterQuality.low,
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
            colorFilter: ColorFilter.mode(
              Get.theme.primaryColor,
              BlendMode.colorBurn,
            ),
            opacity: .5,
          ),
        ),
        padding: EdgeInsets.only(
          top: kTopPadding(context),
          left: kLeftPadding(context) + kPadding,
          right: kRightPadding(context) + kPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "9 Ramadhan 1445 H",
                        style: Get.textTheme.bodyLarge?.copyWith(
                          color: Get.theme.appBarTheme.iconTheme?.color,
                        ),
                      ),
                      Text(
                        "Faisalabad, Pakistan",
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: Get.theme.appBarTheme.iconTheme?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.SETTINGS);
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Get.theme.appBarTheme.iconTheme?.color,
                  ),
                ),
              ],
            ),
            const Gap(20),
            Text(
              "04:41",
              style: Get.textTheme.displayLarge?.copyWith(
                color: Get.theme.appBarTheme.iconTheme?.color,
              ),
            ),
            Text(
              "Fajr 3 hours 9 min left",
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Get.theme.appBarTheme.iconTheme?.color,
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var item in [0, 0, 0, 0, 0])
                  SizedBox(
                    child: Column(
                      children: [
                        Text(
                          "Fajr",
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: Get.theme.appBarTheme.iconTheme?.color,
                          ),
                        ),
                        const Gap(4),
                        Icon(
                          Icons.dark_mode,
                          color: Get.theme.appBarTheme.iconTheme?.color,
                        ),
                        const Gap(4),
                        Text(
                          "4:41 AM",
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: Get.theme.appBarTheme.iconTheme?.color,
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            )
          ],
        ),
      ),
      body: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "All Features",
                style: Get.textTheme.bodyLarge,
              ),
              const Gap(10),
              Wrap(
                alignment: WrapAlignment.spaceAround,
                runAlignment: WrapAlignment.start,
                spacing: kSpacing,
                runSpacing: kSpacing,
                children: [
                  featureCard(
                    icon: FlutterIslamicIcons.solidQuran2,
                    text: "Quran",
                    onTap: () {
                      Get.toNamed(Routes.READ_QURAN);
                    },
                  ),
                  featureCard(
                    icon: FlutterIslamicIcons.solidQibla,
                    text: "Qibla",
                  ),
                  featureCard(
                    icon: FlutterIslamicIcons.solidTasbih2,
                    text: "Tasbih",
                  ),
                  featureCard(
                    icon: FlutterIslamicIcons.solidPrayingPerson,
                    text: "Time",
                  ),
                  featureCard(
                    icon: FlutterIslamicIcons.solidMuslim,
                    text: "All",
                  ),
                ],
              ),
              const Gap(20),
              Text(
                "Resume Reading",
                style: Get.textTheme.bodyLarge,
              ),
              const Gap(10),
              Container(
                decoration: BoxDecoration(
                  color: Get.theme.cardColor,
                  borderRadius: BorderRadius.circular(kBorderRadius),
                  border: Border.all(
                    color: Get.theme.dividerColor,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: kSpacing,
                  ),
                  tileColor: Get.theme.cardColor,
                  leading: Icon(
                    FlutterIslamicIcons.solidQuran2,
                    size: 30.sp,
                    color: Get.theme.primaryColor,
                  ),
                  title: const Text("Start, where you left"),
                  subtitle: RichText(
                    text: TextSpan(
                      text: "02 ",
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Get.theme.primaryColor,
                      ),
                      children: [
                        TextSpan(
                          text: "Al Bakara",
                          style: Get.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () {},
                    child: Text("Resume"),
                  ),
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.all(kSpacing),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(kBorderRadius),
              //     border: Border.all(
              //       color: Get.theme.primaryColor,
              //     ),
              //   ),
              //   child: Row(
              //     children: [
              //       Icon(
              //         FlutterIslamicIcons.solidQuran2,
              //       ),
              //       const Gap(20),
              //       Expanded(
              //         child: Text("Surah Kahf"),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget featureCard({
    required IconData icon,
    required String text,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(kPadding),
            decoration: BoxDecoration(
              color: Get.theme.primaryColor,
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            child: Icon(
              icon,
              color: Get.theme.cardColor,
            ),
          ),
          const Gap(4),
          Text(
            text,
            style: Get.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
