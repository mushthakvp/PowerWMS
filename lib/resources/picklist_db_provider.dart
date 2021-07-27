import 'package:scanner/models/picklist.dart';
import 'package:sembast/sembast.dart';

class PicklistDbProvider {
  PicklistDbProvider(this.db);

  final Database db;

  @override
  Future<List<Picklist>> getPicklists(String? search) {
    var store = _store();
    var finder =
        Finder(filter: search == null ? null : Filter.equals('uid', search));
    return store.find(db, finder: finder).then((records) =>
        records.map((snapshot) => Picklist.fromJson(snapshot.value)).toList());
  }

  Future<dynamic> savePicklist(Picklist picklist) {
    return _store().record(picklist.id).put(db, picklist.toJson());
  }

  Future<dynamic> savePicklists(List<Picklist> picklists) {
    print(picklists.map<int>((picklist) => picklist.id));
    return _store()
        .records(picklists.map<int>((picklist) => picklist.id))
        .put(db, picklists.map((picklist) => picklist.toJson()).toList());
  }

  Future<int> count() {
    return _store().count(db);
  }

  @override
  Future<dynamic> clear() {
    return _store().drop(db);
  }

  StoreRef _store() {
    return intMapStoreFactory.store('picklists');
  }
}
