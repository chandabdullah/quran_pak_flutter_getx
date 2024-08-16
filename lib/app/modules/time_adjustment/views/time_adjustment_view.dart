import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uicons/uicons.dart';

import '../controllers/time_adjustment_controller.dart';

class TimeAdjustmentView extends GetView<TimeAdjustmentController> {
  const TimeAdjustmentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return GetBuilder<TimeAdjustmentController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Time Adjustment"),
        ),
        body: SafeArea(
          child: ListView.separated(
            itemCount: controller.timeAdjustment.length,
            separatorBuilder: (_, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              var item = controller.timeAdjustment[index];
              return ListTile(
                onTap: () {
                  onAdjustTime(
                    context,
                    index,
                    title: "${item["title"]} Time Adjustment",
                    selectedIndex: (item?["time"] ?? 0) + controller.maxTime,
                  );
                },
                leading: Icon(
                  item["icon"],
                ),
                title: Text(
                  item["title"].toString().capitalize ?? "",
                  style: theme.textTheme.titleMedium,
                ),
                trailing: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item["time"] != 0)
                      IconButton(
                        splashRadius: 20,
                        tooltip: "Refresh",
                        onPressed: () {
                          controller.onTimeAdjust(index, 120);
                        },
                        icon: Icon(
                          UIcons.boldRounded.refresh,
                          size: 16,
                          color: theme.primaryColor,
                        ),
                      ),
                    Text(
                      item["time"] == 0
                          ? "No Adjusted"
                          : item["time"] < 0
                              ? "${item["time"]} min"
                              : "+${item["time"]} min",
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: item["time"] == 0 ? null : theme.primaryColor,
                        fontWeight: item["time"] == 0 ? null : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }

  onAdjustTime(
    BuildContext context,
    int index, {
    required String title,
    int? selectedIndex,
  }) {
    var theme = Theme.of(context);

    BottomPicker(
      pickerTitle: const Text("Prayer Time Adjustment"),
      selectedItemIndex: selectedIndex ?? controller.maxTime,
      items: [
        for (int index = -controller.maxTime;
            index < (controller.maxTime + 1);
            index++)
          Center(
            child: Text(
              index <= 0 ? "$index min" : "+$index min",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
          ),
      ],
      itemExtent: 40,
      dismissable: true,
      backgroundColor: theme.cardColor,
      buttonSingleColor: theme.primaryColor,
      // buttonTextStyle: theme.textTheme.bodyMedium!.copyWith(
      //   color: theme.cardColor,
      // ),
      closeIconColor: theme.primaryColor,
      // displayButtonIcon: false,
      // title: title.capitalize ?? "",
      // titleStyle: theme.textTheme.titleLarge ?? const TextStyle(),
      pickerTextStyle: theme.textTheme.bodySmall ?? const TextStyle(),
      buttonContent: Text(
        "Adjust Time",
        style: Get.textTheme.bodyMedium?.copyWith(
          color: Get.theme.cardColor,
        ),
      ),
      onSubmit: (val) {
        controller.onTimeAdjust(index, val);
      },
    ).show(context);
    // showCustomBottomSheet(
    //   context,
    //   title: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Text(
    //         title,
    //         style: theme.textTheme.titleLarge,
    //       ),
    //       CustomIconButton(
    //         iconData: UIcons.regularRounded.cross,
    //         isSmall: true,
    //         tooltip: "Close",
    //       ),
    //       // IconButton(
    //       //   onPressed: () {},
    //       //   icon: Icon(
    //       //     UIcons.regularRounded.cross,
    //       //     size: 15,
    //       //   ),
    //       // ),
    //     ],
    //   ),
    //   content: Padding(
    //     padding: const EdgeInsets.all(kPadding),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Text(
    //           "",
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
