import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/services/payer_name_and_icon.dart';
import 'package:quran_pak/app/services/prayer_tracker_service.dart';

import '../controllers/prayer_stats_controller.dart';

class PrayerStatsView extends GetView<PrayerStatsController> {
  const PrayerStatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prayer Stats"),
        centerTitle: true,
      ),
      body: GetBuilder<PrayerStatsController>(builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(kPadding),
          children: [
            _statRow(),
            const Gap(kPadding),
            _markTodayCard(),
            const Gap(kPadding),
            _last7Card(),
            const Gap(kPadding),
            _perPrayerCard(),
          ],
        );
      }),
    );
  }

  // ---------------------------------------------------------------------------

  Widget _statRow() {
    return Row(
      children: [
        _statTile("Streak", "${controller.streak}", "days", Icons.local_fire_department_rounded),
        const Gap(kSpacing),
        _statTile("Perfect", "${controller.perfectDays}", "days", Icons.verified_rounded),
        const Gap(kSpacing),
        _statTile("Total", "${controller.totalCompleted}", "prayers", Icons.done_all_rounded),
      ],
    );
  }

  Widget _statTile(String label, String value, String unit, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(kSpacing),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(kBorderRadius),
          border: Border.all(color: Get.theme.splashColor),
        ),
        child: Column(
          children: [
            Icon(icon, color: Get.theme.primaryColor),
            const Gap(8),
            Text(
              value,
              style: Get.textTheme.titleLarge?.copyWith(
                color: Get.theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(unit, style: Get.textTheme.bodySmall),
            Text(label,
                style: Get.textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------

  Widget _markTodayCard() {
    return _card(
      title: "Today's Prayers",
      trailing: Text(
        "${controller.completedToday}/5",
        style: Get.textTheme.titleSmall?.copyWith(
          color: Get.theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(PrayerTrackerService.prayers.length, (i) {
          final done = controller.todayTracker[i];
          return Column(
            children: [
              GestureDetector(
                onTap: () => controller.toggleToday(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done
                        ? Get.theme.primaryColor
                        : Get.theme.primaryColor.withValues(alpha: .08),
                    border: Border.all(
                      color: done
                          ? Get.theme.primaryColor
                          : Get.theme.primaryColor.withValues(alpha: .3),
                    ),
                  ),
                  child: Icon(
                    done
                        ? Icons.check_rounded
                        : returnIconAccordingToPrayer(
                            PrayerTrackerService.prayers[i].toLowerCase(),
                            prayerName:
                                PrayerTrackerService.prayers[i].toLowerCase(),
                          ),
                    color: done ? Colors.white : Get.theme.primaryColor,
                    size: 20,
                  ),
                ),
              ),
              const Gap(6),
              Text(
                PrayerTrackerService.prayers[i],
                style: Get.textTheme.bodySmall?.copyWith(fontSize: 11),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------------

  Widget _last7Card() {
    final data = controller.last7Days;
    return _card(
      title: "Last 7 Days",
      trailing: Text(
        "${(controller.rateWeek * 100).round()}%",
        style: Get.textTheme.titleSmall?.copyWith(
          color: Get.theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: SizedBox(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: data.map((e) {
            final ratio = e.value / 5;
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("${e.value}", style: Get.textTheme.bodySmall),
                  const Gap(4),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 70 * ratio + 4,
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor
                          .withValues(alpha: .3 + .7 * ratio),
                      borderRadius: BorderRadius.circular(kBorderRadius),
                    ),
                  ),
                  const Gap(6),
                  Text(
                    DateFormat('E').format(e.key).substring(0, 2),
                    style: Get.textTheme.bodySmall?.copyWith(fontSize: 10),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------

  Widget _perPrayerCard() {
    final totals = controller.perPrayerTotals;
    final max = controller.maxPerPrayer;
    return _card(
      title: "By Prayer (all time)",
      child: Column(
        children: List.generate(PrayerTrackerService.prayers.length, (i) {
          final ratio = totals[i] / max;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 64,
                  child: Text(
                    PrayerTrackerService.prayers[i],
                    style: Get.textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 10,
                      backgroundColor:
                          Get.theme.primaryColor.withValues(alpha: .1),
                      color: Get.theme.primaryColor,
                    ),
                  ),
                ),
                const Gap(10),
                Text("${totals[i]}", style: Get.textTheme.bodySmall),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------------

  Widget _card({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(kPadding),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: Get.theme.splashColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Get.textTheme.titleSmall),
              if (trailing != null) trailing,
            ],
          ),
          const Gap(kSpacing),
          child,
        ],
      ),
    );
  }
}
