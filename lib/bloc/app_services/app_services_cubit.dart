import 'dart:convert';

import 'package:att_loneworker/core/constants/app_services/app_services_constant.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/localization/localization_keys_constants.dart';
import '../../core/enums/storage/storage_keys_enum.dart';
import '../../core/init/locator.dart';
import '../../model/home_service_item/home_service_item.dart';
import '../../view/alarm_settings/alarm_settings_view.dart';
import '../../view/battery_settings/battery_settings_view.dart';
import '../../view/tilt_alert_settings/tilt_alert_settings_view.dart';

class AppServicesCubit extends Cubit<List<HomeServiceItem>> {
  AppServicesCubit() : super([]);

  final _logger = getIt<Logger>();
  List<HomeServiceItem> selectedHomeServices = [];
  List<HomeServiceItem> allHomeServices = appHomeServiceList;

  initializeServices() {
    Box homeServicesBox = Hive.box(SharedPreferencesKeys.HOME_SERVICES.name);

    var homeServicesStorageDataDummy =
        homeServicesBox.get(SharedPreferencesKeys.HOME_SERVICES.name);

    if (homeServicesStorageDataDummy != null) {
      List<HomeServiceItem> homeServicesStorageData = homeServicesBox
          .get(SharedPreferencesKeys.HOME_SERVICES.name)
          .cast<HomeServiceItem>();
      if (homeServicesStorageData != null) {
        selectedHomeServices = homeServicesStorageData;

        allHomeServices.forEach((element) {
          selectedHomeServices.forEach((selectedHomeService) {
            if (element.id == selectedHomeService.id) {
              element.isSelected = true;
            }
          });
        });
      }
    }
  }

  updateHomeServicesList({required List<HomeServiceItem> selectedServices}) {
    selectedHomeServices = selectedServices;
    _logger
        .w('selectedServices ${selectedHomeServices.map((e) => e.toJson())}');
    saveHomeServicesToHive();
    emitState();
  }

  saveHomeServicesToHive() async {
    Box homeServicesBox = Hive.box(SharedPreferencesKeys.HOME_SERVICES.name);
    homeServicesBox.put(
        SharedPreferencesKeys.HOME_SERVICES.name, selectedHomeServices);

    // List<HomeServiceItem> homeServicesStorageData =
    //     homeServicesBox.get(SharedPreferencesKeys.HOME_SERVICES.name);

    // _logger.w(
    //     'saveHomeServicesToHive ${homeServicesStorageData.map((e) => e?.toJson())}');
  }

  emitState() => emit([...selectedHomeServices]);
}
