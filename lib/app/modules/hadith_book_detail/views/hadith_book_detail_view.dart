import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/components/hadith_detail_page.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/services/api_call_status.dart';
import 'package:quran_pak/app/services/hadith_service.dart';

import '../controllers/hadith_book_detail_controller.dart';

class HadithBookDetailView extends GetView<HadithBookDetailController> {
  const HadithBookDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: GetBuilder<HadithBookDetailController>(
          builder: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(controller.collection?.nameEn ?? "Hadith"),
              if (controller.collection != null)
                Text(
                  "${controller.totalFiltered} of ${controller.collection!.total}",
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Get.theme.appBarTheme.titleTextStyle?.color
                        ?.withValues(alpha: .7),
                  ),
                ),
            ],
          ),
        ),
      ),
      body: GetBuilder<HadithBookDetailController>(builder: (_) {
        return Column(
          children: [
            _searchField(),
            _modeToggle(),
            Expanded(child: _body()),
          ],
        );
      }),
    );
  }

  Widget _searchField() {
    final byNumber = controller.searchMode == HadithSearchMode.number;
    return Padding(
      padding: const EdgeInsets.fromLTRB(kPadding, kPadding, kPadding, 4),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onSearch,
        keyboardType: byNumber ? TextInputType.number : TextInputType.text,
        inputFormatters:
            byNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: byNumber
              ? "Enter hadith number"
              : "Search topic or word in this book",
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: controller.query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: controller.clearSearch,
                ),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
        ),
      ),
    );
  }

  Widget _modeToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding),
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
      case ApiCallStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case ApiCallStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const Gap(12),
              const Text("Couldn't load this collection"),
              const Gap(12),
              ElevatedButton(
                  onPressed: controller.load, child: const Text("Retry")),
            ],
          ),
        );
      case ApiCallStatus.empty:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded,
                  size: 48, color: Get.theme.hintColor),
              const Gap(12),
              Text(
                controller.query.isEmpty
                    ? "No hadith found"
                    : 'No results for "${controller.query}"',
                style: Get.textTheme.bodyMedium,
              ),
            ],
          ),
        );
      default:
        final items = controller.visible;
        return ListView.separated(
          controller: controller.scrollController,
          padding: const EdgeInsets.fromLTRB(kPadding, 8, kPadding, kPadding),
          itemCount: items.length + (controller.hasMore ? 1 : 0),
          separatorBuilder: (_, __) => const Gap(kSpacing),
          itemBuilder: (context, index) {
            if (index >= items.length) {
              return const Padding(
                padding: EdgeInsets.all(kPadding),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return _hadithRow(items[index]);
          },
        );
    }
  }

  Widget _hadithRow(HadithItem h) {
    final theme = Get.theme;
    final section = controller.sectionNameFor(h);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: theme.splashColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.to(() => HadithDetailPage(
                hadith: h,
                collectionName: controller.collection?.nameEn ?? "",
                sectionName: section,
              )),
          child: Padding(
            padding: const EdgeInsets.all(kSpacing),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(kBorderRadius),
                  ),
                  child: Text(
                    "${h.number}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Gap(kSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (section.isNotEmpty)
                        Text(
                          section,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const Gap(2),
                      Text(
                        h.preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: theme.hintColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
