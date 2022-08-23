import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scanner/barcode_parser/barcode_parser.dart';
import 'package:scanner/exceptions/domain_exception.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/providers/add_product_provider.dart';
import 'package:scanner/providers/mutation_provider.dart';
import 'package:scanner/widgets/barcode_input.dart';

final audio = Audio('assets/error.mp3');

class ScanForm extends StatelessWidget {
  const ScanForm(this.onParse, {Key? key}) : super(key: key);

  final void Function(bool proceed) onParse;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MutationProvider?>()!;
    final formKey = GlobalKey<FormState>();
    return ListTile(
      visualDensity: VisualDensity.compact,
      title: Column(
        children: [
          Container(
            width: double.infinity,
            child: Form(
              key: formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Selector<AddProductProvider, bool>(
                    selector: (_, p) => p.canAdd,
                    builder: (context, enable, _) {
                      return Flexible(
                        flex: 2,
                        child: ElevatedButton(
                          child: Text(
                            AppLocalizations.of(context)!.productAdd.toUpperCase(),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                enable ? Colors.blue : Colors.grey
                            ),
                          ),
                          onPressed: provider.needToScan() || !enable
                              ? null
                              : () {
                            formKey.currentState?.save();
                            context.read<AddProductProvider>().canAdd = false;
                          },
                        ),
                      );
                    },
                  ),
                  Flexible(
                    flex: 3,
                    child: BarcodeInput((value, barcode) {
                      if (!provider.needToScan() || value.length > 0) {
                        _parseHandler(context, provider, value, barcode);
                        context.read<AddProductProvider>().canAdd = false;
                      }
                    }, (String barcode) {
                      if (barcode.isEmpty) {
                        context.read<AddProductProvider>().canAdd = false;
                        return;
                      }
                      bool enableAddButton = provider.line.product.uid == barcode
                          || provider.line.product.ean == barcode;
                      context.read<AddProductProvider>().canAdd = enableAddButton;
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

  _parseHandler(
    BuildContext context,
    MutationProvider mutation,
    String ean,
    GS1Barcode? barcode,
  ) {
    final settings = context.read<ValueNotifier<Settings>>().value;
    try {
      if (ean != '' &&
          (mutation.line.product.ean != ean &&
              mutation.line.product.uid != ean &&
              mutation.packaging?.uid != ean)) {
        context.read<AddProductProvider>().canAdd = false;
        throw new DomainException(
          AppLocalizations.of(context)!.productWrongProduct,
        );
      }
      if (!mutation.shallAllowScan) {
        context.read<AddProductProvider>().canAdd = false;
        throw new DomainException(AppLocalizations.of(context)!.productCannotScan);
      }
      int amount;
      if (mutation.amount > 0) {
        // amount = mutation.amount;
        amount = _calculatePositiveAmount(mutation, ean, settings);
      } else {
        amount = _calculateAmount(mutation, ean, settings);
      }
      if (amount == 0) {
        throw new DomainException('Amount should be greater than 0');
      }
      final serial = barcode?.getAIData('21');
      final batch = barcode?.getAIData('10');
      // Production date
      final productionDateFormat = barcode?.getAIData('11') as DateTime?;
      String? productionDate;
      // Validate the prod date
      if (productionDateFormat != null) {
        productionDate = DateFormat('yyMMdd').format(productionDateFormat);
        if (productionDate.length != 6) {
          throw new DomainException(
            AppLocalizations.of(context)!.dateNotCorrect,
          );
        }
      }

      // Expired date
      final expirationDateFormat = barcode?.getAIData('17') as DateTime?;
      String? expirationDate;
      // Validate the expired date
      if (expirationDateFormat != null) {
        expirationDate = DateFormat('yyMMdd').format(expirationDateFormat);
        if (expirationDate.length != 6) {
          throw new DomainException(
            AppLocalizations.of(context)!.dateNotCorrect,
          );
        }
      }

      if (barcode != null &&
          serial != null &&
          mutation.idleItems.any((item) => item.stickerCode == serial)) {
        throw new DomainException(
          AppLocalizations.of(context)!.productAlreadyScanned,
        );
      }
      try {
        var item = mutation.idleItems.firstWhere((item) {
          return !mutation.needToScan() ||
              (item.batch == batch &&
                  item.productionDate == productionDate &&
                  item.expirationDate == expirationDate &&
                  item.stickerCode == serial);
        });
        mutation.replaceItem(
          item,
          StockMutationItem(
            id: item.id,
            productId: mutation.line.product.id,
            batch: batch ?? '',
            amount: amount + item.amount,
            productionDate: productionDate,
            expirationDate: expirationDate,
            stickerCode: serial,
            picklistLineId: mutation.line.id,
            picklistId: mutation.line.picklistId,
            warehouse: mutation.line.warehouse,
            warehouseCode: mutation.line.lineWarehouseCode
          ),
        );
      } catch (e) {
        mutation.addItem(StockMutationItem(
          productId: mutation.line.product.id,
          batch: batch ?? '',
          amount: amount,
          productionDate: productionDate,
          expirationDate: expirationDate,
          stickerCode: serial,
          picklistLineId: mutation.line.id,
            picklistId: mutation.line.picklistId,
            warehouse: mutation.line.warehouse,
            warehouseCode: mutation.line.lineWarehouseCode
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
        onParse(settings.directlyProcess && mutation.toPickAmount == 0);
      }
      if (settings.directlyProcess
          && mutation.isCancelRestProductAmount
          && mutation.cancelRestProductAmount != 0
          && mutation.showToPickAmount == 0
      ) {
        Navigator.of(context).pop();
      }
    } catch (e, stack) {
      AssetsAudioPlayer.newPlayer().open(audio, autoStart: true).then((value) {
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      print('$e\n$stack');
    }
  }

  int _calculateAmount(
    MutationProvider provider,
    String ean,
    Settings settings,
  ) {
    var amount = 0;
    if (provider.line.product.ean == ean || provider.line.product.uid == ean) {
      if (provider.isCancelRestProductAmount) {
        amount = provider.amount;
      } else {
        amount = provider.needToScan() || !settings.oneScanPickAll
            ? -1
            : provider.toPickAmount;
      }
    } else if (provider.packaging != null && provider.packaging!.uid == ean) {
      amount = provider.packaging!.defaultAmount.round();
    } else {
      amount = provider.amount;
    }
    return amount;
  }

  int _calculatePositiveAmount(
      MutationProvider provider,
      String ean,
      Settings settings,
  ) {
    int amount = 0;
    if (!provider.isCancelRestProductAmount) {
      amount = provider.needToScan() || !settings.oneScanPickAll
          ? 1
          : provider.toPickAmount;
    } else {
      amount = provider.amount;
    }
    return amount;
  }
}
