import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:scanner/l10n/app_localizations.dart';
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
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.s20
                    .primaryColor
                    .semiBold,
              ),
              content: Column(
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
                      title: AppLocalizations.of(context)!.cancel,
                    )),
                    if (!restrictAlert) ...[
                      const Gap(12),
                      Expanded(
                          child: AppButton(
                        radius: 8,
                        buttonColor: AppColors.primary,
                        onPressed: onConfirm,
                        title:
                            confirmText ?? AppLocalizations.of(context)!.save,
                      ))
                    ]
                  ],
                )
              ],
            ));
  }

  static showStateFulAlertBox(context,
      {required message,
      String? title,
      Function? onConfirm,
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
        barrierDismissible: false,
        builder: (context) {
          LoadingNotifier loadingNotifier = LoadingNotifier(false);

          return AnimatedBuilder(
            animation: loadingNotifier,
            builder: (context, setState) {
              return AlertDialog(
                scrollable: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: Text(
                  title ?? "Are you sure",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.s20
                      .primaryColor
                      .semiBold,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [const Gap(4), message],
                ),
                actions: [
                  if (loadingNotifier.getLoadingStatus)
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ))
                  else
                    Row(
                      children: [
                        Expanded(
                            child: AppButton(
                          radius: 8,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          buttonColor: Colors.red,
                          title: AppLocalizations.of(context)!.cancel,
                        )),
                        ...[
                          const Gap(12),
                          Expanded(
                              child: AppButton(
                            radius: 8,
                            buttonColor: AppColors.primary,
                            onPressed: () {
                              onConfirm!(loadingNotifier);
                            },
                            title: confirmText ??
                                AppLocalizations.of(context)!.save,
                          ))
                        ]
                      ],
                    )
                ],
              );
            },
          );
        });
  }
}

class LoadingNotifier extends ValueNotifier<bool> {
  bool isLoading = false;

  LoadingNotifier(bool value) : super(value);

  bool get getLoadingStatus => isLoading;

  changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }
}
