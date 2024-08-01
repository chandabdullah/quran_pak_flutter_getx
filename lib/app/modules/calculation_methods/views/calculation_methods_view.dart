import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_pak/app/data/local/my_shared_pref.dart';

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
          child: ListView.separated(
            itemCount: controller.calculationMethods.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              var method = controller.calculationMethods[index];

              return ListTile(
                onTap: () {
                  controller.onCalculationMethodChange(method.id);
                },
                trailing: controller.calculationMethodId == method.id
                    ? Icon(
                        Icons.check,
                        color: Get.theme.primaryColor,
                      )
                    : const SizedBox(),
                title: Text(method.name),
                subtitle: method.params?.midnight == null
                    ? null
                    : Text(method.params?.midnight ?? ""),
              );
            },
          ),
        ),
      );
    });
  }
}
