import 'dart:developer';

import 'package:att_loneworker/bloc/auth/auth_cubit.dart';
import 'package:att_loneworker/bloc/tilt_alarm_settings/tilt_alarm_settings_cubit.dart';
import 'package:att_loneworker/bloc/user_information/user_information_cubit.dart';
import 'package:att_loneworker/bloc/user_location/user_location_cubit.dart';
import 'package:att_loneworker/core/config/easy_loading/easy_loading_config.dart';
import 'package:att_loneworker/core/constants/routes/routes.dart';
import 'package:att_loneworker/core/constants/routes/routes_name.dart';
import 'package:att_loneworker/core/enums/storage/storage_keys_enum.dart';
import 'package:att_loneworker/core/init/locator.dart';
import 'package:att_loneworker/helpers/navigation/navigation_helper.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'bloc/alarm_settings/alarm_settings_cubit.dart';
import 'bloc/alarm_state/alarm_state_cubit.dart';
import 'bloc/app_services/app_services_cubit.dart';
import 'bloc/battery_settings/battery_settings_cubit.dart';
import 'bloc/location_settings/location_settings_cubit.dart';
import 'bloc/sensor_event/sensor_event_cubit.dart';
import 'bloc/user_adress/user_adress_cubit.dart';
import 'core/app/theme.dart';
import 'core/cache/shared_preferences_manager.dart';
import 'core/config/hive/hive_config.dart';
import 'core/constants/localization/localization_constants.dart';
import 'helpers/audio/audio_helper.dart';
import 'helpers/device_screen_info/device_info.dart';
import 'view/sensor/sensor_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig().setUp();
  await EasyLocalization.ensureInitialized();

  await setupLocator();
  configLoading();
  await SharedPreferencesManager.instance.init();

  // var isCleared = await SharedPreferencesManager.instance.clearCache();
  // log('isCleared $isCleared');

  // var isRemovedBatterySettings = await SharedPreferencesManager.instance
  //     .removeCacheStorage(key: SharedPreferencesKeys.BATTERY_SETTINGS);
  // log('isRemovedBatterySettings $isRemovedBatterySettings');
  // var isRemovedTiltSettings = await SharedPreferencesManager.instance
  //     .removeCacheStorage(key: SharedPreferencesKeys.TILT_SETTINGS);
  // log('isRemovedTiltSettings $isRemovedTiltSettings');

  // await Hive.box(SharedPreferencesKeys.TOKEN_STORAGE.name).clear();

  // await FlutterLogs.initLogs(
  //     logLevelsEnabled: [
  //       LogLevel.INFO,
  //     ],
  //     timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
  //     directoryStructure: DirectoryStructure.FOR_DATE,
  //     logTypesEnabled: ["Sensor"],
  //     logFileExtension: LogFileExtension.TXT,
  //     logsWriteDirectoryName: "SensorLogs",
  //     logsExportDirectoryName: "SensorLogs/Exported",
  //     debugFileOperations: true,
  //     isDebuggable: true);

  runApp(EasyLocalization(
      supportedLocales: LocalizationConstants.SUPPORTED_LOCALES,
      path: LocalizationConstants.LANG_PATH,
      fallbackLocale: LocalizationConstants.EN_LOCALE,
      child: const LoneWorkerApp()));
  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  // await HiveConfig().setUp();
  // await setupLocator();
  // if (NavigationHelper.navigatorKey.currentContext != null) {
  //   BlocProvider.of<AlarmSettingsCubit>(
  //           NavigationHelper.navigatorKey.currentContext!)
  //       .initializeAlarmSettings();
  //   BlocProvider.of<BatterySettingsCubit>(
  //           NavigationHelper.navigatorKey.currentContext!)
  //       .initializeBatteryAlarmSettings();
  //   BlocProvider.of<TiltAlarmSettingsCubit>(
  //           NavigationHelper.navigatorKey.currentContext!)
  //       .initializeTiltAlarmSettings();

  //   getIt<AudioPlayerHandler>().initializeStream();
  // }

  if (isTimeout) {
    print('Background Headless timeout ${DateTime.now()}');
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('Headless event received ${DateTime.now()}');
  print('[BackgroundFetch] Headless event received.');
  BackgroundFetch.finish(taskId);
}

class LoneWorkerApp extends StatefulWidget {
  const LoneWorkerApp({super.key});

  @override
  State<LoneWorkerApp> createState() => _LoneWorkerAppState();
}

class _LoneWorkerAppState extends State<LoneWorkerApp> {
  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    print('initPlatformState ${DateTime.now()}');
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            startOnBoot: true,
            forceAlarmManager: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      print('Event received ${DateTime.now()}');
      print("[BackgroundFetch] Event received $taskId");
      if (NavigationHelper.navigatorKey.currentContext != null) {
        BlocProvider.of<AlarmSettingsCubit>(
                NavigationHelper.navigatorKey.currentContext!)
            .initializeAlarmSettings();
        BlocProvider.of<BatterySettingsCubit>(
                NavigationHelper.navigatorKey.currentContext!)
            .initializeBatteryAlarmSettings();
        BlocProvider.of<TiltAlarmSettingsCubit>(
                NavigationHelper.navigatorKey.currentContext!)
            .initializeTiltAlarmSettings();

        getIt<AudioPlayerHandler>().initializeStream();
      }

      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      if (NavigationHelper.navigatorKey.currentContext != null) {
        BlocProvider.of<AlarmSettingsCubit>(
                NavigationHelper.navigatorKey.currentContext!)
            .initializeAlarmSettings();
        BlocProvider.of<BatterySettingsCubit>(
                NavigationHelper.navigatorKey.currentContext!)
            .initializeBatteryAlarmSettings();
        BlocProvider.of<TiltAlarmSettingsCubit>(
                NavigationHelper.navigatorKey.currentContext!)
            .initializeTiltAlarmSettings();

        getIt<AudioPlayerHandler>().initializeStream();
      }
      print('TASK TIMEOUT ${DateTime.now()}');
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('configure success ${DateTime.now()}');
    print('[BackgroundFetch] configure success: $status');

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AlarmStateCubit>(
            create: (context) => AlarmStateCubit(),
          ),
          BlocProvider<SensorEventCubit>(
            create: (context) => SensorEventCubit(),
          ),
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(),
          ),
          BlocProvider<AlarmSettingsCubit>(
            create: (context) => AlarmSettingsCubit(),
          ),
          BlocProvider<BatterySettingsCubit>(
            create: (context) => BatterySettingsCubit(),
          ),
          BlocProvider<TiltAlarmSettingsCubit>(
            create: (context) => TiltAlarmSettingsCubit(),
          ),
          BlocProvider<UserInformationCubit>(
            create: (context) => UserInformationCubit(),
          ),
          BlocProvider<AppServicesCubit>(
            create: (context) => AppServicesCubit(),
          ),
          BlocProvider<LocationSettingsCubit>(
            create: (context) => LocationSettingsCubit(),
          ),
          BlocProvider<UserAdressCubit>(
            create: (context) => UserAdressCubit(),
          ),
          BlocProvider<UserLocationCubit>(
            create: (context) => UserLocationCubit(),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (context, child) => MaterialApp(
            navigatorKey: NavigationHelper.navigatorKey,
            theme: getIt<AppTheme>().CSBSTheme,
            builder: EasyLoading.init(),
            title: 'Loneworker',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routes: appRoutes,
            initialRoute:
                Hive.box(SharedPreferencesKeys.TOKEN_STORAGE.name).isNotEmpty
                    ? AppRoutesNames.homeView
                    : AppRoutesNames.loginView,
          ),
        ));
  }
}
