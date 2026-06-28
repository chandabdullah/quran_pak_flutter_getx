import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/components/hadith_card.dart';
import 'package:quran_pak/app/components/hadith_detail_page.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/services/api_call_status.dart';
import 'package:quran_pak/app/services/hadith_service.dart';

import '../controllers/hadith_search_controller.dart';

class HadithSearchView extends GetView<HadithSearchController> {
  const HadithSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: GetBuilder<HadithSearchController>(
          builder: (_) {
            final byNumber = controller.searchMode == HadithSearchMode.number;
            return TextField(
              controller: controller.searchController,
              autofocus: true,
              keyboardType:
                  byNumber ? TextInputType.number : TextInputType.text,
              inputFormatters:
                  byNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
              textInputAction: TextInputAction.search,
              onChanged: controller.onSearch,
              style: Get.textTheme.bodyLarge,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: byNumber
                    ? "Enter hadith number…"
                    : "Search all Hadith…",
              ),
            );
          },
        ),
        actions: [
          GetBuilder<HadithSearchController>(
            builder: (_) => controller.query.isEmpty
                ? const SizedBox()
                : IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: controller.clearSearch,
                  ),
          ),
        ],
      ),
      body: GetBuilder<HadithSearchController>(
        builder: (_) => Column(
          children: [
            _modeToggle(),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _modeToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(kPadding, 8, kPadding, 4),
      child: Row(
        children: [
          _modeChip("Topic / Word", HadithSearchMode.topic),
          const Gap(8),
          _modeChip("Number", HadithSearchMode.number),
        ],
      ),
    );
  }

  Widget _modeChip(String label, HadithSearchMode mode) {
    final selected = controller.searchMode == mode;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Get.theme.hintColor,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Get.theme.cardColor,
      selectedColor: Get.theme.primaryColor,
      side: BorderSide(
        color: selected ? Get.theme.primaryColor : Get.theme.splashColor,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      onSelected: (_) => controller.setMode(mode),
    );
  }

  Widget _body() {
    switch (controller.status) {
      case ApiCallStatus.holding:
        return _hint();
      case ApiCallStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case ApiCallStatus.empty:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded,
                  size: 48, color: Get.theme.hintColor),
              const Gap(12),
              Text('No results for "${controller.query}"'),
            ],
          ),
        );
      default:
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: kPadding,
                vertical: 8,
              ),
              color: Get.theme.primaryColor.withValues(alpha: .06),
              child: Text(
                "${controller.results.length} result(s)",
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Get.theme.hintColor,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(kPadding),
                itemCount: controller.results.length,
                itemBuilder: (context, index) {
                  final r = controller.results[index];
                  return GestureDetector(
                    onTap: () => Get.to(() => HadithDetailPage(
                          hadith: r.hadith,
                          collectionName: r.bookName,
                          sectionName: r.sectionEn,
                        )),
                    child: HadithCard(
                      hadith: r.hadith,
                      collectionName: r.bookName,
                      sectionName: r.sectionEn,
                    ),
                  );
                },
              ),
            ),
          ],
        );
    }
  }

  Widget _hint() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kPadding * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_rounded,
                size: 56, color: Get.theme.primaryColor.withValues(alpha: .5)),
            const Gap(16),
            Text(
              "Search the six authentic collections",
              textAlign: TextAlign.center,
              style: Get.textTheme.titleMedium,
            ),
            const Gap(8),
            Text(
              "Find a hadith by its number, by book or chapter name, "
              "or by any word or topic in Arabic, Urdu or English.",
              textAlign: TextAlign.center,
              style: Get.textTheme.bodySmall?.copyWith(
                color: Get.theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
