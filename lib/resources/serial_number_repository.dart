import 'package:scanner/resources/serial_number_db_provider.dart';
import 'package:sembast/sembast.dart';

class SerialNumberRepository {
  SerialNumberRepository(Database db) {
    _dbProvider = SerialNumberDbProvider(db);
  }

  late SerialNumberDbProvider _dbProvider;

  Future<List<String>> getSerialNumberList() async {
    List<String> list;

    print("from DB");

    list = await _dbProvider.getSerialList();
    print("list form db: ${list.length}");

    return list;
  }

  Future<void> deleteProduct({required String serialNumber}) async {
    await _dbProvider.delete(serialNumber);
  }

  Future<void> addSerialNumberList(List<String> serialNumberList) async {
    await _dbProvider.saveSerialNumber(serialNumberList);
  }

  clearCache() async {
    _dbProvider.clear();
  }
}
