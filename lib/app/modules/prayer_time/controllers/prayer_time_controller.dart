import 'package:adhan/adhan.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:quran_pak/app/modules/home/controllers/home_controller.dart';
import 'package:quran_pak/app/services/api_call_status.dart';
import 'package:quran_pak/app/services/notification_service.dart';
import 'package:quran_pak/app/services/prayer_time_service.dart';
import 'package:quran_pak/utils/date_time_utils.dart';

class PrayerTimeController extends GetxController {
  var homeController = Get.find<HomeController>();

  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  /// Whether the OS notification permission is granted.
  bool notificationsAllowed = false;

  Future<void> refreshNotificationPermission() async {
    notificationsAllowed = await NotificationService.areEnabled();
    update();
  }

  bool isNotifEnabled(int index) => NotificationService.isPrayerEnabled(index);

  /// Toggles the reminder for a prayer. Returns false if permission is missing.
  /// Scheduling uses each upcoming day's real computed prayer time.
  Future<bool> togglePrayerNotification(int index) async {
    if (!notificationsAllowed) {
      await refreshNotificationPermission();
      if (!notificationsAllowed) return false;
    }
    final enabled = !NotificationService.isPrayerEnabled(index);
    await NotificationService.setPrayerEnabled(index, enabled: enabled);
    update();
    return true;
  }

  final calendarControllerToday = AdvancedCalendarController.today();

  PrayerTimes? todayPrayerTimes;
  PrayerTimes? prayerTimes;

  DateTime selectedDate = DateTime.now();

  HijriCalendar selectedIslamicDate() => selectedDate.adjustHijriDateFunction();
  // HijriCalendar selectedIslamicDate = HijriCalendar.fromDate(
  //   DateTime.now().add(
  //     Duration(
  //       days: MyHijriAdjustment.getHijriAdjustment(),
  //     ),
  //   ),
  // );

  addCalendarListener() {
    calendarControllerToday.addListener(() {
      selectedDate = calendarControllerToday.value;
      update();
      getPrayerTime();
    });
  }

  onDateChange(DateTime newDate) {
    selectedDate = newDate;
    calendarControllerToday.value = newDate;
    update();
    getPrayerTime();
  }

  getPrayerTime() async {
    apiCallStatus = ApiCallStatus.loading;
    update();

    Coordinates myCoordinates = await PrayerTimeService.getCoordinates();
    CalculationParameters parameters = PrayerTimeService.getParameters();

    DateComponents dateComponents = DateComponents(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    try {
      prayerTimes = PrayerTimes(
        myCoordinates,
        dateComponents,
        parameters,
      );
      apiCallStatus = ApiCallStatus.success;
      update();
    } catch (e) {
      // CustomSnackBar.showCustomToast(message: e.toString());
      apiCallStatus = ApiCallStatus.error;
      update();
    }
  }

  @override
  void onInit() {
    todayPrayerTimes = homeController.prayerTimes;
    update();
    getPrayerTime();
    refreshNotificationPermission();
    super.onInit();
  }

  @override
  void onReady() {
    addCalendarListener();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    calendarControllerToday.dispose();
    super.dispose();
  }
}
