import 'package:adhan/adhan.dart';

const int defaultCalculationMethod = 2;

Map<String, dynamic> allCalculationMethods = {
  "calculationMethods": [
    {
      "id": 3,
      "name": "Muslim World League",
      "params": {"Fajr": 18, "Isha": 17},
      "location": {"latitude": 51.5194682, "longitude": -0.1360365},
      "method": CalculationMethod.muslim_world_league
    },
    {
      "id": 2,
      "name": "Islamic Society of North America (ISNA)",
      "params": {"Fajr": 15, "Isha": 15},
      "location": {
        "latitude": 39.70421229999999,
        "longitude": -86.39943869999999
      },
      "method": CalculationMethod.north_america
    },
    {
      "id": 5,
      "name": "Egyptian General Authority of Survey",
      "params": {"Fajr": 19.5, "Isha": 17.5},
      "location": {"latitude": 30.0444196, "longitude": 31.2357116},
      "method": CalculationMethod.egyptian
    },
    {
      "id": 4,
      "name": "Umm Al-Qura University, Makkah",
      "params": {"Fajr": 18.5, "Isha": 90}, // isha 90 min
      "location": {"latitude": 21.3890824, "longitude": 39.8579118},
      "method": CalculationMethod.umm_al_qura
    },
    {
      "id": 1,
      "name": "University of Islamic Sciences, Karachi",
      "params": {"Fajr": 18, "Isha": 18},
      "location": {"latitude": 24.8614622, "longitude": 67.0099388},
      "method": CalculationMethod.karachi
    },
    {
      "id": 7,
      "name": "Institute of Geophysics, University of Tehran",
      "params": {
        "Fajr": 17.7,
        "Isha": 14,
        "Maghrib": 4.5,
        "Midnight": "JAFARI"
      },
      "location": {"latitude": 35.6891975, "longitude": 51.3889736},
      "method": CalculationMethod.tehran
    },
    {
      "id": 9,
      "name": "Kuwait",
      "params": {"Fajr": 18, "Isha": 17.5},
      "location": {"latitude": 29.375859, "longitude": 47.9774052},
      "method": CalculationMethod.kuwait
    },
    {
      "id": 10,
      "name": "Qatar",
      "params": {"Fajr": 18, "Isha": 90}, // isha 90 min
      "location": {"latitude": 25.2854473, "longitude": 51.5310398},
      "method": CalculationMethod.qatar
    },
    {
      "id": 11,
      "name": "Majlis Ugama Islam Singapura, Singapore",
      "params": {"Fajr": 20, "Isha": 18},
      "location": {"latitude": 1.352083, "longitude": 103.819836},
      "method": CalculationMethod.singapore
    },
    {
      "id": 13,
      "name": "Diyanet İşleri Başkanlığı, Turkey",
      "params": {"Fajr": 18, "Isha": 17},
      "location": {"latitude": 39.9333635, "longitude": 32.8597419},
      "method": CalculationMethod.turkey
    },
    {
      "id": 15,
      "name": "Moonsighting Committee Worldwide (Moonsighting.com)",
      "params": {"shafaq": "general"},
      "method": CalculationMethod.moon_sighting_committee,
    },
    {
      "id": 16,
      "name": "Dubai (experimental)",
      "params": {"Fajr": 18.2, "Isha": 18.2},
      "location": {"latitude": 25.0762677, "longitude": 55.087404},
      "method": CalculationMethod.dubai
    },
    {
      "id": 17,
      "name": "Shia Ithna-Ashari, Leva Institute, Qum",
      "params": {
        "Fajr": 16,
        "Isha": 14,
        "maghrib": 4,
        "Midnight": "JAFARI",
      },
      "location": {"latitude": 25.0762677, "longitude": 55.087404},
      "method": CalculationMethod.other,
    },
  ]
};
