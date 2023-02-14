import 'package:att_loneworker/core/constants/localization/localization_keys_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../toast/toast_helper.dart';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

class GpsHelper {
  // final ToastHelper() = getIt<ToastHelper>();
  checkGps() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      var result = await Geolocator.requestPermission();
      Logger().i('GPS Permission Result --> ${result.name}');
      if (result == LocationPermission.denied) {
        Logger().e(tr(LocalizationKeys.LOCATION_PERMISSION));
        ToastHelper()
            .showToast(message: tr(LocalizationKeys.LOCATION_PERMISSION));
        return Future.error('Location permissions are denied');
      }
    } else if (permission == LocationPermission.deniedForever) {
      // Logger().w('GPS Permission Result --> ${permission.name}');
      ToastHelper()
          .showToast(message: tr(LocalizationKeys.LOCATION_PERMISSION));
      return Future.error('Location permissions are denied forever.');
    } else if (permission == LocationPermission.whileInUse) {
      // Logger().w('GPS Permission Result --> ${permission.name}');

      return;
    }

    if (!(await Geolocator.isLocationServiceEnabled())) {
      ToastHelper()
          .showToast(message: tr(LocalizationKeys.LOCATION_PERMISSION));
      Logger().w('Konum Servisi Kapalı!');
      return Future.error('Location Service is Disabled');
    }
  }

  Future<Position> getCurrentLocation() async {
    await checkGps();
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<Position?> getLastKnownLocation() async {
    await checkGps();
    return Geolocator.getLastKnownPosition();
  }

  Future<LatLng> getLastKnownOrCurrentLocation(
      {Duration timeLimit = const Duration(seconds: 5)}) async {
    var lastKnown = await getLastKnownLocation();

    // Check if lastKnownLocation is older than our time limit.
    if (lastKnown != null &&
        lastKnown.timestamp != null &&
        DateTime.now().difference(lastKnown.timestamp!).compareTo(timeLimit) >
            0) {
      lastKnown = null;
    }
    lastKnown ??= await getCurrentLocation();

    Logger().i('GPS -- ${lastKnown.toJson()}');
    // if (lastKnown != null) {
    //   ToastHelper()
    //       .showToast(message: 'Konum Başarıyla Alındı', color: Colors.green);
    // }
    var latLng = LatLng(lastKnown.latitude, lastKnown.longitude);
    return latLng;
  }

  double calculateDistanceBetween(Position startPos, Position endPos) {
    return Geolocator.distanceBetween(startPos.latitude, startPos.longitude,
        endPos.latitude, endPos.longitude);
  }
}
