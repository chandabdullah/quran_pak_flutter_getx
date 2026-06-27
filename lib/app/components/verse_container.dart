import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:quran_flutter/quran_flutter.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/utils/quran_utils.dart';

class VerseContainer extends StatefulWidget {
  const VerseContainer({
    super.key,
    required this.verse,
    this.arabicFontSize,
    this.translatedFontSize,
    this.showVerseSymbol = true,
  });

  final Verse verse;
  final double? arabicFontSize;
  final double? translatedFontSize;
  final bool showVerseSymbol;

  @override
  State<VerseContainer> createState() => _VerseContainerState();
}

class _VerseContainerState extends State<VerseContainer> {
  late bool _bookmarked;

  @override
  void initState() {
    super.initState();
    _bookmarked = MyBookmark.isBookmarked(
      widget.verse.surahNumber,
      widget.verse.verseNumber,
    );
  }

  void _toggleBookmark() {
    final surah = Quran.getSurah(widget.verse.surahNumber);
    final nowBookmarked = MyBookmark.toggleBookmark(
      surah: widget.verse.surahNumber,
      verse: widget.verse.verseNumber,
      surahName: surah.nameEnglish,
      savedAt: DateTime.now().millisecondsSinceEpoch,
    );
    setState(() => _bookmarked = nowBookmarked);
    Get.closeAllSnackbars();
    Get.rawSnackbar(
      messageText: Text(
        nowBookmarked
            ? "Bookmarked ${surah.nameEnglish} : ${widget.verse.verseNumber}"
            : "Bookmark removed",
        style: Get.textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
      icon: Icon(
        nowBookmarked ? Icons.bookmark_added_rounded : Icons.bookmark_remove_rounded,
        color: Colors.white,
      ),
      backgroundColor: Get.theme.primaryColor,
      margin: const EdgeInsets.all(kPadding),
      borderRadius: kBorderRadius,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    final QuranLanguage language = MyQuranTranslation.getTranslationLanguage();
    final Verse translatedVerse = Quran.getVerse(
      surahNumber: widget.verse.surahNumber,
      verseNumber: widget.verse.verseNumber,
      language: language,
    );

    // Pick the right translation font: Nastaliq for Urdu, Amiri for other
    // RTL scripts, the default UI font otherwise.
    final String? translationFont = language == QuranLanguage.urdu
        ? urduFont
        : (language.isRTL ? arabicFont : null);

    final theme = Get.theme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: theme.splashColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Action strip: verse number + bookmark toggle.
          Container(
            color: theme.primaryColor.withValues(alpha: .06),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(kBorderRadius),
                  ),
                  child: Text(
                    "${widget.verse.surahNumber}:${widget.verse.verseNumber}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(kBorderRadius),
                  onTap: _toggleBookmark,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      _bookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: theme.primaryColor,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kPadding,
              vertical: kSpacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                  textAlign: TextAlign.end,
                  textDirection: TextDirection.rtl,
                  text: TextSpan(
                    text: "${widget.verse.text} ",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontFamily: arabicFont,
                      height: 2,
                      fontWeight: FontWeight.normal,
                      fontSize: widget.arabicFontSize ??
                          (MyFontSize.getArabicFontSize() *
                              MyFontSize.defaultArabicMultiply),
                    ),
                    children: [
                      if (widget.showVerseSymbol)
                        TextSpan(
                          text: QuranUtils.getVerseEndSymbol(
                              widget.verse.verseNumber),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.primaryColor,
                          ),
                        ),
                    ],
                  ),
                ),
                if (MyQuranTranslation.getShowQuranTranslation()) ...[
                  const Gap(18),
                  Text(
                    "${widget.showVerseSymbol ? "${translatedVerse.verseNumber}. " : ""}"
                    "${translatedVerse.text}",
                    textAlign: language.isRTL ? TextAlign.end : TextAlign.start,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: translationFont,
                      height: language == QuranLanguage.urdu ? 2.2 : 1.6,
                      fontSize: widget.translatedFontSize ??
                          (MyFontSize.getTranslatedFontSize() *
                              MyFontSize.defaultTranslatedMultiply),
                    ),
                    textDirection:
                        language.isRTL ? TextDirection.rtl : TextDirection.ltr,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
