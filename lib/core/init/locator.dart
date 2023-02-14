import 'package:att_loneworker/helpers/functions/app_functions.dart';
import 'package:att_loneworker/helpers/gps/gps_helper.dart';
import 'package:att_loneworker/service/auth/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../helpers/accelerometer/accelerometer_helper.dart';
import '../../helpers/audio/audio_helper.dart';
import '../../helpers/battery/battery_helper.dart';
import '../../helpers/dialog/dialog_helper.dart';
import '../../helpers/gps/geocoding_helper.dart';
import '../../helpers/navigation/navigation_helper.dart';
import '../../helpers/network/connectivity/connectivity_helper.dart';
import '../../helpers/network/network_connection/network_connection_helper.dart';
import '../../helpers/tilt_alarm_helper/tilt_alarm_helper.dart';
import '../../helpers/toast/toast_helper.dart';
import '../app/theme.dart';
import '../constants/constants.dart';

final getIt = GetIt.instance;

Future setupLocator() async {
  //NETWORK
  getIt.registerSingleton<Dio>(Dio(BaseOptions(
      baseUrl: BASE_URL,
      contentType: 'application/json',
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000)));

  //LOG
  getIt.registerSingleton<Logger>(Logger());

  getIt.registerSingleton<AppTheme>(AppTheme());

  //SERVICE

  getIt.registerSingleton<AuthService>(AuthService());

  //HELPERS
  getIt.registerSingleton<ToastHelper>(ToastHelper());
  getIt.registerSingleton<DialogHelper>(DialogHelper());
  getIt.registerSingleton<AppFunctionsHelper>(AppFunctionsHelper());
  getIt.registerSingleton<NavigationHelper>(NavigationHelper());
  getIt.registerSingleton<AudioPlayerHandler>(AudioPlayerHandler());
  getIt.registerSingleton<BatteryHelper>(BatteryHelper());
  getIt.registerSingleton<TiltAlarmHelper>(TiltAlarmHelper());
  getIt.registerSingleton<AccelerometerHelper>(AccelerometerHelper());
  getIt.registerSingleton<NetworkConnectionHelper>(NetworkConnectionHelper());
  getIt.registerSingleton<ConnectivityHelper>(ConnectivityHelper());
  getIt.registerSingleton<GpsHelper>(GpsHelper());
  getIt.registerSingleton<GeoCodingHelper>(GeoCodingHelper());
}
