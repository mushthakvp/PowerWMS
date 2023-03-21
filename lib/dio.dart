import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

var dio = Dio();

/// ERP Dio
var erpDio = Dio();

// interceptNormalDio(){
//   dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
//         // Check if the token is expired
//         bool isTokenExpired = checkIfTokenIsExpired();
//
//         if (isTokenExpired) {
//           // Log out the user
//           logout();
//         } else {
//           // Set the token in the header
//           String token = getToken();
//           options.headers["Authorization"] = "Bearer $token";
//
//           // Proceed with the request
//           handler.next(options);
//         }
//       }
//   ));
// }

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
