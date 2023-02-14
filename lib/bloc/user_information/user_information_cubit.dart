import 'package:att_loneworker/model/user/user_information/user_information.dart';
import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../core/enums/storage/storage_keys_enum.dart';
import '../../core/init/locator.dart';

class UserInformationCubit extends Cubit<UserInformation> {
  UserInformationCubit() : super(UserInformation());
  late UserInformation? userInformation;
  final _logger = getIt<Logger>();

  initializeUserInformation() {
    Box userInformationBox =
        Hive.box(SharedPreferencesKeys.USER_INFORMATION.name);

    UserInformation userInformationStorageData =
        userInformationBox.get(SharedPreferencesKeys.USER_INFORMATION.name);

    userInformation = userInformationStorageData;
    _logger.w('initializeUserInformation ${userInformation?.toJson()}');
  }
}
