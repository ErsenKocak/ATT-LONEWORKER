import 'dart:math';

import 'package:flutter/material.dart';

import '../navigation/navigation_helper.dart';

class DeviceInfo {
  static MediaQueryData get mediaQuery =>
      MediaQuery.of(NavigationHelper.navigatorKey.currentContext!);

  static get bottomPadding =>
      max(DeviceInfo.mediaQuery.viewPadding.bottom, DeviceInfo.height(1.5));

  static double width(double width) {
    return MediaQuery.of(NavigationHelper.navigatorKey.currentContext!)
            .size
            .width /
        100.0 *
        width;
  }

  static double height(double height) {
    return MediaQuery.of(NavigationHelper.navigatorKey.currentContext!)
            .size
            .height /
        100.0 *
        height;
  }
}
