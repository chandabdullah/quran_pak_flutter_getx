import 'package:flutter/material.dart';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:flutter_svg/svg.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';

import '../controllers/qibla_direction_controller.dart';

class QiblaDirectionView extends GetView<QiblaDirectionController> {
  const QiblaDirectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QiblaDirectionController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Qibla Direction'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: switch (controller.status) {
            QiblaStatus.loading => const Center(
                child: CircularProgressIndicator(),
              ),
            QiblaStatus.ready => _buildCompass(),
            _ => _buildLocationPrompt(context),
          },
        ),
      );
    });
  }

  Widget _buildCompass() {
    return Container(
      decoration: const BoxDecoration(),
      child: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildMessage(
              context,
              icon: Icons.explore_off_rounded,
              title: "Compass unavailable",
              message:
                  "Your device doesn't seem to have a compass sensor, so the "
                  "Qibla direction can't be shown.",
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final double? heading = snapshot.data!.heading;
          if (heading == null) {
            return _buildMessage(
              context,
              icon: Icons.screen_rotation_rounded,
              title: "Calibrate your compass",
              message:
                  "Move your phone in a figure-8 motion to calibrate the compass.",
            );
          }

          final double direction = heading - (controller.qibla?.direction ?? 0);

          return Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              children: [
                const Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 700),
                      turns: -direction / 360,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        MyDarkMode.getThemeIsLight()
                            ? 'assets/svg/qibla.svg'
                            : 'assets/svg/qibla_dark.svg',
                      ),
                    ),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 700),
                      turns: -direction / 360,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/svg/needle.svg',
                        fit: BoxFit.contain,
                        height: 300,
                        alignment: Alignment.center,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  "${controller.qibla?.direction.toStringAsFixed(1)}° from North",
                  style: Get.textTheme.titleMedium,
                ),
                const Gap(8),
                Text(
                  "Point the needle to the top to face the Qibla",
                  textAlign: TextAlign.center,
                  style: Get.textTheme.bodySmall,
                ),
                const Gap(20),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Shown whenever we can't get the user's location: services off, or the
  /// permission is denied / denied-forever. Gives a clear call to action.
  Widget _buildLocationPrompt(BuildContext context) {
    final bool deniedForever =
        controller.status == QiblaStatus.permissionDeniedForever;
    final bool serviceDisabled =
        controller.status == QiblaStatus.serviceDisabled;

    final String title = serviceDisabled
        ? "Turn on Location"
        : "Location Permission Needed";
    final String message = serviceDisabled
        ? "Location services are turned off. Enable them so we can find the "
            "Qibla direction from where you are."
        : deniedForever
            ? "Location permission is permanently denied. Please allow location "
                "access from the app settings to use the Qibla compass."
            : "We need access to your location to point you towards the Qibla "
                "accurately.";
    final String buttonText = serviceDisabled
        ? "Enable Location"
        : deniedForever
            ? "Open App Settings"
            : "Grant Permission";

    final VoidCallback onPressed = serviceDisabled
        ? controller.openLocationSettings
        : deniedForever
            ? controller.openAppSettings
            : controller.resolveLocation;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kPadding * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Get.theme.primaryColor.withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                serviceDisabled
                    ? Icons.location_off_rounded
                    : Icons.location_on_rounded,
                size: 64,
                color: Get.theme.primaryColor,
              ),
            ),
            const Gap(24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Get.textTheme.titleLarge,
            ),
            const Gap(12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Get.theme.hintColor,
              ),
            ),
            const Gap(28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kBorderRadius),
                  ),
                ),
                onPressed: onPressed,
                icon: const Icon(Icons.my_location_rounded),
                label: Text(buttonText),
              ),
            ),
            const Gap(12),
            TextButton(
              onPressed: controller.resolveLocation,
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kPadding * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Get.theme.primaryColor),
            const Gap(20),
            Text(title, style: Get.textTheme.titleLarge),
            const Gap(12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Get.theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
