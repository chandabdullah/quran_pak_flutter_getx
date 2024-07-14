import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
// import 'package:flutter_qiblah_update/flutter_qiblah.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';

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
        body: Builder(builder: (_) {
          if (controller.hasPermissions) {
            return Column(
              children: <Widget>[
                _buildManualReader(context),
                Expanded(child: _buildCompass()),
              ],
            );
          } else {
            return _buildPermissionSheet();
          }
        }),
        // body: FutureBuilder(
        //   future: controller.deviceSupport,
        //   builder: (_, AsyncSnapshot<bool?> snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const CircularProgressIndicator();
        //     }
        //     if (snapshot.hasError) {
        //       return Center(
        //         child: Text("Error: ${snapshot.error.toString()}"),
        //       );
        //     }

        //     if (snapshot.data!) {
        //       return QiblahCompass();
        //     } else {
        //       return SizedBox();
        //     }
        //   },
        // ),
      );
    });
  }

  Widget _buildManualReader(context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          ElevatedButton(
            child: Text('Read Value'),
            onPressed: () async {
              final CompassEvent tmp = await FlutterCompass.events!.first;

              controller.lastRead = tmp;
              controller.lastReadAt = DateTime.now();
              controller.update();
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${controller.lastRead}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${controller.lastReadAt}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        double? direction = snapshot.data!.heading;

        // if direction is null, then device does not support this sensor
        // show error message
        if (direction == null)
          return Center(
            child: Text("Device does not have sensors !"),
          );
// return Material(
//           shape: CircleBorder(),
//           clipBehavior: Clip.antiAlias,
//           elevation: 4.0,
//           child: Container(
//             padding: EdgeInsets.all(16.0),
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//             ),
//             child: Transform.rotate(
//               angle: (direction * (math.pi / 180) * -1),
//               child: SvgPicture.asset('assets/svg/qibla.svg'),
//             ),
//           ),
//         );

        final _compassSvg = SvgPicture.asset('assets/svg/qibla.svg');
        final _needleSvg = SvgPicture.asset(
          'assets/svg/needle.svg',
          fit: BoxFit.contain,
          height: 300,
          alignment: Alignment.center,
        );

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: (direction * (math.pi / 180) * -1),
              child: _compassSvg,
            ),
            Transform.rotate(
              angle: (direction * (math.pi / 180) * -1),
              // angle: (qiblahDirection.qiblah * (math.pi / 180) * -1),
              alignment: Alignment.center,
              child: _needleSvg,
            ),
            Positioned(
              bottom: 8,
              child: Text("${controller.lastRead?.heading}°"),
            )
          ],
        );
      },
    );
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
              // openAppSettings().then((opened) {
              // });
            },
          )
        ],
      ),
    );
  }
}

/// ===================================================
/// ===================================================
/// ===================================================

// class QiblahCompass extends StatefulWidget {
//   @override
//   _QiblahCompassState createState() => _QiblahCompassState();
// }

// class _QiblahCompassState extends State<QiblahCompass> {
//   final _locationStreamController =
//       StreamController<LocationStatus>.broadcast();

//   Stream<LocationStatus> get stream => _locationStreamController.stream;

//   @override
//   void initState() {
//     super.initState();
//     _checkLocationStatus();
//   }

//   @override
//   void dispose() {
//     _locationStreamController.close();
//     FlutterQiblah().dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       padding: const EdgeInsets.all(8.0),
//       child: StreamBuilder(
//         stream: stream,
//         builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting)
//             return CircularProgressIndicator();
//           if (snapshot.data!.enabled == true) {
//             switch (snapshot.data!.status) {
//               case LocationPermission.always:
//               case LocationPermission.whileInUse:
//                 return QiblahCompassWidget();

//               case LocationPermission.denied:
//                 return Center(
//                   child: Text("Location service permission denied"),
//                   // callback: _checkLocationStatus,
//                 );
//               case LocationPermission.deniedForever:
//                 return Center(
//                   child: Text("Location service Denied Forever !"),
//                   // callback: _checkLocationStatus,
//                 );
//               // case GeolocationStatus.unknown:
//               //   return LocationErrorWidget(
//               //     error: "Unknown Location service error",
//               //     callback: _checkLocationStatus,
//               //   );
//               default:
//                 return const SizedBox();
//             }
//           } else {
//             return Center(
//               child: Text("Please enable Location service"),
//               // callback: _checkLocationStatus,
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future<void> _checkLocationStatus() async {
//     final locationStatus = await FlutterQiblah.checkLocationStatus();
//     if (locationStatus.enabled &&
//         locationStatus.status == LocationPermission.denied) {
//       await FlutterQiblah.requestPermissions();
//       final s = await FlutterQiblah.checkLocationStatus();
//       _locationStreamController.sink.add(s);
//     } else {
//       _locationStreamController.sink.add(locationStatus);
//     }
//   }
// }

// class QiblahCompassWidget extends StatelessWidget {
//   final _compassSvg = SvgPicture.asset('assets/svg/qibla.svg');
//   final _needleSvg = SvgPicture.asset(
//     'assets/svg/needle.svg',
//     fit: BoxFit.contain,
//     height: 300,
//     alignment: Alignment.center,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FlutterQiblah.qiblahStream,
//       builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }

//         final qiblahDirection = snapshot.data!;

//         return Stack(
//           alignment: Alignment.center,
//           children: <Widget>[
//             Transform.rotate(
//               angle: (qiblahDirection.direction * (pi / 180) * -1),
//               child: _compassSvg,
//             ),
//             Transform.rotate(
//               angle: (qiblahDirection.qiblah * (pi / 180) * -1),
//               alignment: Alignment.center,
//               child: _needleSvg,
//             ),
//             Positioned(
//               bottom: 8,
//               child: Text("${qiblahDirection.offset.toStringAsFixed(3)}°"),
//             )
//           ],
//         );
//       },
//     );
//   }
// }
