import 'dart:typed_data';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:scanner/api.dart';
import 'package:scanner/exceptions/domain_exception.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/widgets/barcode_input.dart';

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
                  FutureBuilder<Response<Uint8List>>(
                    future: getProductImage(line.product.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                      }
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Image.memory(
                            snapshot.data!.data!,
                            width: 120,
                          ),
                        );
                      }
                      return Container(width: 120);
                    },
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('To pick'),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '${mutation.pickAmount.round()}',
                            style: TextStyle(
                              fontSize: 50,
                              color: mutation.pickAmount < 0
                                  ? Colors.red
                                  : Colors.black54,
                            ),
                          ),
                        ),
                        Text('(${line.product.unit})'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            if (mutation.packaging != null) ..._packagingTile(mutation),
            ListTile(
              visualDensity: VisualDensity.compact,
              title: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text('ADD'), flex: 2),
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
              trailing: TextButton(
                child: Text('PROCESS'),
                onPressed: mutation.items.length > 0
                    ? () {
                        _onProcessHandler(mutation);
                      }
                    : null,
              ),
            ),
            Divider(height: 1),
            ...mutation.items.map((item) => Dismissible(
                  key: Key(item.batch),
                  onDismissed: (direction) {
                    setState(() {
                      mutation.removeItem(item);
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
                ))
          ]),
        );
      },
    );
  }

  _packagingTile(StockMutation mutation) {
    return [
      ListTile(
        visualDensity: VisualDensity.compact,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Warehouse location'),
                Text('H01-S01-V02'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Trade unit amount'),
                Text('${mutation.defaultAmount} BOXES'),
              ],
            ),
          ],
        ),
      ),
      Divider(height: 1),
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
        throw new DomainException('product.wrong_product');
      }
      final serial = barcode?.getAIData('21');
      final batch = barcode?.getAIData('10');
      final productionDate = barcode?.getAIData('11');
      final expirationDate = barcode?.getAIData('17');
      if (barcode != null &&
          serial &&
          mutation.items.any((item) => item.stickerCode == serial)) {
        throw new DomainException('product.already_scanned');
      }
      try {
        var item = mutation.items.firstWhere(
          (item) {
            return item.batch == batch &&
                item.productionDate == productionDate &&
                item.expirationDate == expirationDate &&
                item.stickerCode == serial;
          },
        );
        mutation.removeItem(item);
        mutation.addItem(StockMutationItem(
          productId: mutation.line.product.id,
          batch: batch,
          mutationAmount: amount + item.mutationAmount,
          productionDate: productionDate,
          expirationDate: expirationDate,
          stickerCode: serial,
        ));
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
      if (mutation.pickAmount <= 0 && mutation.allowBelowZero == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('product.want_to_process'),
            // content: const Text('AlertDialog description'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  mutation.allowBelowZero = false;
                  Navigator.pop(context, 'Cancel');
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  mutation.allowBelowZero = true;
                  _onProcessHandler(mutation);
                  Navigator.pop(context, 'OK');
                },
                child: const Text('OK'),
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
}
