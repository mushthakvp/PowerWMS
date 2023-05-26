import 'package:flutter/material.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/repository/local_db/stock_mutation_item_db_provider.dart';
import 'package:scanner/repository/remote_db/stock_mutation_item_api_provider.dart';
import 'package:sembast/sembast.dart';

class ReservedListProvider extends ChangeNotifier {
  ReservedListProvider(Database db) {
    apiProvider = StockMutationItemApiProvider();
    dbProvider = StockMutationItemDbProvider(db);
  }

  late StockMutationItemDbProvider dbProvider;
  late StockMutationItemApiProvider apiProvider;
  List<StockMutationItem>? stocks;
  bool isLoading = false;

  Future<void> getMutationList(
      int picklistId,
      int picklistLineId,
  ) async {
    _showLoading();
    this.stocks = await apiProvider.getStockMutationItems(picklistId, picklistLineId);
    await dbProvider.saveCancelledItems(stocks ?? []);
    this.isLoading = false;
    notifyListeners();
  }

  Future<void> cancelledMutation(int id, PicklistLine line) async {
    await apiProvider.cancelStockMutationItem(id);
    this.stocks = await apiProvider.getStockMutationItems(line.picklistId, line.id);
    notifyListeners();
  }

  _showLoading() {
    this.isLoading = true;
    notifyListeners();
  }

  reset() {
    this.isLoading = false;
    stocks = null;
  }
}