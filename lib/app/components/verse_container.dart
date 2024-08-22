import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:quran_flutter/quran_flutter.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/utils/quran_utils.dart';

class VerseContainer extends StatelessWidget {
  const VerseContainer({
    super.key,
    required this.verse,
    // this.translatedVerse,
    // this.englishAya,
    // this.arabicAya,
    // this.verseNumber,
  });

  // final String? englishAya;
  // final String? arabicAya;
  // final int? verseNumber;
  final Verse verse;
  // final Verse? translatedVerse;

  @override
  Widget build(BuildContext context) {
    Verse translatedVerse = Quran.getVerse(
      surahNumber: verse.surahNumber,
      verseNumber: verse.verseNumber,
      language: QuranLanguage.urdu,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPadding,
        vertical: kSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichText(
            textAlign: TextAlign.end,
            text: TextSpan(
                text: "${verse.text} ",
                style: Get.textTheme.bodyLarge?.copyWith(
                  fontFamily: arabicFont,
                ),
                children: [
                  TextSpan(
                    text: QuranUtils.getVerseEndSymbol(verse.verseNumber),
                    style: Get.textTheme.bodyLarge?.copyWith(
                      color: Get.theme.primaryColor,
                    ),
                  ),
                ]),
          ),
          const Gap(25),
          // if (translatedVerse != null)
          Text(
            "${translatedVerse.verseNumber}. ${translatedVerse.text}",
            textAlign: TextAlign.start,
            style: Get.textTheme.bodyMedium,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
