import 'package:adhan/adhan.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/routes/app_pages.dart';
import 'package:quran_pak/app/services/payer_name_and_icon.dart';
import 'package:quran_pak/utils/date_time_utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (_) {
      return DraggableHome(
        physics: const ScrollPhysics(),
        centerTitle: false,
        title: RichText(
          text: TextSpan(
            text: "It's time for ",
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Get.theme.appBarTheme.iconTheme?.color,
            ),
            children: [
              TextSpan(
                text: controller.prayerTimes?.currentPrayer().name.capitalize ??
                    "Fajr",
                style: Get.textTheme.titleLarge?.copyWith(
                  color: Get.theme.appBarTheme.iconTheme?.color,
                ),
              ),
              TextSpan(
                text: " Prayer",
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Get.theme.appBarTheme.iconTheme?.color,
                ),
              ),
            ],
          ),
        ),
        // title: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Text(
        //       controller.islamicDate().toFormat('dd MMMM yyyy'),
        //       style: Get.textTheme.bodyLarge?.copyWith(
        //         color: Get.theme.appBarTheme.iconTheme?.color,
        //       ),
        //     ),
        //     Text(
        //       // "Faisalabad, Pakistan",
        //       DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY).format(
        //         DateTime.now().toLocal(),
        //       ),
        //       style: Get.textTheme.bodySmall?.copyWith(
        //         color: Get.theme.appBarTheme.iconTheme?.color,
        //       ),
        //     ),
        //   ],
        // ),
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
              image: const AssetImage("assets/images/mosque.png"),
              filterQuality: FilterQuality.low,
              fit: BoxFit.cover,
              repeat: ImageRepeat.noRepeat,
              colorFilter: ColorFilter.mode(
                Get.theme.primaryColor,
                BlendMode.colorBurn,
              ),
              opacity: .3,
            ),
          ),
          padding: EdgeInsets.only(
            top: kTopPadding(context),
            left: kLeftPadding(context) + kPadding,
            right: kRightPadding(context) + kPadding,
          ),
          child: (controller.prayerTimes == null)
              ? Center(
                  child: CircularProgressIndicator(
                    color: Get.theme.cardColor,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                controller
                                    .islamicDate()
                                    .toFormat('dd MMMM yyyy'),
                                style: Get.textTheme.bodyLarge?.copyWith(
                                  color: Get.theme.appBarTheme.iconTheme?.color,
                                ),
                              ),
                              Text(
                                // "Faisalabad, Pakistan",
                                DateFormat(
                                        DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                                    .format(
                                  DateTime.now().toLocal(),
                                ),
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
                    const Gap(8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "It's time for",
                                textAlign: TextAlign.center,
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Get.theme.appBarTheme.iconTheme?.color,
                                ),
                              ),
                              Text(
                                controller.prayerTimes
                                        ?.currentPrayer()
                                        .name
                                        .capitalize ??
                                    "Fajr",
                                textAlign: TextAlign.center,
                                style: Get.textTheme.headlineLarge?.copyWith(
                                  color: Get.theme.appBarTheme.iconTheme?.color,
                                ),
                              ),
                              Text(
                                "Prayer",
                                textAlign: TextAlign.center,
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Get.theme.appBarTheme.iconTheme?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Next Prayer",
                                textAlign: TextAlign.center,
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Get.theme.appBarTheme.iconTheme?.color,
                                ),
                              ),
                              Text(
                                controller.nextPrayerTime() == null
                                    ? (controller.nextPrayerTimes
                                            ?.timeForPrayer(Prayer.fajr))
                                        .toLocalDateFormat()
                                    : controller
                                        .nextPrayerTime()
                                        .toLocalDateFormat(),
                                textAlign: TextAlign.center,
                                style: Get.textTheme.titleLarge?.copyWith(
                                  color: Get.theme.appBarTheme.iconTheme?.color,
                                ),
                              ),
                              Text(
                                controller.nextPrayerTime() == null
                                    ? ("${Prayer.fajr.name.capitalize}"
                                        " "
                                        "${timeLeft(DateTime.now(), controller.nextPrayerTimes?.timeForPrayer(Prayer.fajr) ?? DateTime.now())}")
                                    : ("${controller.prayerTimes?.nextPrayer().name.capitalize}"
                                        " "
                                        "${timeLeft(DateTime.now(), controller.nextPrayerTime() ?? DateTime.now())}"),
                                textAlign: TextAlign.center,
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Get.theme.appBarTheme.iconTheme?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(30),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          prayerTimeCard(
                            // icon: UIcons.regularStraight.moon_stars,
                            prayerName: Prayer.fajr,
                            prayerTime: controller.prayerTimes!.fajr,
                          ),
                          prayerTimeCard(
                            // icon: UIcons.regularStraight.sun,
                            prayerName: Prayer.dhuhr,
                            prayerTime: controller.prayerTimes!.dhuhr,
                          ),
                          prayerTimeCard(
                            // icon: Icons.dark_mode,
                            prayerName: Prayer.asr,
                            prayerTime: controller.prayerTimes!.asr,
                          ),
                          prayerTimeCard(
                            // icon: Icons.dark_mode,
                            prayerName: Prayer.maghrib,
                            prayerTime: controller.prayerTimes!.maghrib,
                          ),
                          prayerTimeCard(
                            // icon: Icons.dark_mode,
                            prayerName: Prayer.isha,
                            prayerTime: controller.prayerTimes!.isha,
                          ),
                        ],
                      ),
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
                GridView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: kPadding,
                    crossAxisSpacing: kPadding,
                    childAspectRatio: 1.1 / 1,
                  ),
                  // alignment: WrapAlignment.spaceAround,
                  // runAlignment: WrapAlignment.start,
                  // spacing: kSpacing,
                  // runSpacing: kSpacing,
                  children: [
                    featureCard(
                      icon: FlutterIslamicIcons.solidQuran2,
                      text: "Quran",
                      subtitle: "Explore the Quran\nby Surah or Juz",
                      onTap: () {
                        Get.toNamed(Routes.QURAN);
                      },
                    ),
                    featureCard(
                      icon: FlutterIslamicIcons.solidMuslim2,
                      text: "Hadith",
                      subtitle: "Discover 6 Authentic\nHadith Collections",
                      // onTap: () {
                      //   Get.toNamed(Routes.HADITH);
                      // },
                    ),
                    featureCard(
                      icon: FlutterIslamicIcons.solidQibla,
                      text: "Qibla",
                      subtitle: "Locate the Qibla\nwith Precision",
                      onTap: () {
                        Get.toNamed(Routes.QIBLA_DIRECTION);
                      },
                    ),
                    featureCard(
                      icon: FlutterIslamicIcons.solidTasbihHand,
                      text: "Tasbih",
                      subtitle: "Track and Count\nYour Tasbih",
                      onTap: () {
                        Get.toNamed(Routes.TASBIH);
                      },
                    ),
                    featureCard(
                      icon: FlutterIslamicIcons.solidKowtow,
                      text: "Prayer Time",
                      subtitle: "Accurate Daily Prayer\nTimings",
                      onTap: () {
                        Get.toNamed(Routes.PRAYER_TIME);
                      },
                    ),
                    featureCard(
                      icon: FlutterIslamicIcons.solidMosque,
                      text: "Masjid",
                      subtitle: "Find Nearby Masjids\nin Your Area",
                    ),
                    // featureCard(
                    //   icon: FlutterIslamicIcons.solidZakat,
                    //   text: "Zakat",
                    //   subtitle: "Easily Calculate\nYour Zakat",
                    // ),
                  ],
                ),
                const Gap(20),
                if (controller.isResumeReading)
                  Column(
                    children: [
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
                          tileColor: Get.theme.appBarTheme.iconTheme?.color,
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
                    ],
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget prayerTimeCard({
    // required IconData icon,
    required Prayer prayerName,
    required DateTime prayerTime,
  }) {
    return SizedBox(
      child: Column(
        children: [
          Text(
            prayerName.name == 'none'
                ? "Midnight"
                : prayerName.name.capitalize ?? "",
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Get.theme.appBarTheme.iconTheme?.color,
            ),
          ),
          const Gap(8),
          Icon(
            // icon,
            returnIconAccordingToPrayer(
              controller.prayerTimes?.currentPrayer().name,
              prayerName: prayerName.name,
            ),
            color: Get.theme.appBarTheme.iconTheme?.color,
          ),
          const Gap(12),
          Text(
            prayerTime.toLocalDateFormat(),
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Get.theme.appBarTheme.iconTheme?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget featureCard({
    required IconData icon,
    required String text,
    String? subtitle,
    Function()? onTap,
  }) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(kBorderRadius),
        onTap: onTap,
        splashColor: Get.theme.primaryColor.withOpacity(.2),
        highlightColor: Get.theme.primaryColor.withOpacity(.3),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(kPadding),
          decoration: BoxDecoration(
            // color: Get.theme.primaryColor,
            borderRadius: BorderRadius.circular(kBorderRadius),
            border: Border.all(
              color: onTap == null
                  ? Get.theme.disabledColor
                  : Get.theme.primaryColor,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: FittedBox(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    icon,
                    color: onTap == null ? Get.theme.disabledColor : null,
                    // color: Get.theme.appBarTheme.iconTheme?.color,
                    size: 50.sp,
                  ),
                ),
              ),
              const Gap(5),
              Text(
                text,
                textAlign: TextAlign.start,
                style: Get.textTheme.headlineSmall?.copyWith(
                  color: onTap == null ? Get.theme.disabledColor : null,
                  // color: Get.theme.appBarTheme.iconTheme?.color,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  textAlign: TextAlign.start,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: onTap == null ? Get.theme.disabledColor : null,
                    // color: Get.theme.appBarTheme.iconTheme?.color,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    // return GestureDetector(
    //   onTap: onTap,
    //   child: Column(
    //     children: [
    //       Expanded(
    //         child: Container(
    //           width: double.infinity,
    //           padding: const EdgeInsets.all(kPadding),
    //           decoration: BoxDecoration(
    //             color: Get.theme.primaryColor,
    //             borderRadius: BorderRadius.circular(kBorderRadius),
    //           ),
    //           child: Icon(
    //             icon,
    //             color: Get.theme.appBarTheme.iconTheme?.color,
    //           ),
    //         ),
    //       ),
    //       const Gap(4),
    //       Text(
    //         text,
    //         style: Get.textTheme.bodyMedium,
    //       ),
    //     ],
    //   ),
    // );
  }
}
