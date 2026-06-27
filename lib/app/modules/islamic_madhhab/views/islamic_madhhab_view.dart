import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/components/selectable_tile.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';

import '../controllers/islamic_madhhab_controller.dart';

class IslamicMadhhabView extends GetView<IslamicMadhhabController> {
  const IslamicMadhhabView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic Madhhab'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(kPadding),
          itemCount: controller.islamicMadhhabList.length,
          itemBuilder: (context, index) {
            var method = controller.islamicMadhhabList[index];
            int? selectedId = MyIslamicMadhab.getIslamicMadhabId();

            return SelectableTile(
              title: method.name,
              selected: selectedId == method.id,
              onTap: () => controller.onIslamicMadhabChange(method.id),
            );
          },
        ),
      ),
    );
  }
}
