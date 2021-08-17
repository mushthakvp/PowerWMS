import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/resources/picklist_line_api_provider.dart';
import 'package:scanner/resources/picklist_line_db_provider.dart';
import 'package:sembast/sembast.dart';

class PicklistLineRepository {
  PicklistLineRepository(Database db) {
    _apiProvider = PicklistLineApiProvider();
    _dbProvider = PicklistLineDbProvider(db);
  }

  late PicklistLineApiProvider _apiProvider;
  late PicklistLineDbProvider _dbProvider;

  Stream<List<PicklistLine>> getPicklistLinesStream(int picklistId) async* {
    final stream = _dbProvider.getPicklistLinesStream(picklistId);
    if (await _dbProvider.count(picklistId) == 0) {
      final list = await _apiProvider.getPicklistLines(picklistId);
      _dbProvider.savePicklistLines(list);
    }

    yield* stream;
  }

  Future<dynamic> clear({int? picklistId}) {
    return _dbProvider.clear(picklistId);
  }
}
