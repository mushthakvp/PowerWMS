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

  Future<Response<Map<String, dynamic>>> triggerCancelledAmount({required int picklistId,
    required int lineId,
  }) async {
    return dio.post<Map<String, dynamic>>(
      '/picklist/$picklistId/cancel/$lineId',
    ).catchError((error, _) {
      throw Failure(error.toString());
    });
  }

  Future<Response<Map<String, dynamic>>> triggerBackorderAmount({required int picklistId,
    required int lineId,
  }) async {
    return dio.post<Map<String, dynamic>>(
      '/picklist/$picklistId/backorder/$lineId',
    ).catchError((error, _) {
      throw Failure(error.toString());
    });
  }
}
