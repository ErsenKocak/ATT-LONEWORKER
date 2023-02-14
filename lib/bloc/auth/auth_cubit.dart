import 'package:att_loneworker/bloc/user_information/user_information_cubit.dart';
import 'package:att_loneworker/core/config/hive/hive_config.dart';
import 'package:att_loneworker/core/constants/routes/routes_name.dart';
import 'package:att_loneworker/core/enums/storage/storage_keys_enum.dart';
import 'package:att_loneworker/model/auth/auth_request.dart';
import 'package:att_loneworker/model/auth/auth_response.dart';
import 'package:att_loneworker/model/user/user_information/user_information.dart';
import 'package:att_loneworker/service/auth/auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../core/init/locator.dart';
import '../../helpers/navigation/navigation_helper.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  final _authService = getIt<AuthService>();
  final _logger = getIt<Logger>();
  late AuthResponse? authResponse;
  late UserInformation? userInformation;

  Future<void> login(
      {required AuthRequest authRequest, bool? isRememberMe}) async {
    try {
      emit(AuthLoadingState());

      var response = await _authService.login(authRequest: authRequest);

      if (response != null) {
        authResponse = response;
        userInformation = UserInformation.fromJson(
            JwtDecoder.decode(authResponse!.accessToken!));
        _logger.w('userInformation JWT DECODER ${userInformation?.toJson()}');
        saveUserInformationToHive();
        initializeUserInformationCubit();
        if (isRememberMe == true) {
          saveTokenToHive();
        }
        emit(AuthLoadedState(authResponse!));
      } else {
        emit(AuthErrorState(''));
      }
    } on DioError catch (error) {
      emit(AuthErrorState(error.message));
    }
  }

  logout(BuildContext context) {
    Navigator.pop(context);
    Navigator.of(context, rootNavigator: true)
        .pushReplacementNamed(AppRoutesNames.loginView);
    removeTokenFromHive();
  }

  saveTokenToHive() async {
    Box tokenBox = Hive.box(SharedPreferencesKeys.TOKEN_STORAGE.name);
    tokenBox.put(SharedPreferencesKeys.TOKEN_STORAGE.name, authResponse);

    // AuthResponse tokenStorageData =
    //     tokenBox.get(SharedPreferencesKeys.TOKEN_STORAGE.name);
    // _logger.w('TOKEN ${tokenStorageData.toJson()}');
  }

  saveUserInformationToHive() async {
    Box userInformationBox =
        Hive.box(SharedPreferencesKeys.USER_INFORMATION.name);
    userInformationBox.put(
        SharedPreferencesKeys.USER_INFORMATION.name, userInformation);

    // UserInformation userInformationStorageData =
    //     userInformationBox.get(SharedPreferencesKeys.USER_INFORMATION.name);
  }

  removeTokenFromHive() async {
    var tokenBox = Hive.box(SharedPreferencesKeys.TOKEN_STORAGE.name);
    await tokenBox.clear();
  }

  initializeUserInformationCubit() {
    if (NavigationHelper.navigatorKey.currentContext != null) {
      BlocProvider.of<UserInformationCubit>(
              NavigationHelper.navigatorKey.currentContext!)
          .initializeUserInformation();
    }
  }
}
