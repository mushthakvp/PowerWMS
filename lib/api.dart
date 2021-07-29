import 'package:dio/dio.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/models/stock_mutation.dart';

Future login(String username, String password) {
  return dio.post(
    '/account/token',
    data: {
      'email': username,
      'password': password,
    },
  );
}

Future<Response<Map<String, dynamic>>> addStockMutation(
    StockMutation mutation) {
  return dio.post(
    '/stockmutation/add',
    data: mutation.toJson(),
  );
}

Future<Response<Map<String, dynamic>>> getStockMutation(
    int picklistId, int productId) {
  return dio.post(
    '/stockmutation/list',
    data: {
      'productId': productId,
      'picklistId': picklistId,
      'skipPaging': true,
    },
  );
}

Future<Response<Map<String, dynamic>>> cancelStockMutation(int id) {
  return dio.post('/stockmutation/$id/cancel');
}
