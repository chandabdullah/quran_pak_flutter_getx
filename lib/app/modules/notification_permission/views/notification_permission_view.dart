import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/components/permission_scaffold.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/routes/app_pages.dart';
import 'package:quran_pak/app/services/notification_service.dart';
import 'package:quran_pak/app/services/onboarding_service.dart';

/// Asks for notification permission. Used both as the second onboarding step
/// ([onboarding] == true, with a "Maybe later" skip) and from the Prayer Time
/// screen ([onboarding] == false, pops with the result).
class NotificationPermissionView extends StatefulWidget {
  const NotificationPermissionView({super.key, this.onboarding = false});

  final bool onboarding;

  @override
  State<NotificationPermissionView> createState() =>
      _NotificationPermissionViewState();
}

class _NotificationPermissionViewState
    extends State<NotificationPermissionView> {
  bool _requesting = false;

  Future<void> _enable() async {
    setState(() => _requesting = true);
    final granted = await NotificationService.requestPermission();
    setState(() => _requesting = false);

    if (widget.onboarding) {
      _finishOnboarding();
    } else if (granted) {
      Get.back(result: true);
    } else {
      Get.rawSnackbar(
        message: "Notifications are blocked. Enable them from system settings.",
        backgroundColor: Get.theme.primaryColor,
        margin: const EdgeInsets.all(kPadding),
        borderRadius: kBorderRadius,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _finishOnboarding() {
    OnboardingService.markDone();
    Get.offAllNamed(Routes.HOME);
  }

  @override
  Widget build(BuildContext context) {
    return PermissionScaffold(
      icon: Icons.notifications_active_rounded,
      step: widget.onboarding ? 2 : null,
      totalSteps: 2,
      title: "Never miss a prayer",
      message:
          "Allow notifications and we'll remind you the moment each prayer "
          "begins. You can turn the reminder on or off for any prayer later.",
      primaryLabel: "Enable Notifications",
      primaryLoading: _requesting,
      onPrimary: _requesting ? null : _enable,
      secondaryLabel: widget.onboarding ? "Maybe later" : "Not now",
      onSecondary: widget.onboarding ? _finishOnboarding : () => Get.back(),
      bullets: const [
        (Icons.access_time_rounded, "Right on time, every day"),
        (Icons.tune_rounded, "Choose which prayers remind you"),
        (Icons.notifications_off_rounded, "Turn off anytime"),
      ],
    );
  }
}
