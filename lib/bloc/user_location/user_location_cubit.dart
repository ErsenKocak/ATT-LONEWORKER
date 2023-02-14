import 'package:bloc/bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';

import '../../core/init/locator.dart';
import '../../helpers/gps/gps_helper.dart';

class UserLocationCubit extends Cubit<LatLng?> {
  UserLocationCubit() : super(null);

  final _gpsHelper = getIt<GpsHelper>();

  Future<void> checkUserLocation() async {
    var gpsHelperResponse = await _gpsHelper.getLastKnownOrCurrentLocation();
    emit(LatLng(gpsHelperResponse.latitude, gpsHelperResponse.longitude));
  }
}
