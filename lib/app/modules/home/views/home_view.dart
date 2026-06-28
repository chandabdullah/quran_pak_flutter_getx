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
        // Show the app-bar actions only once the header has collapsed; while
        // expanded, the hero shows its own bookmark/settings icons.
        alwaysShowLeadingAndAction: false,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.BOOKMARKS),
            icon: const Icon(Icons.favorite_border_rounded),
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
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(primary, Colors.white, .12) ?? primary,
            primary,
            Color.lerp(primary, Colors.black, .35) ?? primary,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Mosque silhouette centered behind the clock.
          Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: .22,
              child: Image.asset(
                "assets/images/mosque.png",
                fit: BoxFit.fitWidth,
                width: double.infinity,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              kPadding + 4,
              kTopPadding(context) + 8,
              kPadding + 4,
              kPadding,
            ),
            child: Column(
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
                    _circleIcon(Icons.favorite_border_rounded,
                        () => Get.toNamed(Routes.BOOKMARKS)),
                    const Gap(8),
                    _circleIcon(Icons.settings_outlined,
                        () => Get.toNamed(Routes.SETTINGS)),
                  ],
                ),
                const Spacer(),
                _timeAndDate(),
                const Gap(kPadding),
                _prayerFocus(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Compact current time + Gregorian date on the left, Islamic (Hijri) date
  /// on the right.
  Widget _timeAndDate() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Expanded(child: _ClockLine()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    color: Colors.white70, size: 12),
                const Gap(4),
                Text(
                  "Islamic Date",
                  style: Get.textTheme.bodySmall?.copyWith(
                      color: Colors.white70, letterSpacing: .5, fontSize: 10),
                ),
              ],
            ),
            const Gap(2),
            Text(
              controller.islamicDate().toFormat('dd MMMM yyyy'),
              style: Get.textTheme.titleSmall
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  /// The focal point of the hero: current prayer + next prayer with a live
  /// countdown and a progress bar between them.
  Widget _prayerFocus() {
    if (controller.prayerTimes == null) {
      return Container(
        height: 92,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        ),
      );
    }
    return _PrayerFocus(
      currentName: controller.currentPrayerName,
      currentTime: controller.currentPrayerTime(),
      nextName: controller.upcomingPrayerName,
      nextTime: controller.nextPrayerTime(),
      // When the countdown hits zero, rebuild so the next prayer becomes
      // current and its countdown starts immediately.
      onElapsed: controller.update,
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
        'icon': FlutterIslamicIcons.solidKowtow,
        'label': 'Prayer',
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
        'route': null
      },
      {
        'icon': FlutterIslamicIcons.solidPrayingPerson,
        'label': 'Dua',
        'route': Routes.DUA
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

/// Compact live time + Gregorian date (left side of the hero info row).
class _ClockLine extends StatefulWidget {
  const _ClockLine();

  @override
  State<_ClockLine> createState() => _ClockLineState();
}

class _ClockLineState extends State<_ClockLine> {
  late final Timer _timer;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('hh:mm a').format(_now),
          style: Get.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          DateFormat('EEEE, dd MMMM yyyy').format(_now),
          style: Get.textTheme.bodySmall?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

/// Engaging prayer focus card: current prayer + next prayer with a live
/// countdown and a progress bar showing how far through the interval we are.
class _PrayerFocus extends StatefulWidget {
  const _PrayerFocus({
    required this.currentName,
    required this.currentTime,
    required this.nextName,
    required this.nextTime,
    required this.onElapsed,
  });

  final String currentName;
  final DateTime? currentTime;
  final String nextName;
  final DateTime? nextTime;
  final VoidCallback onElapsed;

  @override
  State<_PrayerFocus> createState() => _PrayerFocusState();
}

class _PrayerFocusState extends State<_PrayerFocus> {
  late final Timer _timer;
  DateTime? _firedFor;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final next = widget.nextTime;
      // Fire once when the next prayer time is reached so the parent rebuilds
      // and the following prayer's countdown begins.
      if (next != null &&
          !DateTime.now().isBefore(next) &&
          _firedFor != next) {
        _firedFor = next;
        widget.onElapsed();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    if (d.isNegative) d = Duration.zero;
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final next = widget.nextTime;
    final current = widget.currentTime;

    final remaining = next == null ? null : next.difference(now);
    double progress = 0;
    if (current != null && next != null) {
      final total = next.difference(current).inSeconds;
      final done = now.difference(current).inSeconds;
      if (total > 0) progress = (done / total).clamp(0.0, 1.0);
    }

    return Container(
      padding: const EdgeInsets.all(kSpacing),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _prayerCol(
                  "NOW",
                  widget.currentName,
                  widget.currentTime.toLocalDateFormat(),
                  alignEnd: false,
                ),
              ),
              Container(width: 1, height: 36, color: Colors.white24),
              Expanded(
                child: _prayerCol(
                  "NEXT",
                  widget.nextName,
                  widget.nextTime.toLocalDateFormat(),
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const Gap(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(kBorderRadius),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_bottom_rounded,
                  color: Colors.white, size: 14),
              const Gap(6),
              Text(
                remaining == null
                    ? "—"
                    : "${_format(remaining)} until ${widget.nextName}",
                style: Get.textTheme.bodySmall?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _prayerCol(String label, String name, String time,
      {required bool alignEnd}) {
    final align = alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label,
            style: Get.textTheme.bodySmall?.copyWith(
                color: Colors.white70, fontSize: 10, letterSpacing: .5)),
        const Gap(2),
        Text(
          name,
          style: Get.textTheme.titleMedium
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(time,
            style: Get.textTheme.bodySmall?.copyWith(color: Colors.white)),
      ],
    );
  }
}
