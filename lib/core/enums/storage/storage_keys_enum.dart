enum SharedPreferencesKeys {
  TOKEN_STORAGE,
  REMEMBER_ME,
  USER_INFORMATION,
  UNIT_STORAGE,
  OFFLINE_PROCESS,
  ALARM_SETTINGS,
  BATTERY_SETTINGS,
  TILT_SETTINGS,
  HOME_SERVICES
}

extension LocalStorageKeyExtension on SharedPreferencesKeys {
  String get getLocalStorageValue {
    switch (this) {
      case SharedPreferencesKeys.TOKEN_STORAGE:
        return SharedPreferencesKeys.TOKEN_STORAGE.name;
      case SharedPreferencesKeys.REMEMBER_ME:
        return SharedPreferencesKeys.REMEMBER_ME.name;
      case SharedPreferencesKeys.USER_INFORMATION:
        return SharedPreferencesKeys.USER_INFORMATION.name;
      case SharedPreferencesKeys.UNIT_STORAGE:
        return SharedPreferencesKeys.UNIT_STORAGE.name;
      case SharedPreferencesKeys.OFFLINE_PROCESS:
        return SharedPreferencesKeys.OFFLINE_PROCESS.name;
      case SharedPreferencesKeys.ALARM_SETTINGS:
        return SharedPreferencesKeys.ALARM_SETTINGS.name;
      case SharedPreferencesKeys.BATTERY_SETTINGS:
        return SharedPreferencesKeys.BATTERY_SETTINGS.name;
      case SharedPreferencesKeys.TILT_SETTINGS:
        return SharedPreferencesKeys.TILT_SETTINGS.name;
      case SharedPreferencesKeys.HOME_SERVICES:
        return SharedPreferencesKeys.HOME_SERVICES.name;
      default:
        return '';
    }
  }
}
