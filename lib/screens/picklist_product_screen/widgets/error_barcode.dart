import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum BarcodeRequired {
  batchField, productionField, expirationField, serialNumber
}

extension BarcodeRequiredTitle on BarcodeRequired {
  String get title {
    switch (this) {
      case BarcodeRequired.batchField:
        return "Batch (10)";
      case BarcodeRequired.productionField:
        return "Production Date (11)";
      case BarcodeRequired.expirationField:
        return "Expiration Date (17)";
      case BarcodeRequired.serialNumber:
        return "Serial no. (21)";
      default:
        return "";
    }
  }
}

class ErrorBarcode {
  /// Show Option
  Future<void> showOption(BuildContext context, List<BarcodeRequired> barcodeRequired) async {
    showDialog<dynamic>(
        context: context,
        barrierColor: Colors.black.withOpacity(.4),
        barrierDismissible: true,
        builder: (BuildContext context) {
          _dialogContext = context;
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 32),
            elevation: 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(16),
                  child: Text(
                      "Barcode invalid",
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500)
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(23),
                  child: Column(
                    children: BarcodeRequired.values.map((code) {
                      return Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 16,
                              width: 16,
                              margin: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: barcodeRequired.contains(code) ? Colors.redAccent : Colors.green,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8)
                                )
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(code.title, style: TextStyle(fontSize: 18))
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, bottom: 6),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: hideOption,
                    child: Text(AppLocalizations.of(context)!
                        .close
                        .toUpperCase()),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  /// BuildContext
  BuildContext? _dialogContext;

  void hideOption() {
    if (_dialogContext != null) {
      if (Navigator.canPop(_dialogContext!)) {
        Navigator.pop(_dialogContext!);
      }
      _dialogContext = null;
    }
  }
}