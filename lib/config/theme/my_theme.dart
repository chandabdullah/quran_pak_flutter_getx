import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/data/local/my_shared_pref.dart';

import '/config/theme/dark_theme_colors.dart';
import '/config/theme/light_theme_colors.dart';
import '/config/theme/my_styles.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData getThemeData() {
    bool isLight = MyDarkMode.getThemeIsLight();

    return ThemeData(
      // fontFamily: arabicFont,
      fontFamily: GoogleFonts.dosis().fontFamily,

      useMaterial3: true,
      // main color (app bar,tabs..etc)
      primaryColor: isLight
          ? LightThemeColors.primaryColor.call()
          : DarkThemeColors.primaryColor.call(),

      colorScheme: isLight
          ? ColorScheme.light(
              primary: LightThemeColors.primaryColor.call(),
              secondary: LightThemeColors.secondaryColor,
              tertiary: LightThemeColors.tertiaryColor,
            )
          : ColorScheme.dark(
              primary: DarkThemeColors.primaryColor.call(),
              secondary: DarkThemeColors.secondaryColor,
              tertiary: DarkThemeColors.tertiaryColor,
            ),

      // color contrast (if the theme is dark text should be white for example)
      brightness: isLight ? Brightness.light : Brightness.dark,

      // card widget background color
      cardColor:
          isLight ? LightThemeColors.cardColor : DarkThemeColors.cardColor,

      // hint text color
      hintColor: isLight
          ? LightThemeColors.hintTextColor
          : DarkThemeColors.hintTextColor,

      // divider color
      dividerColor: isLight
          ? LightThemeColors.dividerColor
          : DarkThemeColors.dividerColor,

      dividerTheme: DividerThemeData(
        color: isLight
            ? LightThemeColors.dividerColor
            : DarkThemeColors.dividerColor,
      ),

      scaffoldBackgroundColor: isLight
          ? LightThemeColors.scaffoldBackgroundColor
          : DarkThemeColors.scaffoldBackgroundColor,

      // progress bar theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: isLight
            ? LightThemeColors.primaryColor.call()
            : DarkThemeColors.primaryColor.call(),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),

      // appBar theme
      appBarTheme: MyStyles.getAppBarTheme(isLightTheme: isLight),

      // elevated button theme
      elevatedButtonTheme:
          MyStyles.getElevatedButtonTheme(isLightTheme: isLight),

      textButtonTheme: MyStyles.getTextButtonTheme(isLightTheme: isLight),
      outlinedButtonTheme:
          MyStyles.getOutlinedButtonThemeData(isLightTheme: isLight),

      // text theme
      textTheme: MyStyles.getTextTheme(isLightTheme: isLight),
      // textTheme: GoogleFonts.amiriQuranTextTheme(
      //   isLight ? Typography.blackRedmond : Typography.whiteRedmond,
      // ),

      // chip theme
      chipTheme: MyStyles.getChipTheme(isLightTheme: isLight),

      // icon theme
      iconTheme: MyStyles.getIconTheme(isLightTheme: isLight),

      // input theme
      inputDecorationTheme: MyStyles.getInputTheme(isLightTheme: isLight),

      listTileTheme: MyStyles.getListTileTheme(isLightTheme: isLight),
    );
  }

  /// update app theme and save theme type to shared pref
  /// (so when the app is killed and up again theme will remain the same)
  static changeTheme() {
    // *) check if the current theme is light (default is light)
    bool isLightTheme = MyDarkMode.getThemeIsLight();
    // *) store the new theme mode on get storage
    MyDarkMode.setThemeIsLight(!isLightTheme ? AppTheme.Light : AppTheme.Dark);
    // *) let GetX change theme
    Get.changeThemeMode(!isLightTheme ? ThemeMode.light : ThemeMode.dark);
  }

  /// check if the theme is light or dark
  static bool get getThemeIsLight => MyDarkMode.getThemeIsLight();
}
