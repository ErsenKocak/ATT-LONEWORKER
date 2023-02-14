import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/constants.dart';
import '../base_model.dart';

// @HiveType(typeId: ALARM_SETTINGS_ID)
class AlarmSettings extends BaseModel {
  // @HiveField(0)
  bool? isAlarmActive;
  // @HiveField(1)
  bool? isSOSAlarmActive;
  // @HiveField(2)
  int? durationOfAlarm;

  bool? isDisableAlarmIsCharging;

  int? alarmVolume;

  AlarmSettings(
      {this.isAlarmActive,
      this.isSOSAlarmActive,
      this.durationOfAlarm,
      this.isDisableAlarmIsCharging,
      this.alarmVolume});

  AlarmSettings.fromJson(Map<String, dynamic> json) {
    isAlarmActive = json['isAlarmActive'];
    isSOSAlarmActive = json['isSOSAlarmActive'];
    durationOfAlarm = json['durationOfAlarm'];
    isDisableAlarmIsCharging = json['isDisableAlarmIsCharging'];
    alarmVolume = json['alarmVolume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isAlarmActive'] = isAlarmActive;
    data['isSOSAlarmActive'] = isSOSAlarmActive;
    data['durationOfAlarm'] = durationOfAlarm;
    data['isDisableAlarmIsCharging'] = isDisableAlarmIsCharging;
    data['alarmVolume'] = alarmVolume;
    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return AlarmSettings.fromJson(json);
  }
}
