import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scanner/models/cancelled_stock_mutation_item.dart';
import 'package:scanner/models/packaging.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CacheProductStatus { set, get, remove }

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
  ) {
    handleProductCancelAmount(CacheProductStatus.get);
    handleProductBackorderAmount(CacheProductStatus.get);
  }

  final PicklistLine line;
  final List<StockMutationItem> idleItems;
  final List<CancelledStockMutationItem> cancelledItems;
  final List<StockMutation> queuedMutations;
  final Packaging? packaging;
  bool? allowBelowZero;
  int amount = 0;

  // the status of cancel rest of product amount checkbox
  bool isCancelRestProductAmount = true;

  // the cancel product amount
  int cancelRestProductAmount = 0;

  bool get showCancelRestProductAmount {
    return isCancelRestProductAmount && cancelRestProductAmount != 0;
  }

  // the status of backorder rest of product amount checkbox
  bool isBackorderRestProductAmount = true;

  // the cancel product amount
  int backorderRestProductAmount = 0;

  bool get showBackorderProductAmount {
    return isBackorderRestProductAmount && backorderRestProductAmount != 0;
  }

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

  int get showToPickAmount {
    if (this.isCancelRestProductAmount) {
      return toPickAmount - cancelRestProductAmount;
    } else if (this.isBackorderRestProductAmount) {
      return toPickAmount - backorderRestProductAmount;
    } else {
      return amount;
    }
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

  bool get shallAllowScan {
    // When item is not yet processed
    if (askedAmount >= 0 &&
        askedAmount <=
            idleItems.map((e) => e.amount).toList().fold(0, (p, c) => p + c)) {
      return false;
      // When item was processed
    } else if (askedAmount >= 0 && askedAmount <= totalPickedAmount) {
      return false;
      // When total picked amount (ready for process || processed)
      // == asked amount
    } else if (totalPickedAmount +
            idleItems.map((e) => e.amount).toList().fold(0, (p, c) => p + c) ==
        askedAmount) {
      return false;
    }
    return true;
  }

  needToScan() {
    return line.product.serialNumberField != null &&
        line.product.serialNumberField == true;
  }

  addItem(StockMutationItem value) {
    idleItems.add(value);
    amount = toPickAmount;
    _cacheData();
    notifyListeners();
  }

  removeItem(StockMutationItem value) {
    idleItems.remove(value);
    if (this.isCancelRestProductAmount) {
      amount = toPickAmount - cancelRestProductAmount;
    } else if (this.isBackorderRestProductAmount) {
      amount = toPickAmount - backorderRestProductAmount;
    } else {
      amount = toPickAmount;
    }
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

  changeAmount(int value, bool isCancel) {
    if (!isCancel) {
      this.isCancelRestProductAmount = false;
      this.cancelRestProductAmount = 0;
      notifyListeners();
      return;
    }
    this.amount = value;
    this.cancelRestProductAmount = max<int>(0, toPickAmount - amount);
    this.isCancelRestProductAmount = true;
    // In case picked amount is a negative number
    // Then, cancel amount doesn't effected
    if (askedAmount < 0) {
      this.cancelRestProductAmount = toPickAmount - amount;
    }
    notifyListeners();
  }

  changeBackorderAmount(int value, bool isBackorder) {
    if (!isBackorder) {
      this.backorderRestProductAmount = 0;
      this.isBackorderRestProductAmount = false;
      notifyListeners();
    }
    this.amount = value;
    this.backorderRestProductAmount = max<int>(0, toPickAmount - amount);
    this.isBackorderRestProductAmount = true;
    if (askedAmount < 0) {
      this.backorderRestProductAmount = toPickAmount - amount;
    }
    notifyListeners();
  }

  handleProductCancelAmount(CacheProductStatus status) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${line.id}_${line.product.id}';
    switch (status) {
      case CacheProductStatus.set:
        prefs.setInt(key, this.cancelRestProductAmount);
        break;
      case CacheProductStatus.get:
        int? count = prefs.getInt(key);
        if (count != null) {
          this.cancelRestProductAmount = count;
          this.amount -= count;
          this.isCancelRestProductAmount = count != 0;
        } else {
          this.isCancelRestProductAmount = false;
        }
        notifyListeners();
        break;
      case CacheProductStatus.remove:
        prefs.remove(key);
        this.isCancelRestProductAmount = false;
        this.cancelRestProductAmount = 0;
        notifyListeners();
        break;
    }
  }

  handleProductBackorderAmount(CacheProductStatus status) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${line.id}_${line.product.id}_backorder';
    switch (status) {
      case CacheProductStatus.set:
        prefs.setInt(key, this.backorderRestProductAmount);
        break;
      case CacheProductStatus.get:
        int? count = prefs.getInt(key);
        if (count != null) {
          this.backorderRestProductAmount = count;
          this.amount -= count;
          this.isBackorderRestProductAmount = count != 0;
        } else {
          this.isBackorderRestProductAmount = false;
        }
        notifyListeners();
        break;
      case CacheProductStatus.remove:
        prefs.remove(key);
        this.isBackorderRestProductAmount = false;
        this.backorderRestProductAmount = 0;
        notifyListeners();
        break;
    }
  }

  _cacheData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      '${line.id}',
      jsonEncode(idleItems.map((item) => item.toJson()).toList()),
    );
  }
}
