import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/screens/count_screen/model/order/order_request.dart';
import 'package:scanner/screens/count_screen/model/order/order_response.dart';
import 'package:tuple/tuple.dart';

class OrderApiProvider {


  Future<Tuple2<OrderResponse?, Failure?>> orderProduct({
    required OrderRequest request
  }) async {
    if (kDebugMode) {
      print('HTTP Headers: ${erpDio.options.baseUrl}');
    }
    try {
      return await erpDio
          .post<Map<String, dynamic>>('/salesOrders', data: request.toJson())
          .then((value) => Tuple2(OrderResponse.fromJson(value.data!), null));
    } on DioError catch (error) {
      if (kDebugMode) {
        print('HTTP Error: $error');
      }
      if (error.response != null) {
        if (error.response?.statusCode != 401) {
          var message = error.response?.data['error'] as String?;
          if (message != null) {
            return Tuple2(null, Failure(message));
          }
        } else {
          var message = error.response?.data as String?;
          if (message != null) {
            return Tuple2(null, Failure(message));
          }
        }
      }
      return Tuple2(null, Failure(error.message));
    }
  }
}
