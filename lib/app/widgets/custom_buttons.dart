import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.text,
    this.onPress,
  });

  final String text;
  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: kSpacing,
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return Get.theme.colorScheme.primary.withOpacity(0.5);
            } else if (states.contains(WidgetState.disabled)) {
              return Get.theme.splashColor;
            }
            return Colors.transparent;
          },
        ),
        shape: WidgetStateProperty.resolveWith(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return null;
            }
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
              side: BorderSide(
                color: Get.theme.primaryColor,
                width: 1,
              ),
            );
          },
          // RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(
          //     kBorderRadius,
          //   ),
          //   side: BorderSide(
          //     color: Get.theme.primaryColor,
          //     width: 1,
          //   ),
          // ),
        ),
      ),
      onPressed: onPress,
      child: Text(text),
    );
  }
}
