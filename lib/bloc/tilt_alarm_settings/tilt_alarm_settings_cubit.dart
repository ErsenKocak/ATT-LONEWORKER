import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../core/cache/shared_preferences_manager.dart';
import '../../core/enums/storage/storage_keys_enum.dart';
import '../../core/init/locator.dart';
import '../../helpers/audio/audio_helper.dart';
import '../../helpers/tilt_alarm_helper/tilt_alarm_helper.dart';
import '../../model/tilt_alarm_settings/tilt_alarm_settings.dart';

class TiltAlarmSettingsCubit extends Cubit<TiltAlarmSettings> {
  TiltAlarmSettingsCubit() : super(TiltAlarmSettings());
  final _logger = getIt<Logger>();
  final _audioPlayerHandler = getIt<AudioPlayerHandler>();
  final _tiltAlarmHelper = getIt<TiltAlarmHelper>();
  TiltAlarmSettings tiltAlarmSettings = TiltAlarmSettings(
      isTiltAlarmActive: false,
      tiltAngle: 0,
      durationOfTiltAlarmSituation: 60,
      durationOfThePreAlarm: 30);

  initializeTiltAlarmSettings() {
    TiltAlarmSettings? sharedSettings = SharedPreferencesManager.instance
        .getJsonModel<TiltAlarmSettings>(
            TiltAlarmSettings(), SharedPreferencesKeys.TILT_SETTINGS);

    if (sharedSettings != null) tiltAlarmSettings = sharedSettings;

    setAlarmConfiguration();
    _logger.w('sharedSettings ${sharedSettings?.toJson()}');
    _logger.w('tiltAlarmSettings ${tiltAlarmSettings?.toJson()}');

    emitState();
  }

  saveTiltAlarmSettingsToStorage() async {
    setAlarmConfiguration();
    _logger.i('SAVING MODEL  ${tiltAlarmSettings.toJson()}');
    var saveModel = await SharedPreferencesManager.instance
        .saveJsonModel<TiltAlarmSettings>(
            SharedPreferencesKeys.TILT_SETTINGS, tiltAlarmSettings);

    _logger.w('saveModel ${saveModel}');

    emitState();
  }

  setAlarmConfiguration() {
    if (tiltAlarmSettings.isTiltAlarmActive == true) {
      _tiltAlarmHelper.initializeStream();
      _tiltAlarmHelper.listenDeviceMotionSensor();
    } else {
      _logger.w(
          '_audioPlayerHandler.isPlaying ${_audioPlayerHandler.playerIsPlaying()}');
      if (_audioPlayerHandler.playerIsPlaying() == true) {
        _audioPlayerHandler.playerStop();
      }

      _tiltAlarmHelper.disposeStream();
    }
  }

  emitState() => emit(TiltAlarmSettings(
      isTiltAlarmActive: tiltAlarmSettings.isTiltAlarmActive,
      tiltAngle: tiltAlarmSettings.tiltAngle,
      durationOfTiltAlarmSituation:
          tiltAlarmSettings.durationOfTiltAlarmSituation,
      durationOfThePreAlarm: tiltAlarmSettings.durationOfThePreAlarm));
}
