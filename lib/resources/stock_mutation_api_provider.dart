import 'dart:async';

import 'package:dio/dio.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/models/stock_mutation.dart';

class StockMutationApiProvider {
  Future<Response<Map<String, dynamic>>> addStockMutation(
    StockMutation mutation,
  ) {
    return dio.post(
      '/stockmutation/add',
      data: mutation.toJson(),
    );
  }
}
