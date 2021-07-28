import 'package:json_annotation/json_annotation.dart';
import 'package:scanner/models/packaging.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product {
  final String uid;
  final String? name;
  final String? description;
  final String ean;
  final String? productGroupName;
  final int? productGroupBatchField;
  final int? productGroupProductionDateField;
  final int? productGroupExpirationDateField;
  final String unit;
  final int status;
  final num stock;
  final bool hasImage;
  final List<Packaging> packagings;
  final int id;
  final bool isNew;

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
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
