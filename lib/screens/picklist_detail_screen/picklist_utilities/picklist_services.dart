import 'package:scanner/models/picklist.dart';
import 'package:scanner/models/picklist_line.dart';

filter(String search) => (PicklistLine line) =>
search == '' || line.product.ean == search || line.product.uid == search;

List<PicklistLine> scanFilter(String search, List<PicklistLine> line) {
  List<PicklistLine> result = [];
  if (search.length == 13) {
    final request = '0$search';
    result = line
        .where((l) => l.product.ean == request || l.product.uid == request)
        .toList();
  }
  if (result.isEmpty) {
    result = line
        .where((l) => l.product.ean == search || l.product.uid == search)
        .toList();
  }
  return result;
}

mixin PicklistStatusDelegate {
  onUpdateStatus(PicklistStatus status);
}