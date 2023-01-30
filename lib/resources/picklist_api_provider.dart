import 'package:dio/dio.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/models/base_response.dart';
import 'package:scanner/models/picklist.dart';

class PicklistApiProvider {
  Future<List<Picklist>> getPicklists(String search) {
    print("getPicklists");
    return dio
        .post<Map<String, dynamic>>(
          '/picklist/list',
          data: {
            'search': search == '' ? null : search,
            'skipPaging': true,
          },
        )
        .then(
          (response) => (response.data!['data'] as List<dynamic>)
              .map((json) => Picklist.fromJson(json))
              .toList(),
        )
        .catchError((error, _) {
          throw Failure(error.toString());
        });
  }

  Future<BaseResponse?> completePicklist(int id) async {
    try {
      return await dio
          .post<Map<String, dynamic>>('/picklist/$id/complete')
          .then((response) => BaseResponse.fromJson(response.data!));
    } on DioError catch (e) {
      return BaseResponse(success: false, message: e.toString());
    }
  }
}
