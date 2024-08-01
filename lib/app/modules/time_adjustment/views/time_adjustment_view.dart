import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/time_adjustment_controller.dart';

class TimeAdjustmentView extends GetView<TimeAdjustmentController> {
  const TimeAdjustmentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TimeAdjustmentView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TimeAdjustmentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
