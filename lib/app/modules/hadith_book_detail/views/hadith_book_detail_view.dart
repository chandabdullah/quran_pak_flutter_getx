import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/hadith_book_detail_controller.dart';

class HadithBookDetailView extends GetView<HadithBookDetailController> {
  const HadithBookDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HadithBookDetailController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text(Get.arguments),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'HadithBookDetailView is working',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    });
  }
}
