import 'dart:async';
import 'dart:developer';

import 'package:att_loneworker/bloc/battery_settings/battery_settings_cubit.dart';
import 'package:battery_info/enums/charging_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:once/once.dart';

import 'package:sensors_plus/sensors_plus.dart';

import '../../bloc/alarm_settings/alarm_settings_cubit.dart';
import '../../core/init/locator.dart';
import '../audio/audio_helper.dart';
import '../battery/battery_helper.dart';
import '../functions/app_functions.dart';
import '../navigation/navigation_helper.dart';

class AccelerometerHelper {
  StreamSubscription<AccelerometerEvent>? _accelerometerSub;
  final _logger = getIt<Logger>();
  final _appFunctionsHelper = getIt<AppFunctionsHelper>();
  final _batteryHelper = getIt<BatteryHelper>();
  final AudioPlayerHandler _audioPlayerHandler = getIt<AudioPlayerHandler>();
  late AlarmSettingsCubit _alarmSettingsCubit;

  listenDeviceAccelerometerSensor() {
    _accelerometerSub =
        accelerometerEvents.listen((AccelerometerEvent event) async {
      _logger.w('accelerometer listen');
      soundAlarm(accelerometerEvent: event);
    });
  }

  initializeStream() {
    if (NavigationHelper.navigatorKey.currentContext != null) {
      _alarmSettingsCubit =
          BlocProvider.of(NavigationHelper.navigatorKey.currentContext!);
    }
  }

  soundAlarm({required AccelerometerEvent accelerometerEvent}) async {
    if (_alarmSettingsCubit.alarmSettings.isDisableAlarmIsCharging == true &&
        _batteryHelper.batteryChargingStatus == ChargingStatus.Charging) return;

    if (_alarmSettingsCubit.alarmSettings.isAlarmActive == true) {
      if (accelerometerEvent.x < -6 || accelerometerEvent.y > 11) {
        // log('DÜŞÜYOR');
        DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
        _logger.wtf(
            'accelerometerEvent -- soundAlarm -- ${accelerometerEvent} -- DATE -- ${dateFormat.format(DateTime.now())}');
        Once.runCustom('tiltAlarm',
            duration: Duration(
                seconds:
                    _alarmSettingsCubit.alarmSettings.durationOfAlarm ?? 600),
            debugCallback: false, callback: () {
          _logger.w('Date ${DateTime.now()}');

          if (_audioPlayerHandler.playerIsPlaying() == false) {
            _audioPlayerHandler.play();
            _logger.w(
                '_playerState !!! -- ${_audioPlayerHandler.playerIsPlaying()}');
          }
        });
      }
    }
  }

  disposeStream() => _accelerometerSub?.cancel();
}
