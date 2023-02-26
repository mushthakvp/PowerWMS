import 'package:flutter/material.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/main.dart';

pop() {
  navigatorKey.currentState?.pop();
}

Future showErrorAlert({
  String? title,
  required String message,
  VoidCallback? onClose,
}) async {
  return await showDialog(
      barrierDismissible: onClose == null,
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
            title: Text(title ?? 'An Error Occurred!'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(navigatorKey.currentContext!)!
                    .ok
                    .toUpperCase()),
                onPressed: onClose ??
                    () {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        Navigator.of(context).pop(true);
                      });
                    },
              )
            ],
          ));
}
