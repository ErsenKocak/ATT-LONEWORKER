import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/device_screen_info/device_screen_info.dart';
import '../../enums/font/font_family.dart';
import '../../enums/font/font_weight.dart';

class AppButtonWidget extends StatelessWidget {
  final String buttonText;
  final double? buttonTextSize;
  final FontWeight? fontWeight;
  final Color backgroundColor;
  final Color textColor;
  final Function onTap;

  double? height;
  double? width;

  AppButtonWidget({
    required this.buttonText,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
    this.height = 13,
    this.width = 85,
    this.fontWeight,
    this.buttonTextSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: DeviceInfo.width(height!),
        width: DeviceInfo.width(width!),
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: TextStyle(
            fontFamily: AppFontFamily.LatoTR.value,
            fontSize: ScreenUtil().setSp(buttonTextSize ?? 20),
            fontWeight: fontWeight ?? AppFontWeight.extraBold.value,
            color: textColor,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: backgroundColor,
        ),
      ),
    );
  }
}
