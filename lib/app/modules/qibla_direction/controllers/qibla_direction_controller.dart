// import 'package:flutter_qiblah_update/flutter_qiblah.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';

class QiblaDirectionController extends GetxController {
  // final deviceSupport = FlutterQiblah.androidDeviceSensorSupport();
  bool hasPermissions = false;
  CompassEvent? lastRead;
  DateTime? lastReadAt;
  Qibla? qibla;

  Coordinates? coordinates = MyCoordinates.getCoordinates();

  // double? direction;
  // double? distance;

  void fetchPermissionStatus() {
    Geolocator.checkPermission().then((status) {
      hasPermissions = (status == LocationPermission.whileInUse ||
          status == LocationPermission.always);
      update();
    });
  }

  getQiblaDirection() {
    if (coordinates == null) return;

    qibla = Qibla(coordinates!);
    print("Qibla: ${qibla?.direction}");

    // const coordinate = Coordinate(41.2995, 69.2401);
    // direction = QiblaDirection.find(coordinate);
    // distance = QiblaDirection.countDistance(coordinate);

    update();
  }

  @override
  void onInit() async {
    fetchPermissionStatus();
    getQiblaDirection();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
//     FlutterQiblah().dispose();
    super.onClose();
  }
}
