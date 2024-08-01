import 'package:get/get.dart';

import '../modules/calculation_methods/bindings/calculation_methods_binding.dart';
import '../modules/calculation_methods/views/calculation_methods_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/islamic_madhhab/bindings/islamic_madhhab_binding.dart';
import '../modules/islamic_madhhab/views/islamic_madhhab_view.dart';
import '../modules/location_permission/bindings/location_permission_binding.dart';
import '../modules/location_permission/views/location_permission_view.dart';
import '../modules/qibla_direction/bindings/qibla_direction_binding.dart';
import '../modules/qibla_direction/views/qibla_direction_view.dart';
import '../modules/read_quran/bindings/read_quran_binding.dart';
import '../modules/read_quran/views/read_quran_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/time_adjustment/bindings/time_adjustment_binding.dart';
import '../modules/time_adjustment/views/time_adjustment_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.READ_QURAN,
      page: () => const ReadQuranView(),
      binding: ReadQuranBinding(),
    ),
    GetPage(
      name: _Paths.QIBLA_DIRECTION,
      page: () => const QiblaDirectionView(),
      binding: QiblaDirectionBinding(),
    ),
    GetPage(
      name: _Paths.LOCATION_PERMISSION,
      page: () => const LocationPermissionView(),
      binding: LocationPermissionBinding(),
    ),
    GetPage(
      name: _Paths.CALCULATION_METHODS,
      page: () => const CalculationMethodsView(),
      binding: CalculationMethodsBinding(),
    ),
    GetPage(
      name: _Paths.TIME_ADJUSTMENT,
      page: () => const TimeAdjustmentView(),
      binding: TimeAdjustmentBinding(),
    ),
    GetPage(
      name: _Paths.ISLAMIC_MADHHAB,
      page: () => const IslamicMadhhabView(),
      binding: IslamicMadhhabBinding(),
    ),
  ];
}
