import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:provider/provider.dart';
import 'package:scanner/api.dart';
import 'package:scanner/exceptions/domain_exception.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/screens/products_screen/widgets/amount.dart';
import 'package:scanner/widgets/barcode_input.dart';
import 'package:scanner/widgets/product_image.dart';

final audio = Audio('assets/error.mp3');

class ProductView extends StatefulWidget {
  final PicklistLine _line;

  const ProductView(this._line, {Key? key}) : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  Future<StockMutation>? _mutationFuture;

  @override
  void initState() {
    _mutationFuture = StockMutation.fromMemory(widget._line);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final line = widget._line;
    return FutureBuilder<StockMutation>(
      future: _mutationFuture!,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return SliverFillRemaining();
        }
        if (!snapshot.hasData) {
          return SliverFillRemaining();
        }
        final mutation = snapshot.data!;
        return SliverList(
          delegate: SliverChildListDelegate([
            ListTile(
              title: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.productProductNumber}:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(mutation.line.product.uid),
                      SizedBox(height: 10),
                      const Text(
                        'GTIN / EAN:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(mutation.line.product.ean),
                    ],
                  ),
                  Spacer(),
                  // SizedBox(width: 20),
                  ProductImage(line.product.id, width: 120),
                ],
              ),
            ),
            Divider(height: 1),
            ..._pickTile(mutation),
            ListTile(
              visualDensity: VisualDensity.compact,
              title: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Text(AppLocalizations.of(context)!
                            .productAdd
                            .toUpperCase()),
                        flex: 2),
                    Flexible(
                      flex: 3,
                      child: BarcodeInput((value, barcode) {
                        _parseHandler(mutation, value, barcode);
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1),
            ListTile(
              visualDensity: VisualDensity.compact,
              trailing: ElevatedButton(
                child: Text(
                    AppLocalizations.of(context)!.productProcess.toUpperCase()),
                onPressed: mutation.items.length > 0
                    ? () {
                        _onProcessHandler(mutation);
                      }
                    : null,
              ),
            ),
            Divider(height: 1),
            if (mutation.needToScan())
              ..._itemsBuilder(
                mutation.items,
                (item) => mutation.removeItem(item),
              ),
          ]),
        );
      },
    );
  }

  _pickTile(StockMutation mutation) {
    return [
      ListTile(
        visualDensity: VisualDensity.compact,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!
                      .productAmountAsked(mutation.line.product.unit),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '${mutation.askedAmount}',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!
                      .productAmountBoxes(mutation.askedPackagingAmount)
                      .toUpperCase(),
                ),
              ],
            ),
            SizedBox(width: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!
                      .productAmountToPick(mutation.line.product.unit),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '${mutation.toPickAmount}',
                    style: TextStyle(
                      fontSize: 50,
                      color: mutation.toPickAmount < 0
                          ? Colors.red
                          : Colors.black54,
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!
                      .productAmountBoxes(mutation.toPickPackagingAmount)
                      .toUpperCase(),
                ),
              ],
            ),
          ],
        ),
      ),
      Divider(height: 1),
      if (!mutation.needToScan())
        ..._amountInput(
          mutation.line.product.unit,
          mutation.items.first.mutationAmount.toString(),
          (amount) {
            var first = mutation.items.first;
            setState(() {
              mutation.replaceItem(
                  first,
                  StockMutationItem(
                    productId: mutation.line.product.id,
                    batch: first.batch,
                    mutationAmount: int.parse(amount),
                    productionDate: first.productionDate,
                    expirationDate: first.expirationDate,
                    stickerCode: first.stickerCode,
                  ));
            });
          },
        ),
    ];
  }

  _parseHandler(StockMutation mutation, String ean, GS1Barcode? barcode) {
    try {
      var amount = 0;
      if (mutation.line.product.ean == ean) {
        amount = 1;
      } else if (mutation.packaging != null && mutation.packaging!.uid == ean) {
        amount = mutation.packaging!.defaultAmount.round();
      } else {
        throw new DomainException(
          AppLocalizations.of(context)!.productWrongProduct,
        );
      }
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
        var item = mutation.items.firstWhere(
          (item) {
            return !mutation.needToScan() ||
                (item.batch == batch &&
                    item.productionDate == productionDate &&
                    item.expirationDate == expirationDate &&
                    item.stickerCode == serial);
          },
        );
        final settings = context.read<ValueNotifier<Settings>>().value;
        mutation.replaceItem(
          item,
          StockMutationItem(
            productId: mutation.line.product.id,
            batch: batch,
            mutationAmount: !mutation.needToScan() && settings.oneScanPickAll
                ? mutation.toPickAmount
                : amount + item.mutationAmount,
            productionDate: productionDate,
            expirationDate: expirationDate,
            stickerCode: serial,
          ),
        );
      } catch (e) {
        mutation.addItem(StockMutationItem(
          productId: mutation.line.product.id,
          batch: batch,
          mutationAmount: amount,
          productionDate: productionDate,
          expirationDate: expirationDate,
          stickerCode: serial,
        ));
      } finally {
        setState(() {});
      }
      if (mutation.toPickAmount <= 0 && mutation.allowBelowZero == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.productWantToProcess,
            ),
            // content: const Text('AlertDialog description'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  mutation.allowBelowZero = false;
                  Navigator.pop(context, 'Cancel');
                },
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton(
                onPressed: () {
                  mutation.allowBelowZero = true;
                  _onProcessHandler(mutation);
                  Navigator.pop(context, 'OK');
                },
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      AssetsAudioPlayer.newPlayer().open(audio, autoStart: true).then((value) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  _onProcessHandler(StockMutation mutation) {
    addStockMutation(mutation).then((response) {
      if (response.data != null) {
        final snackBar = SnackBar(
          backgroundColor:
              response.data!['success'] as bool ? Colors.green : Colors.red,
          content: Text(response.data!['message']),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        if (response.data!['success']) {
          mutation.clear();
          Navigator.of(context).pop();
        }
      }
    });
  }

  _amountInput(
      String unit, String value, void Function(String value) onChange) {
    return [
      ListTile(
        visualDensity: VisualDensity.compact,
        title: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.productAmountPicked(unit),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Amount(value, onChange),
          ],
        ),
      ),
      Divider(height: 1),
    ];
  }

  _itemsBuilder(List<StockMutationItem> items,
      void Function(StockMutationItem item) onRemove) {
    return items.map((item) => Dismissible(
          key: Key(item.batch),
          onDismissed: (direction) {
            setState(() {
              onRemove(item);
            });
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  '${item.mutationAmount} x ${item.batch} | ${item.stickerCode}',
                ),
              ),
              Divider(height: 1),
            ],
          ),
        ));
  }
}
