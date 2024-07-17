import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '/app/constants/app_constants.dart';

showCustomBottomSheet(
  context, {
  Widget? title,
  Widget? content,
  bool centerTitle = true,
}) {
  var theme = Theme.of(context);

  Get.bottomSheet(
    BottomSheet(
      backgroundColor: theme.cardColor,
      onClosing: () {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      enableDrag: false,
      showDragHandle: false,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: kBottomPadding(context),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: centerTitle == true ? Alignment.center : null,
                padding: const EdgeInsets.all(kPadding),
                child: title,
              ),
              const Divider(
                height: 1,
              ),
              const Gap(12),
              content ?? const SizedBox(),
              // ListTile(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(
              //       kBorderRadius,
              //     ),
              //   ),
              //   dense: true,
              //   onTap: () {
              //     if (Get.isBottomSheetOpen ?? false) {
              //       Get.back();
              //     }
              //   },
              //   title: Text(
              //     "English",
              //     style:
              //         theme.textTheme.titleMedium!.copyWith(
              //       color: theme.primaryColor,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              //   trailing: Icon(
              //     UIcons.regularRounded.check,
              //     color: theme.primaryColor,
              //     size: 20,
              //   ),
              // ),
              // const Divider(
              //   height: 1,
              // ),
              // ListTile(
              //   dense: true,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(
              //       kBorderRadius,
              //     ),
              //   ),
              //   onTap: () {
              //     if (Get.isBottomSheetOpen ?? false) {
              //       Get.back();
              //     }
              //   },
              //   title: Text(
              //     "اردو",
              //     style: theme.textTheme.titleMedium,
              //   ),
              // ),
            ],
          ),
        );
      },
    ),
  );
}
