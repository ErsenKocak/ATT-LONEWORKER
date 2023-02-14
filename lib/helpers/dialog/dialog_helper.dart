import 'dart:developer';

import 'package:att_loneworker/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ndialog/ndialog.dart';

class DialogHelper {
  Future showDialog(BuildContext context,
      {String? title, Widget? body, List<Widget>? actions}) async {
    log('showDialog');
    await NDialog(
            dialogStyle: DialogStyle(
                contentPadding: const EdgeInsets.all(8),
                titleDivider: false,
                elevation: 8,
                titlePadding: const EdgeInsets.all(0)),
            title: Container(
              height: 50,
              width: 100.sw,
              color: AppColors.primary,
              child: Center(
                  child: title != null
                      ? Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .apply(color: Colors.white),
                        )
                      : const SizedBox()),
            ),
            content: body,
            actions: actions)
        .show(context);
  }
}
