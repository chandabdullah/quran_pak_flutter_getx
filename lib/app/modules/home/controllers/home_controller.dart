import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:quran_pak/app/services/location_service.dart';
import 'package:turn_page_transition/turn_page_transition.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  PrayerTimes? prayerTimes;
  DateTime? nextPrayerTime() => prayerTimes?.timeForPrayer(
        prayerTimes!.nextPrayer(),
      );

  Coordinates? coordinates;

  final TurnPageController turnPageController = TurnPageController(
    direction: TurnDirection.leftToRight,
  );

  getCurrentLocation() async {
    print('----');
    LocationData? location = await LocationService.getCurrentLocation();
    print(location);

    if (location == null) return;
    if (location.latitude == null) return;
    if (location.longitude == null) return;

    coordinates = Coordinates(location.latitude!, location.longitude!);
    print(coordinates);

    update();
  }

  getPrayerTime() {
    if (coordinates == null) return;

    final params = CalculationMethod.karachi.getParameters();
    params.madhab = Madhab.hanafi;
    prayerTimes = PrayerTimes.today(coordinates!, params);
    // final qibla = Qibla(coordinates!);
    // print("direction: ${qibla.direction}");
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

  @override
  void onReady() async {
    await getCurrentLocation();
    await getPrayerTime();
    // var permission = await Geolocator.requestPermission();
    // print("name: ${permission.name}");
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
