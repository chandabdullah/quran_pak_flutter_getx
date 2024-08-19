import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'package:quran_pak/app/components/my_widgets_animator.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/services/payer_name_and_icon.dart';
import 'package:quran_pak/app/services/prayer_time_service.dart';
import 'package:quran_pak/utils/date_time_utils.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/prayer_time_controller.dart';

class PrayerTimeView extends GetView<PrayerTimeController> {
  const PrayerTimeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var theme = Get.theme;

    return GetBuilder<PrayerTimeController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat("dd MMM, yyyy").format(controller.selectedDate),
                style: theme.textTheme.titleLarge!.copyWith(
                  color: theme.appBarTheme.titleTextStyle?.color,
                ),
              ),
              Text(
                controller.selectedIslamicDate().toFormat('dd MMMM yyyy'),
                style: theme.textTheme.titleSmall!.copyWith(
                  color: theme.appBarTheme.titleTextStyle?.color,
                ),
              ),
            ],
          ),
          centerTitle: false,
          // actions: [
          //   FittedBox(
          //     child: Padding(
          //       padding: const EdgeInsets.all(5),
          //       child: Icon(
          //         returnIconAccordingToPrayer(
          //           controller.todayPrayerTimes?.currentPrayer().name,
          //           isSolid: true,
          //         ),
          //       ),
          //     ),
          //   ),
          // ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: theme.cardColor,
                child: AdvancedCalendar(
                  controller: controller.calendarControllerToday,
                  events: const [],
                  weekLineHeight: 48.0,
                  startWeekDay: 1,
                  innerDot: true,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StickyHeader(
                        header: Container(
                          width: Get.width,
                          padding: const EdgeInsets.symmetric(
                            horizontal: kPadding,
                            vertical: kPadding / 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            border: Border(
                              bottom: BorderSide(
                                color: theme.dividerColor.withOpacity(.2),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  controller.onDateChange(
                                    controller.selectedDate.add(
                                      const Duration(days: -1),
                                    ),
                                  );
                                },
                                color: Get.theme.hintColor,
                                icon: const Icon(Icons.arrow_back),
                              ),
                              Expanded(
                                child: Text(
                                  "Prayer Time",
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  controller.onDateChange(
                                    controller.selectedDate.add(
                                      const Duration(days: 1),
                                    ),
                                  );
                                },
                                color: Get.theme.hintColor,
                                icon: const Icon(Icons.arrow_forward),
                              ),
                            ],
                          ),
                        ),
                        content: MyWidgetsAnimator(
                          apiCallStatus: controller.apiCallStatus,
                          loadingWidget: () => const Center(
                            child: Padding(
                              padding: EdgeInsets.all(kPadding),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          successWidget: () => Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: kPadding,
                            ),
                            // padding: const EdgeInsets.all(kSpacing),
                            decoration: BoxDecoration(
                              color: Get.theme.cardColor,
                              border: Border.all(
                                color: Get.theme.splashColor,
                              ),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                            ),
                            child: Column(
                              children: [
                                prayerTimeCard(
                                  prayerName: prayerNamesList[0],
                                  prayerTime: controller.prayerTimes?.fajr ??
                                      DateTime(2000),
                                ),
                                const Divider(
                                  height: 1,
                                  indent: kSpacing,
                                  endIndent: kSpacing,
                                ),
                                prayerTimeCard(
                                  prayerName: prayerNamesList[1],
                                  prayerTime: controller.prayerTimes?.sunrise ??
                                      DateTime(2000),
                                ),
                                const Divider(
                                  height: 1,
                                  indent: kSpacing,
                                  endIndent: kSpacing,
                                ),
                                prayerTimeCard(
                                  prayerName: prayerNamesList[2],
                                  prayerTime: controller.prayerTimes?.dhuhr ??
                                      DateTime(2000),
                                ),
                                const Divider(
                                  height: 1,
                                  indent: kSpacing,
                                  endIndent: kSpacing,
                                ),
                                prayerTimeCard(
                                  prayerName: prayerNamesList[3],
                                  prayerTime: controller.prayerTimes?.asr ??
                                      DateTime(2000),
                                ),
                                const Divider(
                                  height: 1,
                                  indent: kSpacing,
                                  endIndent: kSpacing,
                                ),
                                prayerTimeCard(
                                  prayerName: prayerNamesList[4],
                                  prayerTime: controller.prayerTimes?.maghrib ??
                                      DateTime(2000),
                                ),
                                const Divider(
                                  height: 1,
                                  indent: kSpacing,
                                  endIndent: kSpacing,
                                ),
                                prayerTimeCard(
                                  prayerName: prayerNamesList[5],
                                  prayerTime: controller.prayerTimes?.isha ??
                                      DateTime(2000),
                                ),
                              ],
                            ),
                          ),
                          // successWidget: () => ListView(
                          //   shrinkWrap: true,
                          //   padding: const EdgeInsets.symmetric(
                          //     horizontal: kPadding,
                          //     vertical: kPadding / 2,
                          //   ),
                          //   physics: const NeverScrollableScrollPhysics(),
                          //   children: [
                          //     prayerTimeCard(
                          //       theme,
                          //       prayerName: prayerNamesList[0],
                          //       prayerTime: controller.prayerTimes?.fajr ??
                          //           DateTime(2000),
                          //     ),
                          //     prayerTimeCard(
                          //       theme,
                          //       prayerName: prayerNamesList[1],
                          //       prayerTime: controller.prayerTimes?.sunrise ??
                          //           DateTime(2000),
                          //     ),
                          //     prayerTimeCard(
                          //       theme,
                          //       prayerName: prayerNamesList[2],
                          //       prayerTime: controller.prayerTimes?.dhuhr ??
                          //           DateTime(2000),
                          //     ),
                          //     prayerTimeCard(
                          //       theme,
                          //       prayerName: prayerNamesList[3],
                          //       prayerTime: controller.prayerTimes?.asr ??
                          //           DateTime(2000),
                          //     ),
                          //     prayerTimeCard(
                          //       theme,
                          //       prayerName: prayerNamesList[4],
                          //       prayerTime: controller.prayerTimes?.maghrib ??
                          //           DateTime(2000),
                          //     ),
                          //     prayerTimeCard(
                          //       theme,
                          //       prayerName: prayerNamesList[5],
                          //       prayerTime: controller.prayerTimes?.isha ??
                          //           DateTime(2000),
                          //     ),
                          //   ],
                          //   // itemBuilder: (context, index) {
                          //   //   // var item = controller.selectedDayPrayerTime[index];

                          //   //   return prayerTimeCard(theme);
                          //   // },
                          // ),
                        ),
                      ),
                      const Gap(20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Container prayerTimeCard({
    required String prayerName,
    required DateTime prayerTime,
  }) {
    bool isCurrentPrayer = PrayerTimeService.isCurrentPrayer(
      prayerTimes: controller.prayerTimes,
      prayerName: prayerName,
      selectedDate: controller.selectedDate,
    );

    return Container(
      padding: const EdgeInsets.all(kSpacing),
      child: Row(
        children: [
          // Icon(
          //   returnIconAccordingToPrayer(
          //     controller.prayerTimes?.currentPrayer().name,
          //     prayerName: prayerName,
          //   ),
          //   color: isCurrentPrayer
          //       ? Colors.black
          //       : Get.textTheme.titleLarge?.color?.withOpacity(.7),
          //   size: 22.sp,
          // ),
          // SizedBox(
          //   width: 13.w,
          // ),
          Expanded(
            child: Text(
              prayerName.capitalize ?? "",
              style: Get.textTheme.titleLarge!.copyWith(
                fontWeight:
                    isCurrentPrayer ? FontWeight.bold : FontWeight.normal,
                fontSize: 18.sp,
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            prayerTime == DateTime(2000)
                ? "__:__"
                : prayerTime.toLocalDateFormat(),
            style: Get.textTheme.titleMedium!.copyWith(
              fontSize: 18.sp,
              fontWeight: isCurrentPrayer ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
