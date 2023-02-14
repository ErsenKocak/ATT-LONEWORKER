import 'dart:io';
import 'package:att_loneworker/core/enums/http_url/http_url.dart';
import 'package:att_loneworker/model/auth/auth_request.dart';
import 'package:att_loneworker/model/auth/auth_response.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../core/init/locator.dart';

class AuthService {
  final _logger = getIt<Logger>();
  final _dio = getIt<Dio>();

  Future<AuthResponse?> login({required AuthRequest authRequest}) async {
    try {
      _logger.w('REQUEST ${authRequest.toJson()}');

      var response =
          await _dio.post(HttpClientApiUrl.login.uri, data: authRequest);

      if (response.data != null && response.statusCode == HttpStatus.ok) {
        _dio.options.headers.addAll({
          HttpHeaders.authorizationHeader:
              'Bearer ${response.data['access_token']}'
        });
        return AuthResponse.fromJson(response.data);
      } else {
        return null;
      }
    } on DioError catch (error) {
      _logger.e('AuthService -- LOGIN -- ERROR -- ${error.message}');
      throw Exception(error.message);
    }
  }
}
