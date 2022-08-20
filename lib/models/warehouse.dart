import 'package:json_annotation/json_annotation.dart';

part 'warehouse.g.dart';

@JsonSerializable(explicitToJson: true)
class Warehouse {
  Warehouse({
    this.name,
    this.code,
    this.globalLocationNumber,
    this.id,
    this.isNew,
  });

  final String? name;
  final String? code;
  final int? globalLocationNumber;
  final int? id;
  final bool? isNew;

  Warehouse copyWith({
    String? name,
    String? code,
    int? globalLocationNumber,
    int? id,
    bool? isNew,
  }) =>
      Warehouse(
        name: name ?? this.name,
        code: code ?? this.code,
        globalLocationNumber: globalLocationNumber ?? this.globalLocationNumber,
        id: id ?? this.id,
        isNew: isNew ?? this.isNew,
      );

  factory Warehouse.fromJson(Map<String, dynamic> json) =>
      _$WarehouseFromJson(json);
  Map<String, dynamic> toJson() => _$WarehouseToJson(this);
}