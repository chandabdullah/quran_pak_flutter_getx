// import 'package:flutter_qiblah_update/flutter_qiblah.dart';
import 'package:get/get.dart';
// import 'package:qibla_direction/qibla_direction.dart';

class QiblaDirectionController extends GetxController {
  // final deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  double? direction;
  double? distance;

  getQiblaDirection() {
    // const coordinate = Coordinate(41.2995, 69.2401);
    // direction = QiblaDirection.find(coordinate);
    // distance = QiblaDirection.countDistance(coordinate);

    update();
  }

  @override
  void onInit() {
    getQiblaDirection();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
