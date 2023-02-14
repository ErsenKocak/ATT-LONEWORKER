import 'package:att_loneworker/model/base_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/constants.dart';

part 'user_information.g.dart';

@HiveType(typeId: USER_INFORMATION_ID)
class UserInformation extends BaseModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? companyId;
  @HiveField(2)
  String? firstname;
  @HiveField(3)
  String? lastname;
  @HiveField(4)
  String? username;
  @HiveField(5)
  String? language;
  @HiveField(6)
  String? deviceUuid;
  @HiveField(7)
  String? deviceType;

  UserInformation(
      {this.id,
      this.companyId,
      this.firstname,
      this.lastname,
      this.username,
      this.language,
      this.deviceUuid,
      this.deviceType});

  UserInformation.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    companyId = json['CompanyId'];
    firstname = json['Firstname'];
    lastname = json['Lastname'];
    username = json['Username'];
    language = json['Language'];
    deviceUuid = json['DeviceUuid'];
    deviceType = json['DeviceType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = id;
    data['CompanyId'] = companyId;
    data['Firstname'] = firstname;
    data['Lastname'] = lastname;
    data['Username'] = username;
    data['Language'] = language;
    data['DeviceUuid'] = deviceUuid;
    data['DeviceType'] = deviceType;
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return UserInformation.fromJson(json);
  }
}
