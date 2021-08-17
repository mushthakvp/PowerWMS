import 'dart:async';

import 'package:scanner/models/cancelled_stock_mutation_item.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:sembast/sembast.dart';

class StockMutationItemDbProvider {
  static const name = 'stock_mutation_items';
  static const cancelledName = 'cancelled_stock_mutation_items';

  StockMutationItemDbProvider(this.db);

  final _store = intMapStoreFactory.store(name);
  final _cancelledStore = intMapStoreFactory.store(cancelledName);
  final Database db;

  Stream<List<StockMutationItem>> getStockMutationItems(int productId) {
    var finder = Finder(
      filter: Filter.and([
        Filter.equals('productId', productId),
      ]),
    );
    return _store.query(finder: finder).onSnapshots(db).transform(
      StreamTransformer<List<RecordSnapshot<int, Map<String, Object?>>>,
          List<StockMutationItem>>.fromHandlers(
        handleData: (snapshotList, sink) {
          sink.add(
            snapshotList
                .map((snapshot) => StockMutationItem.fromJson(snapshot.value))
                .toList(),
          );
        },
      ),
    );
  }

  Future<dynamic> saveCancelledItems(List<StockMutationItem> list) {
    return _store
        .records(list.map((item) => item.id!))
        .put(db, list.map((item) => item.toJson()).toList());
  }

  Future<int> countStockMutationItems(int productId) {
    final filter = Filter.and([
      Filter.equals('productId', productId),
      Filter.notNull('status'),
    ]);
    return _store.count(db, filter: filter);
  }

  Future<dynamic> queueItemForCancel(StockMutationItem item) {
    assert(item.id != null);
    final cancelled = CancelledStockMutationItem.fromItem(item);
    return _cancelledStore.record(item.id!).put(db, cancelled.toJson());
  }

  Stream<List<CancelledStockMutationItem>> getCancelledStockMutationItemsStream(
    int productId,
  ) {
    var finder = Finder(filter: Filter.equals('productId', productId));
    return _store.query(finder: finder).onSnapshots(db).transform(
      StreamTransformer.fromHandlers(handleData: (snapshots, sink) {
        sink.add(snapshots.map((element) {
          return CancelledStockMutationItem.fromJson(element.value);
        }).toList());
      }),
    );
  }

  Future<List<int>> getCancelledStockMutationItemIds() {
    return _store.findKeys(db);
  }

  Future<dynamic> deleteCancelledItem(int id) {
    return db.transaction((transaction) {
      _cancelledStore.record(id).delete(transaction);
      _store.record(id).update(transaction, {
        'status': StockMutationItemStatus.Cancelled,
      });
    });
  }
}
