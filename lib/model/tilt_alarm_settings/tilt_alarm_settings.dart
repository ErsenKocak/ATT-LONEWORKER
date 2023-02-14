import '../base_model.dart';

class TiltAlarmSettings extends BaseModel {
  // @HiveField(0)
  bool? isTiltAlarmActive;
  // @HiveField(1)
  int? tiltAngle;
  int? durationOfTiltAlarmSituation;
  int? durationOfThePreAlarm;

  TiltAlarmSettings({
    this.isTiltAlarmActive,
    this.tiltAngle,
    this.durationOfTiltAlarmSituation,
    this.durationOfThePreAlarm,
  });

  TiltAlarmSettings.fromJson(Map<String, dynamic> json) {
    isTiltAlarmActive = json['isTiltAlarmActive'];
    tiltAngle = json['tiltAngle'];
    durationOfTiltAlarmSituation = json['durationOfTiltAlarmSituation'];
    durationOfThePreAlarm = json['durationOfThePreAlarm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isTiltAlarmActive'] = isTiltAlarmActive;
    data['tiltAngle'] = tiltAngle;
    data['durationOfTiltAlarmSituation'] = durationOfTiltAlarmSituation;
    data['durationOfThePreAlarm'] = durationOfThePreAlarm;

    return data;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return TiltAlarmSettings.fromJson(json);
  }
}
