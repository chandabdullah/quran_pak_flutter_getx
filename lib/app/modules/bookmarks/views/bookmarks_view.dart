import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';

import '../controllers/bookmarks_controller.dart';

class BookmarksView extends GetView<BookmarksController> {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourites"),
        centerTitle: true,
      ),
      body: GetBuilder<BookmarksController>(builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(kPadding),
          children: [
            _label("SAVED VERSES"),
            const Gap(8),
            if (controller.savedVerses.isEmpty)
              _empty()
            else
              ...controller.savedVerses.map(_savedTile),
          ],
        );
      }),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: Get.textTheme.bodySmall?.copyWith(
          color: Get.theme.primaryColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      );

  Widget _savedTile(QuranBookmark b) {
    return Container(
      margin: const EdgeInsets.only(bottom: kSpacing),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: Get.theme.splashColor),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        onTap: () => controller.open(b.surah, b.verse),
        leading: CircleAvatar(
          backgroundColor: Get.theme.primaryColor.withValues(alpha: .12),
          child: Icon(Icons.favorite_rounded, color: Get.theme.primaryColor),
        ),
        title: Text(b.surahName, style: Get.textTheme.titleSmall),
        subtitle: Text(
          "Surah ${b.surah} · Verse ${b.verse}",
          style: Get.textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline_rounded, color: Get.theme.hintColor),
          onPressed: () => controller.remove(b),
        ),
      ),
    );
  }

  Widget _empty() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.favorite_border_rounded,
              size: 56, color: Get.theme.hintColor),
          const Gap(12),
          Text("No saved verses yet", style: Get.textTheme.titleSmall),
          const Gap(4),
          Text(
            "Tap the heart on any verse to save it here.",
            textAlign: TextAlign.center,
            style: Get.textTheme.bodySmall?.copyWith(color: Get.theme.hintColor),
          ),
        ],
      ),
    );
  }
}
