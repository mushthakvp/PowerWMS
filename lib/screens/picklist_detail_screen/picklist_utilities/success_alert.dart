import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/util/extensions/text_style_ext.dart';

AlertDialog successAlert(BuildContext context,
    {String? msg,
    required String picklistNumber,
    String? countryCode,
    String? internalMemo,
    required VoidCallback onPop}) {
  Widget qrWidget() {
    return Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: QrImage(
            padding: EdgeInsets.zero,
            data: picklistNumber,
            version: QrVersions.auto));
  }

  return AlertDialog(
    title: Text(
      msg ?? "",
      textAlign: TextAlign.center,
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          internalMemo ?? "",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.s18.normal.black,
        ),
        Gap(8),
        qrWidget(),
        Gap(8),
        Text(
          countryCode ?? "",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.s20.semiBold.black,
        ),
      ],
    ),
    actions: <Widget>[
      TextButton(
        child: Text(AppLocalizations.of(context)!.ok.toUpperCase()),
        onPressed: () {
          Navigator.of(context).pop();
          onPop();
        },
      )
    ],
  );
}
