import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:quran_flutter/quran_flutter.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/app/modules/home/controllers/home_controller.dart';
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
  late bool _saved;

  int get _surah => widget.verse.surahNumber;
  int get _verse => widget.verse.verseNumber;

  @override
  void initState() {
    super.initState();
    _saved = MyBookmark.isSaved(_surah, _verse);
  }

  /// Heart = save this verse to favourites (many allowed).
  void _toggleSave() {
    final surah = Quran.getSurah(_surah);
    final nowSaved = MyBookmark.toggleSavedVerse(
      surah: _surah,
      verse: _verse,
      surahName: surah.nameEnglish,
      savedAt: DateTime.now().millisecondsSinceEpoch,
    );
    setState(() => _saved = nowSaved);
    _refreshHome();
    _snack(
      nowSaved ? "Saved ${surah.nameEnglish} : $_verse" : "Removed from saved",
      nowSaved ? Icons.favorite_rounded : Icons.heart_broken_rounded,
    );
  }

  /// Bookmark = the single "continue reading" mark. Tapping a marked verse
  /// removes the pin (auto-detect resumes); tapping any other verse pins it.
  void _toggleContinueMark() {
    final surah = Quran.getSurah(_surah);
    if (MyBookmark.isManualMarkAt(_surah, _verse)) {
      MyBookmark.clearManualMark();
      _refreshHome();
      _snack("Continue mark removed — auto-resume on",
          Icons.bookmark_remove_rounded);
    } else {
      // Single bookmark: setting this one replaces any previous mark, and the
      // revision notifier instantly un-highlights the old verse tile.
      MyBookmark.setManualMark(
        surah: _surah,
        verse: _verse,
        surahName: surah.nameEnglish,
      );
      _refreshHome();
      _snack("Continue from ${surah.nameEnglish} : $_verse",
          Icons.bookmark_added_rounded);
    }
  }

  /// Keep the home screen's "Continue Reading" / favourites in sync instantly.
  void _refreshHome() {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().update();
    }
  }

  void _snack(String message, IconData icon) {
    Get.closeAllSnackbars();
    Get.rawSnackbar(
      messageText: Text(message,
          style: Get.textTheme.bodyMedium?.copyWith(color: Colors.white)),
      icon: Icon(icon, color: Colors.white),
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
      surahNumber: _surah,
      verseNumber: _verse,
      language: language,
    );

    // Direction rules: Arabic (verse text) is always RTL. Urdu and English are
    // shown left-to-right; other RTL scripts keep their natural direction.
    final bool isUrdu = language == QuranLanguage.urdu;
    final bool rtl = language.isRTL && isUrdu;
    final TextDirection transDir = rtl ? TextDirection.rtl : TextDirection.ltr;
    final String? translationFont =
        isUrdu ? urduFont : (rtl ? arabicFont : null);

    final theme = Get.theme;

    // Rebuilds whenever the single continue mark changes anywhere, so only the
    // currently-bookmarked verse stays highlighted.
    return ValueListenableBuilder<int>(
      valueListenable: MyBookmark.continueRevision,
      builder: (context, _, __) {
        final bool isContinueMark = MyBookmark.isManualMarkAt(_surah, _verse);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: kPadding, vertical: 6),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(kBorderRadius),
            border: Border.all(
              color: isContinueMark ? theme.primaryColor : theme.splashColor,
              width: isContinueMark ? 1.4 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Action strip: verse number + heart (save) + bookmark (continue).
              Container(
                color: theme.primaryColor.withValues(alpha: .06),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(kBorderRadius),
                      ),
                      child: Text(
                        "$_surah:$_verse",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _iconButton(
                      icon: _saved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      active: _saved,
                      onTap: _toggleSave,
                      tooltip: "Save verse",
                    ),
                    _iconButton(
                      icon: isContinueMark
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      active: isContinueMark,
                      onTap: _toggleContinueMark,
                      tooltip: "Continue mark",
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
                    // Arabic — always right to left.
                    RichText(
                      textAlign: TextAlign.end,
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
                              text: QuranUtils.getVerseEndSymbol(_verse),
                              style: theme.textTheme.bodyLarge
                                  ?.copyWith(color: theme.primaryColor),
                            ),
                        ],
                      ),
                    ),
                    if (MyQuranTranslation.getShowQuranTranslation()) ...[
                      const Gap(18),
                      Text(
                        translatedVerse.text,
                        textAlign: rtl ? TextAlign.end : TextAlign.start,
                        // textDirection: transDir,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontFamily: translationFont,
                          height: language == QuranLanguage.urdu ? 2.2 : 1.6,
                          fontSize: widget.translatedFontSize ??
                              (MyFontSize.getTranslatedFontSize() *
                                  MyFontSize.defaultTranslatedMultiply),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _iconButton({
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      tooltip: tooltip,
      onPressed: onTap,
      icon: Icon(
        icon,
        color: active ? Get.theme.primaryColor : Get.theme.hintColor,
        size: 22,
      ),
    );
  }
}
