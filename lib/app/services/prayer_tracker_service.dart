import 'package:hive_flutter/hive_flutter.dart';

/// Persists which obligatory prayers the user completed on each day using Hive.
///
/// Each day is stored under a `yyyy-M-d` key as a `List<bool>` of length 5,
/// ordered [Fajr, Dzuhr, Asr, Maghrib, Isha].
class PrayerTrackerService {
  PrayerTrackerService._();

  static const String boxName = 'prayer_tracker';
  static const List<String> prayers = [
    'Fajr',
    'Dzuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  static Box get _box => Hive.box(boxName);

  /// Opens the Hive box. Call once during app start-up.
  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
  }

  static String keyFor(DateTime day) => '${day.year}-${day.month}-${day.day}';

  static List<bool> getForDay(DateTime day) {
    final raw = _box.get(keyFor(day));
    if (raw is List && raw.length == 5) {
      return raw.map((e) => e == true).toList();
    }
    return List<bool>.filled(5, false);
  }

  static void setForDay(DateTime day, List<bool> values) {
    _box.put(keyFor(day), values);
  }

  static void toggle(DateTime day, int index) {
    final values = getForDay(day);
    values[index] = !values[index];
    setForDay(day, values);
  }

  static int completedCount(DateTime day) =>
      getForDay(day).where((e) => e).length;

  static bool isComplete(DateTime day) => completedCount(day) == 5;

  // ---------------------------------------------------------------------------
  // Stats
  // ---------------------------------------------------------------------------

  /// Total individual prayers ticked across all recorded days.
  static int totalPrayersCompleted() {
    int total = 0;
    for (final key in _box.keys) {
      final raw = _box.get(key);
      if (raw is List) total += raw.where((e) => e == true).length;
    }
    return total;
  }

  /// How many days have all five prayers completed.
  static int perfectDays() {
    int days = 0;
    for (final key in _box.keys) {
      final raw = _box.get(key);
      if (raw is List && raw.length == 5 && raw.every((e) => e == true)) {
        days++;
      }
    }
    return days;
  }

  /// Consecutive days (ending today) where all five prayers were completed.
  static int currentStreak() {
    int streak = 0;
    var day = DateTime.now();
    while (isComplete(DateTime(day.year, day.month, day.day))) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Completion counts per prayer index across all recorded days.
  static List<int> perPrayerTotals() {
    final totals = List<int>.filled(5, 0);
    for (final key in _box.keys) {
      final raw = _box.get(key);
      if (raw is List && raw.length == 5) {
        for (var i = 0; i < 5; i++) {
          if (raw[i] == true) totals[i]++;
        }
      }
    }
    return totals;
  }

  /// Completed-prayer count for each of the last [days] days (oldest first).
  static List<MapEntry<DateTime, int>> lastDays(int days) {
    final List<MapEntry<DateTime, int>> result = [];
    final now = DateTime.now();
    for (var i = days - 1; i >= 0; i--) {
      final d = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: i));
      result.add(MapEntry(d, completedCount(d)));
    }
    return result;
  }

  /// Completion ratio (0..1) over the last [days] days.
  static double completionRate(int days) {
    final entries = lastDays(days);
    final completed = entries.fold<int>(0, (sum, e) => sum + e.value);
    return entries.isEmpty ? 0 : completed / (entries.length * 5);
  }
}
