import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';

/// A shared, polished layout for the onboarding permission pages (location and
/// notifications): a pulsing icon, optional step dots, a title, message, a
/// list of benefit bullets, a primary CTA and a secondary (skip) action.
class PermissionScaffold extends StatefulWidget {
  const PermissionScaffold({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.primaryLoading = false,
    this.secondaryLabel,
    this.onSecondary,
    this.bullets = const [],
    this.step,
    this.totalSteps = 2,
  });

  final IconData icon;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final bool primaryLoading;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final List<(IconData, String)> bullets;
  final int? step;
  final int totalSteps;

  @override
  State<PermissionScaffold> createState() => _PermissionScaffoldState();
}

class _PermissionScaffoldState extends State<PermissionScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Get.theme.primaryColor;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding * 1.5),
          child: Column(
            children: [
              if (widget.step != null) _stepDots(primary),
              const Spacer(),
              // Gently pulsing icon badge. Only a cheap scale animates each
              // frame; the shadow/background are static so it stays smooth even
              // on low-end devices.
              ScaleTransition(
                scale: Tween(begin: 0.97, end: 1.05).animate(
                  CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                ),
                child: Container(
                  padding: const EdgeInsets.all(36),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary.withValues(alpha: .12),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: .18),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(widget.icon, size: 64, color: primary),
                ),
              ),
              const Gap(28),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Get.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Gap(12),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyMedium
                    ?.copyWith(color: Get.theme.hintColor, height: 1.5),
              ),
              const Gap(24),
              ...widget.bullets.map((b) => _bullet(primary, b.$1, b.$2)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                    ),
                  ),
                  onPressed: widget.onPrimary,
                  child: widget.primaryLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(widget.primaryLabel,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              if (widget.secondaryLabel != null) ...[
                const Gap(6),
                TextButton(
                  onPressed: widget.onSecondary,
                  child: Text(
                    widget.secondaryLabel!,
                    style: TextStyle(color: Get.theme.hintColor),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepDots(Color primary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.totalSteps, (i) {
        final active = i == (widget.step! - 1);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: active ? 24 : 8,
          decoration: BoxDecoration(
            color: active ? primary : primary.withValues(alpha: .25),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }

  Widget _bullet(Color primary, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            child: Icon(icon, color: primary, size: 18),
          ),
          const Gap(12),
          Expanded(child: Text(text, style: Get.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
