import '../base_model.dart';

class BatteryAlarmSettings extends BaseModel {
  // @HiveField(0)
  bool? isBatteryAlarmActive;
  // @HiveField(1)
  int? batteryCondition;
  int? batteryAlarmDuration;

  BatteryAlarmSettings({
    this.isBatteryAlarmActive,
    this.batteryCondition,
    this.batteryAlarmDuration,
  });

  BatteryAlarmSettings.fromJson(Map<String, dynamic> json) {
    isBatteryAlarmActive = json['isBatteryAlarmActive'];
    batteryCondition = json['batteryCondition'];
    batteryAlarmDuration = json['batteryAlarmDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isBatteryAlarmActive'] = isBatteryAlarmActive;
    data['batteryCondition'] = batteryCondition;
    data['batteryAlarmDuration'] = batteryAlarmDuration;

    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return BatteryAlarmSettings.fromJson(json);
  }
}
