import 'package:att_loneworker/core/cache/shared_preferences_manager.dart';
import 'package:att_loneworker/core/constants/localization/localization_keys_constants.dart';
import 'package:att_loneworker/core/enums/storage/storage_keys_enum.dart';
import 'package:att_loneworker/model/alarm_settings/alarm_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../core/init/locator.dart';
import '../../helpers/accelerometer/accelerometer_helper.dart';
import '../../helpers/audio/audio_helper.dart';

class AlarmSettingsCubit extends Cubit<AlarmSettings> {
  AlarmSettingsCubit() : super(AlarmSettings());
  final _logger = getIt<Logger>();
  final _audioPlayerHandler = getIt<AudioPlayerHandler>();
  final _accelerometerHelper = getIt<AccelerometerHelper>();
  AlarmSettings alarmSettings = AlarmSettings(
      alarmVolume: 50,
      durationOfAlarm: 30,
      isAlarmActive: false,
      isDisableAlarmIsCharging: false,
      isSOSAlarmActive: true);

  initializeAlarmSettings() {
    AlarmSettings? sharedSettings = SharedPreferencesManager.instance
        .getJsonModel<AlarmSettings>(
            AlarmSettings(), SharedPreferencesKeys.ALARM_SETTINGS);

    if (sharedSettings != null) alarmSettings = sharedSettings;

    _audioPlayerHandler.setPlayerVolume(
        volume: alarmSettings.alarmVolume! / 10);
    setAlarmConfiguration();
    _logger.w('sharedSettings ${sharedSettings?.toJson()}');
    _logger.w('alarmSettings ${alarmSettings?.toJson()}');

    emitState();
  }

  saveAlarmSettingsToStorage() async {
    setAlarmConfiguration();
    var saveModel = await SharedPreferencesManager.instance
        .saveJsonModel<AlarmSettings>(
            SharedPreferencesKeys.ALARM_SETTINGS, alarmSettings);
    _audioPlayerHandler.setPlayerVolume(
        volume: alarmSettings.alarmVolume! / 10);

    _logger.w('saveModel ${saveModel}');

    emitState();
  }

  setAlarmConfiguration() {
    _logger.w('alarmSettings.isAlarmActive ${alarmSettings.isAlarmActive}');
    if (alarmSettings.isAlarmActive == true) {
      _accelerometerHelper.initializeStream();
      _accelerometerHelper.listenDeviceAccelerometerSensor();
    } else {
      if (_audioPlayerHandler.playerIsPlaying() == true) {
        _audioPlayerHandler.playerStop();
      }
      _accelerometerHelper.disposeStream();
    }
  }

  emitState() => emit(AlarmSettings(
      alarmVolume: alarmSettings.alarmVolume,
      durationOfAlarm: alarmSettings.durationOfAlarm,
      isAlarmActive: alarmSettings.isAlarmActive,
      isDisableAlarmIsCharging: alarmSettings.isDisableAlarmIsCharging,
      isSOSAlarmActive: alarmSettings.isSOSAlarmActive));
}
