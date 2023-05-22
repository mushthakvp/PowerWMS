import 'dart:async';

import 'package:scanner/models/stock_mutation.dart';
import 'package:sembast/sembast.dart';

snapshotsToMap(List<RecordSnapshot<int, Map<String, Object?>>> snapshots) {
  return snapshots.fold<Map<int, StockMutation>>({}, (previousValue, element) {
    return previousValue
      ..putIfAbsent(
        element.key,
        () => StockMutation.fromJson(element.value),
      );
  });
}

class StockMutationDbProvider {
  static const name = 'stock_mutations';

  StockMutationDbProvider(this.db);

  final _store = intMapStoreFactory.store(name);
  final Database db;

  Stream<Map<int, StockMutation>> getStockMutationsStream(int picklistId) {
    var finder = Finder(filter: Filter.equals('picklistId', picklistId));
    return _store.query(finder: finder).onSnapshots(db).transform(
      StreamTransformer.fromHandlers(handleData: (snapshots, sink) {
        sink.add(snapshotsToMap(snapshots));
      }),
    );
  }

  Future<int> addStockMutation(StockMutation mutation) {
    return _store.add(db, mutation.toJson());
  }

  Future<dynamic> deleteStockMutation(int id) {
    return _store.record(id).delete(db);
  }

  Future<Map<int, StockMutation>> getStockMutations() {
    return _store.find(db).then((snapshots) => snapshotsToMap(snapshots));
  }
}
