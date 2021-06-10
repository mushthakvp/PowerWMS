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

  static Future<StockMutation> fromMemory(PicklistLine line) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('${line.id}');
    List<StockMutationItem> items = [];
    if (json != null) {
      items = (jsonDecode(json) as List<dynamic>)
          .map((json) => StockMutationItem.fromJson(json))
          .toList();
    }

    return StockMutation._(line, items);
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

  int get pickedAmount {
    return items.fold<int>(0, (sum, item) => sum + item.mutationAmount);
  }

  num get pickAmount {
    return line.pickAmount - line.pickedAmount - pickedAmount;
  }

  int get defaultAmount {
    return packaging != null ? max((pickAmount / packaging!.defaultAmount).floor(), 0) : 0;
  }

  addItem(StockMutationItem value) {
    items.add(value);
    _cacheData();
  }

  removeItem(StockMutationItem value) {
    items.remove(value);
    _cacheData();
  }

  clear() {
    items.clear();
    _cacheData();
  }

  _cacheData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('${line.id}', jsonEncode(items.map((item) => item.toJson()).toList()));
  }
}
