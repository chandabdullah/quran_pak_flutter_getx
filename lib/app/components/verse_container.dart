import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:quran_flutter/quran_flutter.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/utils/quran_utils.dart';

class VerseContainer extends StatelessWidget {
  const VerseContainer({
    super.key,
    required this.verse,
    this.arabicFontSize,
    this.translatedFontSize,
    this.showVerseSymbol = true,
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
  final double? arabicFontSize;
  final double? translatedFontSize;
  final bool showVerseSymbol;

  @override
  Widget build(BuildContext context) {
    QuranLanguage language = MyQuranTranslation.getTranslationLanguage();
    Verse translatedVerse = Quran.getVerse(
      surahNumber: verse.surahNumber,
      verseNumber: verse.verseNumber,
      language: language,
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
                  fontSize: arabicFontSize ??
                      (MyFontSize.getArabicFontSize() *
                          MyFontSize.defaultArabicMultiply),
                ),
                children: [
                  if (showVerseSymbol)
                    TextSpan(
                      text: QuranUtils.getVerseEndSymbol(verse.verseNumber),
                      style: Get.textTheme.bodyLarge?.copyWith(
                        color: Get.theme.primaryColor,
                      ),
                    ),
                ]),
          ),
          if (MyQuranTranslation.getShowQuranTranslation()) const Gap(25),
          if (MyQuranTranslation.getShowQuranTranslation())
            Text(
              "${showVerseSymbol ? "${translatedVerse.verseNumber}. " : ""}"
              "${translatedVerse.text}",
              textAlign: TextAlign.start,
              style: Get.textTheme.bodyMedium?.copyWith(
                fontSize: translatedFontSize ??
                    (MyFontSize.getTranslatedFontSize() *
                        MyFontSize.defaultTranslatedMultiply),
              ),
              textDirection:
                  language.isRTL ? TextDirection.rtl : TextDirection.ltr,
            ),
        ],
      ),
    );
  }
}
