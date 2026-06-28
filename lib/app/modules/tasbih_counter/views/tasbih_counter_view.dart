import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/data/local_data/tasbih.dart';

import '../controllers/tasbih_counter_controller.dart';

class TasbihCounterView extends GetView<TasbihCounterController> {
  const TasbihCounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TasbihCounterController>(builder: (_) {
      final theme = Get.theme;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tasbih Counter'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: "Reset",
              onPressed: controller.resetCount,
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              children: [
                _dhikrSelector(theme),
                const Gap(kPadding),
                _statsRow(theme),
                const Spacer(),
                _counterRing(context, theme),
                const Gap(8),
                Text(
                  controller.count >= controller.selectedTarget
                      ? "Target reached — tap to continue"
                      : "Tap the circle to count",
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                ),
                const Spacer(),
                _targetChips(theme),
                const Gap(kPadding),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------

  Widget _dhikrSelector(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: theme.splashColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Row(
        children: [
          IconButton(
            onPressed: controller.onPrevious,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Expanded(
            child: CarouselSlider(
              carouselController: controller.carouselController,
              disableGesture: true,
              items: [
                for (Tasbih tasbih in controller.tasbihData)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Text(
                          tasbih.arabic,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontFamily: arabicFont,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      const Gap(4),
                      Text(tasbih.english, style: theme.textTheme.bodyMedium),
                    ],
                  ),
              ],
              options: CarouselOptions(
                enableInfiniteScroll: true,
                aspectRatio: 3.4 / 1,
                viewportFraction: 1,
                onPageChanged: (i, reason) => controller.resetCount(),
              ),
            ),
          ),
          IconButton(
            onPressed: controller.onNext,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }

  Widget _statsRow(ThemeData theme) {
    return Row(
      children: [
        _stat(theme, "Rounds", "${controller.rounds}", Icons.repeat_rounded),
        const Gap(kSpacing),
        _stat(theme, "Lifetime", "${controller.lifetimeTotal}",
            Icons.all_inclusive_rounded),
      ],
    );
  }

  Widget _stat(ThemeData theme, String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: kSpacing),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(kBorderRadius),
          border: Border.all(color: theme.splashColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.primaryColor, size: 18),
            const Gap(8),
            Text(value,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Gap(6),
            Text(label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.hintColor)),
          ],
        ),
      ),
    );
  }

  Widget _counterRing(BuildContext context, ThemeData theme) {
    final size = MediaQuery.of(context).size.width * 0.62;
    final reached = controller.count >= controller.selectedTarget;
    return GestureDetector(
      onTap: reached ? controller.continueAfterTarget : controller.increment,
      child: SizedBox(
        height: size,
        width: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animated progress ring.
            SizedBox(
              height: size,
              width: size,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: controller.progress),
                duration: const Duration(milliseconds: 250),
                builder: (context, value, _) => CircularProgressIndicator(
                  value: value,
                  strokeWidth: 12,
                  backgroundColor: theme.primaryColor.withValues(alpha: .12),
                  valueColor: AlwaysStoppedAnimation(theme.primaryColor),
                  strokeCap: StrokeCap.round,
                ),
              ),
            ),
            // Inner filled circle with the count.
            Container(
              height: size - 44,
              width: size - 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.primaryColor,
                    Color.lerp(theme.primaryColor, Colors.black, .25) ??
                        theme.primaryColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: .35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${controller.count}",
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "of ${controller.selectedTarget}",
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _targetChips(ThemeData theme) {
    return Wrap(
      spacing: 8,
      alignment: WrapAlignment.center,
      children: controller.targets.map((t) {
        final selected = controller.selectedTarget == t;
        return ChoiceChip(
          label: Text("$t"),
          selected: selected,
          showCheckmark: false,
          labelStyle: TextStyle(
            color: selected ? Colors.white : theme.hintColor,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: theme.cardColor,
          selectedColor: theme.primaryColor,
          side: BorderSide(
            color: selected ? theme.primaryColor : theme.splashColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          onSelected: (_) {
            if (!selected) {
              controller.selectedTargetIndex = controller.targets.indexOf(t);
              controller.resetCount();
            }
          },
        );
      }).toList(),
    );
  }
}
