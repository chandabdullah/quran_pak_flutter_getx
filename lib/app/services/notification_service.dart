import 'package:adhan/adhan.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'prayer_time_service.dart';

/// Handles local "Prayer Reminder" notifications. Reminders are scheduled as
/// exact one-shot alarms for each of the next [_daysAhead] days using the real
/// computed prayer time for that day, so they fire precisely on time. The
/// window is re-extended every time the app recomputes prayer times.
class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static final GetStorage _box = GetStorage();

  static const String _channelId = 'prayer_reminders';
  static const String _channelName = 'Prayer Reminders';
  static const String _icon = 'ic_notification';

  /// How many days of reminders to schedule ahead of time.
  static const int _daysAhead = 30;

  /// The five obligatory prayers, in tracker/notification index order.
  static const List<String> prayers = [
    'Fajr',
    'Dzuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  static AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  static Future<void> init() async {
    tzdata.initializeTimeZones();
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const android = AndroidInitializationSettings(_icon);
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    await _android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: 'Reminders at each prayer time',
        importance: Importance.max,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Permission
  // ---------------------------------------------------------------------------

  static Future<bool> areEnabled() async =>
      await _android?.areNotificationsEnabled() ?? false;

  static Future<bool> requestPermission() async {
    final granted = await _android?.requestNotificationsPermission() ?? false;
    await _android?.requestExactAlarmsPermission();
    return granted;
  }

  // ---------------------------------------------------------------------------
  // Per-prayer enable state
  // ---------------------------------------------------------------------------

  static bool isPrayerEnabled(int index) =>
      _box.read('notif_prayer_$index') == true;

  static Future<void> setPrayerEnabled(int index,
      {required bool enabled}) async {
    _box.write('notif_prayer_$index', enabled);
    await rescheduleAll();
  }

  static bool get anyEnabled =>
      List.generate(5, (i) => isPrayerEnabled(i)).any((e) => e);

  // ---------------------------------------------------------------------------
  // Scheduling
  // ---------------------------------------------------------------------------

  static NotificationDetails get _details => NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: 'Reminders at each prayer time',
          importance: Importance.max,
          priority: Priority.high,
          icon: _icon,
        ),
        iOS: const DarwinNotificationDetails(),
      );

  static int _id(int dayOffset, int prayerIndex) =>
      1000 + dayOffset * 10 + prayerIndex;

  /// Cancels every prayer reminder and re-schedules the enabled ones for the
  /// next [_daysAhead] days using each day's actual computed prayer time.
  static Future<void> rescheduleAll() async {
    // Clear the whole reserved id range first.
    for (var d = 0; d < _daysAhead; d++) {
      for (var i = 0; i < 5; i++) {
        await _plugin.cancel(_id(d, i));
      }
    }

    if (!anyEnabled) return;

    final coordinates = await PrayerTimeService.getCoordinates();
    if (coordinates.latitude == 0 && coordinates.longitude == 0) return;
    final params = PrayerTimeService.getParameters();
    final now = tz.TZDateTime.now(tz.local);

    for (var d = 0; d < _daysAhead; d++) {
      final date = DateTime.now().add(Duration(days: d));
      final pt = PrayerTimes(
        coordinates,
        DateComponents(date.year, date.month, date.day),
        params,
      );
      final times = [pt.fajr, pt.dhuhr, pt.asr, pt.maghrib, pt.isha];

      for (var i = 0; i < 5; i++) {
        if (!isPrayerEnabled(i)) continue;
        final local = times[i].toLocal();
        final when = tz.TZDateTime(tz.local, local.year, local.month,
            local.day, local.hour, local.minute, local.second);
        if (!when.isAfter(now)) continue;

        await _plugin.zonedSchedule(
          _id(d, i),
          'Prayer Reminder',
          "It's time for ${prayers[i]} prayer",
          when,
          _details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  /// Debug helper: fire a reminder for [name] immediately.
  static Future<void> showTestNotification(String name) async {
    await _plugin.show(
      9999,
      'Prayer Reminder',
      "It's time for $name prayer",
      _details,
    );
  }
}
