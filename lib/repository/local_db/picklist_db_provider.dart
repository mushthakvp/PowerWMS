import 'dart:async';

import 'package:scanner/models/picklist.dart';
import 'package:scanner/repository/local_db/picklist_line_db_provider.dart';
import 'package:sembast/sembast.dart';

class PicklistDbProvider {
  PicklistDbProvider(this.db) {
    var lineStore = intMapStoreFactory.store(PicklistLineDbProvider.name);
    lineStore.addOnChangesListener(db, (transaction, changes) async {
      for (var change in changes) {
        if (change.isUpdate) {
          final picklistId = change.newValue!['picklistId'] as int;
          final finder =
              Finder(filter: Filter.equals('picklistId', picklistId));
          final lines = await lineStore.find(transaction, finder: finder);
          if (lines
              .every((line) => line['pickAmount'] == line['pickedAmount'])) {
            await _store.record(picklistId).update(
              transaction,
              {
                'status': PicklistStatus.picked.name,
              },
            );
          }
        }
      }
    });
  }

  final _store = intMapStoreFactory.store('picklists');
  final Database db;

  Stream<List<Picklist>> getPicklistsStream(String? search) {
    var finder = Finder(
      filter: search == '' || search == null
          ? null
          : Filter.or(
              [
                Filter.matches('uid', search),
                Filter.matches('debtor.name', search),
              ],
            ),
    );
    return _store.query(finder: finder).onSnapshots(db).transform(
      StreamTransformer.fromHandlers(
        handleData: (snapshotList, sink) {
          sink.add(
            snapshotList
                .map((snapshot) => Picklist.fromJson(snapshot.value))
                .toList(),
          );
        },
      ),
    );
  }

  Future<void> updatePicklistStatus(
      int id, PicklistStatus status, bool isReset) async {
    final res = await _store.record(id).get(db);
    final picklist = Picklist.fromJson(res ?? {});
    if (picklist.status == PicklistStatus.completed) {
      return;
    }
    if (isReset && picklist.defaultStatus != null) {
      _store.record(id).update(db, {
        'status': picklist.defaultStatus!.name,
      });
    }
    if (!isReset) {
      _store.record(id).update(
          db, {'status': status.name, 'defaultStatus': picklist.status.name});
    }
  }

  Future<dynamic> savePicklists(List<Picklist> picklists) {
    return _store
        .records(picklists.map<int>((picklist) => picklist.id))
        .put(db, picklists.map((picklist) => picklist.toJson()).toList());
  }

  Future<int> count() {
    return _store.count(db);
  }

  Future<dynamic> clear() {
    return _store.drop(db);
  }
}
