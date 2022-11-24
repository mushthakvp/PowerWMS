import 'package:scanner/dio.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/resources/picklist_line_api_provider.dart';
import 'package:scanner/resources/picklist_line_db_provider.dart';
import 'package:scanner/resources/stock_mutation_item_db_provider.dart';
import 'package:scanner/util/internet_state.dart';
import 'package:sembast/sembast.dart';

class PicklistLineRepository {
  PicklistLineRepository(Database db) {
    _apiProvider = PicklistLineApiProvider();
    _dbProvider = PicklistLineDbProvider(db);
    _stockDbProvider = StockMutationItemDbProvider(db);
  }

  late PicklistLineApiProvider _apiProvider;
  late PicklistLineDbProvider _dbProvider;
  late StockMutationItemDbProvider _stockDbProvider;

  Stream<List<PicklistLine>> getPicklistLinesStream(int picklistId) async* {
    final stream = _dbProvider.getPicklistLinesStream(picklistId);
    if (await _dbProvider.count(picklistId) == 0) {
      if (!InternetState.shared.connectivityAvailable()) {
        throw NoConnection('Intentional exception');
      }
      final list = await _apiProvider.getPicklistLines(picklistId);
      _dbProvider.savePicklistLines(list);
    }

    yield* stream;
  }

  Future<PicklistLine> updatePicklistLinePickedAmount(PicklistLine line, StockMutationItem item) async {
    var result = await _dbProvider.updatePicklistLinePickedAmount(line, item);
    await _stockDbProvider.deleteCancelledItem(item.id!);
    return result;
  }

  Future<dynamic> clear({int? picklistId}) {
    return _dbProvider.clear(picklistId);
  }
}
