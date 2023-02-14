import 'package:att_loneworker/model/base_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/constants.dart';
part 'home_service_item.g.dart';

@HiveType(typeId: HOME_SERVICES_ID)
class HomeServiceItem extends BaseModel {
  @HiveField(0)
  String? title;
  @HiveField(1)
  int? iconCode;
  @HiveField(2)
  int? iconColorValue;
  @HiveField(3)
  String? navigateScreen;
  @HiveField(4)
  bool? isSelected;
  @HiveField(5)
  int? id;

  HomeServiceItem(
      {this.id,
      this.title,
      this.iconCode,
      this.navigateScreen,
      this.isSelected,
      this.iconColorValue});

  HomeServiceItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    iconCode = json['iconCode'];
    iconColorValue = json['iconColorValue'];
    navigateScreen = json['navigateScreen'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['iconCode'] = iconCode;
    data['iconColorValue'] = iconColorValue;
    data['navigateScreen'] = navigateScreen;
    data['isSelected'] = isSelected;

    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return HomeServiceItem.fromJson(json);
  }
}
