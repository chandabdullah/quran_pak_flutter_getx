import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
    this.subtitle,
    this.subtitleWidget,
    this.iconColor,
    this.borderRadius,
    this.trailing,
  });

  final String title;
  final IconData? icon;
  final Function()? onTap;
  final String? subtitle;
  final Widget? subtitleWidget;
  final Color? iconColor;
  final BorderRadius? borderRadius;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: kSpacing,
        vertical: 0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
      iconColor: iconColor,
      leading: icon == null
          ? const SizedBox()
          : Icon(
              icon,
              size: 25.sp,
              color: onTap == null ? Get.theme.disabledColor : null,
            ),
      title: Text(
        title,
        style: Get.textTheme.bodyLarge?.copyWith(
          color: onTap == null ? Get.theme.disabledColor : null,
        ),
      ),
      subtitle: subtitleWidget ??
          (subtitle == null
              ? null
              : Text(
                  subtitle ?? "",
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: onTap == null ? Get.theme.disabledColor : null,
                  ),
                )),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing ?? "",
              style: Get.textTheme.bodySmall?.copyWith(
                color: onTap == null ? Get.theme.disabledColor : null,
              ),
            ),
          Icon(
            Icons.keyboard_arrow_right_rounded,
            color:
                onTap == null ? Get.theme.disabledColor : Get.theme.hintColor,
          ),
        ],
      ),
    );
  }
}

class CustomSwitchListTile extends StatelessWidget {
  const CustomSwitchListTile({
    super.key,
    required this.value,
    required this.title,
    required this.icon,
    this.onChange,
    this.subtitle,
    this.iconColor,
    this.borderRadius,
  });

  final bool value;
  final String title;
  final IconData icon;
  final Function(bool)? onChange;
  final String? subtitle;
  final Color? iconColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChange,
      dense: true,
      // onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: kSpacing,
        vertical: 0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
      controlAffinity: ListTileControlAffinity.trailing,
      secondary: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(
        title,
        style: Get.textTheme.bodyLarge,
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle ?? "",
              style: Get.textTheme.bodyMedium,
            ),
    );
  }
}
