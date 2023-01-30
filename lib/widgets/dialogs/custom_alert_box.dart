import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:scanner/util/color_const.dart';
import 'package:scanner/util/extensions/text_style_ext.dart';
import 'package:scanner/widgets/custom_button.dart';

class CustomAlertBox {
  static showAlertBox(context,
      {required message,
      String? title,
      VoidCallback? onConfirm,
      bool? restrictAlert = false,
      String? confirmText}) {
    if (message.runtimeType == String) {
      message = Text(
        message,
        style: Theme.of(context).textTheme.bodySmall?.s16,
        textAlign: TextAlign.center,
      );
    } else {
      message = message;
    }

    return showDialog(
        context: context,
        barrierDismissible: !restrictAlert!,
        builder: (context) => AlertDialog(
          scrollable: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text(
                title ?? "Are you sure",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1?.s20.primaryColor.semiBold,
              ),
              content:  Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [const Gap(4), message],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                        child: AppButton(
                      radius: 8,
                      onPressed: () {
                        if (restrictAlert) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      buttonColor: Colors.red,
                      title: "Cancel",
                    )),
                    if (!restrictAlert) ...[
                      const Gap(12),
                      Expanded(
                          child: AppButton(
                        radius: 8,
                        buttonColor: AppColors.primary,
                        onPressed: onConfirm,
                        title: confirmText ?? "Confirm",
                      ))
                    ]
                  ],
                )
              ],
            ));
  }
}
