import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:location/location.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/app/services/connectivity_service.dart';
import 'package:quran_pak/app/services/location_service.dart';
import 'package:quran_pak/app/services/prayer_time_service.dart';
import 'package:quran_pak/utils/date_time_utils.dart';
import 'package:turn_page_transition/turn_page_transition.dart';
// import 'package:intl/intl.dart';

class HomeController extends GetxController {
  HijriCalendar islamicDate() =>
      DateTime.now().toLocal().adjustHijriDateFunction();

  bool isInternetAvailable = true;

  PrayerTimes? prayerTimes;
  PrayerTimes? nextPrayerTimes;
  SunnahTimes? sunnahTimes;

  DateTime get today => DateTime.now().toLocal();
  DateTime? currentPrayerTime() => prayerTimes?.timeForPrayer(
        prayerTimes!.currentPrayer(),
      );
  DateTime? nextPrayerTime() => prayerTimes?.timeForPrayer(
        prayerTimes!.nextPrayer(),
      );

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
