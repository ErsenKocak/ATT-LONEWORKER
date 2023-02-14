import 'package:att_loneworker/core/constants/colors.dart';
import 'package:att_loneworker/core/enums/font/font_family.dart';
import 'package:flutter/material.dart';

class AppTheme {
  var CSBSTheme = ThemeData.light().copyWith(
      primaryColor: AppColors.primary,
      appBarTheme: const AppBarTheme(color: AppColors.secondaryColor),
      iconTheme: const IconThemeData(color: AppColors.secondaryColor),
      textTheme: ThemeData.light().textTheme.apply(
            displayColor: AppColors.secondaryColor,
            fontFamily: AppFontFamily.LatoTR.value,
          ),
      primaryTextTheme: ThemeData.light()
          .textTheme
          .apply(fontFamily: AppFontFamily.LatoTR.value),
      scaffoldBackgroundColor: AppColors.scaffoldColor,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkerGrey,
      ));
}
