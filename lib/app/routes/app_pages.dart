import 'package:get/get.dart';

import '../modules/calculation_methods/bindings/calculation_methods_binding.dart';
import '../modules/calculation_methods/views/calculation_methods_view.dart';
import '../modules/hadith/bindings/hadith_binding.dart';
import '../modules/hadith/views/hadith_view.dart';
import '../modules/hijri_adjustment/bindings/hijri_adjustment_binding.dart';
import '../modules/hijri_adjustment/views/hijri_adjustment_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/islamic_madhhab/bindings/islamic_madhhab_binding.dart';
import '../modules/islamic_madhhab/views/islamic_madhhab_view.dart';
import '../modules/juz_detail/bindings/juz_detail_binding.dart';
import '../modules/juz_detail/views/juz_detail_view.dart';
import '../modules/location_permission/bindings/location_permission_binding.dart';
import '../modules/location_permission/views/location_permission_view.dart';
import '../modules/prayer_time/bindings/prayer_time_binding.dart';
import '../modules/prayer_time/views/prayer_time_view.dart';
import '../modules/qibla_direction/bindings/qibla_direction_binding.dart';
import '../modules/qibla_direction/views/qibla_direction_view.dart';
import '../modules/quran/bindings/quran_binding.dart';
import '../modules/quran/views/quran_view.dart';
import '../modules/quran_settings/bindings/quran_settings_binding.dart';
import '../modules/quran_settings/views/quran_settings_view.dart';
import '../modules/read_quran/bindings/read_quran_binding.dart';
import '../modules/read_quran/views/read_quran_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/surah_detail/bindings/surah_detail_binding.dart';
import '../modules/surah_detail/views/surah_detail_view.dart';
import '../modules/tasbih/bindings/tasbih_binding.dart';
import '../modules/tasbih/views/tasbih_view.dart';
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
    GetPage(
      name: _Paths.HIJRI_ADJUSTMENT,
      page: () => const HijriAdjustmentView(),
      binding: HijriAdjustmentBinding(),
    ),
    GetPage(
      name: _Paths.QURAN,
      page: () => const QuranView(),
      binding: QuranBinding(),
    ),
    GetPage(
      name: _Paths.SURAH_DETAIL,
      page: () => const SurahDetailView(),
      binding: SurahDetailBinding(),
    ),
    GetPage(
      name: _Paths.JUZ_DETAIL,
      page: () => const JuzDetailView(),
      binding: JuzDetailBinding(),
    ),
    GetPage(
      name: _Paths.PRAYER_TIME,
      page: () => const PrayerTimeView(),
      binding: PrayerTimeBinding(),
    ),
    GetPage(
      name: _Paths.TASBIH,
      page: () => const TasbihView(),
      binding: TasbihBinding(),
    ),
    GetPage(
      name: _Paths.HADITH,
      page: () => const HadithView(),
      binding: HadithBinding(),
    ),
    GetPage(
      name: _Paths.QURAN_SETTINGS,
      page: () => const QuranSettingsView(),
      binding: QuranSettingsBinding(),
    ),
  ];
}
