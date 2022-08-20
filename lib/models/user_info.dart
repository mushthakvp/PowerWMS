import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable(explicitToJson: true)
class UserInfo {
  UserInfo({
     this.id,
    this.email,
    this.firstName,
    this.lastName,
  });

  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;

  UserInfo copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
  }) =>
      UserInfo(
        id: id ?? this.id,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
      );

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}