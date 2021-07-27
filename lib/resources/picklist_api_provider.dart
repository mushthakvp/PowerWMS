import 'package:scanner/dio.dart';
import 'package:scanner/models/picklist.dart';

class PicklistApiProvider {
  Future<List<Picklist>> getPicklists(String? search) {
    return dio.post<Map<String, dynamic>>(
      '/picklist/list',
      data: {
        'search': search,
        'skipPaging': true,
      },
    ).then(
      (response) => (response.data!['data'] as List<dynamic>)
          .map((json) => Picklist.fromJson(json))
          .toList(),
    );
  }
}
