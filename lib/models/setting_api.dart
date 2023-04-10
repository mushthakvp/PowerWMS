/// id : 6
/// apiRoles : []
/// apiSettings : [{"type":2,"baseEndpoint":"http://46.243.188.238/API/api/","administrationCode":"MVL00001","addToStock":false,"basicAuthorizationUser":null,"basicAuthorizationPassword":"","basicAuthorizationPasswordChanged":false,"apiKey":null,"baseOAuthEndpoint":"http://46.243.188.238/API/","clientUID":"wms","clientSecret":"wms","redirectUri":"http://46.243.188.238/API","refreshToken":"lSwL!IAAAANTYmLUWxNYJKCOMPncAluwoAREPVO-hXI_HC-uESKDqsQAAAAFax_o_djdykmLAOmiVD8eeNdpPskD08J6pOBwp6MtWmeN_Vtp6jWAk2EGs4WIK7CqE54qlolHU57u2qxn7PiE36BrCkL5HM2eHw8G9hxFBXRziwiihWkpzl7CYQh_zU27PO4kq1grGILiJR_XPkrD7-ZJiS2yIWgKht4PEbj-9QOEYSCngAtXfGSBUc-N_beAfAjHbyzm14rDV8uTg2v6_GsYcye9QFafKNmwtkC9ioQ","id":6,"isNew":false}]

class SettingApi {
  SettingApi({
    num? id,
    List<dynamic>? apiRoles,
    List<ApiSettings>? apiSettings,
  }) {
    _id = id;
    _apiRoles = apiRoles;
    _apiSettings = apiSettings;
  }

  SettingApi.fromJson(dynamic json) {
    _id = json['id'];
    if (json['apiRoles'] != null) {
      _apiRoles = [];
      json['apiRoles'].forEach((v) {
        _apiRoles?.add((v));
      });
    }
    if (json['apiSettings'] != null) {
      _apiSettings = [];
      json['apiSettings'].forEach((v) {
        _apiSettings?.add(ApiSettings.fromJson(v));
      });
    }
  }

  num? _id;
  List<dynamic>? _apiRoles;
  List<ApiSettings>? _apiSettings;

  SettingApi copyWith({
    num? id,
    List<dynamic>? apiRoles,
    List<ApiSettings>? apiSettings,
  }) =>
      SettingApi(
        id: id ?? _id,
        apiRoles: apiRoles ?? _apiRoles,
        apiSettings: apiSettings ?? _apiSettings,
      );

  num? get id => _id;

  List<dynamic>? get apiRoles => _apiRoles;

  List<ApiSettings>? get apiSettings => _apiSettings;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_apiRoles != null) {
      map['apiRoles'] = _apiRoles?.map((v) => v.toJson()).toList();
    }
    if (_apiSettings != null) {
      map['apiSettings'] = _apiSettings?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// type : 2
/// baseEndpoint : "http://46.243.188.238/API/api/"
/// administrationCode : "MVL00001"
/// addToStock : false
/// basicAuthorizationUser : null
/// basicAuthorizationPassword : ""
/// basicAuthorizationPasswordChanged : false
/// apiKey : null
/// baseOAuthEndpoint : "http://46.243.188.238/API/"
/// clientUID : "wms"
/// clientSecret : "wms"
/// redirectUri : "http://46.243.188.238/API"
/// refreshToken : "lSwL!IAAAANTYmLUWxNYJKCOMPncAluwoAREPVO-hXI_HC-uESKDqsQAAAAFax_o_djdykmLAOmiVD8eeNdpPskD08J6pOBwp6MtWmeN_Vtp6jWAk2EGs4WIK7CqE54qlolHU57u2qxn7PiE36BrCkL5HM2eHw8G9hxFBXRziwiihWkpzl7CYQh_zU27PO4kq1grGILiJR_XPkrD7-ZJiS2yIWgKht4PEbj-9QOEYSCngAtXfGSBUc-N_beAfAjHbyzm14rDV8uTg2v6_GsYcye9QFafKNmwtkC9ioQ"
/// id : 6
/// isNew : false

class ApiSettings {
  ApiSettings({
    num? type,
    String? baseEndpoint,
    String? administrationCode,
    bool? addToStock,
    dynamic basicAuthorizationUser,
    String? basicAuthorizationPassword,
    bool? basicAuthorizationPasswordChanged,
    dynamic apiKey,
    String? baseOAuthEndpoint,
    String? clientUID,
    String? clientSecret,
    String? redirectUri,
    String? refreshToken,
    num? id,
    bool? isNew,
  }) {
    _type = type;
    _baseEndpoint = baseEndpoint;
    _administrationCode = administrationCode;
    _addToStock = addToStock;
    _basicAuthorizationUser = basicAuthorizationUser;
    _basicAuthorizationPassword = basicAuthorizationPassword;
    _basicAuthorizationPasswordChanged = basicAuthorizationPasswordChanged;
    _apiKey = apiKey;
    _baseOAuthEndpoint = baseOAuthEndpoint;
    _clientUID = clientUID;
    _clientSecret = clientSecret;
    _redirectUri = redirectUri;
    _refreshToken = refreshToken;
    _id = id;
    _isNew = isNew;
  }

  ApiSettings.fromJson(dynamic json) {
    _type = json['type'];
    _baseEndpoint = json['baseEndpoint'];
    _administrationCode = json['administrationCode'];
    _addToStock = json['addToStock'];
    _basicAuthorizationUser = json['basicAuthorizationUser'];
    _basicAuthorizationPassword = json['basicAuthorizationPassword'];
    _basicAuthorizationPasswordChanged =
        json['basicAuthorizationPasswordChanged'];
    _apiKey = json['apiKey'];
    _baseOAuthEndpoint = json['baseOAuthEndpoint'];
    _clientUID = json['clientUID'];
    _clientSecret = json['clientSecret'];
    _redirectUri = json['redirectUri'];
    _refreshToken = json['refreshToken'];
    _id = json['id'];
    _isNew = json['isNew'];
  }

  num? _type;
  String? _baseEndpoint;
  String? _administrationCode;
  bool? _addToStock;
  dynamic _basicAuthorizationUser;
  String? _basicAuthorizationPassword;
  bool? _basicAuthorizationPasswordChanged;
  dynamic _apiKey;
  String? _baseOAuthEndpoint;
  String? _clientUID;
  String? _clientSecret;
  String? _redirectUri;
  String? _refreshToken;
  num? _id;
  bool? _isNew;

  ApiSettings copyWith({
    num? type,
    String? baseEndpoint,
    String? administrationCode,
    bool? addToStock,
    dynamic basicAuthorizationUser,
    String? basicAuthorizationPassword,
    bool? basicAuthorizationPasswordChanged,
    dynamic apiKey,
    String? baseOAuthEndpoint,
    String? clientUID,
    String? clientSecret,
    String? redirectUri,
    String? refreshToken,
    num? id,
    bool? isNew,
  }) =>
      ApiSettings(
        type: type ?? _type,
        baseEndpoint: baseEndpoint ?? _baseEndpoint,
        administrationCode: administrationCode ?? _administrationCode,
        addToStock: addToStock ?? _addToStock,
        basicAuthorizationUser:
            basicAuthorizationUser ?? _basicAuthorizationUser,
        basicAuthorizationPassword:
            basicAuthorizationPassword ?? _basicAuthorizationPassword,
        basicAuthorizationPasswordChanged: basicAuthorizationPasswordChanged ??
            _basicAuthorizationPasswordChanged,
        apiKey: apiKey ?? _apiKey,
        baseOAuthEndpoint: baseOAuthEndpoint ?? _baseOAuthEndpoint,
        clientUID: clientUID ?? _clientUID,
        clientSecret: clientSecret ?? _clientSecret,
        redirectUri: redirectUri ?? _redirectUri,
        refreshToken: refreshToken ?? _refreshToken,
        id: id ?? _id,
        isNew: isNew ?? _isNew,
      );

  num? get type => _type;

  String? get baseEndpoint => _baseEndpoint;

  String? get administrationCode => _administrationCode;

  bool? get addToStock => _addToStock;

  dynamic get basicAuthorizationUser => _basicAuthorizationUser;

  String? get basicAuthorizationPassword => _basicAuthorizationPassword;

  bool? get basicAuthorizationPasswordChanged =>
      _basicAuthorizationPasswordChanged;

  dynamic get apiKey => _apiKey;

  String? get baseOAuthEndpoint => _baseOAuthEndpoint;

  String? get clientUID => _clientUID;

  String? get clientSecret => _clientSecret;

  String? get redirectUri => _redirectUri;

  String? get refreshToken => _refreshToken;

  num? get id => _id;

  bool? get isNew => _isNew;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['baseEndpoint'] = _baseEndpoint;
    map['administrationCode'] = _administrationCode;
    map['addToStock'] = _addToStock;
    map['basicAuthorizationUser'] = _basicAuthorizationUser;
    map['basicAuthorizationPassword'] = _basicAuthorizationPassword;
    map['basicAuthorizationPasswordChanged'] =
        _basicAuthorizationPasswordChanged;
    map['apiKey'] = _apiKey;
    map['baseOAuthEndpoint'] = _baseOAuthEndpoint;
    map['clientUID'] = _clientUID;
    map['clientSecret'] = _clientSecret;
    map['redirectUri'] = _redirectUri;
    map['refreshToken'] = _refreshToken;
    map['id'] = _id;
    map['isNew'] = _isNew;
    return map;
  }
}
