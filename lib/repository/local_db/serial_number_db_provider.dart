import 'package:sembast/sembast.dart';

class SerialNumberDbProvider {
  SerialNumberDbProvider(this.db);

  final _store = intMapStoreFactory.store('serial_number');
  final Database db;

  Future<dynamic> saveSerialNumber(List<String> serialNumberList) async {
    await db.transaction((txn) async {
      var listAsMap = await _store.record(0).get(txn);
      print("saveSerialNumber");
      print(listAsMap);
      if (listAsMap == null) {
        listAsMap = {'serialNumberList': []};
      }
      Map<String, dynamic> mutableMap = Map.from(listAsMap);
      mutableMap['serialNumberList'] = serialNumberList;
      await _store.record(0).put(txn, mutableMap);
    });
  }

  Future<List<String>> getSerialList() async {
    var listAsMap = await _store.record(0).get(db);
    if (listAsMap != null) {
      var myList = List<String>.from(listAsMap['serialNumberList'] as List);
      return myList;
    } else {
      return [];
    }
  }

  Future<dynamic> delete(String serialNumber) async {
    await db.transaction((txn) async {
      var listAsMap = await _store.record(0).get(txn);
      if (listAsMap != null) {
        Map<String, dynamic> mutableMap = Map.from(listAsMap);
        var list = List<String>.from(listAsMap['serialNumberList'] as List);
        list.remove(serialNumber);
        mutableMap['serialNumberList'] = list;
        await _store.record(0).put(txn, mutableMap);
      }
    });
  }

  Future<int> count() {
    return _store.count(db);
  }

  Future<dynamic> clear() {
    return _store.drop(db);
  }
}
