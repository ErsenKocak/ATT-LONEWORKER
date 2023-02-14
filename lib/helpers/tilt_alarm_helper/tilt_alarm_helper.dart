import 'dart:async';

import 'package:att_loneworker/bloc/tilt_alarm_settings/tilt_alarm_settings_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:once/once.dart';

import '../../bloc/alarm_settings/alarm_settings_cubit.dart';
import '../../core/init/locator.dart';
import '../audio/audio_helper.dart';
import '../functions/app_functions.dart';
import '../navigation/navigation_helper.dart';

class TiltAlarmHelper {
  StreamSubscription<AbsoluteOrientationEvent>?
      _motionSensorAbsoluteOrientationSub;
  late TiltAlarmSettingsCubit _tiltAlarmSettingsCubit;
  late AlarmSettingsCubit _alarmSettingsCubit;
  final _logger = getIt<Logger>();
  final _appFunctionsHelper = getIt<AppFunctionsHelper>();
  final AudioPlayerHandler _audioPlayerHandler = getIt<AudioPlayerHandler>();

  listenDeviceMotionSensor() {
    _motionSensorAbsoluteOrientationSub = motionSensors.absoluteOrientation
        .listen((AbsoluteOrientationEvent event) {
      soundAlarm(
          degree:
              _appFunctionsHelper.convertRadianToDegree(radian: event.pitch));
    });
  }

  initializeStream() {
    if (NavigationHelper.navigatorKey.currentContext != null) {
      _tiltAlarmSettingsCubit =
          BlocProvider.of(NavigationHelper.navigatorKey.currentContext!);
      _alarmSettingsCubit =
          BlocProvider.of(NavigationHelper.navigatorKey.currentContext!);
    }
  }

  disposeStream() => _motionSensorAbsoluteOrientationSub?.cancel();

  soundAlarm({required int degree}) async {
    // print('Degree $degree');
    // await _audioPlayerHandler.setLoopmode(LoopMode.one);

    if (_tiltAlarmSettingsCubit.tiltAlarmSettings.isTiltAlarmActive == true &&
        _tiltAlarmSettingsCubit.tiltAlarmSettings.tiltAngle != 0 &&
        degree < _tiltAlarmSettingsCubit.tiltAlarmSettings.tiltAngle! &&
        _alarmSettingsCubit.alarmSettings.isAlarmActive == true) {
      _logger.wtf('Degree $degree');
      Once.runCustom('tiltAlarm',
          duration: Duration(
              seconds: _tiltAlarmSettingsCubit
                      .tiltAlarmSettings.durationOfTiltAlarmSituation ??
                  600),
          debugCallback: false, callback: () {
        print('Once.runHourly');
        _logger.w('Date ${DateTime.now()}');
        _logger.w('motion sensor degree ${degree}');
        _logger.w(
            'tiltSettings degree ${_tiltAlarmSettingsCubit.tiltAlarmSettings.tiltAngle}');
        if (_audioPlayerHandler.playerIsPlaying() == false) {
          _audioPlayerHandler.play();
          _logger.w(
              '_playerState !!! -- ${_audioPlayerHandler.playerIsPlaying()}');
        }
      });
    }

    // else {
    //   if (_audioPlayerHandler.playerIsPlaying() == true) {
    //     _audioPlayerHandler.playerStop();
    //   }
    // }
  }
}
