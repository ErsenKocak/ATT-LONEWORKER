import 'package:flutter/material.dart';

enum AppFontWeight {
  extraBold,
  bold,
  regular,
  medium,
  semiBold,
}

extension AppFontWeightValue on AppFontWeight {
  FontWeight get value {
    switch (this) {
      case AppFontWeight.extraBold:
        return FontWeight.w900;
      case AppFontWeight.bold:
        return FontWeight.bold;
      case AppFontWeight.semiBold:
        return FontWeight.w600;
      case AppFontWeight.medium:
        return FontWeight.w500;
      case AppFontWeight.regular:
        return FontWeight.normal;
      default:
        return FontWeight.normal;
    }
  }
}
