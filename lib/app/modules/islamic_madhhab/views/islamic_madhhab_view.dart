import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';

import '../controllers/islamic_madhhab_controller.dart';

class IslamicMadhhabView extends GetView<IslamicMadhhabController> {
  const IslamicMadhhabView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var theme = Get.theme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic Madhhab'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: controller.islamicMadhhabList.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            var method = controller.islamicMadhhabList[index];
            int? calculationMethodId = MyIslamicMadhab.getIslamicMadhabId();

            return ListTile(
              onTap: () {
                controller.onIslamicMadhabChange(method.id);
              },
              trailing: calculationMethodId == method.id
                  ? Icon(
                      Icons.check,
                      color: theme.primaryColor,
                    )
                  : const SizedBox(),
              title: Text(method.name),
            );
          },
        ),
      ),
    );
  }
}
