import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_pak/app/constants/app_constants.dart';
import 'package:gap/gap.dart';

showCustomBottomSheet({
  required context,
  bool? isDismissible,
  String? title,
  String? subTitle,
  double? height,
  double? padding,
  Function()? onTap,
  Widget? trailingWidget,
  required List<Widget> listOfItem,
}) {
  var theme = Theme.of(context);

  Get.bottomSheet(
    CustomBottomSheet(
      title: title,
      subTitle: subTitle,
      list: listOfItem,
      height: height ?? Get.height * 0.9,
      padding: padding,
      onTap: onTap,
      trailingWidget: trailingWidget,
    ),
    isDismissible: isDismissible ?? true,
    ignoreSafeArea: true,
    isScrollControlled: true,
    backgroundColor: theme.scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(kBorderRadius),
        topRight: Radius.circular(kBorderRadius),
      ),
    ),
  );
}

class CustomBottomSheet extends StatelessWidget {
  CustomBottomSheet({
    super.key,
    this.title,
    this.subTitle,
    this.padding,
    required this.height,
    required this.list,
    this.onTap,
    this.trailingWidget,
  });

  String? title;
  String? subTitle;
  double? padding;
  double height;
  Widget? trailingWidget;
  List<Widget> list;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        0,
        kPadding / 2,
        0,
        kBottomPadding(context),
      ),
      constraints: BoxConstraints(
        maxHeight: height,
      ),
      // height: height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: Get.width / 3,
                color: Get.theme.hintColor,
                height: 5,
              ),
            ),
            if (title != '') const Gap(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_outlined),
                    onPressed: () {
                      if (onTap == null) {
                        if (Get.isBottomSheetOpen ?? false) Get.back();
                      }
                      onTap?.call();
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        title ?? "",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  trailingWidget ??
                      const SizedBox(
                        width: 45,
                        height: 15,
                      )
                ],
              ),
            ),
            if (title != '') const Gap(8),
            // for (int index = 0; index < list.length; index++)
            Divider(
              height: 1,
              color: Get.theme.dividerColor.withOpacity(.5),
            ),
            Padding(
              padding: padding == null
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.fromLTRB(
                      kPadding,
                      0,
                      kPadding,
                      kPadding / 1.5,
                    ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: list,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
