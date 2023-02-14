import 'package:att_loneworker/model/location_settings/location_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../core/init/locator.dart';

class LocationSettingsCubit extends Cubit<LocationAlarmSettings> {
  LocationSettingsCubit() : super(LocationAlarmSettings());
  final _logger = getIt<Logger>();
}
