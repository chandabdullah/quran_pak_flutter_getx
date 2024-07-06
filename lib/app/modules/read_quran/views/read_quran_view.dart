import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

import '../controllers/read_quran_controller.dart';

class ReadQuranView extends GetView<ReadQuranController> {
  const ReadQuranView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Read Quran"),
      ),
      body: TurnPageView.builder(
        controller: controller.turnPageController,
        itemCount: 10,
        itemBuilder: (context, index) => Container(
          height: double.infinity,
          width: double.infinity,
          color: Get.theme.cardColor,
          alignment: Alignment.center,
          child: Center(
            child: Text("${index + 1}"),
          ),
        ),
        useOnTap: false,
        useOnSwipe: true,
        overleafColorBuilder: (index) => Colors.grey.withOpacity(.3),
        animationTransitionPoint: 0.5,
      ),
    );
  }
}
