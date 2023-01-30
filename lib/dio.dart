import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

var dio = Dio();

/// ERP Dio
var erpDio = Dio();

interceptErpDio() {
  erpDio.interceptors.add(
    InterceptorsWrapper(onRequest: (options, handler) {
      return handler.next(options);
    }, onResponse: (response, handler) {
      return handler.next(response);
    }, onError: (DioError e, handler) {
      return handler.next(e);
    }),
  );
}

updateErpDio(
    {required String server,
    required String admin,
    required String userName,
    required String password}) {
  erpDio.options.baseUrl = '$server$admin';
  erpDio.options.headers = {
    'authorization':
        'Basic ${base64.encode(utf8.encode('$userName:$password'))}'
  };
  if (kDebugMode) {
    print('HTTP Headers: ${erpDio.options.headers}');
  }
}

class Failure {
  final String message;

  const Failure(this.message);
}

class NoConnection extends Failure {
  const NoConnection(String message) : super(message);
}
