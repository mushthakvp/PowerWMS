import 'package:dio/dio.dart';
import 'package:scanner/dio.dart';

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
