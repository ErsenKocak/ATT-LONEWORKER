import 'package:att_loneworker/helpers/device_screen_info/device_screen_info.dart';
import 'package:att_loneworker/helpers/toast/toast_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/localization/localization_keys_constants.dart';
import '../../core/enums/font/font_family.dart';
import '../../core/init/locator.dart';
import '../../core/widgets/appbar/app_bar_widget.dart';
import '../../core/widgets/custom_icon_button/custom_icon_button.dart';
import '../../core/widgets/step_progress/step_progress_widget.dart';
import '../../core/widgets/toggle_switch/toggle_switch_widget.dart';
import '../../helpers/device_screen_info/device_info.dart';
import '../../helpers/dialog/dialog_helper.dart';

class LocationSettingsView extends StatefulWidget {
  const LocationSettingsView({super.key});

  @override
  State<LocationSettingsView> createState() => _LocationSettingsViewState();
}

class _LocationSettingsViewState extends State<LocationSettingsView> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  final _logger = getIt<Logger>();
  final _dialogHelper = getIt<DialogHelper>();

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  Divider get _divider {
    return const Divider(
      thickness: 1,
      color: AppColors.lightGrey,
    );
  }

  SizedBox get _sizedBox {
    return SizedBox(
      height: getProportionateScreenHeight(20),
    );
  }

  _buildLocationAlarmActivate() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Location Alarm activate',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(14),
            fontFamily: AppFontFamily.LatoTR.value,
          ),
        ),
        ToggleSwitchWidget(
            // initialLabelIndex: _LocationSettingsCubit
            //             .LocationAlarmSettings.isLocationAlarmActive ==
            //         true
            //     ? 0
            //     : 1,
            initialLabelIndex: 0,
            onToggle: (index) {
              _locationAlarmActivateToggle(index!);
            })
      ],
    );
  }

  _locationAlarmActivateToggle(int index) async {
    _logger.w('_locationAlarmActivateToggle index $index');

    if (index == 0) {
      bool permissionGranted = await _locationAlarmCheckPermission();
      if (permissionGranted == true) {
      } else {
        //TODO: INDEX TO 1 Location Stream Close
      }
    } else {}

    // _LocationSettingsCubit.LocationAlarmSettings.isLocationAlarmActive =
    //     index == 0 ? true : false;
    // _LocationSettingsCubit.saveLocationAlarmSettingsToStorage();
  }

  Future<bool> _locationAlarmCheckPermission() async {
    LocationPermission permissionStatus = await Geolocator.checkPermission();

    _logger.w('permissionStatus $permissionStatus');

    if (permissionStatus == LocationPermission.denied ||
        permissionStatus == LocationPermission.deniedForever ||
        permissionStatus == LocationPermission.unableToDetermine) {
      var locationRequest = await Geolocator.requestPermission();
      _logger.w('locationRequest  $locationRequest');
      if (locationRequest == LocationPermission.denied ||
          locationRequest == LocationPermission.deniedForever ||
          locationRequest == LocationPermission.unableToDetermine) {
        await _locationAlarmPermissionDialog();

        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  _locationAlarmPermissionDialog() async {
    await _dialogHelper.showDialog(context,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: DeviceInfo.height(2)),
          child: Text(tr(LocalizationKeys.LOCATION_PERMISSION)),
        ),
        title: tr(LocalizationKeys.PERMISSION_REQUIRED),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Icon(
                  Icons.cancel_outlined,
                  color: AppColors.darkGrey,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkGrey,
                elevation: 0,
              ),
              child: Text(tr(LocalizationKeys.OPEN_SETTINGS)),
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openLocationSettings();
              },
            ),
          ),
        ]);
  }

  _buildLocationDuration() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Icon(
              Icons.timer_sharp,
              color: AppColors.primary,
            ),
            SizedBox(
              width: getProportionateScreenWidth(10),
            ),
            Text(
              '${tr(LocalizationKeys.LOCATION_DURATION)}  - ${(10)} ${tr(LocalizationKeys.SECONDS)}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontFamily: AppFontFamily.LatoTR.value,
              ),
            ),
          ],
        ),
        SizedBox(
          height: getProportionateScreenHeight(15),
        ),
        StepProgressWidget(
          totalStep: 10,
          initialStep:
              // _batterySettingsCubit.batteryAlarmSettings.batteryAlarmDuration !=
              //         null
              //     ? _batterySettingsCubit
              //             .batteryAlarmSettings.batteryAlarmDuration! ~/
              //         10
              //     : 1,
              1,
          onTap: _onTapDurationOfLocationAlarmStepProgress,
        )
      ],
    );
  }

  _onTapDurationOfLocationAlarmStepProgress(int value) {
    // _batterySettingsCubit.batteryAlarmSettings.batteryAlarmDuration =
    //     value * 10;
    // _batterySettingsCubit.saveBatteryAlarmSettingsToStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget(
        AppBar().preferredSize.height + 100,
        context,
        tr(LocalizationKeys.LOCATION_SETTINGS),
        _scaffoldKey,
        [
          const CustomIconButton(
              icon: Icon(
            Icons.add,
            color: Colors.transparent,
          ))
        ],
        CustomIconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          callBack: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DeviceInfo.height(2)),
        physics: const BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              _buildLocationAlarmActivate(),
              _sizedBox,
              _divider,
              _sizedBox,
              _buildLocationDuration(),
              _sizedBox,
              _divider,
              _sizedBox,
            ],
          ),
        ),
      ),
    );
  }
}
