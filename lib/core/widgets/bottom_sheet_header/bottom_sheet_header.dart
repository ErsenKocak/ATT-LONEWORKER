import 'package:att_loneworker/core/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../helpers/device_screen_info/device_screen_info.dart';

class BottomSheetModalHeaderWidget extends StatelessWidget {
  const BottomSheetModalHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: DeviceInfo.height(0.5),
        width: DeviceInfo.width(15),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.all(Radius.circular(DeviceInfo.height(4))),
        ),
      ),
    );
  }
}
