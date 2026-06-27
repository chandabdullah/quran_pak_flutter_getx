import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';

/// A card-style option row with a selected state, used by the various
/// settings pickers (madhhab, calculation method, etc.).
class SelectableTile extends StatelessWidget {
  const SelectableTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    return Container(
      margin: const EdgeInsets.only(bottom: kSpacing),
      decoration: BoxDecoration(
        color: selected
            ? theme.primaryColor.withValues(alpha: .08)
            : theme.cardColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(
          color: selected ? theme.primaryColor : theme.splashColor,
          width: selected ? 1.4 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(kBorderRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kPadding,
              vertical: 14,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: selected ? theme.primaryColor : null,
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      if ((subtitle ?? '').isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.hintColor),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected ? theme.primaryColor : theme.hintColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
