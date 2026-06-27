import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/components/selectable_tile.dart';
import 'package:quran_pak/app/constants/app_constants.dart';

import '../controllers/calculation_methods_controller.dart';

class CalculationMethodsView extends GetView<CalculationMethodsController> {
  const CalculationMethodsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalculationMethodsController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Calculation Methods"),
        ),
        body: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(kPadding),
            itemCount: controller.calculationMethods.length,
            itemBuilder: (context, index) {
              var method = controller.calculationMethods[index];

              return SelectableTile(
                title: method.name,
                subtitle: method.params?.midnight,
                selected: controller.calculationMethodId == method.id,
                onTap: () => controller.onCalculationMethodChange(method.id),
              );
            },
          ),
        ),
      );
    });
  }
}
