import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AyaEnd extends StatelessWidget {
  const AyaEnd({
    super.key,
    required this.number,
    this.size,
  });

  final int number;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(size ?? 35, size ?? 35),
          painter: OctagonalStarPainter(),
        ),
        Text(
          '$number',
          style: Get.textTheme.bodyMedium?.copyWith(
            fontSize: (number) >= 100 ? 12 : 15,
          ),
        ),
      ],
    );
  }
}

class OctagonalStarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Get.theme.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double radius = size.width / 2;
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    Path path = Path();
    int numPoints = 16; // 8 for the star points and 8 for the inner points
    double angle = (2 * pi) / numPoints;

    for (int i = 0; i < numPoints; i++) {
      double outerRadius = i.isEven ? radius : radius * 0.7;
      double x = centerX + outerRadius * cos(i * angle);
      double y = centerY + outerRadius * sin(i * angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
