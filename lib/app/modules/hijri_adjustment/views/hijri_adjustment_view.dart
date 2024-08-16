import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';
import 'package:uicons/uicons.dart';

import '../controllers/hijri_adjustment_controller.dart';

class HijriAdjustmentView extends GetView<HijriAdjustmentController> {
  const HijriAdjustmentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Hijri Adjustment")),
      body: SafeArea(
        child: ListView.separated(
          itemCount: controller.hijriAdjustmentList.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            var hijriAdjustment = controller.hijriAdjustmentList[index];
            int localHijriAdjustment = MyHijriAdjustment.getHijriAdjustment();

            return ListTile(
              onTap: () {
                controller.onHijriAdjustment(hijriAdjustment);
              },
              trailing: localHijriAdjustment == hijriAdjustment
                  ? Icon(
                      UIcons.regularRounded.check,
                      color: theme.primaryColor,
                    )
                  : const SizedBox(),
              title: Text(
                hijriAdjustment == 0
                    ? "Auto"
                    : "${hijriAdjustment > 0 ? "+$hijriAdjustment" : hijriAdjustment} days",
              ),
            );
          },
        ),
      ),
    );
  }
}
