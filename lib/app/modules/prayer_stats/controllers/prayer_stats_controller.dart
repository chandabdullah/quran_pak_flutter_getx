import 'package:get/get.dart';
import 'package:quran_pak/app/services/prayer_tracker_service.dart';

class PrayerStatsController extends GetxController {
  DateTime get today => DateTime.now();

  List<bool> get todayTracker => PrayerTrackerService.getForDay(today);
  int get completedToday => PrayerTrackerService.completedCount(today);

  int get streak => PrayerTrackerService.currentStreak();
  int get perfectDays => PrayerTrackerService.perfectDays();
  int get totalCompleted => PrayerTrackerService.totalPrayersCompleted();

  double get rateWeek => PrayerTrackerService.completionRate(7);
  double get rateMonth => PrayerTrackerService.completionRate(30);

  List<int> get perPrayerTotals => PrayerTrackerService.perPrayerTotals();
  List<MapEntry<DateTime, int>> get last7Days =>
      PrayerTrackerService.lastDays(7);

  /// Highest per-prayer total, used to scale the per-prayer bars.
  int get maxPerPrayer {
    final totals = perPrayerTotals;
    final m = totals.isEmpty ? 0 : totals.reduce((a, b) => a > b ? a : b);
    return m == 0 ? 1 : m;
  }

  void toggleToday(int index) {
    PrayerTrackerService.toggle(today, index);
    update();
  }
}
