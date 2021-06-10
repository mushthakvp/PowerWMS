import 'package:json_annotation/json_annotation.dart';

part 'packaging_unit_translation.g.dart';

@JsonSerializable()
class PackagingUnitTranslation {
  final String culture;
  final String value;
  final int id;
  final bool isNew;

  PackagingUnitTranslation({
    required this.culture,
    required this.value,
    required this.id,
    required this.isNew,
  });

  factory PackagingUnitTranslation.fromJson(Map<String, dynamic> json) => _$PackagingUnitTranslationFromJson(json);
  Map<String, dynamic> toJson() => _$PackagingUnitTranslationToJson(this);
}
