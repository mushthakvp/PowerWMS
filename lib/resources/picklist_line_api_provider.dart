import 'package:scanner/dio.dart';
import 'package:scanner/models/picklist_line.dart';

class PicklistLineApiProvider {
  Future<List<PicklistLine>> getPicklistLines(int picklistId) {
    print("GETPICKLISTLINES");
    return dio.post<Map<String, dynamic>>(
      '/picklist/lines',
      data: {
        'picklistId': picklistId,
        'skipPaging': true,
      },
    ).then(
      (response) => (response.data!['data'] as List<dynamic>)
          .map((json) => PicklistLine.fromJson(json))
          .toList(),
    ).catchError((error, stack) {
      print(stack);
      throw Failure(error.toString());
    });
  }

  Future<PicklistLine> getPicklistLine(int picklistId, int lineId) {
    return dio
        .post<Map<String, dynamic>>('/picklist/$picklistId/line/$lineId')
        .then((response) => PicklistLine.fromJson(response.data!));
  }
}
