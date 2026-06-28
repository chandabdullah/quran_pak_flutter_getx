import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/modules/dua/controllers/dua_controller.dart';
import 'package:quran_pak/app/services/dua_service.dart';

class DuaDetailView extends StatelessWidget {
  const DuaDetailView({super.key, required this.dua});

  final Dua dua;

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final hasController = Get.isRegistered<DuaController>();
    return Scaffold(
      appBar: AppBar(
        title: Text("#${dua.id}  ${dua.titleEn}"),
        centerTitle: true,
        actions: [
          if (hasController)
            GetBuilder<DuaController>(
              builder: (c) => IconButton(
                tooltip: "Save dua",
                icon: Icon(
                  c.isSaved(dua.id)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                ),
                onPressed: () => c.toggleSaved(dua.id),
              ),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(kPadding),
        children: [
          // Arabic — always right to left.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(kPadding),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                dua.arabic,
                textAlign: TextAlign.right,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFamily: arabicFont,
                  height: 2,
                ),
              ),
            ),
          ),
          if (dua.transliteration.isNotEmpty) ...[
            const Gap(kPadding),
            _section(theme, "Transliteration", dua.transliteration,
                italic: true),
          ],
          if (dua.english.isNotEmpty) ...[
            const Gap(kPadding),
            _section(theme, "English", dua.english),
          ],
          if (dua.urdu.isNotEmpty) ...[
            const Gap(kPadding),
            _section(theme, "Urdu", dua.urdu, fontFamily: urduFont, urdu: true),
          ],
          if (dua.reference.isNotEmpty) ...[
            const Gap(kPadding),
            Row(
              children: [
                Icon(Icons.menu_book_rounded, size: 16, color: theme.hintColor),
                const Gap(6),
                Text("Reference: ${dua.reference}",
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _section(ThemeData theme, String label, String text,
      {String? fontFamily, bool italic = false, bool urdu = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const Gap(6),
        // English/Urdu/Transliteration are shown left to right.
        Text(
          text,
          textAlign: TextAlign.left,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontFamily: fontFamily,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            height: urdu ? 2.2 : 1.6,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
