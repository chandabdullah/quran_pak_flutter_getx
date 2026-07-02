import 'package:flutter/services.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/services/prayer_tracker_service.dart';
import 'package:quran_pak/app/services/notification_service.dart';
import 'package:quran_pak/app/services/onboarding_service.dart';
import 'package:quran_pak/config/translations/localization_service.dart';

import '/app/data/local/my_shared_pref.dart';
import '/config/theme/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_flutter/quran_flutter.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

/// Runs a start-up init but never lets a failure abort `main()` (which would
/// leave the app stuck on the native splash with no UI ever mounted).
Future<void> _safeInit(String name, Future<void> Function() init) async {
  try {
    await init();
  } catch (e, s) {
    debugPrint('Startup init "$name" failed: $e\n$s');
  }
}

void main() async {
  // wait for bindings
  WidgetsFlutterBinding.ensureInitialized();

  // init shared preference (required before anything reads storage)
  await _safeInit('shared_pref', () => MySharedPref.init());

  // init Hive (prayer tracker)
  await _safeInit('hive', () => PrayerTrackerService.init());

  // init local notifications (prayer reminders)
  await _safeInit('notifications', () => NotificationService.init());

  // init Quran data
  await _safeInit('quran', () => Quran.initialize());

  // Show the permission onboarding only on first launch; afterwards go home.
  final String initialRoute =
      OnboardingService.isDone ? AppPages.INITIAL : Routes.LOCATION_PERMISSION;

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    ScreenUtilInit(
      // todo add your (Xd / Figma) artboard size
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (context, widget) {
        return GetMaterialApp(
          title: appName,
          useInheritedMediaQuery: true,
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            // Depend on the platform brightness so "System" theme reacts to
            // OS light/dark changes while the app is open.
            MediaQuery.platformBrightnessOf(context);
            return Theme(
              data: MyTheme.getThemeData(),
              child: MediaQuery(
                data: MediaQuery.of(context),
                child: widget!,
              ),
            );
          },
          initialRoute: initialRoute,
          getPages: AppPages.routes,
          locale: MyLocale.getCurrentLocal(),
          translations: LocalizationService(),
        );
      },
    ),
  );
}
