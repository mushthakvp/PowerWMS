import 'package:json_annotation/json_annotation.dart';
import 'package:scanner/models/packaging.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product {
  final String uid;
  final String? name;
  final String? description;
  final String? ean;
  final String? productGroupName;
  final String unit;
  final int status;
  final num stock;
  final bool hasImage;
  final String? extra1;
  final String? extra2;
  final String? extra3;
  final String? extra4;
  final String? extra5;
  final List<Packaging> packagings;
  final int id;
  final bool isNew;
  final int? batchField;
  final int? productionDateField;
  final int? expirationDateField;
  final bool? serialNumberField;

  Product({
    required this.uid,
    required this.name,
    required this.description,
    required this.ean,
    required this.productGroupName,
    required this.unit,
    required this.status,
    required this.stock,
    required this.hasImage,
    required this.extra1,
    required this.extra2,
    required this.extra3,
    required this.extra4,
    required this.extra5,
    required this.packagings,
    required this.id,
    required this.isNew,
    required this.batchField,
    required this.productionDateField,
    required this.expirationDateField,
    required this.serialNumberField
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
