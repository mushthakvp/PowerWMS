class PickListLineModel {
  List<PickListLineV2>? data;
  int? total;
  int? filteredTotal;

  PickListLineModel({
    this.data,
    this.total,
    this.filteredTotal,
  });

  factory PickListLineModel.fromJson(Map<String, dynamic> json) =>
      PickListLineModel(
        data: json["data"] == null
            ? []
            : List<PickListLineV2>.from(
                json["data"]!.map((x) => PickListLineV2.fromJson(x))),
        total: json["total"],
        filteredTotal: json["filteredTotal"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total": total,
        "filteredTotal": filteredTotal,
      };
}

class PickListLineV2 {
  String? picklist;
  int? picklistId;
  int? line;
  String? uid;
  String? warehouse;
  int? warehouseId;
  dynamic lineDate;
  double? pickAmount;
  dynamic canceledAmount;
  dynamic backOrderAmount;
  dynamic orderedAmount;
  double? pickedAmount;
  double? available;
  dynamic descriptionA;
  dynamic descriptionB;
  dynamic internalMemo;
  int? status;
  Product? product;
  dynamic location;
  String? batchSuggestion;
  String? lineLocationCode;
  String? lineWarehouseCode;
  int? id;
  bool? isNew;

  PickListLineV2({
    this.picklist,
    this.picklistId,
    this.line,
    this.uid,
    this.warehouse,
    this.warehouseId,
    this.lineDate,
    this.pickAmount,
    this.canceledAmount,
    this.backOrderAmount,
    this.orderedAmount,
    this.pickedAmount,
    this.available,
    this.descriptionA,
    this.descriptionB,
    this.internalMemo,
    this.status,
    this.product,
    this.location,
    this.batchSuggestion,
    this.lineLocationCode,
    this.lineWarehouseCode,
    this.id,
    this.isNew,
  });

  factory PickListLineV2.fromJson(Map<String, dynamic> json) => PickListLineV2(
        picklist: json["picklist"],
        picklistId: json["picklistId"],
        line: json["line"],
        uid: json["uid"],
        warehouse: json["warehouse"],
        warehouseId: json["warehouseId"],
        lineDate: json["lineDate"],
        pickAmount: json["pickAmount"],
        canceledAmount: json["canceledAmount"],
        backOrderAmount: json["backOrderAmount"],
        orderedAmount: json["orderedAmount"],
        pickedAmount: json["pickedAmount"],
        available: json["available"],
        descriptionA: json["descriptionA"],
        descriptionB: json["descriptionB"],
        internalMemo: json["internalMemo"],
        status: json["status"],
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        location: json["location"],
        batchSuggestion: json["batchSuggestion"],
        lineLocationCode: json["lineLocationCode"],
        lineWarehouseCode: json["lineWarehouseCode"],
        id: json["id"],
        isNew: json["isNew"],
      );

  Map<String, dynamic> toJson() => {
        "picklist": picklist,
        "picklistId": picklistId,
        "line": line,
        "uid": uid,
        "warehouse": warehouse,
        "warehouseId": warehouseId,
        "lineDate": lineDate,
        "pickAmount": pickAmount,
        "canceledAmount": canceledAmount,
        "backOrderAmount": backOrderAmount,
        "orderedAmount": orderedAmount,
        "pickedAmount": pickedAmount,
        "available": available,
        "descriptionA": descriptionA,
        "descriptionB": descriptionB,
        "internalMemo": internalMemo,
        "status": status,
        "product": product?.toJson(),
        "location": location,
        "batchSuggestion": batchSuggestion,
        "lineLocationCode": lineLocationCode,
        "lineWarehouseCode": lineWarehouseCode,
        "id": id,
        "isNew": isNew,
      };
}

class Product {
  List<Packaging>? packagings;
  String? uid;
  String? name;
  String? description;
  String? ean;
  String? productGroupName;
  int? batchField;
  int? productionDateField;
  int? expirationDateField;
  bool? serialNumberField;
  String? unit;
  int? status;
  int? stock;
  bool? hasImage;
  dynamic generalSalePrice;
  dynamic generalSalePriceIncluding;
  dynamic currencyId;
  dynamic discount;
  dynamic vat;
  dynamic commercialText;
  dynamic moq;
  String? extra1;
  String? extra2;
  String? extra3;
  String? extra4;
  String? extra5;
  int? id;
  bool? isNew;

  Product({
    this.packagings,
    this.uid,
    this.name,
    this.description,
    this.ean,
    this.productGroupName,
    this.batchField,
    this.productionDateField,
    this.expirationDateField,
    this.serialNumberField,
    this.unit,
    this.status,
    this.stock,
    this.hasImage,
    this.generalSalePrice,
    this.generalSalePriceIncluding,
    this.currencyId,
    this.discount,
    this.vat,
    this.commercialText,
    this.moq,
    this.extra1,
    this.extra2,
    this.extra3,
    this.extra4,
    this.extra5,
    this.id,
    this.isNew,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        packagings: json["packagings"] == null
            ? []
            : List<Packaging>.from(
                json["packagings"]!.map((x) => Packaging.fromJson(x))),
        uid: json["uid"],
        name: json["name"],
        description: json["description"],
        ean: json["ean"],
        productGroupName: json["productGroupName"],
        batchField: json["batchField"],
        productionDateField: json["productionDateField"],
        expirationDateField: json["expirationDateField"],
        serialNumberField: json["serialNumberField"],
        unit: json["unit"],
        status: json["status"],
        stock: json["stock"],
        hasImage: json["hasImage"],
        generalSalePrice: json["generalSalePrice"],
        generalSalePriceIncluding: json["generalSalePriceIncluding"],
        currencyId: json["currencyId"],
        discount: json["discount"],
        vat: json["vat"],
        commercialText: json["commercialText"],
        moq: json["moq"],
        extra1: json["extra1"],
        extra2: json["extra2"],
        extra3: json["extra3"],
        extra4: json["extra4"],
        extra5: json["extra5"],
        id: json["id"],
        isNew: json["isNew"],
      );

  Map<String, dynamic> toJson() => {
        "packagings": packagings == null
            ? []
            : List<dynamic>.from(packagings!.map((x) => x.toJson())),
        "uid": uid,
        "name": name,
        "description": description,
        "ean": ean,
        "productGroupName": productGroupName,
        "batchField": batchField,
        "productionDateField": productionDateField,
        "expirationDateField": expirationDateField,
        "serialNumberField": serialNumberField,
        "unit": unit,
        "status": status,
        "stock": stock,
        "hasImage": hasImage,
        "generalSalePrice": generalSalePrice,
        "generalSalePriceIncluding": generalSalePriceIncluding,
        "currencyId": currencyId,
        "discount": discount,
        "vat": vat,
        "commercialText": commercialText,
        "moq": moq,
        "extra1": extra1,
        "extra2": extra2,
        "extra3": extra3,
        "extra4": extra4,
        "extra5": extra5,
        "id": id,
        "isNew": isNew,
      };
}

class Packaging {
  int? productId;
  int? packagingUnitId;
  String? uid;
  double? defaultAmount;
  dynamic weight;
  String? weightMeasurementUnitId;
  dynamic length;
  dynamic width;
  dynamic height;
  dynamic dimensionMeasurementUnitId;
  List<PackagingUnitTranlation>? packagingUnitTranlations;
  dynamic translatedName;
  String? formattedDimension;
  int? id;
  bool? isNew;

  Packaging({
    this.productId,
    this.packagingUnitId,
    this.uid,
    this.defaultAmount,
    this.weight,
    this.weightMeasurementUnitId,
    this.length,
    this.width,
    this.height,
    this.dimensionMeasurementUnitId,
    this.packagingUnitTranlations,
    this.translatedName,
    this.formattedDimension,
    this.id,
    this.isNew,
  });

  factory Packaging.fromJson(Map<String, dynamic> json) => Packaging(
        productId: json["productId"],
        packagingUnitId: json["packagingUnitId"],
        uid: json["uid"],
        defaultAmount: json["defaultAmount"],
        weight: json["weight"],
        weightMeasurementUnitId: json["weightMeasurementUnitId"],
        length: json["length"],
        width: json["width"],
        height: json["height"],
        dimensionMeasurementUnitId: json["dimensionMeasurementUnitId"],
        packagingUnitTranlations: json["packagingUnitTranlations"] == null
            ? []
            : List<PackagingUnitTranlation>.from(
                json["packagingUnitTranlations"]!
                    .map((x) => PackagingUnitTranlation.fromJson(x))),
        translatedName: json["translatedName"],
        formattedDimension: json["formattedDimension"],
        id: json["id"],
        isNew: json["isNew"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "packagingUnitId": packagingUnitId,
        "uid": uid,
        "defaultAmount": defaultAmount,
        "weight": weight,
        "weightMeasurementUnitId": weightMeasurementUnitId,
        "length": length,
        "width": width,
        "height": height,
        "dimensionMeasurementUnitId": dimensionMeasurementUnitId,
        "packagingUnitTranlations": packagingUnitTranlations == null
            ? []
            : List<dynamic>.from(
                packagingUnitTranlations!.map((x) => x.toJson())),
        "translatedName": translatedName,
        "formattedDimension": formattedDimension,
        "id": id,
        "isNew": isNew,
      };
}

class PackagingUnitTranlation {
  String? culture;
  String? value;
  int? id;
  bool? isNew;

  PackagingUnitTranlation({
    this.culture,
    this.value,
    this.id,
    this.isNew,
  });

  factory PackagingUnitTranlation.fromJson(Map<String, dynamic> json) =>
      PackagingUnitTranlation(
        culture: json["culture"],
        value: json["value"],
        id: json["id"],
        isNew: json["isNew"],
      );

  Map<String, dynamic> toJson() => {
        "culture": culture,
        "value": value,
        "id": id,
        "isNew": isNew,
      };
}
