import 'package:scanner/models/picklist_line.dart';
import 'package:sembast/sembast.dart';

class PicklistLineDbProvider {
  PicklistLineDbProvider(this.db);

  final _store = intMapStoreFactory.store('picklist_lines');
  final Database db;

  Future<List<PicklistLine>> getPicklistLines(int picklistId) {
    var finder = Finder(filter: Filter.equals('picklistId', picklistId));
    return _store.find(db, finder: finder).then((records) => records
        .map((snapshot) => PicklistLine.fromJson(snapshot.value))
        .toList());
  }

  Future<PicklistLine?> getPicklistLine(int id) {
    var finder = Finder(filter: Filter.equals('id', id));
    return _store.findFirst(db, finder: finder).then(
          (record) => record?.value != null
              ? PicklistLine.fromJson(record!.value)
              : null,
        );
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

  Future<dynamic> clear(int picklistId) {
    var finder = Finder(filter: Filter.equals('picklistId', picklistId));
    return _store.delete(db, finder: finder);
  }
}
