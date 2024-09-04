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
          constraints: BoxConstraints(
            maxHeight: Get.height * .9,
            minHeight: Get.height / 2,
          ),
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
            ],
          ),
        );
      },
    ),
    isScrollControlled: true,
    enableDrag: true,
    ignoreSafeArea: false,
  );
}
