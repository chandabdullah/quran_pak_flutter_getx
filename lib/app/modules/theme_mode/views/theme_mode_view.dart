import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/components/selectable_tile.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/config/theme/my_theme.dart';

/// Lets the user pick System default / Light / Dark. Selecting an option
/// applies it and returns to the previous screen.
class ThemeModeView extends StatelessWidget {
  const ThemeModeView({super.key});

  @override
  Widget build(BuildContext context) {
    final current = MyTheme.currentThemeMode;
    return Scaffold(
      appBar: AppBar(title: const Text("Appearance"), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(kPadding),
        children: [
          _option(AppTheme.System, "System default",
              "Follow your device's light or dark setting", current),
          _option(AppTheme.Light, "Light", "Always use the light theme",
              current),
          _option(AppTheme.Dark, "Dark", "Always use the dark theme", current),
        ],
      ),
    );
  }

  Widget _option(
      AppTheme mode, String title, String subtitle, AppTheme current) {
    return SelectableTile(
      title: title,
      subtitle: subtitle,
      selected: current == mode,
      onTap: () {
        MyTheme.applyTheme(mode);
        Get.back();
      },
    );
  }
}
