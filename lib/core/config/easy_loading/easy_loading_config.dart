import 'package:att_loneworker/core/constants/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 10)
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = AppColors.progressBarColor
    ..backgroundColor = const Color(0xFFFFFFFF)
    ..indicatorColor = AppColors.progressBarColor
    ..textColor = AppColors.progressBarColor
    ..maskColor = Colors.white
    ..userInteractions = false
    ..dismissOnTap = false
    ..maskType = EasyLoadingMaskType.black
    ..toastPosition = EasyLoadingToastPosition.center
    ..animationStyle = EasyLoadingAnimationStyle.scale;
}
