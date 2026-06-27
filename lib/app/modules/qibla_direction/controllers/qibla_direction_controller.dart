import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';

/// High-level state of the Qibla screen, used to decide what to render.
enum QiblaStatus {
  loading,
  serviceDisabled, // device location services are turned off
  permissionDenied, // app lacks location permission (can re-request)
  permissionDeniedForever, // user must enable it from app settings
  ready, // we have coordinates and can show the compass
}

class QiblaDirectionController extends GetxController {
  QiblaStatus status = QiblaStatus.loading;
  Qibla? qibla;
  Coordinates? coordinates;

  @override
  void onInit() {
    super.onInit();
    resolveLocation();
  }

  /// Checks location services + permission and, when available, fetches the
  /// current position and computes the Qibla direction from it.
  Future<void> resolveLocation() async {
    status = QiblaStatus.loading;
    update();

    // 1) Are the device's location services switched on?
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Fall back to a previously saved location if we have one so the user
      // still sees a (best-effort) direction while services are off.
      _useSavedCoordinatesIfAny();
      if (status != QiblaStatus.ready) status = QiblaStatus.serviceDisabled;
      update();
      return;
    }

    // 2) Do we have permission?
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      _useSavedCoordinatesIfAny();
      if (status != QiblaStatus.ready) {
        status = QiblaStatus.permissionDeniedForever;
      }
      update();
      return;
    }

    if (permission == LocationPermission.denied) {
      _useSavedCoordinatesIfAny();
      if (status != QiblaStatus.ready) status = QiblaStatus.permissionDenied;
      update();
      return;
    }

    // 3) Permission granted + services on → use the live position.
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      coordinates = Coordinates(position.latitude, position.longitude);
      MyCoordinates.saveCoordinates(coordinates!);
    } catch (_) {
      // If the live read fails (e.g. timeout) fall back to saved coordinates.
      _useSavedCoordinatesIfAny();
    }

    if (coordinates != null) {
      qibla = Qibla(coordinates!);
      status = QiblaStatus.ready;
    } else if (status == QiblaStatus.loading) {
      status = QiblaStatus.serviceDisabled;
    }
    update();
  }

  void _useSavedCoordinatesIfAny() {
    final saved = MyCoordinates.getCoordinates();
    if (saved != null && (saved.latitude != 0 || saved.longitude != 0)) {
      coordinates = saved;
      qibla = Qibla(saved);
      status = QiblaStatus.ready;
    }
  }

  /// Opens the device's location settings so the user can switch services on.
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
    await resolveLocation();
  }

  /// Opens the app's settings page (used when permission is denied forever).
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
    await resolveLocation();
  }
}
