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

class ScanForm extends StatefulWidget {
  const ScanForm(this.onParse, {Key? key}) : super(key: key);

  final void Function(bool proceed) onParse;

  @override
  _ScanFormState createState() => _ScanFormState();
}

class _ScanFormState extends State<ScanForm> {
  int? _amount;

  @override
  void didChangeDependencies() {
    if (_amount == null) {
      Provider.of<StockMutation>(context).context.watch<StockMutation>();
    }
    _amount = widget.mutation.toPickAmount;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final mutation = widget.mutation;
    final formKey = GlobalKey<FormState>();
    return ListTile(
      visualDensity: VisualDensity.compact,
      title: Column(
        children: [
          if (!mutation.needToScan())
            ..._amountInput(
              mutation.line.product.unit,
              (amount) {
                setState(() {
                  _amount = int.tryParse(amount) ?? _amount;
                });
              },
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
                      _parseHandler(mutation, value, barcode);
                      setState(() {
                        _amount = widget.mutation.toPickAmount;
                      });
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
    void Function(String value) onChange,
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
              (value) {
                setState(() {
                  _amount = value;
                });
              },
            ),
          ],
        ),
      ),
      Divider(height: 1),
    ];
  }

  _parseHandler(StockMutation mutation, String ean, GS1Barcode? barcode) {
    final settings = context.read<ValueNotifier<Settings>>().value;
    try {
      int amount = _calculateAmount(mutation, ean, settings);
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
        ).then((result) => widget.onParse(result));
      } else {
        widget.onParse(false);
      }
    } catch (e, stack) {
      AssetsAudioPlayer.newPlayer().open(audio, autoStart: true).then((value) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      print(stack);
    }
  }

  int _calculateAmount(StockMutation mutation, String ean, Settings settings) {
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
