import 'package:att_loneworker/model/base_model.dart';
import 'package:hive/hive.dart';

import '../../core/constants/constants.dart';
part 'auth_response.g.dart';

@HiveType(typeId: AUTH_RESPONSE_ID)
class AuthResponse extends BaseModel {
  @HiveField(0)
  String? accessToken;
  @HiveField(1)
  String? tokenType;
  @HiveField(2)
  int? expiresIn;

  AuthResponse({this.accessToken, this.tokenType, this.expiresIn});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return AuthResponse.fromJson(json);
  }
}
