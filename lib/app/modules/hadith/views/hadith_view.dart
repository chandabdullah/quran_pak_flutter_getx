import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/routes/app_pages.dart';
import 'package:quran_pak/app/services/api_call_status.dart';
import 'package:quran_pak/app/services/hadith_service.dart';

import '../controllers/hadith_controller.dart';

class HadithView extends GetView<HadithController> {
  const HadithView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hadith'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Search all Hadith",
            icon: const Icon(Icons.search_rounded),
            onPressed: () => Get.toNamed(Routes.HADITH_SEARCH),
          ),
          const Gap(4),
        ],
      ),
      body: GetBuilder<HadithController>(builder: (_) {
        if (controller.status == ApiCallStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.status == ApiCallStatus.error) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const Gap(12),
                const Text("Couldn't load the Hadith collections"),
                const Gap(12),
                ElevatedButton(
                  onPressed: controller.loadBooks,
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }
        return Column(
          children: [
            _searchBar(),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(kPadding),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: kPadding,
                  crossAxisSpacing: kPadding,
                  childAspectRatio: .82,
                ),
                itemCount: controller.books.length,
                itemBuilder: (context, index) =>
                    _bookCard(controller.books[index]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(kPadding, kPadding, kPadding, 0),
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.HADITH_SEARCH),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: kSpacing, vertical: 14),
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            borderRadius: BorderRadius.circular(kBorderRadius),
            border: Border.all(color: Get.theme.splashColor),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: Get.theme.hintColor),
              const Gap(10),
              Text(
                "Search by number, book, word or topic",
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: Get.theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookCard(HadithBook book) {
    return Material(
      borderRadius: BorderRadius.circular(kBorderRadius),
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(kBorderRadius),
        onTap: () => Get.toNamed(
          Routes.HADITH_BOOK_DETAIL,
          arguments: {"book": book.book},
        ),
        child: Container(
          padding: const EdgeInsets.all(kPadding),
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            border: Border.all(color: Get.theme.primaryColor.withValues(alpha: .4)),
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FlutterIslamicIcons.solidQuran2,
                  color: Get.theme.primaryColor,
                  size: 26,
                ),
              ),
              const Gap(10),
              Text(
                book.nameAr,
                textAlign: TextAlign.center,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontFamily: arabicFont,
                ),
              ),
              const Gap(2),
              Text(
                book.nameEn,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Get.theme.hintColor,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(kBorderRadius),
                ),
                child: Text(
                  "${book.total} hadith",
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Get.theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
