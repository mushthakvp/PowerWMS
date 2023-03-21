import 'package:flutter/material.dart';
import 'package:scanner/models/stock_mutation.dart';

class StockMutationNeedToProcessProvider extends ChangeNotifier {
  List<StockMutation> stocks = [];
  bool _isPendingMutation = false;

  changePendingMutation({required bool isPending}) async{
    _isPendingMutation = isPending;
    await Future.delayed(Duration(milliseconds: 500),(){
      notifyListeners();
    });

  }

   bool get isPendingMutation => _isPendingMutation;

  addStock(StockMutation stock) {
    var index =
        this.stocks.indexWhere((element) => element.lineId == stock.lineId);
    if (index == -1) {
      // add
      this.stocks.add(stock);
    } else {
      // replace
      stocks[index] = stock;
    }
  }

  clearStocks() {
    this.stocks = [];
  }
}
