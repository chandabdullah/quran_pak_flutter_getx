import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String appName = 'Momin';

Duration apiCallAfter = const Duration(hours: 1);

/// Mushaf-style Arabic font used for Quran / Arabic text.
String? get arabicFont => GoogleFonts.amiriQuran().fontFamily;

/// Nastaliq font used for Urdu translations.
String? get urduFont => GoogleFonts.notoNastaliqUrdu().fontFamily;

/// Primary UI / English font (matches the app's modern design language).
String? get uiFont => GoogleFonts.poppins().fontFamily;

const double kPadding = 16.0;
const double kSpacing = 12.0;
const double kBorderRadius = 6.0;

double kBottomPadding(BuildContext context) {
  return MediaQuery.of(context).padding.bottom;
}

double kTopPadding(BuildContext context) {
  return MediaQuery.of(context).padding.top;
}

double kRightPadding(BuildContext context) {
  return MediaQuery.of(context).padding.right;
}

double kLeftPadding(BuildContext context) {
  return MediaQuery.of(context).padding.left;
}
