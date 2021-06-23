import 'dart:convert';
import 'dart:math';

import 'package:scanner/models/packaging.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockMutation {
  final PicklistLine line;
  final List<StockMutationItem> items;
  final Packaging? packaging;
  bool? allowBelowZero;

  static Future<StockMutation> fromMemory(
    PicklistLine line,
    List<StockMutationItem> items,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('${line.id}');
    if (json != null) {
      items.addAll((jsonDecode(json) as List<dynamic>)
          .map((json) => StockMutationItem.fromJson(json))
          .toList());
    }

    final mutation = StockMutation._(line, items);
    if (!mutation.needToScan()) {
      mutation.items.add(StockMutationItem(
        productId: mutation.line.product.id,
        amount: mutation.maxAmountToPick,
        batch: '',
        productionDate: '',
        expirationDate: '',
        stickerCode: '',
      ));
    }

    return mutation;
  }

  StockMutation._(this.line, this.items)
      : packaging = line.product.packagings.firstWhere(
            (packaging) => packaging.packagingUnitId == 1,
            orElse: null);

  Map<String, dynamic> toJson() => {
        'warehouseId': line.warehouseId,
        'picklistId': line.picklistId,
        'isBook': true,
        'items': items.map((item) => item.toJson()).toList(),
      };

  int get totalAmount {
    return items.fold<int>(0, (sum, item) => sum + item.amount);
  }

  int get maxAmountToPick {
    return (line.pickAmount - line.pickedAmount).round();
  }

  int get toPickAmount {
    return (line.pickAmount - line.pickedAmount).round();
  }

  int get askedAmount {
    return line.pickAmount.round();
  }

  int get toPickPackagingAmount {
    return packaging != null
        ? max((toPickAmount / packaging!.defaultAmount).floor(), 0)
        : 0;
  }

  int get askedPackagingAmount {
    return packaging != null
        ? max((askedAmount / packaging!.defaultAmount).floor(), 0)
        : 0;
  }

  needToScan() {
    return line.product.productGroupBatchField > 0 ||
        line.product.productGroupExpirationDateField > 0 ||
        line.product.productGroupProductionDateField > 0;
  }

  addItem(StockMutationItem value) {
    items.add(value);
    _cacheData();
  }

  removeItem(StockMutationItem value) {
    items.remove(value);
    _cacheData();
  }

  cancelItem(StockMutationItem value) {
    final index = items.indexOf(value);
    if (index != -1) {
      items.replaceRange(index, index + 1, [
        StockMutationItem(
          productId: value.productId,
          amount: value.amount,
          batch: value.batch,
          productionDate: value.productionDate,
          expirationDate: value.expirationDate,
          stickerCode: value.stickerCode,
          status: StockMutationItemStatus.Cancelled,
        ),
      ]);
      _cacheData();
    }
  }

  replaceItem(StockMutationItem oldValue, StockMutationItem newValue) {
    final index = items.indexOf(oldValue);
    if (index != -1) {
      items.replaceRange(index, index + 1, [newValue]);
    } else {
      items.add(newValue);
    }
  }

  clear() {
    items.clear();
    _cacheData();
  }

  _cacheData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      '${line.id}',
      jsonEncode(items.map((item) => item.toJson()).toList()),
    );
  }
}
