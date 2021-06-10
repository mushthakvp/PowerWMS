import 'dart:typed_data';

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

Future<Response<Map<String, dynamic>>> getPicklists(String search) {
  return dio.post(
    '/picklist/list',
    data: {
      'search': search,
      'skipPaging': true,
    },
  );
}

Future<Response<Map<String, dynamic>>> getPicklistLines(int picklistId) {
  return dio.post(
    '/picklist/lines',
    data: {
      'picklistId': picklistId,
      'skipPaging': true,
    },
  );
}

Future<Response<Map<String, dynamic>>> getProducts() {
  return dio.post(
    '/product/list',
    data: {
      'skipPaging': true,
    },
  );
}

Future<Response<Uint8List>> getProductImage(int id) {
  return dio.get(
    '/product/image/$id',
    options: Options(responseType: ResponseType.bytes),
  );
}

Future<Response<Map<String, dynamic>>> addStockMutation(StockMutation mutation) {
  return dio.post(
    '/StockMutation',
    data: mutation.toJson(),
  );
}
