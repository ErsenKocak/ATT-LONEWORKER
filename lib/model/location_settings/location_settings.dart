import '../base_model.dart';

class LocationAlarmSettings extends BaseModel {
  // @HiveField(0)
  bool? isLocationAlarmActive;
  // @HiveField(1)

  int? locationAlarmDuration;

  LocationAlarmSettings({
    this.isLocationAlarmActive,
    this.locationAlarmDuration,
  });

  LocationAlarmSettings.fromJson(Map<String, dynamic> json) {
    isLocationAlarmActive = json['isLocationAlarmActive'];

    locationAlarmDuration = json['locationAlarmDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isLocationAlarmActive'] = isLocationAlarmActive;

    data['locationAlarmDuration'] = locationAlarmDuration;

    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return LocationAlarmSettings.fromJson(json);
  }
}
