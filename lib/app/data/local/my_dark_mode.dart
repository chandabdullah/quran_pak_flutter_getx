part of my_share_preferences;

enum AppTheme {
  Light,
  Dark,
  // System,
}

class MyDarkMode {
  static final GetStorage _storage = GetStorage();

  static const String _lightThemeKey = 'is_theme_light';

  /// =================================================
  /// Dark Theme
  /// =================================================

  /// set theme current type as light theme
  static void setThemeIsLight(AppTheme lightTheme) {
    _storage.write(_lightThemeKey, lightTheme.name);
  }

  static bool getThemeIsLight() {
    String themeValue = "Light";
    if (_storage.read(_lightThemeKey) != null) {
      themeValue = _storage.read(_lightThemeKey);
    }

    AppTheme currentTheme = AppTheme.values.firstWhere(
      (theme) => theme.toString().split('.').last == themeValue,
      orElse: () => AppTheme.Light,
    );

    bool isLightTheme = true;
    // BuildContext context = Get.context;

    switch (currentTheme) {
      case AppTheme.Light:
        isLightTheme = true;
        break;
      case AppTheme.Dark:
        isLightTheme = false;
        break;
      // case AppTheme.SystemDefault:
      //   isLightTheme =
      //       SchedulerBinding.instance.platformDispatcher.platformBrightness ==
      //               Brightness.dark
      //           ? false
      //           : true;
      //   break;
    }

    return isLightTheme;
  }

  static AppTheme getCurrentTheme() {
    String themeValue = "Light";
    if (_storage.read(_lightThemeKey) != null) {
      themeValue = _storage.read(_lightThemeKey);
    }

    AppTheme currentTheme = AppTheme.values.firstWhere(
      (theme) => theme.toString().split('.').last == themeValue,
      orElse: () => AppTheme.Light,
    );
    return currentTheme;
  }
}
