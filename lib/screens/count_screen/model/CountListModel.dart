class CountListModel {
  CountListModel({
    required this.reference,
    required this.uid,
    required this.userId,
    required this.user,
    required this.warehouseId,
    required this.warehouse,
    required this.warehouseCode,
    required this.plannedDateOriginal,
    required this.plannedDate,
    required this.id,
    required this.isNew,
  });

  CountListModel.fromJson(dynamic json) {
    reference = json['reference'];
    uid = json['uid'];
    userId = json['userId'];
    user = json['user'];
    warehouseId = json['warehouseId'];
    warehouse = json['warehouse'];
    warehouseCode = json['warehouseCode'];
    plannedDateOriginal = json['plannedDateOriginal'];
    plannedDate = json['plannedDate'];
    id = json['id'];
    isNew = json['isNew'];
  }

  late String reference;
  late String uid;
  late int userId;
  late String user;
  late int warehouseId;
  late String warehouse;
  late String warehouseCode;
  late String plannedDateOriginal;
  late String plannedDate;
  late int id;
  late bool isNew;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reference'] = reference;
    map['uid'] = uid;
    map['userId'] = userId;
    map['user'] = user;
    map['warehouseId'] = warehouseId;
    map['warehouse'] = warehouse;
    map['warehouseCode'] = warehouseCode;
    map['plannedDateOriginal'] = plannedDateOriginal;
    map['plannedDate'] = plannedDate;
    map['id'] = id;
    map['isNew'] = isNew;
    return map;
  }
}
