import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/qibla_direction/bindings/qibla_direction_binding.dart';
import '../modules/qibla_direction/views/qibla_direction_view.dart';
import '../modules/read_quran/bindings/read_quran_binding.dart';
import '../modules/read_quran/views/read_quran_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';

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
  ];
}
