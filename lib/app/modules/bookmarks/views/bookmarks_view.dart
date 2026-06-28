import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:quran_pak/app/modules/dua/views/dua_detail_view.dart';
import 'package:quran_pak/app/services/dua_service.dart';

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
        return Column(
          children: [
            _segments(),
            Expanded(
              child: controller.segment == 0 ? _versesList() : _duasList(),
            ),
          ],
        );
      }),
    );
  }

  Widget _segments() {
    return Padding(
      padding: const EdgeInsets.all(kPadding),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(kBorderRadius),
          border: Border.all(color: Get.theme.splashColor),
        ),
        child: Row(
          children: [
            _segmentButton("Verses", 0, controller.savedVerses.length),
            _segmentButton("Duas", 1, controller.savedDuas.length),
          ],
        ),
      ),
    );
  }

  Widget _segmentButton(String label, int value, int count) {
    final selected = controller.segment == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setSegment(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Get.theme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(kBorderRadius - 2),
          ),
          alignment: Alignment.center,
          child: Text(
            "$label ($count)",
            style: Get.textTheme.titleSmall?.copyWith(
              color: selected ? Colors.white : Get.theme.hintColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Verses
  // ---------------------------------------------------------------------------

  Widget _versesList() {
    if (controller.savedVerses.isEmpty) {
      return _empty(Icons.favorite_border_rounded, "No saved verses yet",
          "Tap the heart on any verse to save it here.");
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(kPadding, 0, kPadding, kPadding),
      children: controller.savedVerses.map(_verseTile).toList(),
    );
  }

  Widget _verseTile(QuranBookmark b) {
    return Container(
      margin: const EdgeInsets.only(bottom: kSpacing),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: Get.theme.splashColor),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius)),
        onTap: () => controller.open(b.surah, b.verse),
        leading: CircleAvatar(
          backgroundColor: Get.theme.primaryColor.withValues(alpha: .12),
          child: Icon(Icons.favorite_rounded, color: Get.theme.primaryColor),
        ),
        title: Text(b.surahName, style: Get.textTheme.titleSmall),
        subtitle: Text("Surah ${b.surah} · Verse ${b.verse}",
            style: Get.textTheme.bodySmall),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline_rounded, color: Get.theme.hintColor),
          onPressed: () => controller.removeVerse(b),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Duas
  // ---------------------------------------------------------------------------

  Widget _duasList() {
    if (controller.savedDuas.isEmpty) {
      return _empty(Icons.menu_book_outlined, "No saved duas yet",
          "Tap the heart on any dua to save it here.");
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(kPadding, 0, kPadding, kPadding),
      children: controller.savedDuas.map(_duaTile).toList(),
    );
  }

  Widget _duaTile(Dua dua) {
    return Container(
      margin: const EdgeInsets.only(bottom: kSpacing),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: Get.theme.splashColor),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius)),
        onTap: () => Get.to(() => DuaDetailView(dua: dua)),
        leading: CircleAvatar(
          backgroundColor: Get.theme.primaryColor.withValues(alpha: .12),
          child: Text("#${dua.id}",
              style: Get.textTheme.bodySmall
                  ?.copyWith(color: Get.theme.primaryColor)),
        ),
        title: Text(dua.titleEn, style: Get.textTheme.titleSmall),
        subtitle: Text(dua.reference,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Get.textTheme.bodySmall),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline_rounded, color: Get.theme.hintColor),
          onPressed: () => controller.removeDua(dua.id),
        ),
      ),
    );
  }

  Widget _empty(IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kPadding * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Get.theme.hintColor),
            const Gap(12),
            Text(title, style: Get.textTheme.titleSmall),
            const Gap(4),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: Get.textTheme.bodySmall
                    ?.copyWith(color: Get.theme.hintColor)),
          ],
        ),
      ),
    );
  }
}
