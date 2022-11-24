import 'dart:async';

import 'package:scanner/models/cancelled_stock_mutation_item.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/resources/stock_mutation_db_provider.dart';
import 'package:scanner/resources/stock_mutation_item_db_provider.dart';
import 'package:sembast/sembast.dart';

class PicklistLineDbProvider {
  static const name = 'picklist_lines';

  PicklistLineDbProvider(this.db) {
    intMapStoreFactory
        .store(StockMutationDbProvider.name)
        .addOnChangesListener(db, (transaction, changes) async {
      for (var change in changes) {
        if (change.isAdd) {
          final mutation = StockMutation.fromJson(change.newValue!);
          final record = _store.record(mutation.lineId);
          final line = await record.get(transaction);
          if (line != null) {
            final amount = (line['pickedAmount'] as num) +
                mutation.items.fold(0, (result, item) => result + item.amount);
            await record.update(
              transaction,
              {
                'pickedAmount': amount,
                'status': amount >= (line['pickAmount'] as num)
                    ? PicklistLineStatus.picked.name
                    : line['status'],
              },
            );
          }
        }
      }
    });
    intMapStoreFactory
        .store(StockMutationItemDbProvider.cancelledName)
        .addOnChangesListener(db, (transaction, changes) async {
      for (var change in changes) {
        if (change.isAdd) {
          final item = CancelledStockMutationItem.fromJson(change.newValue!);
          final finder =
              Finder(filter: Filter.equals('product.id', item.productId));
          final line =
              (await _store.findFirst(transaction, finder: finder))?.value;
          if (line != null) {
            await _store.record(line['id'] as int).update(
              transaction,
              {'pickedAmount': (line['pickedAmount'] as num) - item.amount},
            );
          }
        }
      }
    });
  }

  final _store = intMapStoreFactory.store(name);
  final Database db;

  Stream<List<PicklistLine>> getPicklistLinesStream(int picklistId) {
    var finder = Finder(filter: Filter.equals('picklistId', picklistId));
    return _store.query(finder: finder).onSnapshots(db).transform(
        StreamTransformer.fromHandlers(handleData: (snapshotList, sink) {
      sink.add(
        snapshotList
            .map((snapshot) => PicklistLine.fromJson(snapshot.value))
            .toList(),
      );
    }));
  }

  Future<PicklistLine> updatePicklistLinePickedAmount(PicklistLine line, StockMutationItem item) async {
    var finder = Finder(filter: Filter.equals('picklistId', line.picklistId));
    final list = await _store.query(finder: finder).getSnapshots(db).then((snapshotList) => {
      snapshotList.map((snapshot) => PicklistLine.fromJson(snapshot.value)).toList()
    });

    var picklistLine = list.first.firstWhere((element) => element.product.id == item.productId);
    await _store.record(picklistLine.id).update(db,
      {'pickedAmount': (picklistLine.pickedAmount + item.amount)},
    );
    var result = picklistLine.copyWith(pickedAmount: (picklistLine.pickedAmount + item.amount));
    return result;
  }

  Future<dynamic> savePicklistLine(PicklistLine line) {
    return _store.record(line.id).put(db, line.toJson());
  }

  Future<dynamic> savePicklistLines(List<PicklistLine> lines) {
    print(lines.map<int>((line) => line.id));
    return _store
        .records(lines.map<int>((line) => line.id))
        .put(db, lines.map((line) => line.toJson()).toList());
  }

  Future<int> count(int picklistId) {
    return _store.count(db, filter: Filter.equals('picklistId', picklistId));
  }

  Future<dynamic> clear(int? picklistId) {
    if (picklistId != null) {
      final finder = Finder(filter: Filter.equals('picklistId', picklistId));
      return _store.delete(db, finder: finder);
    } else {
      return _store.drop(db);
    }
  }
}
