import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/services/api_call_status.dart';
import 'package:quran_pak/app/services/dua_service.dart';

import '../controllers/dua_controller.dart';
import 'dua_detail_view.dart';

class DuaView extends GetView<DuaController> {
  const DuaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Duas"),
        centerTitle: true,
        actions: [
          GetBuilder<DuaController>(
            builder: (_) => IconButton(
              tooltip: controller.showSavedOnly ? "Show all" : "Saved duas",
              icon: Icon(
                controller.showSavedOnly
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
              ),
              onPressed: controller.toggleSavedView,
            ),
          ),
          const Gap(4),
        ],
      ),
      body: GetBuilder<DuaController>(builder: (_) {
        if (controller.status == ApiCallStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            _searchField(),
            _categoryChips(),
            Expanded(child: _list()),
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
          hintText: "Search by number, word or topic…",
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: controller.query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    controller.searchController.clear();
                    controller.onSearch("");
                  },
                ),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
        ),
      ),
    );
  }

  Widget _categoryChips() {
    final chips = <Widget>[_chip("All", "all")];
    for (final c in controller.categories) {
      chips.add(_chip(c.en, c.id));
    }
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: kPadding),
        children: chips,
      ),
    );
  }

  Widget _chip(String label, String id) {
    final selected = controller.selectedCategory == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
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
        onSelected: (_) => controller.selectCategory(id),
      ),
    );
  }

  Widget _list() {
    if (controller.filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 48, color: Get.theme.hintColor),
            const Gap(12),
            const Text("No duas found"),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(kPadding),
      itemCount: controller.filtered.length,
      itemBuilder: (context, index) => _duaTile(controller.filtered[index]),
    );
  }

  Widget _duaTile(Dua dua) {
    final theme = Get.theme;
    return Container(
      margin: const EdgeInsets.only(bottom: kSpacing),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: theme.splashColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.to(() => DuaDetailView(dua: dua)),
          child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    // Index number badge.
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(kBorderRadius),
                      ),
                      child: Text(
                        "#${dua.id}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        dua.titleEn,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => controller.toggleSaved(dua.id),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          controller.isSaved(dua.id)
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: theme.primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    dua.arabic,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontFamily: arabicFont,
                      height: 1.9,
                    ),
                  ),
                ),
                const Gap(8),
                Text(
                  dua.english,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                ),
                if (dua.reference.isNotEmpty) ...[
                  const Gap(8),
                  Row(
                    children: [
                      Icon(Icons.menu_book_rounded,
                          size: 13, color: theme.primaryColor),
                      const Gap(4),
                      Expanded(
                        child: Text(
                          dua.reference,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
