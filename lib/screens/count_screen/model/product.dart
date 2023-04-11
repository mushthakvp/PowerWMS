import 'package:json_annotation/json_annotation.dart';
import 'package:scanner/models/packaging.dart';

part 'product.g.dart';

enum Extra1 {
  y,
  n,
}

@JsonSerializable(explicitToJson: true)
class Product {
  Product({
    required this.uid,
    required this.name,
    required this.description,
    required this.ean,
    required this.productGroupName,
    required this.productGroupBatchField,
    required this.productGroupProductionDateField,
    required this.productGroupExpirationDateField,
    required this.unit,
    required this.status,
    required this.stock,
    required this.hasImage,
    required this.packagings,
    required this.id,
    required this.isNew,
    required this.moq,
    required this.extra1,
    required this.generalSalePriceIncluding,
  });

  final String uid;
  final String? name;
  final String? description;
  final String? ean;
  final String? productGroupName;
  final int? productGroupBatchField;
  final int? productGroupProductionDateField;
  final int? productGroupExpirationDateField;
  final String unit;
  final int? status;
  num? stock;
  final bool? hasImage;
  final List<Packaging>? packagings;
  final int id;
  final bool? isNew;
  num? moq;
  final String? extra1;
  final num? generalSalePriceIncluding;

  Product copyWith({
    String? name,
    String? description,
    String? ean,
    String? productGroupName,
    int? productGroupBatchField,
    int? productGroupProductionDateField,
    int? productGroupExpirationDateField,
    int? status,
    num? stock,
    bool? hasImage,
    List<Packaging>? packagings,
    bool? isNew,
    num? moq,
    String? extra1,
    num? generalSalePriceIncluding,
  }) {
    return Product(
      uid: uid,
      name: name ?? this.name,
      description: description ?? this.description,
      ean: ean ?? this.ean,
      productGroupName: productGroupName ?? this.productGroupName,
      productGroupBatchField:
          productGroupBatchField ?? this.productGroupBatchField,
      productGroupProductionDateField: productGroupProductionDateField ??
          this.productGroupProductionDateField,
      productGroupExpirationDateField: productGroupExpirationDateField ??
          this.productGroupExpirationDateField,
      unit: unit,
      status: status ?? this.status,
      stock: stock ?? this.stock,
      hasImage: hasImage ?? this.hasImage,
      packagings: packagings ?? this.packagings,
      id: id,
      isNew: isNew ?? this.isNew,
      moq: moq ?? this.moq,
      extra1: extra1 ?? this.extra1,
      generalSalePriceIncluding:
          generalSalePriceIncluding ?? this.generalSalePriceIncluding,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
