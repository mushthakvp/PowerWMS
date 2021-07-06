import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:scanner/models/packaging.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockMutation extends ChangeNotifier {
  final PicklistLine line;
  final List<StockMutationItem> items;
  final Packaging? packaging;
  bool? allowBelowZero;
  int amount = 0;

  static Future<StockMutation> fromMemory(PicklistLine line) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('${line.id}');
    List<StockMutationItem> items = [];
    if (json != null) {
      items = (jsonDecode(json) as List<dynamic>)
          .map((json) => StockMutationItem.fromJson(json))
          .toList();
    }
    final mutation = StockMutation._(line, items);
    mutation.amount = mutation.toPickAmount;

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
    return (line.pickAmount - line.pickedAmount).round() - totalAmount;
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
    return line.product.productGroupBatchField > 0;
  }

  addItem(StockMutationItem value) {
    items.add(value);
    amount = toPickAmount;
    _cacheData();
    notifyListeners();
  }

  removeItem(StockMutationItem value) {
    items.remove(value);
    amount = toPickAmount;
    _cacheData();
    notifyListeners();
  }

  replaceItem(StockMutationItem oldValue, StockMutationItem newValue) {
    final index = items.indexOf(oldValue);
    if (index != -1) {
      items.replaceRange(index, index + 1, [newValue]);
    } else {
      items.add(newValue);
    }
    amount = toPickAmount;
    _cacheData();
    notifyListeners();
  }

  clear() {
    items.clear();
    amount = toPickAmount;
    _cacheData();
    notifyListeners();
  }

  changeLinePickedAmount(int value) {
    line.pickedAmount += value;
    amount = toPickAmount;
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
      jsonEncode(items.map((item) => item.toJson()).toList()),
    );
  }
}
