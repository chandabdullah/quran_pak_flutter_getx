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
        title: const Text("Bookmarks"),
        centerTitle: true,
      ),
      body: GetBuilder<BookmarksController>(builder: (_) {
        final lastRead = MyBookmark.getLastRead();
        return ListView(
          padding: const EdgeInsets.all(kPadding),
          children: [
            if (lastRead != null) ...[
              Text(
                "CONTINUE READING",
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Get.theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const Gap(8),
              _lastReadCard(lastRead),
              const Gap(24),
            ],
            Text(
              "SAVED VERSES",
              style: Get.textTheme.bodySmall?.copyWith(
                color: Get.theme.primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
            const Gap(8),
            if (controller.bookmarks.isEmpty)
              _empty()
            else
              ...controller.bookmarks.map(_bookmarkTile),
          ],
        );
      }),
    );
  }

  Widget _lastReadCard(QuranBookmark lastRead) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(kBorderRadius),
        onTap: () => controller.openBookmark(lastRead),
        child: Container(
          padding: const EdgeInsets.all(kPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadius),
            gradient: LinearGradient(
              colors: [
                Get.theme.primaryColor,
                Color.lerp(Get.theme.primaryColor, Colors.black, .25) ??
                    Get.theme.primaryColor,
              ],
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.menu_book_rounded, color: Colors.white, size: 30),
              const Gap(kSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lastRead.surahName,
                      style: Get.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Verse ${lastRead.verse}",
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: .85),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookmarkTile(QuranBookmark b) {
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
        onTap: () => controller.openBookmark(b),
        leading: CircleAvatar(
          backgroundColor: Get.theme.primaryColor.withValues(alpha: .12),
          child: Icon(Icons.bookmark_rounded, color: Get.theme.primaryColor),
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
          Icon(Icons.bookmark_border_rounded,
              size: 56, color: Get.theme.hintColor),
          const Gap(12),
          Text("No bookmarks yet", style: Get.textTheme.titleSmall),
          const Gap(4),
          Text(
            "Tap the bookmark icon on any verse to save it here.",
            textAlign: TextAlign.center,
            style: Get.textTheme.bodySmall?.copyWith(color: Get.theme.hintColor),
          ),
        ],
      ),
    );
  }
}
