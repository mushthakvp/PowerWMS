class SettingsModel {
  final bool isContinues;
  final bool isReturn;

  SettingsModel({
    this.isContinues = false,
    this.isReturn = false,
  });

  factory SettingsModel.fromJson(json) {
    return SettingsModel(
      isContinues: json['is_continues'],
      isReturn: json['is_return'],
    );
  }
}
