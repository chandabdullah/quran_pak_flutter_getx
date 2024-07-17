import 'package:flutter/material.dart';

extension HexColorExtension on String {
  Color hexToColor() {
    String hexCode = "#$this";
    return Color(int.parse(hexCode.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

extension ColorHexExtension on Color {
  String colorToHex() {
    return value.toRadixString(16).substring(2).toUpperCase();
  }
}
