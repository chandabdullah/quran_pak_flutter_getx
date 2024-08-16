import 'package:adhan/adhan.dart';
import '/app/data/local/my_shared_pref.dart';
import '/app/data/local_data/midnight_methods.dart';
import 'package:intl/intl.dart';

class PrayerTimeService {
  static Future<Coordinates> getCoordinates({
    double? newLatitude,
    double? newLongitude,
  }) async {
    // City? city = await getOrSaveLocationToLocal();
    Coordinates? coordinates = MyCoordinates.getCoordinates();

    final myCoordinates = Coordinates(
      // 35.6762, 139.6503, // TOKYO
      // 40.6943, -73.9249,  // NEW YORK
      newLatitude ??
          coordinates?.latitude
          // ?? position?.latitude
          ??
          0,
      newLongitude ??
          coordinates?.longitude
          // ?? position?.longitude
          ??
          0,
    );

    return myCoordinates;
  }

  static CalculationParameters getParameters() {
    var savedCalculationMethod = MyCalculationMethod.getCalculationMethod();
    var savedIslamicMadhhab = MyIslamicMadhab.getIslamicMethod();
    var savedMidnightMethod = MyMidnightMethods.getMidnightMethod();

    int fajarTimeAdjustment = MyPrayerAdjustment.getFajarTimeAdjustment();
    int sunriseTimeAdjustment = MyPrayerAdjustment.getSunriseTimeAdjustment();
    int dhuhrTimeAdjustment = MyPrayerAdjustment.getDuhurTimeAdjustment();
    int asrTimeAdjustment = MyPrayerAdjustment.getAsrTimeAdjustment();
    int maghribTimeAdjustment = MyPrayerAdjustment.getMagribTimeAdjustment();
    int ishaTimeAdjustment = MyPrayerAdjustment.getIshaTimeAdjustment();

    //? Parameters
    CalculationParameters params =
        savedCalculationMethod.method.getParameters();

    //? Madhhab
    params.madhab = savedIslamicMadhhab.value;

    //? High latitude rule
    params.highLatitudeRule = HighLatitudeRule.middle_of_the_night;

    if (MyCalculationMethod.getCalculationMethod().id == 17) {
      params.fajrAngle =
          MyCalculationMethod.getCalculationMethod().params?.fajr ?? 18.0;
      params.ishaAngle =
          MyCalculationMethod.getCalculationMethod().params?.isha ?? 14.0;
      params.maghribAngle =
          MyCalculationMethod.getCalculationMethod().params?.maghrib ?? 4.0;
    }
    // params.highLatitudeRule = HighLatitudeRule.twilight_angle;

    //? Midnight Methods
    switch (savedMidnightMethod.method) {
      case MidnightMode.sunsetToSunrise:
        params.methodAdjustments = PrayerAdjustments(
          fajr: -10,
          isha: 10,
        );
        break;
      case MidnightMode.sunsetToFajr:
        params.methodAdjustments = PrayerAdjustments(
          isha: 10,
        );
        break;
      case MidnightMode.maghribToSunrise:
        params.methodAdjustments = PrayerAdjustments(
          fajr: -10,
        );
        break;
      case MidnightMode.maghribToFajr:
        break;
    }

    //? Prayer Time Adjustment
    params.adjustments = PrayerAdjustments(
      fajr: fajarTimeAdjustment,
      sunrise: sunriseTimeAdjustment,
      dhuhr: dhuhrTimeAdjustment,
      asr: asrTimeAdjustment,
      maghrib: maghribTimeAdjustment,
      isha: ishaTimeAdjustment,
    );

    return params;
  }

  static bool isCurrentPrayer({
    required String prayerName,
    PrayerTimes? prayerTimes,
    DateTime? selectedDate,
  }) {
    return DateFormat('dd MMM yyyy').format(selectedDate ?? DateTime.now()) !=
            DateFormat('dd MMM yyyy').format(DateTime.now())
        ? false
        : prayerTimes?.currentPrayer().name == prayerName;
  }
}
