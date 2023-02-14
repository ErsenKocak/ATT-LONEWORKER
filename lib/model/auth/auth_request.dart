import 'package:att_loneworker/core/constants/constants.dart';
import 'package:att_loneworker/model/base_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'auth_request.g.dart';

@HiveType(typeId: AUTH_REQUEST_ID)
class AuthRequest extends BaseModel {
  @HiveField(0)
  String? username;
  @HiveField(1)
  String? password;

  AuthRequest({this.username, this.password});

  AuthRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return AuthRequest.fromJson(json);
  }
}
