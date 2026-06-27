import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'package:quran_pak/app/components/my_widgets_animator.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/services/payer_name_and_icon.dart';
import 'package:quran_pak/app/services/prayer_time_service.dart';
import 'package:quran_pak/app/services/prayer_tracker_service.dart';
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
                          successWidget: () => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kPadding,
                            ),
                            child: Column(
                              children: [
                                prayerTimeCard(
                                  prayerName: prayerNamesList[0],
                                  prayerTime: controller.prayerTimes?.fajr ??
                                      DateTime(2000),
                                  trackerIndex: 0,
                                ),
                                prayerTimeCard(
                                  prayerName: prayerNamesList[1],
                                  prayerTime: controller.prayerTimes?.sunrise ??
                                      DateTime(2000),
                                ),
                                prayerTimeCard(
                                  prayerName: prayerNamesList[2],
                                  prayerTime: controller.prayerTimes?.dhuhr ??
                                      DateTime(2000),
                                  trackerIndex: 1,
                                ),
                                prayerTimeCard(
                                  prayerName: prayerNamesList[3],
                                  prayerTime: controller.prayerTimes?.asr ??
                                      DateTime(2000),
                                  trackerIndex: 2,
                                ),
                                prayerTimeCard(
                                  prayerName: prayerNamesList[4],
                                  prayerTime: controller.prayerTimes?.maghrib ??
                                      DateTime(2000),
                                  trackerIndex: 3,
                                ),
                                prayerTimeCard(
                                  prayerName: prayerNamesList[5],
                                  prayerTime: controller.prayerTimes?.isha ??
                                      DateTime(2000),
                                  trackerIndex: 4,
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

  Widget prayerTimeCard({
    required String prayerName,
    required DateTime prayerTime,
    int? trackerIndex,
  }) {
    final theme = Get.theme;
    final bool isCurrentPrayer = PrayerTimeService.isCurrentPrayer(
      prayerTimes: controller.prayerTimes,
      prayerName: prayerName,
      selectedDate: controller.selectedDate,
    );

    final Color fg = isCurrentPrayer ? Colors.white : theme.hintColor;

    // Whether this prayer is marked complete for the selected day.
    final bool tracked = trackerIndex != null &&
        PrayerTrackerService.getForDay(controller.selectedDate)[trackerIndex];

    return Container(
      margin: const EdgeInsets.only(bottom: kSpacing),
      padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 14),
      decoration: BoxDecoration(
        color: isCurrentPrayer ? theme.primaryColor : theme.cardColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(
          color: isCurrentPrayer ? theme.primaryColor : theme.splashColor,
        ),
        boxShadow: isCurrentPrayer
            ? [
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: .35),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Icon(
            returnIconAccordingToPrayer(prayerName, prayerName: prayerName),
            color: isCurrentPrayer ? Colors.white : theme.primaryColor,
            size: 22.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              prayerName.capitalize ?? "",
              style: Get.textTheme.titleMedium!.copyWith(
                color: isCurrentPrayer ? Colors.white : null,
                fontWeight:
                    isCurrentPrayer ? FontWeight.bold : FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
          ),
          Text(
            prayerTime == DateTime(2000)
                ? "__:__"
                : prayerTime.toLocalDateFormat(),
            style: Get.textTheme.titleMedium!.copyWith(
              color: isCurrentPrayer ? Colors.white : fg,
              fontSize: 16.sp,
              fontWeight: isCurrentPrayer ? FontWeight.bold : FontWeight.w600,
            ),
          ),
          if (trackerIndex != null) ...[
            SizedBox(width: 10.w),
            InkWell(
              borderRadius: BorderRadius.circular(kBorderRadius),
              onTap: () {
                PrayerTrackerService.toggle(
                    controller.selectedDate, trackerIndex);
                controller.update();
              },
              child: Icon(
                tracked
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isCurrentPrayer
                    ? Colors.white
                    : (tracked ? theme.primaryColor : theme.hintColor),
                size: 22.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
