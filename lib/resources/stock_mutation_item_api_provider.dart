import 'dart:async';
import 'package:scanner/dio.dart';
import 'package:scanner/models/stock_mutation_item.dart';

class StockMutationItemApiProvider {
  Future<List<StockMutationItem>> getStockMutationItems(
    int picklistId,
    int picklistLineId,
  ) {
    return dio.post(
      '/stockmutation/list',
      data: {
        'picklistId': picklistId,
        'picklistLineId': picklistLineId,
        'skipPaging': true,
      },
    ).then((response) => (response.data!['data'] as List<dynamic>)
        .map((json) => StockMutationItem.fromJson(json))
        .toList());
  }

  Future<void> cancelStockMutationItem(int id) async {
    await dio.post('/stockmutation/$id/cancel');
  }
}
