import 'package:flutter/material.dart';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
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
          body: Container(
            decoration: const BoxDecoration(),
            child: StreamBuilder<CompassEvent>(
              stream: FlutterCompass.events,
              builder: (context, snapshot) {
                double heading = 0;
                if (snapshot.hasData) {
                  heading = snapshot.data!.heading!;
                }
                if (controller.coordinates != null) {}
                double? direction =
                    heading - (controller.qibla?.direction ?? 0);

                if (controller.hasPermissions) {
                  return Padding(
                    padding: const EdgeInsets.all(kPadding),
                    child: Stack(
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
                  );
                } else {
                  return _buildPermissionSheet();
                }
              },
            ),
          ));
    });
  }

  Widget _buildPermissionSheet() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Location Permission Required'),
          ElevatedButton(
            child: Text('Request Permissions'),
            onPressed: () async {
              Geolocator.requestPermission()
                  // Permission.locationWhenInUse.request()
                  .then((ignored) {
                print(ignored);
                controller.fetchPermissionStatus();
              });
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            child: Text('Open App Settings'),
            onPressed: () {
              openAppSettings().then((opened) {});
            },
          )
        ],
      ),
    );
  }
}
