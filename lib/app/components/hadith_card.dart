import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/services/hadith_service.dart';

/// Renders a single hadith: a header (number + section/collection), the Arabic
/// text, then the Urdu and English translations, plus any grading.
class HadithCard extends StatelessWidget {
  const HadithCard({
    super.key,
    required this.hadith,
    this.sectionName,
    this.collectionName,
  });

  final HadithItem hadith;
  final String? sectionName;
  final String? collectionName;

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    return Container(
      margin: const EdgeInsets.only(bottom: kSpacing),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: theme.splashColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: kSpacing,
              vertical: 10,
            ),
            color: theme.primaryColor.withValues(alpha: .08),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(kBorderRadius),
                  ),
                  child: Text(
                    "#${hadith.number}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (collectionName != null)
                        Text(
                          collectionName!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      if ((sectionName ?? '').isNotEmpty)
                        Text(
                          sectionName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (hadith.arabic.isNotEmpty)
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      hadith.arabic,
                      textAlign: TextAlign.right,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontFamily: arabicFont,
                        height: 1.9,
                      ),
                    ),
                  ),
                if (hadith.urdu.isNotEmpty) ...[
                  const Gap(14),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      hadith.urdu,
                      textAlign: TextAlign.right,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.8),
                    ),
                  ),
                ],
                if (hadith.english.isNotEmpty) ...[
                  const Gap(14),
                  Text(
                    hadith.english,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                      height: 1.5,
                    ),
                  ),
                ],
                if (hadith.grades.isNotEmpty) ...[
                  const Gap(14),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: hadith.grades
                        .toSet()
                        .map((g) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withValues(alpha: .1),
                                borderRadius: BorderRadius.circular(kBorderRadius),
                              ),
                              child: Text(
                                g,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.primaryColor,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
