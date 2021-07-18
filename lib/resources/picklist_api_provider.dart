import 'package:scanner/dio.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/resources/picklist_repository.dart';

class PicklistApiProvider implements Source {
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
