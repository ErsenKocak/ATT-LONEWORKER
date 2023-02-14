import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../core/init/locator.dart';
import '../../helpers/gps/geocoding_helper.dart';
import '../../helpers/gps/gps_helper.dart';

class UserAdressCubit extends Cubit<String> {
  UserAdressCubit() : super('');

  final _geoCodingHelper = getIt<GeoCodingHelper>();
  final _gpsHelper = getIt<GpsHelper>();
  final _logger = getIt<Logger>();

  Future<void> checkUserAdress() async {
    var gpsHelperResponse = await _gpsHelper.getLastKnownOrCurrentLocation();
    var geoCodingResponse =
        await _geoCodingHelper.getAddressFromLatLng(gpsHelperResponse);

    _logger.w('UserAdressCubit -- checkUserAdress -- $geoCodingResponse');
    emit('${geoCodingResponse ?? ''}');
    // emit(
    //     '1 Stockton St, San Francisco County, CA, 941081 Stockton St, San Francisco County, CA, 941081 Stockton St, San Francisco County, CA, 94108');
  }
}
