import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scanner/screens/pick_list_overview/model/pick_list_line_model.dart';
import '../../../dio.dart';

class PickListOverviewProvider extends ChangeNotifier {
  Future<List<PickListLineV2>> getPickListLine({required int id}) async {
    try {
      Response response = await dio.post<Map<String, dynamic>>(
        '/picklist/lines',
        data: {
          'picklistId': id,
          'skipPaging': true,
        },
      );
      return (response.data!['data'] as List<dynamic>)
          .map((json) => PickListLineV2.fromJson(json))
          .toList();
    } on SocketException {
      throw Exception('No Internet connection');
    } on DioError {
      throw Exception('Something went wrong');
    } catch (e) {
      log(e.toString());
      throw Exception(e.toString());
    }
  }
}
