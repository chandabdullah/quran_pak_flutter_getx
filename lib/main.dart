import 'package:flutter/services.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/services/permissions_service.dart';
import 'package:quran_pak/config/translations/localization_service.dart';

import '/app/data/local/my_shared_pref.dart';
import '/config/theme/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_flutter/quran_flutter.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  // wait for bindings
  WidgetsFlutterBinding.ensureInitialized();

  // init shared preference
  await MySharedPref.init();

  AppPermissions appPermissions =
      await PermissionHandlerService.checkPermissionsForApplication();
  await Quran.initialize();

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
            return Theme(
              data: MyTheme.getThemeData(),
              child: MediaQuery(
                data: MediaQuery.of(context),
                child: widget!,
              ),
            );
          },
          initialRoute: PermissionHandlerService.initialPage(appPermissions),
          getPages: AppPages.routes,
          locale: MyLocale.getCurrentLocal(),
          translations: LocalizationService(),
        );
      },
    ),
  );
}
