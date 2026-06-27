import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/routes/app_pages.dart';
import 'package:quran_pak/app/services/payer_name_and_icon.dart';
import 'package:quran_pak/utils/date_time_utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (_) {
      return DraggableHome(
        title: Text(
          controller.prayerTimes == null
              ? appName
              : "It's time for ${controller.currentPrayerName}",
          style: TextStyle(color: Get.theme.appBarTheme.foregroundColor),
        ),
        centerTitle: false,
        curvedBodyRadius: kBorderRadius,
        headerExpandedHeight: 0.3,
        alwaysShowLeadingAndAction: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.BOOKMARKS),
            icon: const Icon(Icons.bookmarks_outlined),
          ),
          IconButton(
            onPressed: () => Get.toNamed(Routes.SETTINGS),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
        headerWidget: _hero(context),
        body: [
          const Gap(kPadding),
          _prayerStrip(),
          const Gap(kPadding),
          _featureGrid(),
          const Gap(kPadding),
          _lastReadCard(),
          const Gap(kPadding),
          _prayerTracker(),
          const Gap(kPadding),
        ],
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Hero header (primary color + mosque image background)
  // ---------------------------------------------------------------------------

  Widget _hero(BuildContext context) {
    final primary = Get.theme.primaryColor;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary,
            Color.lerp(primary, Colors.black, .35) ?? primary,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Mosque image kept subtle so the text stays readable.
          Positioned.fill(
            child: Opacity(
              opacity: .14,
              child: Image.asset(
                "assets/images/mosque.png",
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              kPadding + 4,
              kTopPadding(context) + kPadding,
              kPadding + 4,
              kPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "As-salamu alaykum",
                            style: Get.textTheme.bodyMedium
                                ?.copyWith(color: Colors.white70),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.white70, size: 14),
                              const Gap(2),
                              Flexible(
                                child: Text(
                                  controller.city ?? "Locating…",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Get.textTheme.bodySmall
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _circleIcon(Icons.bookmarks_outlined,
                        () => Get.toNamed(Routes.BOOKMARKS)),
                    const Gap(8),
                    _circleIcon(Icons.settings_outlined,
                        () => Get.toNamed(Routes.SETTINGS)),
                  ],
                ),
                const _LiveClock(),
                _currentNextPrayer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Current prayer (with its time) and the upcoming prayer (with countdown).
  Widget _currentNextPrayer() {
    if (controller.prayerTimes == null) {
      return const SizedBox(height: 1);
    }
    return Container(
      padding: const EdgeInsets.all(kSpacing),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Expanded(
            child: _prayerInfo(
              "Current",
              controller.currentPrayerName,
              controller.currentPrayerTime().toLocalDateFormat(),
            ),
          ),
          Container(width: 1, height: 34, color: Colors.white24),
          Expanded(
            child: _prayerInfo(
              "Next",
              controller.upcomingPrayerName,
              timeLeft(
                DateTime.now(),
                controller.nextPrayerTime() ?? DateTime.now(),
              ),
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _prayerInfo(String label, String name, String value,
      {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Get.textTheme.bodySmall?.copyWith(color: Colors.white70)),
        Text(
          name,
          style: Get.textTheme.titleMedium
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(value,
            style: Get.textTheme.bodySmall?.copyWith(color: Colors.white)),
      ],
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white.withValues(alpha: .15),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Prayer strip (no colors)
  // ---------------------------------------------------------------------------

  Widget _prayerStrip() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kPadding),
      padding: const EdgeInsets.symmetric(vertical: kPadding, horizontal: 8),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: Get.theme.splashColor),
      ),
      child: controller.prayerTimes == null
          ? const SizedBox(
              height: 92,
              child: Center(child: CircularProgressIndicator()),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _prayerPill(Prayer.fajr, controller.prayerTimes!.fajr),
                _prayerPill(Prayer.dhuhr, controller.prayerTimes!.dhuhr),
                _prayerPill(Prayer.asr, controller.prayerTimes!.asr),
                _prayerPill(Prayer.maghrib, controller.prayerTimes!.maghrib),
                _prayerPill(Prayer.isha, controller.prayerTimes!.isha),
              ],
            ),
    );
  }

  Widget _prayerPill(Prayer prayer, DateTime time) {
    final bool isCurrent = controller.currentPrayer == prayer;
    final primary = Get.theme.primaryColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          PrayerNames.label(prayer),
          style: Get.textTheme.bodySmall?.copyWith(
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
            color: isCurrent ? primary : null,
          ),
        ),
        const Gap(8),
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrent ? primary : primary.withValues(alpha: .1),
          ),
          child: Icon(
            returnIconAccordingToPrayer(prayer.name, prayerName: prayer.name),
            color: isCurrent ? Colors.white : primary,
            size: 20,
          ),
        ),
        const Gap(8),
        Text(
          time.toLocalDateFormat(),
          style: Get.textTheme.bodySmall?.copyWith(
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
            color: isCurrent ? primary : null,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Feature grid (full-cell rectangular splash)
  // ---------------------------------------------------------------------------

  Widget _featureGrid() {
    final features = <Map<String, dynamic>>[
      {
        'icon': FlutterIslamicIcons.solidQuran2,
        'label': 'Quran',
        'route': Routes.QURAN
      },
      {
        'icon': FlutterIslamicIcons.calendar,
        'label': 'Calendar',
        'route': Routes.PRAYER_TIME
      },
      {
        'icon': FlutterIslamicIcons.solidQibla,
        'label': 'Qibla',
        'route': Routes.QIBLA_DIRECTION
      },
      {
        'icon': FlutterIslamicIcons.solidTasbihHand,
        'label': 'Tasbeeh',
        'route': Routes.TASBIH
      },
      {
        'icon': FlutterIslamicIcons.solidPrayer,
        'label': 'Salah',
        'route': Routes.PRAYER_STATS
      },
      {
        'icon': FlutterIslamicIcons.solidMuslim2,
        'label': 'Hadith',
        'route': Routes.HADITH
      },
      {
        'icon': FlutterIslamicIcons.solidKowtow,
        'label': 'Prayer',
        'route': Routes.PRAYER_TIME
      },
      {
        'icon': FlutterIslamicIcons.solidMosque,
        'label': 'Masjid',
        'route': null
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kPadding),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: Get.theme.splashColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: .92,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) {
          final f = features[index];
          return _featureTile(
            icon: f['icon'] as IconData,
            label: f['label'] as String,
            route: f['route'] as String?,
          );
        },
      ),
    );
  }

  Widget _featureTile({
    required IconData icon,
    required String label,
    String? route,
  }) {
    final enabled = route != null;
    final primary = Get.theme.primaryColor;
    // The InkWell fills the whole grid cell, so the splash covers the entire
    // rectangular cell (no rounded corners).
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => Get.toNamed(route) : null,
        splashColor: primary.withValues(alpha: .18),
        highlightColor: primary.withValues(alpha: .10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: enabled ? .12 : .05),
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
              child: Icon(
                icon,
                color: enabled ? primary : Get.theme.disabledColor,
                size: 24,
              ),
            ),
            const Gap(8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Get.textTheme.bodySmall?.copyWith(
                color: enabled ? null : Get.theme.disabledColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Last read (continue) card
  // ---------------------------------------------------------------------------

  Widget _lastReadCard() {
    final lastRead = controller.lastRead;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kPadding),
      padding: const EdgeInsets.all(kPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadius),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Get.theme.primaryColor,
            Color.lerp(Get.theme.primaryColor, Colors.black, .3) ??
                Get.theme.primaryColor,
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Continue Reading",
                    style: Get.textTheme.bodySmall
                        ?.copyWith(color: Colors.white70)),
                const Gap(4),
                Text(
                  lastRead?.surahName ?? "Al-Fatihah",
                  style: Get.textTheme.titleLarge?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text("Verse no. ${lastRead?.verse ?? 1}",
                    style: Get.textTheme.bodySmall
                        ?.copyWith(color: Colors.white70)),
                const Gap(12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Get.theme.primaryColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: kPadding, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kBorderRadius)),
                  ),
                  onPressed: () => Get.toNamed(
                    Routes.SURAH_DETAIL,
                    arguments: {
                      "surah": lastRead?.surah ?? 1,
                      "verse": lastRead?.verse ?? 1,
                    },
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Continue"),
                      Gap(6),
                      Icon(Icons.arrow_forward_rounded, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Icon(FlutterIslamicIcons.solidQuran,
              color: Colors.white.withValues(alpha: .85), size: 64),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Prayer tracker (with View Stats link)
  // ---------------------------------------------------------------------------

  Widget _prayerTracker() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kPadding),
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
              Text("Prayer Tracker", style: Get.textTheme.titleSmall),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.PRAYER_STATS),
                child: Row(
                  children: [
                    Text(
                      "View Stats",
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: Get.theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        size: 18, color: Get.theme.primaryColor),
                  ],
                ),
              ),
            ],
          ),
          const Gap(4),
          Text(
            "${controller.completedToday}/5 completed today",
            style:
                Get.textTheme.bodySmall?.copyWith(color: Get.theme.hintColor),
          ),
          const Gap(kSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              HomeController.trackerPrayers.length,
              (i) => _trackerItem(i),
            ),
          ),
        ],
      ),
    );
  }

  Widget _trackerItem(int index) {
    final done = controller.prayerTracker[index];
    final primary = Get.theme.primaryColor;
    return Column(
      children: [
        GestureDetector(
          onTap: () => controller.togglePrayerTracker(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? primary : primary.withValues(alpha: .08),
              border: Border.all(
                color: done ? primary : primary.withValues(alpha: .3),
              ),
            ),
            child: Icon(
              done ? Icons.check_rounded : Icons.circle_outlined,
              color: done ? Colors.white : primary,
              size: done ? 24 : 18,
            ),
          ),
        ),
        const Gap(6),
        Text(
          HomeController.trackerPrayers[index],
          style: Get.textTheme.bodySmall?.copyWith(
            fontSize: 11,
            fontWeight: done ? FontWeight.bold : null,
            color: done ? primary : null,
          ),
        ),
      ],
    );
  }
}

/// Short prayer labels matching the design.
class PrayerNames {
  static String label(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return "Fajr";
      case Prayer.dhuhr:
        return "Dzuhr";
      case Prayer.asr:
        return "Asr";
      case Prayer.maghrib:
        return "Maghrib";
      case Prayer.isha:
        return "Isha";
      default:
        return prayer.name;
    }
  }
}

/// A lightweight clock that updates itself every second.
class _LiveClock extends StatefulWidget {
  const _LiveClock();

  @override
  State<_LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<_LiveClock> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeText = DateFormat('hh:mm').format(_now);
    final suffix = DateFormat('a').format(_now);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          timeText,
          style: Get.textTheme.displaySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(6),
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(suffix,
              style: Get.textTheme.titleSmall?.copyWith(color: Colors.white70)),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            DateFormat('EEE, dd MMM').format(_now),
            style: Get.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}
