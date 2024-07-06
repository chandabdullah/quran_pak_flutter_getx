import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:flutter_qiblah_update/flutter_qiblah.dart';
import 'package:flutter_svg/svg.dart';
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
