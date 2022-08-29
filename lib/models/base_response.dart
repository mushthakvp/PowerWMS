import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(explicitToJson: true)
class BaseResponse {
  BaseResponse({
    required this.success,
    required this.message,
  });

  final bool success;
  final String message;

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}