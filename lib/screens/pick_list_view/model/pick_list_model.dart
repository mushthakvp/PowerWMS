import 'package:hive_flutter/hive_flutter.dart';
part 'pick_list_model.g.dart';

class PickListNewModel {
  List<PickListNew>? data;

  PickListNewModel({
    this.data,
  });

  factory PickListNewModel.fromJson(Map<String, dynamic> json) =>
      PickListNewModel(
        data: json["data"] == null
            ? []
            : List<PickListNew>.from(
                json["data"]!.map((x) => PickListNew.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 1)
class PickListNew {
  @HiveField(0)
  String? timezone;
  @HiveField(1)
  String? uid;
  @HiveField(2)
  dynamic orderDate;
  @HiveField(3)
  String? orderDateFormatted;
  @HiveField(4)
  dynamic deliveryDate;
  @HiveField(5)
  String? deliveryDateFormatted;
  @HiveField(6)
  Debtor? debtor;
  @HiveField(7)
  String? agent;
  @HiveField(8)
  dynamic colliAmount;
  @HiveField(9)
  dynamic palletAmount;
  @HiveField(10)
  dynamic invoiceId;
  @HiveField(11)
  String? deliveryConditionId;
  @HiveField(12)
  String? countryCode;
  @HiveField(13)
  String? internalMemo;
  @HiveField(14)
  String? picker;
  @HiveField(15)
  dynamic deliveryAddress;
  @HiveField(16)
  dynamic orderReference;
  @HiveField(17)
  String? warehouse;
  @HiveField(18)
  int? lines;
  @HiveField(19)
  int? status;
  @HiveField(20)
  bool? hasCancelled;
  @HiveField(21)
  bool? hasBackOrder;
  @HiveField(22)
  int? id;
  @HiveField(23)
  bool? isNew;

  PickListNew({
    this.timezone,
    this.uid,
    this.orderDate,
    this.orderDateFormatted,
    this.deliveryDate,
    this.deliveryDateFormatted,
    this.debtor,
    this.agent,
    this.colliAmount,
    this.palletAmount,
    this.invoiceId,
    this.deliveryConditionId,
    this.countryCode,
    this.internalMemo,
    this.picker,
    this.deliveryAddress,
    this.orderReference,
    this.warehouse,
    this.lines,
    this.status,
    this.hasCancelled,
    this.hasBackOrder,
    this.id,
    this.isNew,
  });

  factory PickListNew.fromJson(Map<String, dynamic> json) => PickListNew(
        timezone: json["timezone"],
        uid: json["uid"],
        orderDate: json["orderDate"],
        orderDateFormatted: json["orderDateFormatted"],
        deliveryDate: json["deliveryDate"],
        deliveryDateFormatted: json["deliveryDateFormatted"],
        debtor: json["debtor"] == null ? null : Debtor.fromJson(json["debtor"]),
        agent: json["agent"],
        colliAmount: json["colliAmount"],
        palletAmount: json["palletAmount"],
        invoiceId: json["invoiceId"],
        deliveryConditionId: json["deliveryConditionId"],
        countryCode: json["countryCode"],
        internalMemo: json["internalMemo"],
        picker: json["picker"],
        deliveryAddress: json["deliveryAddress"],
        orderReference: json["orderReference"],
        warehouse: json["warehouse"],
        lines: json["lines"],
        status: json["status"],
        hasCancelled: json["hasCancelled"],
        hasBackOrder: json["hasBackOrder"],
        id: json["id"],
        isNew: json["isNew"],
      );

  Map<String, dynamic> toJson() => {
        "timezone": timezone,
        "uid": uid,
        "orderDate": orderDate,
        "orderDateFormatted": orderDateFormatted,
        "deliveryDate": deliveryDate,
        "deliveryDateFormatted": deliveryDateFormatted,
        "debtor": debtor?.toJson(),
        "agent": agent,
        "colliAmount": colliAmount,
        "palletAmount": palletAmount,
        "invoiceId": invoiceId,
        "deliveryConditionId": deliveryConditionId,
        "countryCode": countryCode,
        "internalMemo": internalMemo,
        "picker": picker,
        "deliveryAddress": deliveryAddress,
        "orderReference": orderReference,
        "warehouse": warehouse,
        "lines": lines,
        "status": status,
        "hasCancelled": hasCancelled,
        "hasBackOrder": hasBackOrder,
        "id": id,
        "isNew": isNew,
      };
}

@HiveType(typeId: 2)
class Debtor {
  @HiveField(0)
  String? uid;
  @HiveField(1)
  String? name;
  @HiveField(2)
  dynamic email;
  @HiveField(3)
  String? street;
  @HiveField(4)
  String? number;
  @HiveField(5)
  dynamic streetNote;
  @HiveField(6)
  String? city;
  @HiveField(7)
  String? postalCode;
  @HiveField(8)
  String? country;
  @HiveField(9)
  dynamic vatNumber;
  @HiveField(10)
  dynamic chamberOfCommerceNumber;
  @HiveField(11)
  int? status;
  @HiveField(12)
  dynamic agentId;
  @HiveField(13)
  String? organisation;
  @HiveField(14)
  int? organisationId;
  @HiveField(15)
  int? addressId;
  @HiveField(16)
  dynamic paymentConditionId;
  @HiveField(17)
  int? id;
  @HiveField(18)
  bool? isNew;

  Debtor({
    this.uid,
    this.name,
    this.email,
    this.street,
    this.number,
    this.streetNote,
    this.city,
    this.postalCode,
    this.country,
    this.vatNumber,
    this.chamberOfCommerceNumber,
    this.status,
    this.agentId,
    this.organisation,
    this.organisationId,
    this.addressId,
    this.paymentConditionId,
    this.id,
    this.isNew,
  });

  factory Debtor.fromJson(Map<String, dynamic> json) => Debtor(
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        street: json["street"],
        number: json["number"],
        streetNote: json["streetNote"],
        city: json["city"],
        postalCode: json["postalCode"],
        country: json["country"],
        vatNumber: json["vatNumber"],
        chamberOfCommerceNumber: json["chamberOfCommerceNumber"],
        status: json["status"],
        agentId: json["agentId"],
        organisation: json["organisation"],
        organisationId: json["organisationId"],
        addressId: json["addressId"],
        paymentConditionId: json["paymentConditionId"],
        id: json["id"],
        isNew: json["isNew"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": email,
        "street": street,
        "number": number,
        "streetNote": streetNote,
        "city": city,
        "postalCode": postalCode,
        "country": country,
        "vatNumber": vatNumber,
        "chamberOfCommerceNumber": chamberOfCommerceNumber,
        "status": status,
        "agentId": agentId,
        "organisation": organisation,
        "organisationId": organisationId,
        "addressId": addressId,
        "paymentConditionId": paymentConditionId,
        "id": id,
        "isNew": isNew,
      };
}

enum PickStatus {
  added,
  inProgress,
  inactive,
  picked,
  completed,
  archived,
  priority,
  check
}
