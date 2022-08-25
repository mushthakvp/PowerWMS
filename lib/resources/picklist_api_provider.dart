import 'package:dio/dio.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/models/picklist.dart';

class PicklistApiProvider {
  Future<List<Picklist>> getPicklists(String search) {
    return dio.post<Map<String, dynamic>>(
      '/picklist/list',
      data: {
        'search': search == '' ? null : search,
        'skipPaging': true,
      },
    ).then(
      (response) => (response.data!['data'] as List<dynamic>)
          .map((json) => Picklist.fromJson(json))
          .toList(),
    );
  }

  Future<String?> completePicklist(int id) async {
    try {
      await dio.post<Map<String, dynamic>>('/picklist/$id/complete');
      return null;
    } on DioError catch (e) {
      return e.toString();
    }
  }
}
