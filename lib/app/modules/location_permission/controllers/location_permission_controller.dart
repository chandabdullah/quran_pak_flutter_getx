import 'package:get/get.dart';
import 'package:quran_pak/app/routes/app_pages.dart';
import 'package:quran_pak/app/services/permissions_service.dart';

class LocationPermissionController extends GetxController {
  bool requesting = false;

  Future<void> onEnablePermissions() async {
    requesting = true;
    update();
    await PermissionHandlerService.requestLocationPermission();
    requesting = false;
    update();
    _goToNotificationStep();
  }

  void skip() => _goToNotificationStep();

  /// Onboarding step 2: ask about notifications.
  void _goToNotificationStep() {
    Get.offNamed(Routes.NOTIFICATION_PERMISSION);
  }
}
