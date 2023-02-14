import 'package:att_loneworker/core/enums/storage/storage_keys_enum.dart';
import 'package:att_loneworker/model/auth/auth_response.dart';
import 'package:att_loneworker/model/home_service_item/home_service_item.dart';
import 'package:att_loneworker/model/user/user_information/user_information.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveConfig {
  Future<void> setUp() async {
    await Hive.initFlutter();

    Hive.registerAdapter(AuthResponseAdapter());
    Hive.registerAdapter(UserInformationAdapter());
    Hive.registerAdapter(HomeServiceItemAdapter());

    await Hive.openBox(SharedPreferencesKeys.TOKEN_STORAGE.name);
    await Hive.openBox(SharedPreferencesKeys.USER_INFORMATION.name);
    await Hive.openBox(SharedPreferencesKeys.REMEMBER_ME.name);
    await Hive.openBox(SharedPreferencesKeys.HOME_SERVICES.name);
  }
}
