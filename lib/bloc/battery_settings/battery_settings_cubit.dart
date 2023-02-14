import 'package:att_loneworker/model/battery_settings/battery_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../core/cache/shared_preferences_manager.dart';
import '../../core/enums/storage/storage_keys_enum.dart';
import '../../core/init/locator.dart';
import '../../helpers/audio/audio_helper.dart';
import '../../helpers/battery/battery_helper.dart';

class BatterySettingsCubit extends Cubit<BatteryAlarmSettings> {
  BatterySettingsCubit() : super(BatteryAlarmSettings());
  final _logger = getIt<Logger>();
  final _batteryHelper = getIt<BatteryHelper>();
  final _audioPlayerHandler = getIt<AudioPlayerHandler>();
  BatteryAlarmSettings batteryAlarmSettings = BatteryAlarmSettings(
      isBatteryAlarmActive: false,
      batteryCondition: 30,
      batteryAlarmDuration: 10);

  initializeBatteryAlarmSettings() {
    BatteryAlarmSettings? sharedSettings = SharedPreferencesManager.instance
        .getJsonModel<BatteryAlarmSettings>(
            BatteryAlarmSettings(), SharedPreferencesKeys.BATTERY_SETTINGS);

    if (sharedSettings != null) batteryAlarmSettings = sharedSettings;

    setAlarmConfiguration();
    _logger.w('sharedSettings ${sharedSettings?.toJson()}');
    _logger.w('batteryAlarmSettings ${batteryAlarmSettings?.toJson()}');

    emitState();
  }

  emitState() => emit(BatteryAlarmSettings(
      isBatteryAlarmActive: batteryAlarmSettings.isBatteryAlarmActive,
      batteryCondition: batteryAlarmSettings.batteryCondition));

  saveBatteryAlarmSettingsToStorage() async {
    _logger.w('Saving Model ${batteryAlarmSettings.toJson()}');
    setAlarmConfiguration();
    var saveModel = await SharedPreferencesManager.instance
        .saveJsonModel<BatteryAlarmSettings>(
            SharedPreferencesKeys.BATTERY_SETTINGS, batteryAlarmSettings);

    _logger.w('isSavedModel ${saveModel}');

    emitState();
  }

  setAlarmConfiguration() {
    if (batteryAlarmSettings.isBatteryAlarmActive == true) {
      _batteryHelper.initializeStreams();
      _batteryHelper.listenBattery(batteryAlarmSettings: batteryAlarmSettings);
    } else {
      _logger.w(
          '_audioPlayerHandler.isPlaying ${_audioPlayerHandler.playerIsPlaying()}');
      if (_audioPlayerHandler.playerIsPlaying() == true) {
        _audioPlayerHandler.playerStop();
      }

      _batteryHelper.disposeStreams();
    }
  }
}
