import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String appName = 'Momin';

Duration apiCallAfter = const Duration(hours: 1);

String? get arabicFont => GoogleFonts.thasadith().fontFamily;

const double kPadding = 16.0;
const double kSpacing = 12.0;
const double kBorderRadius = 8.0;

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
