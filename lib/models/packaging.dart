import 'package:json_annotation/json_annotation.dart';
import 'package:scanner/models/packaging_unit_translation.dart';

part 'packaging.g.dart';

@JsonSerializable(explicitToJson: true)
class Packaging {
  final int productId;
  final int packagingUnitId;
  final String? uid;
  final num defaultAmount;
  final num? weight;
  final String? weightMeasurementUnitId;
  final num? length;
  final num? width;
  final num? height;
  final String? dimensionMeasurementUnitId;
  final String product;
  final String productName;
  final String productUnit;
  final num? productDecimals;
  final String productDescription;
  final int batchField;
  final int productionDateField;
  final int expirationDateField;
  @JsonKey(name: 'packagingUnitTranlations')
  final List<PackagingUnitTranslation> packagingUnitTranslations;
  final String? translatedName;
  final String formattedDimension;
  final int id;
  final bool isNew;

  Packaging({
    required this.productId,
    required this.packagingUnitId,
    required this.uid,
    required this.defaultAmount,
    required this.weight,
    required this.weightMeasurementUnitId,
    required this.length,
    required this.width,
    required this.height,
    required this.dimensionMeasurementUnitId,
    required this.product,
    required this.productName,
    required this.productUnit,
    required this.productDecimals,
    required this.productDescription,
    required this.batchField,
    required this.productionDateField,
    required this.expirationDateField,
    required this.packagingUnitTranslations,
    required this.translatedName,
    required this.formattedDimension,
    required this.id,
    required this.isNew,
  });

  factory Packaging.fromJson(Map<String, dynamic> json) =>
      _$PackagingFromJson(json);
  Map<String, dynamic> toJson() => _$PackagingToJson(this);
}
