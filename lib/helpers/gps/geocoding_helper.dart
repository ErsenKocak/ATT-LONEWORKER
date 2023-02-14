import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

import '../../core/init/locator.dart';

class GeoCodingHelper {
  final _logger = getIt<Logger>();

  Future<String?> getAddressFromLatLng(LatLng? latLng) async {
    if (latLng != null) {
      return await placemarkFromCoordinates(latLng.latitude, latLng.longitude)
          .then((List<Placemark> placemarks) {
        Placemark place = placemarks[0];
        var currentAddress =
            '${place.street}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}';

        _logger.w('GeocodingHelper -- getAddressFromLatLng -- $currentAddress');
        _logger.w(
            'GeocodingHelper -- Placemark -- getAddressFromLatLng -- ${place.toJson()}');
        return currentAddress;
      }).catchError((error) {
        _logger.e('GeocodingHelper -- getAddressFromLatLng -- $error');
        return '';
      });
    } else {
      return '';
    }
  }
}
