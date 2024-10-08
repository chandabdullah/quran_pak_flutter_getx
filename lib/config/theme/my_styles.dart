import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/app/constants/app_constants.dart';

import 'dark_theme_colors.dart';
import 'my_fonts.dart';
import 'light_theme_colors.dart';

class MyStyles {
  ///icons theme
  static IconThemeData getIconTheme({required bool isLightTheme}) =>
      IconThemeData(
        color: isLightTheme
            ? LightThemeColors.iconColor
            : DarkThemeColors.iconColor,
      );

  /// input theme
  static InputDecorationTheme getInputTheme({required bool isLightTheme}) =>
      InputDecorationTheme(
        filled: true,
        fillColor: Get.theme.cardColor.withOpacity(.3),
        hintStyle: Get.textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: kSpacing,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: Get.textTheme.bodyMedium?.copyWith(
          color: MaterialStateColor.resolveWith(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.focused)) {
                return isLightTheme
                    ? LightThemeColors.primaryColor.call()
                    : DarkThemeColors.primaryColor.call();
              }
              if (states.contains(MaterialState.error)) {
                return Colors.red;
              }
              return isLightTheme
                  ? LightThemeColors.bodyTextColor
                  : DarkThemeColors.bodyTextColor;
            },
          ),
        ),
        prefixIconColor:
            MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.focused)) {
            return isLightTheme
                ? LightThemeColors.bodyTextColor
                : DarkThemeColors.bodyTextColor;
          }
          if (states.contains(MaterialState.error)) {
            return Colors.red;
          }
          return isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor;
        }),

        // prefixIconColor: isLightTheme
        //     ? LightThemeColors.primaryColor.call()
        //     : DarkThemeColors.primaryColor.call(),
        suffixIconColor: isLightTheme
            ? LightThemeColors.primaryColor.call()
            : DarkThemeColors.primaryColor.call(),
        focusColor: isLightTheme
            ? LightThemeColors.primaryColor.call()
            : DarkThemeColors.primaryColor.call(),
      );

  ///app bar theme
  static AppBarTheme getAppBarTheme({required bool isLightTheme}) =>
      AppBarTheme(
        elevation: 0,
        foregroundColor: isLightTheme
            ? LightThemeColors.appBarIconsColor
            : DarkThemeColors.appBarIconsColor,
        toolbarTextStyle:
            getTextTheme(isLightTheme: isLightTheme).bodyLarge!.copyWith(
                  color: isLightTheme
                      ? LightThemeColors.appBarIconsColor
                      : DarkThemeColors.appBarIconsColor,
                  fontSize: MyFonts.appBarTittleSize,
                ),
        titleTextStyle:
            getTextTheme(isLightTheme: isLightTheme).titleLarge!.copyWith(
                  color: isLightTheme
                      ? LightThemeColors.appBarIconsColor
                      : DarkThemeColors.appBarIconsColor,
                  fontSize: MyFonts.appBarTittleSize,
                ),
        centerTitle: true,
        actionsIconTheme: IconThemeData(
          color: isLightTheme
              ? LightThemeColors.appBarIconsColor
              : DarkThemeColors.appBarIconsColor,
        ),
        iconTheme: IconThemeData(
          color: isLightTheme
              ? LightThemeColors.appBarIconsColor
              : DarkThemeColors.appBarIconsColor,
        ),
        backgroundColor: isLightTheme
            ? LightThemeColors.appBarColor
            : DarkThemeColors.appBarColor,
      );

  ///List Tile
  static ListTileThemeData getListTileTheme({required bool isLightTheme}) =>
      const ListTileThemeData();

  ///text theme
  static TextTheme getTextTheme({required bool isLightTheme}) => TextTheme(
        bodyLarge: Get.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        bodyMedium: Get.textTheme.bodyMedium?.copyWith(
          color: isLightTheme
              ? LightThemeColors.bodyTextColor.withOpacity(.7)
              : DarkThemeColors.bodyTextColor.withOpacity(.7),
        ),
        bodySmall: Get.textTheme.bodySmall?.copyWith(
          color: isLightTheme
              ? LightThemeColors.bodyTextColor.withOpacity(.7)
              : DarkThemeColors.bodyTextColor.withOpacity(.7),
        ),
        displayLarge: Get.textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        displayMedium: Get.textTheme.displayMedium?.copyWith(
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        displaySmall: Get.textTheme.displaySmall?.copyWith(
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        headlineLarge: Get.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        headlineMedium: Get.textTheme.headlineMedium?.copyWith(
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        headlineSmall: Get.textTheme.headlineSmall?.copyWith(
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        titleLarge: Get.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        titleMedium: Get.textTheme.titleMedium?.copyWith(
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        titleSmall: Get.textTheme.titleSmall?.copyWith(
          color: isLightTheme
              ? LightThemeColors.bodyTextColor
              : DarkThemeColors.bodyTextColor,
        ),
        labelSmall: Get.textTheme.labelSmall?.copyWith(
          color: isLightTheme
              ? LightThemeColors.captionTextColor
              : DarkThemeColors.captionTextColor,
        ),
      );

  static ChipThemeData getChipTheme({required bool isLightTheme}) {
    return ChipThemeData(
      backgroundColor: isLightTheme
          ? LightThemeColors.chipBackground
          : DarkThemeColors.chipBackground,
      brightness: Brightness.light,
      labelStyle: getChipTextStyle(isLightTheme: isLightTheme),
      secondaryLabelStyle: getChipTextStyle(isLightTheme: isLightTheme),
      selectedColor: Colors.black,
      disabledColor: Colors.green,
      padding: EdgeInsets.all(5),
      secondarySelectedColor: Colors.purple,
    );
  }

  ///Chips text style
  static TextStyle getChipTextStyle({required bool isLightTheme}) {
    return MyFonts.chipTextStyle.copyWith(
      fontSize: MyFonts.chipTextSize,
      color: isLightTheme
          ? LightThemeColors.chipTextColor
          : DarkThemeColors.chipTextColor,
    );
  }

  // elevated button text style
  static WidgetStateProperty<TextStyle?>? getElevatedButtonTextStyle(
      bool isLightTheme,
      {bool isBold = true,
      double? fontSize}) {
    return WidgetStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return MyFonts.buttonTextStyle.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: fontSize ?? MyFonts.buttonTextSize,
              color: isLightTheme
                  ? LightThemeColors.buttonTextColor
                  : DarkThemeColors.buttonTextColor);
        } else if (states.contains(MaterialState.disabled)) {
          return MyFonts.buttonTextStyle.copyWith(
              fontSize: fontSize ?? MyFonts.buttonTextSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isLightTheme
                  ? LightThemeColors.buttonDisabledTextColor
                  : DarkThemeColors.buttonDisabledTextColor);
        }
        return MyFonts.buttonTextStyle.copyWith(
            fontSize: fontSize ?? MyFonts.buttonTextSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isLightTheme
                ? LightThemeColors.buttonTextColor
                : DarkThemeColors
                    .buttonTextColor); // Use the component's default.
      },
    );
  }

  //elevated button theme data
  static ElevatedButtonThemeData getElevatedButtonTheme(
          {required bool isLightTheme}) =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.r),
              //side: BorderSide(color: Colors.teal, width: 2.0),
            ),
          ),
          elevation: WidgetStateProperty.all(0),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 8.h)),
          textStyle: getElevatedButtonTextStyle(isLightTheme),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return isLightTheme
                    ? LightThemeColors.buttonTextColor
                    : DarkThemeColors.buttonTextColor;
              } else if (states.contains(MaterialState.disabled)) {
                return isLightTheme
                    ? LightThemeColors.buttonTextColor
                    : DarkThemeColors.buttonTextColor;
              }
              return isLightTheme
                  ? LightThemeColors.buttonTextColor
                  : DarkThemeColors.buttonTextColor;
            },
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return isLightTheme
                    ? LightThemeColors.buttonColor.withOpacity(.5)
                    : DarkThemeColors.buttonColor.withOpacity(.5);
              } else if (states.contains(MaterialState.disabled)) {
                return isLightTheme
                    ? LightThemeColors.buttonDisabledColor
                    : DarkThemeColors.buttonDisabledColor;
              }
              return isLightTheme
                  ? LightThemeColors.buttonColor
                  : DarkThemeColors.buttonColor;
            },
          ),
        ),
      );

  //elevated button theme data
  static TextButtonThemeData getTextButtonTheme({required bool isLightTheme}) =>
      TextButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.r),
              //side: BorderSide(color: Colors.teal, width: 2.0),
            ),
          ),
          elevation: WidgetStateProperty.all(0),
          padding:
              WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(
            vertical: 8.h,
            horizontal: 5.w,
          )),
          // textStyle: getElevatedButtonTextStyle(isLightTheme, isBold: false),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return isLightTheme
                    ? LightThemeColors.primaryColor.call().withOpacity(.1)
                    : DarkThemeColors.primaryColor.call().withOpacity(.1);
              } else if (states.contains(MaterialState.disabled)) {
                return isLightTheme
                    ? LightThemeColors.buttonDisabledColor
                    : DarkThemeColors.buttonDisabledColor;
              }
              return Colors.transparent;
            },
          ),
        ),
      );

  static OutlinedButtonThemeData getOutlinedButtonThemeData(
          {required bool isLightTheme}) =>
      OutlinedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStateProperty.all<BorderSide?>(
            BorderSide(
              color: isLightTheme
                  ? LightThemeColors.primaryColor.call()
                  : DarkThemeColors.primaryColor.call(),
              width: 1.0,
            ),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          elevation: WidgetStateProperty.all(0),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 8.h)),
          textStyle: getElevatedButtonTextStyle(isLightTheme),
          // backgroundColor: WidgetStateProperty.resolveWith<Color>(
          //   (Set<MaterialState> states) {
          //     if (states.contains(MaterialState.pressed)) {
          //       return isLightTheme
          //           ? LightThemeColors.primaryColor.call()
          //           : DarkThemeColors.primaryColor.call();
          //     } else if (states.contains(MaterialState.disabled)) {
          //       return isLightTheme
          //           ? LightThemeColors.buttonDisabledColor
          //           : DarkThemeColors.buttonDisabledColor;
          //     }
          //     return isLightTheme
          //         ? LightThemeColors.primaryColor.call()
          //         : DarkThemeColors
          //             .primaryColor; // Use the component's default.
          //   },
          // ),
        ),
      );
}
