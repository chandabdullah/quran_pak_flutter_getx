import 'package:adhan/adhan.dart';

const int defaultMidnightMethod = 4;

enum MidnightMode {
  sunsetToSunrise,
  sunsetToFajr,
  maghribToSunrise,
  maghribToFajr,
}

Map<String, dynamic> allMidnightMethods = {
  "midnightMethods": [
    {
      "id": 1,
      "name": "Sunset to Sunrise",
      "method": MidnightMode.sunsetToSunrise,
    },
    {
      "id": 2,
      "name": "Sunset to Fajar",
      "method": MidnightMode.sunsetToFajr,
    },
    {
      "id": 3,
      "name": "Maghrib to Sunrise",
      "method": MidnightMode.maghribToSunrise,
    },
    {
      "id": 4,
      "name": "Maghrib to Fajar",
      "method": MidnightMode.maghribToFajr,
    },
  ]
};
