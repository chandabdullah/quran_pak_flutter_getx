import 'package:quran_flutter/quran_flutter.dart';

class QuranUtils {
  static getSurahPlace(SurahType? place) {
    return place == SurahType.meccan ? 'Makki' : 'Madani';
  }

  ///Takes [verseNumber], [arabicNumeral] (optional) and returns '۝' symbol with verse number
  static String getVerseEndSymbol(int verseNumber,
      {bool arabicNumeral = true}) {
    var arabicNumeric = '';
    var digits = verseNumber.toString().split("").toList();

    if (!arabicNumeral) return '\u06dd${verseNumber.toString()}';

    const Map arabicNumbers = {
      "0": "٠",
      "1": "١",
      "2": "٢",
      "3": "٣",
      "4": "٤",
      "5": "٥",
      "6": "٦",
      "7": "٧",
      "8": "٨",
      "9": "٩",
    };

    for (var e in digits) {
      arabicNumeric += arabicNumbers[e];
    }

    return '\u06dd$arabicNumeric';
  }

  static bool showBismillah(surahNumber) =>
      (surahNumber != 1 && surahNumber != 9);
}
