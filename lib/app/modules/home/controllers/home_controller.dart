import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

class HomeController extends GetxController {
  final TurnPageController turnPageController = TurnPageController(
    direction: TurnDirection.leftToRight,
  );

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    // var permission = await Geolocator.requestPermission();
    // print("name: ${permission.name}");
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
