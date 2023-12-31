import 'package:scanner/models/cancelled_stock_mutation_item.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/repository/local_db/stock_mutation_item_db_provider.dart';
import 'package:scanner/repository/remote_db/stock_mutation_item_api_provider.dart';
import 'package:sembast/sembast.dart';

class StockMutationItemRepository {
  StockMutationItemRepository(Database db) {
    _apiProvider = StockMutationItemApiProvider();
    _dbProvider = StockMutationItemDbProvider(db);
  }

  late StockMutationItemApiProvider _apiProvider;
  late StockMutationItemDbProvider _dbProvider;

  Stream<List<StockMutationItem>> getStockMutationItemsStream(
    int picklistId,
    int picklistLineId,
    int productId
  ) async* {
    final stream = _dbProvider.getStockMutationItems(productId);
    if (await _dbProvider.countStockMutationItems(productId) == 0) {
      final list =
          await _apiProvider.getStockMutationItems(picklistId, picklistLineId);
      try {
        await _dbProvider.saveCancelledItems(list);
      } catch (e) {
        print(e);
      }
    }
    yield* stream;
  }

  Future<dynamic> saveCancelledItems(List<StockMutationItem> list) async {
    await _dbProvider.saveCancelledItems(list);
  }

  Future<List<CancelledStockMutationItem>> getCancelledStockMutationItems(
      int productId) {
    return _dbProvider.getCancelledStockMutationItems(productId);
  }

  Future<dynamic> tryCancelItem(StockMutationItem item) async {
    assert(item.id != null);
    try {
      cancelItem(item.id!);
    } catch (e) {
      _dbProvider.queueItemForCancel(item);
    }
  }

  Future<dynamic> processQueue() async {
    final ids = await _dbProvider.getCancelledStockMutationItemIds();
    ids.forEach((id) async {
      try {
        await _apiProvider.cancelStockMutationItem(id);
        await _dbProvider.deleteCancelledItem(id);
      } catch (e) {
        print(e);
      }
    });
  }

  Future<dynamic> cancelItem(int id) {
    return _apiProvider.cancelStockMutationItem(id);
  }
}
