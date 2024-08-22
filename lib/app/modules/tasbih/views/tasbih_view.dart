import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tasbih_controller.dart';

class TasbihView extends GetView<TasbihController> {
  const TasbihView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasbih'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TasbihView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
