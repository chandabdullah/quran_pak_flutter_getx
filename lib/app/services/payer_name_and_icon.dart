import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

List<String> prayerNamesList = const <String>[
  "fajr",
  "sunrise",
  "dhuhr",
  "asr",
  "maghrib",
  "isha",
];

IconData returnIconAccordingToPrayer(
  currentPrayer, {
  String? prayerName,
  bool? isSolid = false,
}) {
  IconData icon = UIcons.regularRounded.cloud_moon;

  if ((prayerName ?? currentPrayer) == prayerNamesList[0]) {
    icon = isSolid == true
        ? UIcons.solidRounded.moon_stars
        : UIcons.regularRounded.moon_stars;
  } else if ((prayerName ?? currentPrayer) == prayerNamesList[1]) {
    icon = isSolid == true
        ? UIcons.solidRounded.sunrise
        : UIcons.regularRounded.sunrise;
  } else if ((prayerName ?? currentPrayer) == prayerNamesList[2]) {
    icon =
        isSolid == true ? UIcons.solidRounded.sun : UIcons.regularRounded.sun;
  } else if ((prayerName ?? currentPrayer) == prayerNamesList[3]) {
    icon = isSolid == true
        ? UIcons.solidRounded.cloud_sun
        : UIcons.regularRounded.cloud_sun;
  } else if ((prayerName ?? currentPrayer) == prayerNamesList[4]) {
    icon = isSolid == true
        ? UIcons.solidRounded.sunset
        : UIcons.regularRounded.sunset;
  } else if ((prayerName ?? currentPrayer) == prayerNamesList[5]) {
    icon =
        isSolid == true ? UIcons.solidRounded.moon : UIcons.regularRounded.moon;
  }
  return icon;

  // switch (prayerName ?? prayerTime) {
  //   case "fajr":
  //     icon = isSolid == true
  //         ? UIcons.solidRounded.moon_stars
  //         : UIcons.regularRounded.moon_stars;
  //     break;
  //   case "sunrise":
  //     icon = isSolid == true
  //         ? UIcons.solidRounded.sunrise
  //         : UIcons.regularRounded.sunrise;
  //     break;
  //   case "dhuhr":
  //     icon =
  //         isSolid == true ? UIcons.solidRounded.sun : UIcons.regularRounded.sun;
  //     break;
  //   case "asr":
  //     icon = isSolid == true
  //         ? UIcons.solidRounded.cloud_sun
  //         : UIcons.regularRounded.cloud_sun;
  //     break;
  //   case "maghrib":
  //     icon = isSolid == true
  //         ? UIcons.solidRounded.sunset
  //         : UIcons.regularRounded.sunset;
  //     break;
  //   case "isha":
  //     icon = isSolid == true
  //         ? UIcons.solidRounded.moon
  //         : UIcons.regularRounded.moon;
  //     break;
  //   default:
  // }
}

// String returnBackgroundAccordingToPrayer(
//   currentPrayer, {
//   String? prayerName,
// }) {
//   String background = AssetsPaths.FAJAR_BACKGROUND;

//   if ((prayerName ?? currentPrayer) == prayerNamesList[0]) {
//     background = AssetsPaths.FAJAR_BACKGROUND;
//   } else if ((prayerName ?? currentPrayer) == prayerNamesList[1]) {
//     background = AssetsPaths.FAJAR_BACKGROUND;
//   } else if ((prayerName ?? currentPrayer) == prayerNamesList[2]) {
//     background = AssetsPaths.DUHUR_BACKGROUND;
//   } else if ((prayerName ?? currentPrayer) == prayerNamesList[3]) {
//     background = AssetsPaths.ASR_BACKGROUND;
//   } else if ((prayerName ?? currentPrayer) == prayerNamesList[4]) {
//     background = AssetsPaths.MAGHRIB_BACKGROUND;
//   } else if ((prayerName ?? currentPrayer) == prayerNamesList[5]) {
//     background = AssetsPaths.ISHA_BACKGROUND;
//   }
//   return background;
// }