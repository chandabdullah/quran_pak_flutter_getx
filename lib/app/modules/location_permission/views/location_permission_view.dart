import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/components/permission_scaffold.dart';

import '../controllers/location_permission_controller.dart';

class LocationPermissionView extends GetView<LocationPermissionController> {
  const LocationPermissionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationPermissionController>(builder: (_) {
      return PermissionScaffold(
        icon: Icons.location_on_rounded,
        step: 1,
        totalSteps: 2,
        title: "Enable Location",
        message:
            "We use your location to calculate accurate prayer times and the "
            "Qibla direction for exactly where you are.",
        primaryLabel: "Enable Location",
        primaryLoading: controller.requesting,
        onPrimary: controller.requesting ? null : controller.onEnablePermissions,
        secondaryLabel: "Skip for now",
        onSecondary: controller.skip,
        bullets: const [
          (Icons.access_time_filled_rounded, "Precise daily prayer times"),
          (Icons.explore_rounded, "Accurate Qibla direction"),
          (Icons.lock_outline_rounded, "Stays on your device"),
        ],
      );
    });
  }
}
