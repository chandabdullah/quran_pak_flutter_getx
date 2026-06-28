import 'package:adhan/adhan.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:location/location.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/app/services/connectivity_service.dart';
import 'package:quran_pak/app/services/location_service.dart';
import 'package:quran_pak/app/services/notification_service.dart';
import 'package:quran_pak/app/services/prayer_time_service.dart';
import 'package:quran_pak/app/services/prayer_tracker_service.dart';
import 'package:quran_pak/utils/date_time_utils.dart';
import 'package:turn_page_transition/turn_page_transition.dart';
// import 'package:intl/intl.dart';

class HomeController extends GetxController {
  HijriCalendar islamicDate() =>
      DateTime.now().toLocal().adjustHijriDateFunction();

  bool isInternetAvailable = true;
  bool get isResumeReading => false;

  /// The continue-reading position (drives the "Continue Reading" card).
  ContinueMark? get lastRead => MyBookmark.getContinue();

  // --- Daily prayer tracker (Hive-backed, per day) ---------------------------
  static const List<String> trackerPrayers = PrayerTrackerService.prayers;

  /// Today's completion state for the 5 obligatory prayers.
  List<bool> get prayerTracker => PrayerTrackerService.getForDay(today);

  int get completedToday => PrayerTrackerService.completedCount(today);

  void togglePrayerTracker(int index) {
    PrayerTrackerService.toggle(today, index);
    update();
  }

  // --- Location / city -------------------------------------------------------
  final GetStorage _box = GetStorage();
  static const String _cityKey = 'home_city';

  /// Human-readable city for which the prayer times are shown.
  String? get city => _box.read(_cityKey);

  Future<void> _resolveCity() async {
    if (coordinates == null) return;
    try {
      final result = await LocationService.getCityFromLatLng(
        coordinates!.latitude,
        coordinates!.longitude,
      );
      final name = [result?.city, result?.country]
          .where((e) => (e ?? '').isNotEmpty)
          .join(', ');
      if (name.isNotEmpty) {
        _box.write(_cityKey, name);
        update();
      }
    } catch (_) {}
  }

  PrayerTimes? prayerTimes;
  PrayerTimes? nextPrayerTimes;
  SunnahTimes? sunnahTimes;

  DateTime get today => DateTime.now().toLocal();

  /// Active obligatory prayer right now (never "none"); falls back to Fajr
  /// before prayer times are loaded.
  Prayer get currentPrayer => prayerTimes == null
      ? Prayer.fajr
      : PrayerTimeService.activePrayer(prayerTimes!);

  /// Next prayer (never "none"); falls back to Fajr before times are loaded.
  Prayer get upcomingPrayer => prayerTimes == null
      ? Prayer.fajr
      : PrayerTimeService.nextActivePrayer(prayerTimes!);

  /// Display name for the current prayer, e.g. "Isha".
  String get currentPrayerName => PrayerTimeService.prayerName(currentPrayer);

  /// Display name for the next prayer, e.g. "Fajr".
  String get upcomingPrayerName => PrayerTimeService.prayerName(upcomingPrayer);

  DateTime? currentPrayerTime() => prayerTimes?.timeForPrayer(currentPrayer);

  /// Time of the next prayer. After Isha this rolls over to tomorrow's Fajr,
  /// computed from [nextPrayerTimes].
  DateTime? nextPrayerTime() {
    if (prayerTimes == null) return null;
    if (prayerTimes!.nextPrayer() == Prayer.none) {
      return nextPrayerTimes?.timeForPrayer(Prayer.fajr);
    }
    return prayerTimes!.timeForPrayer(upcomingPrayer);
  }

  DateTime? savedDateTime = MyDateTime.getDateTime();
  Coordinates? coordinates = MyCoordinates.getCoordinates();

  final TurnPageController turnPageController = TurnPageController(
    direction: TurnDirection.leftToRight,
  );

  getCurrentLocation() async {
    LocationData? location = await LocationService.getCurrentLocation();

    if (location == null) return;
    if (location.latitude == null) return;
    if (location.longitude == null) return;

    coordinates = Coordinates(location.latitude!, location.longitude!);

    update();
    _resolveCity();
  }

  getPrayerTime() async {
    if (coordinates == null) return;
    MyCoordinates.saveCoordinates(coordinates!);

    // final params = CalculationMethod.karachi.getParameters();
    // params.madhab = Madhab.hanafi;

    Coordinates myCoordinates = await PrayerTimeService.getCoordinates();
    CalculationParameters params = PrayerTimeService.getParameters();

    prayerTimes = PrayerTimes.today(coordinates!, params);
    nextPrayerTimes = PrayerTimes.utc(
      myCoordinates,
      DateComponents(today.year, today.month, today.day + 1),
      params,
    );
    if (prayerTimes != null) sunnahTimes = SunnahTimes(prayerTimes!);

    MyDateTime.saveDateTime(DateTime.now().toLocal());

    // Refresh the 30-day reminder window with the latest computed times.
    NotificationService.rescheduleAll();
  }

  // getPrayerTime() {
  //   if (coordinates == null) return;
  //   PrayerCalculationParameters params = PrayerCalculationMethod.karachi();
  //   params.madhab = PrayerMadhab.hanafi;
  //   PrayerTimes prayerTimes = PrayerTimes(
  //     coordinates: coordinates!,
  //     calculationParameters: params,
  //     precision: true,
  //     dateTime: DateTime.now(),
  //     locationName: 'Asia/Karachi',
  //   );
  //   double qiblaDirection = Qibla.qibla(coordinates!);
  //   print('Qibla Direction:\t$qiblaDirection degrees');
  //   print('Fajr Start Time:\t${prayerTimes.currentPrayer()}');
  //   print('----------');
  //   print(
  //       'Fajr Start Time:\t${DateFormat(DateFormat.HOUR24_MINUTE).format(prayerTimes.fajrStartTime!.toLocal())}');
  //   print(
  //       'Fajr End Time:\t${DateFormat(DateFormat.HOUR24_MINUTE).format(prayerTimes.fajrEndTime!.toLocal())}');
  //   print(
  //       'Sunrise Time:\t${DateFormat(DateFormat.HOUR24_MINUTE).format(prayerTimes.sunrise!.toLocal())}');
  //   print(
  //       'Dhuhr Start Time:\t${DateFormat(DateFormat.HOUR24_MINUTE).format(prayerTimes.dhuhrStartTime!.toLocal())}');
  //   print(
  //       'Dhuhr End Time:\t${DateFormat(DateFormat.HOUR24_MINUTE).format(prayerTimes.dhuhrEndTime!.toLocal())}');
  //   print(
  //       'Asr Start Time:\t${DateFormat(DateFormat.HOUR24_MINUTE).format(prayerTimes.asrStartTime!.toLocal())}');
  //   print(
  //       'Asr End Time:\t${DateFormat(DateFormat.HOUR24_MINUTE).format(prayerTimes.asrEndTime!.toLocal())}');
  //   print(
  //       'Maghrib Start Time:\t${DateFormat(DateFormat.HOUR24_MINUTE).format(prayerTimes.maghribStartTime!.toLocal())}');
  //   print(
  //       'Maghrib End Time:\t${DateFormat(DateFormat.HOUR24_MINUTE).format(prayerTimes.maghribEndTime!.toLocal())}');
  //   print(
  //       'Isha Start Time:\t${DateFormat(DateFormat.HOUR24_MINUTE).format(prayerTimes.ishaStartTime!.toLocal())}');
  //   print(
  //       'Isha End Time:\t${DateFormat(DateFormat.HOUR24_MINUTE).format(prayerTimes.ishaEndTime!.toLocal())}');
  // }

  @override
  void onInit() {
    super.onInit();
    if (city == null) _resolveCity();
  }

  Future<void> checkLocationAndConnectivity() async {
    if (coordinates == null ||
        savedDateTime == null ||
        (savedDateTime?.isToday() == false)) {
      if (await ConnectivityService.checkInternetConnectivity()) {
        await getCurrentLocation();
      } else {
        isInternetAvailable = false;
        update();
      }
    }
  }

  @override
  void onReady() async {
    await checkLocationAndConnectivity();
    await getPrayerTime();
    update();
    // var permission = await Geolocator.requestPermission();
    // print("name: ${permission.name}");
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
