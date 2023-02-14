import 'dart:convert';
import 'dart:developer';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/base_model.dart';
import '../enums/storage/storage_keys_enum.dart';

class SharedPreferencesManager {
  static final SharedPreferencesManager _instance =
      SharedPreferencesManager._init();

  SharedPreferences? _preferences;
  static SharedPreferencesManager get instance => _instance;

  Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  SharedPreferencesManager._init() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
    });
  }

  Future<bool> saveStringValue(SharedPreferencesKeys key, String value) async {
    return await _preferences!.setString(key.name, value);
  }

  Future<bool> saveBoolValue(SharedPreferencesKeys key, bool value) async {
    return await _preferences!.setBool(key.name, value);
  }

  bool? getBoolValue(SharedPreferencesKeys key) =>
      _preferences!.getBool(key.name);

  String? getStringValue(SharedPreferencesKeys key) =>
      _preferences!.getString(key.toString());

  Future<bool?> saveJsonModel<T>(SharedPreferencesKeys key, T model) async {
    var json = jsonEncode(model);
    return await _preferences!.setString(key.name, json);
  }

  T? getJsonModel<T extends BaseModel>(T model, SharedPreferencesKeys key) {
    var jsonString = _preferences!.getString(key.name);
    log('jsonString $jsonString');
    if (jsonString != null) {
      var jsonModel = jsonDecode(jsonString);
      if (jsonModel is Map) {
        log('jsonModel is Map');
        log('jsonModel $jsonModel');
        log('model $model');
        return model.fromJson(jsonModel as Map<String, dynamic>);
      }
      //  else if (jsonModel is List) {
      //   Logger().w('SHARED LİST-->');
      //   return jsonModel.map((e) => model.fromJson(e)).toList().cast();
      // }

      else {
        return jsonModel;
      }
    } else {
      Logger().d('JSON STRİNG NULL');
      return null;
    }
  }

  Future<bool?> clearCache() async {
    return await _preferences?.clear();
  }

  Future<bool?> removeCacheStorage({required SharedPreferencesKeys key}) async {
    return await _preferences?.remove(key.name);
  }
}
