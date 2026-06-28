import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/data/local_data/tasbih.dart';
import 'package:quran_pak/app/routes/app_pages.dart';

import '../controllers/tasbih_controller.dart';

class TasbihView extends GetView<TasbihController> {
  const TasbihView({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasbih'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: TasbihData.tasbihs.length,
          padding: const EdgeInsets.all(kPadding),
          separatorBuilder: (_, __) => const Gap(kSpacing),
          itemBuilder: (context, index) {
            final Tasbih tasbih = TasbihData.tasbihs[index];
            final int total = box.read('tasbih_total_$index') ?? 0;
            return _tasbihCard(index, tasbih, total);
          },
        ),
      ),
    );
  }

  Widget _tasbihCard(int index, Tasbih tasbih, int total) {
    final theme = Get.theme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(kBorderRadius),
        onTap: () =>
            Get.toNamed(Routes.TASBIH_COUNTER, arguments: {"index": index}),
        child: Container(
          padding: const EdgeInsets.all(kPadding),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(kBorderRadius),
            border: Border.all(color: theme.splashColor),
          ),
          child: Row(
            children: [
              // Index badge.
              Container(
                height: 38,
                width: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${index + 1}",
                  style: theme.textTheme.titleSmall?.copyWith(
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
                    Text(
                      tasbih.arabic,
                      textDirection: TextDirection.rtl,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontFamily: arabicFont,
                        color: theme.primaryColor,
                      ),
                    ),
                    const Gap(4),
                    Text(tasbih.english, style: theme.textTheme.bodyMedium),
                    if (total > 0) ...[
                      const Gap(6),
                      Row(
                        children: [
                          Icon(Icons.all_inclusive_rounded,
                              size: 13, color: theme.hintColor),
                          const Gap(4),
                          Text(
                            "$total recited",
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: theme.hintColor),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: theme.hintColor),
            ],
          ),
        ),
      ),
    );
  }
}
