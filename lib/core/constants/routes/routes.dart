import 'package:att_loneworker/core/constants/routes/routes_name.dart';
import 'package:att_loneworker/view/alarm_settings/alarm_settings_view.dart';
import 'package:att_loneworker/view/battery_settings/battery_settings_view.dart';
import 'package:att_loneworker/view/home/home.dart';
import 'package:att_loneworker/view/location_settings/location_settings_view.dart';
import 'package:att_loneworker/view/sensor/sensor_view.dart';
import 'package:att_loneworker/view/settings/settings_view.dart';
import 'package:att_loneworker/view/tilt_alert_settings/tilt_alert_settings_view.dart';

import '../../../view/login/login.dart';

var appRoutes = {
  AppRoutesNames.loginView: (context) => (const LoginView()),
  AppRoutesNames.homeView: (context) => (const HomeView()),
  AppRoutesNames.settingsView: (context) => (const SettingsView()),
  AppRoutesNames.sensorView: (context) => (const SensorView()),
  AppRoutesNames.alarmSettingsView: (context) => (const AlarmSettingsView()),
  AppRoutesNames.batterySettingsView: (context) =>
      (const BatterySettingsView()),
  AppRoutesNames.tiltAlertSettingsView: (context) =>
      (const TiltAlertSettingsView()),
  AppRoutesNames.locationSettingsSettingsView: (context) =>
      (const LocationSettingsView()),
};
