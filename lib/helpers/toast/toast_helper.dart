import 'package:att_loneworker/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  showToast({required message, Color? color}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color ?? AppColors.darkerGrey,
        textColor: Colors.white,
        fontSize: ScreenUtil().setSp(14));
  }
}
