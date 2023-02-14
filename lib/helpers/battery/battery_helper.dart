import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:att_loneworker/bloc/alarm_settings/alarm_settings_cubit.dart';
import 'package:att_loneworker/bloc/battery_settings/battery_settings_cubit.dart';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/enums/charging_status.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:battery_info/model/iso_battery_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:once/once.dart';

import '../../core/init/locator.dart';
import '../../model/battery_settings/battery_settings.dart';
import '../audio/audio_helper.dart';
import '../navigation/navigation_helper.dart';

class BatteryHelper {
  late Stream<AndroidBatteryInfo?> androidBatteryStream;
  late Stream<IosBatteryInfo?>? iosBatteryStream;
  StreamSubscription<AndroidBatteryInfo?>? androidBatteryStreamSub;
  StreamSubscription<IosBatteryInfo?>? iosBatteryStreamSub;
  final AudioPlayerHandler _audioPlayerHandler = getIt<AudioPlayerHandler>();
  final NavigationHelper _navigationHelper = getIt<NavigationHelper>();
  late AlarmSettingsCubit _alarmSettingsCubit;
  final _logger = getIt<Logger>();
  late ChargingStatus batteryChargingStatus;

  listenBattery({required BatteryAlarmSettings batteryAlarmSettings}) {
    log('androidBatteryStream $androidBatteryStream');
    log('iosBatteryStream $iosBatteryStream');
    if (Platform.isAndroid && androidBatteryStream != null) {
      log('Platform.isAndroid');

      androidBatteryStreamSub = androidBatteryStream.listen((event) {
        log('androidBatteryInfoStream ${event?.toJson()}');
        soundAlarm(
            batteryAlarmSettings: batteryAlarmSettings,
            batteryLevel: event?.batteryLevel,
            chargingStatus: event?.chargingStatus ?? ChargingStatus.Unknown);
        batteryChargingStatus = event?.chargingStatus ?? ChargingStatus.Unknown;
      });
    } else if (Platform.isIOS && iosBatteryStream != null) {
      log('Platform.isIOS');
      iosBatteryStreamSub = iosBatteryStream?.listen((event) {
        log('iosBatteryInfoStream ${event?.toJson()}');
        soundAlarm(
            batteryAlarmSettings: batteryAlarmSettings,
            batteryLevel: event?.batteryLevel,
            chargingStatus: event?.chargingStatus ?? ChargingStatus.Unknown);
        batteryChargingStatus = event?.chargingStatus ?? ChargingStatus.Unknown;
      });
    }
  }

  initializeStreams() {
    androidBatteryStream = BatteryInfoPlugin().androidBatteryInfoStream;
    iosBatteryStream = BatteryInfoPlugin().iosBatteryInfoStream;
    if (NavigationHelper.navigatorKey.currentContext != null) {
      _alarmSettingsCubit =
          BlocProvider.of(NavigationHelper.navigatorKey.currentContext!);
    }
  }

  disposeStreams() {
    log('disposeStreams');
    log('androidBatteryStreamSub $androidBatteryStreamSub');

    if (Platform.isAndroid) {
      log('Platform.isAndroid');
      androidBatteryStreamSub?.cancel();
    } else if (Platform.isIOS) {
      log('Platform.isIOS');
      iosBatteryStreamSub?.cancel();
    }
    log('SUBS NULL');
  }

  soundAlarm(
      {required BatteryAlarmSettings batteryAlarmSettings,
      int? batteryLevel,
      required ChargingStatus chargingStatus}) async {
    // var loopModeResponse = await _audioPlayerHandler.setLoopmode(LoopMode.);
    // log('loopModeResponse $loopModeResponse');
    _logger.w('batteryLevel $batteryLevel');
    _logger
        .w('settedBatteryAlarmLevel ${batteryAlarmSettings.batteryCondition}');
    _logger.w(
        '_alarmSettingsCubit.alarmSettings.isAlarmActive ${_alarmSettingsCubit.alarmSettings.isAlarmActive}');
    if (_alarmSettingsCubit.alarmSettings.isAlarmActive == true) {
      _logger.w('ChargingStatus $chargingStatus');
      _logger.w(
          'isDisableAlarmIsCharging ${_alarmSettingsCubit.alarmSettings.isDisableAlarmIsCharging}');
      if (chargingStatus == ChargingStatus.Charging &&
          _alarmSettingsCubit.alarmSettings.isDisableAlarmIsCharging == true) {
        if (_audioPlayerHandler.playerIsPlaying() == true) {
          _audioPlayerHandler.playerStop();
          _logger
              .w('_playerState 2 -- ${_audioPlayerHandler.playerIsPlaying()}');
        }
        return;
      }

      if (batteryLevel != null &&
          batteryLevel <= batteryAlarmSettings.batteryCondition!) {
        Once.runCustom('batteryAlarm',
            duration:
                Duration(seconds: batteryAlarmSettings.batteryAlarmDuration!),
            debugCallback: false, callback: () {
          log('_audioPlayerHandler.playerIsPlaying() ${_audioPlayerHandler.playerIsPlaying()}');
          if (_audioPlayerHandler.playerIsPlaying() == false) {
            _audioPlayerHandler.play();

            _logger.w(
                '_playerState !!! -- ${_audioPlayerHandler.playerIsPlaying()}');
          }
        });
      } else {
        if (_audioPlayerHandler.playerIsPlaying() == true) {
          _audioPlayerHandler.playerStop();
          _logger
              .w('_playerState 2 -- ${_audioPlayerHandler.playerIsPlaying()}');
        }
      }
    } else {
      if (_audioPlayerHandler.playerIsPlaying() == true) {
        _audioPlayerHandler.playerStop();
        _logger.w('_playerState 2 -- ${_audioPlayerHandler.playerIsPlaying()}');
      }
    }
  }
}
