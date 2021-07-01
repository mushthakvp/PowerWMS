import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scanner/barcode_parser/barcode_parser.dart';
import 'package:scanner/exceptions/domain_exception.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/screens/products_screen/widgets/amount.dart';
import 'package:scanner/widgets/barcode_input.dart';

final audio = Audio('assets/error.mp3');

class ScanForm extends StatelessWidget {
  const ScanForm(this.mutation, this.onParse, this._amount, this.onChange,
      {Key? key})
      : super(key: key);

  final StockMutation mutation;
  final void Function(bool proceed) onParse;
  final int _amount;
  final void Function(int amount) onChange;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return ListTile(
      visualDensity: VisualDensity.compact,
      title: Column(
        children: [
          if (!mutation.needToScan())
            ..._amountInput(
              mutation.line.product.unit,
              onChange,
              context,
            ),
          Container(
            width: double.infinity,
            child: Form(
              key: formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: ElevatedButton(
                        child: Text(
                          AppLocalizations.of(context)!
                              .productAdd
                              .toUpperCase(),
                        ),
                        onPressed: mutation.needToScan()
                            ? null
                            : () {
                                formKey.currentState?.save();
                              },
                      ),
                      flex: 2),
                  Flexible(
                    flex: 3,
                    child: BarcodeInput((value, barcode) {
                      _parseHandler(mutation, value, barcode, context);
                      onChange(mutation.toPickAmount);
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _amountInput(
    String unit,
    void Function(int value) onChange,
    BuildContext context,
  ) {
    return [
      ListTile(
        visualDensity: VisualDensity.compact,
        title: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.productAmountPicked(unit),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Amount(
              _amount,
              onChange,
            ),
          ],
        ),
      ),
      Divider(height: 1),
    ];
  }

  _parseHandler(StockMutation mutation, String ean, GS1Barcode? barcode,
      BuildContext context) {
    final settings = context.read<ValueNotifier<Settings>>().value;
    try {
      int amount = _calculateAmount(mutation, ean, settings, context);
      final serial = barcode?.getAIData('21');
      final batch = barcode?.getAIData('10');
      final productionDate = barcode?.getAIData('11');
      final expirationDate = barcode?.getAIData('17');
      if (barcode != null &&
          serial &&
          mutation.items.any((item) => item.stickerCode == serial)) {
        throw new DomainException(
          AppLocalizations.of(context)!.productAlreadyScanned,
        );
      }
      try {
        var item = mutation.items.firstWhere((item) {
          return !mutation.needToScan() ||
              (item.batch == batch &&
                  item.productionDate == productionDate &&
                  item.expirationDate == expirationDate &&
                  item.stickerCode == serial);
        });
        mutation.replaceItem(
          item,
          StockMutationItem(
            productId: mutation.line.product.id,
            batch: batch ?? '',
            amount: amount + item.amount,
            productionDate: productionDate,
            expirationDate: expirationDate,
            stickerCode: serial,
          ),
        );
      } catch (e, stack) {
        print(e);
        print(stack);
        mutation.addItem(StockMutationItem(
          productId: mutation.line.product.id,
          batch: batch ?? '',
          amount: amount,
          productionDate: productionDate,
          expirationDate: expirationDate,
          stickerCode: serial,
        ));
      }
      if (mutation.maxAmountToPick <= mutation.totalAmount &&
          mutation.allowBelowZero == null &&
          !settings.directlyProcess) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.productWantToProcess,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  mutation.allowBelowZero = false;
                  Navigator.pop(context, false);
                },
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton(
                onPressed: () {
                  mutation.allowBelowZero = true;
                  Navigator.pop(context, true);
                },
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          ),
        ).then((result) => onParse(result));
      } else {
        onParse(false);
      }
    } catch (e, stack) {
      AssetsAudioPlayer.newPlayer().open(audio, autoStart: true).then((value) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      print(stack);
    }
  }

  int _calculateAmount(
    StockMutation mutation,
    String ean,
    Settings settings,
    BuildContext context,
  ) {
    var amount = 0;
    if (mutation.line.product.ean == ean) {
      amount = mutation.needToScan() || !settings.oneScanPickAll
          ? 1
          : mutation.toPickAmount;
    } else if (mutation.packaging != null && mutation.packaging!.uid == ean) {
      amount = mutation.packaging!.defaultAmount.round();
    } else if (_amount > 0) {
      amount = _amount;
    } else {
      throw new DomainException(
        AppLocalizations.of(context)!.productWrongProduct,
      );
    }
    return amount;
  }
}
