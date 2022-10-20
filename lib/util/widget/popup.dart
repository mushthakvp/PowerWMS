import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scanner/main.dart';

pop() {
  navigatorKey.currentState?.pop();
}

Future showErrorAlert({required String message}) async {
  return await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(navigatorKey.currentContext!)!
                    .ok
                    .toUpperCase()),
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          ));
}
