import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scanner/barcode_parser/barcode_parser.dart';
import 'package:scanner/exceptions/domain_exception.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/providers/add_product_provider.dart';
import 'package:scanner/screens/pick_list_overview/provider/mutation.dart';
import 'package:scanner/screens/picklist_product_screen/widgets/error_barcode.dart';
import 'package:scanner/screens/picklist_product_screen/widgets/scan_form.dart';

Future<void> parseHandler(
  BuildContext context,
  MutationProviderV2 mutation,
  String ean,
  GS1Barcode? barcode, {
  required Function(bool) onParse,
  bool? isThrowError = false,
}) async {
  print("_parseHandler");
  print(ean);
  final settings = context.read<ValueNotifier<Settings>>().value;
  try {
    if (ean != '' &&
        (mutation.line.product?.ean != ean &&
            mutation.line.product?.uid != ean &&
            mutation.packaging?.uid != ean)) {
      context.read<AddProductProvider>().canAdd = false;
      throw DomainException(
        AppLocalizations.of(context)!.productWrongProduct,
      );
    }
    if (!mutation.shallAllowScan) {
      context.read<AddProductProvider>().canAdd = false;
      throw new DomainException(
          AppLocalizations.of(context)!.productCannotScan);
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

    // Verify barcode
    var verifiesList = verifyBarcode(
      provider: mutation,
      batch: batch,
      productDate: productionDateFormat,
      expirationDate: expirationDateFormat,
      serialNo: serial,
    );
    if (verifiesList.isNotEmpty && barcode != null) {
      ErrorBarcode().showOption(context, verifiesList);
      AssetsAudioPlayer.newPlayer().open(audio, autoStart: true);
      return;
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
            productId: mutation.line.product?.id ?? 0,
            batch: batch ?? '',
            amount: amount + item.amount,
            productionDate: productionDate,
            expirationDate: expirationDate,
            stickerCode: serial,
            picklistLineId: mutation.line.id,
            picklistId: mutation.line.picklistId ?? 0,
            warehouse: mutation.line.warehouse,
            warehouseCode: mutation.line.lineWarehouseCode),
      );
    } catch (e) {
      mutation.addItem(StockMutationItem(
          productId: mutation.line.product?.id ?? 0,
          batch: batch ?? '',
          amount: amount,
          productionDate: productionDate,
          expirationDate: expirationDate,
          stickerCode: serial,
          picklistLineId: mutation.line.id,
          picklistId: mutation.line.picklistId ?? 0,
          warehouse: mutation.line.warehouse,
          warehouseCode: mutation.line.lineWarehouseCode));
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
      if (settings.directlyProcess &&
          mutation.isCancelRestProductAmount &&
          mutation.cancelRestProductAmount != 0) {
        onParse(true);
        return;
      }
      if (settings.directlyProcess &&
          mutation.isBackorderRestProductAmount &&
          mutation.backorderRestProductAmount != 0) {
        onParse(true);
        return;
      }
      onParse(settings.directlyProcess && mutation.toPickAmount == 0);
      return;
    }
    if (settings.directlyProcess &&
        mutation.isCancelRestProductAmount &&
        mutation.cancelRestProductAmount != 0 &&
        mutation.showToPickAmount == 0) {
      onParse(true);
    }
    if (settings.directlyProcess &&
        mutation.isBackorderRestProductAmount &&
        mutation.backorderRestProductAmount != 0 &&
        mutation.showToPickAmount == 0) {
      onParse(true);
    }
  } catch (e) {
    print("fsafsf");
    print(e);
    if (isThrowError == false) {
      await AssetsAudioPlayer.newPlayer()
          .open(audio, autoStart: true)
          .then((value) {
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(snackBar);
      });
    } else {
      print("isThrowError");
      print("isThrowError1");
      throw e;
    }
  }
}

int _calculateAmount(
  MutationProviderV2 provider,
  String ean,
  Settings settings,
) {
  var amount = 0;
  var oneScanPickAll = settings.oneScanPickAll;
  if (provider.backorderRestProductAmount != 0) {
    amount = provider.needToScan() || !oneScanPickAll
        ? 1
        : (provider.toPickAmount - provider.backorderRestProductAmount);
    // packaging case
    if (provider.packaging != null && provider.packaging!.uid == ean) {
      if (!oneScanPickAll) {
        amount = provider.packaging!.defaultAmount!.round();
      }
    }
    return amount;
  }
  if (provider.line.product!.ean == ean || provider.line.product!.uid == ean) {
    if (provider.isCancelRestProductAmount) {
      amount = provider.amount;
    } else {
      amount =
          provider.needToScan() || !oneScanPickAll ? -1 : provider.toPickAmount;
    }
  } else if (provider.packaging != null && provider.packaging!.uid == ean) {
    amount = provider.packaging!.defaultAmount!.round();
  } else {
    amount = provider.amount;
  }
  return amount;
}

int _calculatePositiveAmount(
  MutationProviderV2 provider,
  String ean,
  Settings settings,
) {
  int amount = 0;
  var oneScanPickAll = settings.oneScanPickAll;
  if (provider.backorderRestProductAmount != 0) {
    amount = provider.needToScan() || !oneScanPickAll
        ? 1
        : (provider.toPickAmount - provider.backorderRestProductAmount);
    // packaging case
    if (provider.packaging != null && provider.packaging!.uid == ean) {
      if (!oneScanPickAll) {
        amount = provider.packaging!.defaultAmount!.round();
      }
    }
    return amount;
  }
  if (!provider.isCancelRestProductAmount) {
    amount =
        provider.needToScan() || !oneScanPickAll ? 1 : provider.toPickAmount;
    // packaging case
    if (provider.packaging != null && provider.packaging!.uid == ean) {
      if (!oneScanPickAll) {
        amount = provider.packaging!.defaultAmount!.round();
      }
    }
  } else {
    amount = provider.amount;
  }
  return amount;
}

List<BarcodeRequired> verifyBarcode({
  required MutationProviderV2 provider,
  required String? batch, // code 10
  required DateTime? productDate, // code 11,
  required DateTime? expirationDate, // code 17,
  required String? serialNo, // code 21,
}) {
  var product = provider.line.product;
  List<BarcodeRequired> re = [];
  if (product!.batchField == 1 && batch == null) {
    re.add(BarcodeRequired.batchField);
  }
  if (product.expirationDateField == 1 && expirationDate == null) {
    re.add(BarcodeRequired.expirationField);
  }
  if (product.productionDateField == 1 && productDate == null) {
    re.add(BarcodeRequired.productionField);
  }
  if (product.serialNumberField == true && serialNo == null) {
    re.add(BarcodeRequired.serialNumber);
  }
  return re;
}
