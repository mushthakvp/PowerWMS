import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scanner/models/cancelled_stock_mutation_item.dart';
import 'package:scanner/models/packaging.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MutationProvider extends ChangeNotifier {
  factory MutationProvider.create(
    PicklistLine line,
    List<StockMutationItem> idleItems,
    List<CancelledStockMutationItem> cancelledItems,
    List<StockMutation> queuedMutations,
  ) {
    Packaging? packaging;
    try {
      packaging = line.product.packagings
          .firstWhere((packaging) => packaging.packagingUnitId == 1);
    } catch (e) {}
    final provider = MutationProvider._(
      line,
      idleItems,
      cancelledItems,
      queuedMutations,
      packaging,
    );
    provider.amount = provider.toPickAmount;

    return provider;
  }

  MutationProvider._(
    this.line,
    this.idleItems,
    this.cancelledItems,
    this.queuedMutations,
    this.packaging,
  );

  final PicklistLine line;
  final List<StockMutationItem> idleItems;
  final List<CancelledStockMutationItem> cancelledItems;
  final List<StockMutation> queuedMutations;
  final Packaging? packaging;
  bool? allowBelowZero;
  int amount = 0;

  getStockMutation() => StockMutation(
        line.warehouseId,
        line.picklistId,
        line.id,
        true,
        idleItems,
      );

  int get totalAmount {
    return idleItems.fold<int>(0, (sum, item) => sum + item.amount);
  }

  int get totalPickedAmount {
    return line.pickedAmount.round();
  }

  int get maxAmountToPick {
    return (line.pickAmount - totalPickedAmount).round();
  }

  int get toPickAmount {
    return (line.pickAmount - totalPickedAmount).round() - totalAmount;
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
    return line.product.productGroupBatchField != null &&
        line.product.productGroupBatchField! > 0;
  }

  addItem(StockMutationItem value) {
    idleItems.add(value);
    amount = toPickAmount;
    _cacheData();
    notifyListeners();
  }

  removeItem(StockMutationItem value) {
    idleItems.remove(value);
    amount = toPickAmount;
    _cacheData();
    notifyListeners();
  }

  replaceItem(StockMutationItem oldValue, StockMutationItem newValue) {
    final index = idleItems.indexOf(oldValue);
    if (index != -1) {
      idleItems.replaceRange(index, index + 1, [newValue]);
    } else {
      idleItems.add(newValue);
    }
    amount = toPickAmount;
    _cacheData();
    notifyListeners();
  }

  clear() {
    idleItems.clear();
    amount = toPickAmount;
    _cacheData();
    notifyListeners();
  }

  changeAmount(int value) {
    amount = value;
    notifyListeners();
  }

  _cacheData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      '${line.id}',
      jsonEncode(idleItems.map((item) => item.toJson()).toList()),
    );
  }
}
