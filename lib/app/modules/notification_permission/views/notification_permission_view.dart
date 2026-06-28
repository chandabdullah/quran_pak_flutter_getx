import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/services/notification_service.dart';

/// Asks the user to grant notification permission so prayer reminders can fire.
/// Pops `true` once notifications are allowed.
class NotificationPermissionView extends StatefulWidget {
  const NotificationPermissionView({super.key});

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
    if (granted) {
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

  @override
  Widget build(BuildContext context) {
    final primary = Get.theme.primaryColor;
    return Scaffold(
      appBar: AppBar(title: const Text("Prayer Reminders")),
      body: Padding(
        padding: const EdgeInsets.all(kPadding * 1.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.notifications_active_rounded,
                  size: 64, color: primary),
            ),
            const Gap(24),
            Text(
              "Never miss a prayer",
              style: Get.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            Text(
              "Allow notifications so we can remind you at each prayer time. "
              "You can then turn the reminder on or off for each prayer.",
              textAlign: TextAlign.center,
              style: Get.textTheme.bodyMedium?.copyWith(color: Get.theme.hintColor),
            ),
            const Gap(28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _requesting ? null : _enable,
                icon: _requesting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.notifications_active_rounded),
                label: const Text("Enable Notifications"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
