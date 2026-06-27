import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/components/hadith_card.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/services/api_call_status.dart';

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
                  "${controller.collection!.total} hadith",
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
            Expanded(child: _body()),
          ],
        );
      }),
    );
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(kPadding, kPadding, kPadding, 4),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onSearch,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Search number, topic or word in this book",
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
                onPressed: controller.load,
                child: const Text("Retry"),
              ),
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
        final list = controller.filtered;
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(kPadding, 4, kPadding, kPadding),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final h = list[index];
            return HadithCard(
              hadith: h,
              sectionName: controller.sectionNameFor(h),
            );
          },
        );
    }
  }
}
