import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/providers/stockmutation_needto_process_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension PicklistLineColor on PicklistLine {
  List<StockMutationItem> _getIdleAmount(
      SharedPreferences? prefs, PicklistLine line) {
    final json = prefs?.getString('${line.id}');
    if (json != null) {
      final res = (jsonDecode(json) as List<dynamic>)
          .map((json) => StockMutationItem.fromJson(json))
          .toList();
      return res;
    } else {
      return [];
    }
  }

  int? getBackorderCancelProductAmount(
      SharedPreferences? prefs, PicklistLine line) {
    final cKey = '${line.id}_${line.product.id}';
    int? cAmount = prefs?.getInt(cKey);
    final bKey = '${line.id}_${line.product.id}_backorder';
    int? bAmount = prefs?.getInt(bKey);
    return cAmount ?? bAmount;
  }

  // 0 - none background
  // 1 - grey
  // 2 - yellow
  // 3 - blue
  int getPriority(
    BuildContext context,
    SharedPreferences? prefs,
    bool isCurrentWarehouse,
  ) {
    // if (!isCurrentWarehouse) {
    //   return 1;
    // }

    // case 2: pickAmount = the amount of process product
    List<StockMutationItem> idleList = _getIdleAmount(prefs, this);
    if (idleList.length > 0) {
      context
          .read<StockMutationNeedToProcessProvider>()
          .changePendingMutation(isPending: true);
    } else {
      context
          .read<StockMutationNeedToProcessProvider>()
          .changePendingMutation(isPending: false);
    }

    // case 1: the pickAmount == pickedAmount
    if (this.isFullyPicked()) {
      return 3;
    }
    if (idleList.isNotEmpty) {
      if (this.pickAmount >= 0 &&
          this.pickAmount <=
              idleList.map((e) => e.amount).toList().fold(0, (p, c) => p + c)) {
        return 3;
      }
    }
    if (idleList.isNotEmpty) {
      context
          .read<StockMutationNeedToProcessProvider>()
          .addStock(StockMutation(warehouseId, picklistId, id, true, idleList));
    }
    // case 3: pickAmount = the amount of process product + picked amount + cancelled amount
    int? cancelBackorderProductAmount =
        getBackorderCancelProductAmount(prefs, this);
    if (cancelBackorderProductAmount != null) {
      if (idleList.isNotEmpty) {
        if (cancelBackorderProductAmount +
                this.pickedAmount +
                (idleList
                    .map((e) => e.amount)
                    .toList()
                    .fold(0, (p, c) => p + c)) ==
            this.pickAmount) {
          return 2;
        }
      } else {
        if (cancelBackorderProductAmount + this.pickedAmount ==
            this.pickAmount) {
          return 2;
        }
      }
    }
    return 0;
  }
}
