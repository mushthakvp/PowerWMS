import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:scanner/util/extensions/text_style_ext.dart';

enum SnackBarType { error, success, info }

class CustomSnackBar {
  static showSnackBar(
    BuildContext context, {
    SnackBarType snackBarType = SnackBarType.error,
    String? message,
    String? title,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Builder(builder: (context) {
          return Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? "Something went wrong",
                      style: Theme.of(context).textTheme.subtitle1?.white,
                    ),
                    if (message != null) ...[
                      Gap(4),
                      Flexible(
                        child: Text(
                          message,
                          style: Theme.of(context).textTheme.caption?.white,
                          maxLines: 2,
                        ),
                      )
                    ],
                  ],
                ),
              ),
            ],
          );
        }),
        margin: EdgeInsets.all(12),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
