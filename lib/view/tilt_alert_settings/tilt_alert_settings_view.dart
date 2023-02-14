import 'package:att_loneworker/bloc/tilt_alarm_settings/tilt_alarm_settings_cubit.dart';
import 'package:att_loneworker/model/tilt_alarm_settings/tilt_alarm_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:motion_sensors/motion_sensors.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/localization/localization_keys_constants.dart';
import '../../core/enums/font/font_family.dart';
import '../../core/init/locator.dart';
import '../../core/widgets/appbar/app_bar_widget.dart';
import '../../core/widgets/custom_icon_button/custom_icon_button.dart';
import '../../core/widgets/step_progress/step_progress_widget.dart';
import '../../core/widgets/toggle_switch/toggle_switch_widget.dart';
import '../../helpers/device_screen_info/device_info.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import '../../helpers/functions/app_functions.dart';
import '../../helpers/tilt_alarm_helper/tilt_alarm_helper.dart';

class TiltAlertSettingsView extends StatefulWidget {
  const TiltAlertSettingsView({super.key});

  @override
  State<TiltAlertSettingsView> createState() => _TiltAlertSettingsViewState();
}

class _TiltAlertSettingsViewState extends State<TiltAlertSettingsView> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TiltAlarmSettingsCubit _tiltAlarmSettingsCubit;
  final _logger = getIt<Logger>();
  final _appFunctionsHelper = getIt<AppFunctionsHelper>();
  final _tiltAlarmHelper = getIt<TiltAlarmHelper>();

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _tiltAlarmSettingsCubit = context.read<TiltAlarmSettingsCubit>();
    _logger.w(
        '_tiltAlarmSettingsCubit init state ${_tiltAlarmSettingsCubit.tiltAlarmSettings.toJson()}');
    _tiltAlarmHelper.initializeStream();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _buildTiltAlarmActivate() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tilt Alarm activate',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(14),
            fontFamily: AppFontFamily.LatoTR.value,
          ),
        ),
        ToggleSwitchWidget(
            initialLabelIndex:
                _tiltAlarmSettingsCubit.tiltAlarmSettings.isTiltAlarmActive ==
                        true
                    ? 0
                    : 1,
            onToggle: (index) {
              _batteryTiltActivateToggle(index!);
            })
      ],
    );
  }

  _batteryTiltActivateToggle(int index) {
    _tiltAlarmSettingsCubit.tiltAlarmSettings.isTiltAlarmActive =
        index == 0 ? true : false;
    _tiltAlarmSettingsCubit.saveTiltAlarmSettingsToStorage();
  }

  _buildTiltAlarmAngle() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Icon(
              Icons.screen_rotation,
              color: AppColors.primary,
            ),
            SizedBox(
              width: getProportionateScreenWidth(10),
            ),
            Text(
              '${tr(LocalizationKeys.TILT_ANGLE)} - %${(_tiltAlarmSettingsCubit.tiltAlarmSettings.tiltAngle ?? 1 * 10)}',
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
          totalStep: 7,
          initialStep: _tiltAlarmSettingsCubit.tiltAlarmSettings.tiltAngle == 0
              ? 1
              : (_tiltAlarmSettingsCubit.tiltAlarmSettings.tiltAngle! ~/ 15) + 1
          // _batterySettingsCubit.batteryAlarmSettings.batteryCondition! ~/
          //     10,
          ,
          onTap: _onTapTiltAlarmAngleStepProgress,
        )
      ],
    );
  }

  _onTapTiltAlarmAngleStepProgress(int value) {
    if (value != 1) {
      _logger.i('_onTapTiltAlarmAngleStepProgress != 0 ${(value - 1) * 15}');
      _tiltAlarmSettingsCubit.tiltAlarmSettings.tiltAngle = (value - 1) * 15;
    } else {
      _logger.i('_onTapTiltAlarmAngleStepProgress 0');
      _tiltAlarmSettingsCubit.tiltAlarmSettings.tiltAngle = 0;
    }
    _tiltAlarmSettingsCubit.saveTiltAlarmSettingsToStorage();
  }

  _buildTiltAlarmDurationInAlarmSituation() {
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
              '${tr(LocalizationKeys.DURATION_IN_ALARM_SITUATION)} - ${(_tiltAlarmSettingsCubit.tiltAlarmSettings.durationOfTiltAlarmSituation ?? 1 * 10)} ${tr(LocalizationKeys.SECONDS)}',
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
          initialStep: _tiltAlarmSettingsCubit
                  .tiltAlarmSettings.durationOfTiltAlarmSituation! ~/
              10,
          onTap: _onTapTiltAlarmDurationInAlarmSituationStepProgress,
        )
      ],
    );
  }

  _onTapTiltAlarmDurationInAlarmSituationStepProgress(int value) {
    _tiltAlarmSettingsCubit.tiltAlarmSettings.durationOfTiltAlarmSituation =
        value * 10;
    _tiltAlarmSettingsCubit.saveTiltAlarmSettingsToStorage();
  }

  _buildTiltAlarmDurationOfPreAlarm() {
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
              '${tr(LocalizationKeys.DURATION_OF_THE_PRE_ALARM)} - ${(_tiltAlarmSettingsCubit.tiltAlarmSettings.durationOfThePreAlarm ?? 1 * 10)} ${tr(LocalizationKeys.SECONDS)}',
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
          initialStep: _tiltAlarmSettingsCubit
                  .tiltAlarmSettings.durationOfThePreAlarm! ~/
              10,
          onTap: _onTapTiltAlarmDurationOfPreAlarmStepProgress,
        )
      ],
    );
  }

  _onTapTiltAlarmDurationOfPreAlarmStepProgress(int value) {
    _tiltAlarmSettingsCubit.tiltAlarmSettings.durationOfThePreAlarm =
        value * 10;
    _tiltAlarmSettingsCubit.saveTiltAlarmSettingsToStorage();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget(
        AppBar().preferredSize.height + 100,
        context,
        tr(LocalizationKeys.TILT_ALERT),
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
        padding: EdgeInsets.all(getProportionateScreenWidth(10)),
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(14)),
          child: BlocBuilder<TiltAlarmSettingsCubit, TiltAlarmSettings>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTiltAlarmActivate(),
                  _sizedBox,
                  _divider,
                  _sizedBox,
                  _buildTiltAlarmAngle(),
                  _sizedBox,
                  _divider,
                  _sizedBox,
                  _buildTiltAlarmDurationInAlarmSituation(),
                  _sizedBox,
                  _divider,
                  _sizedBox,
                  _buildTiltAlarmDurationOfPreAlarm(),
                  _sizedBox,
                  _divider,
                  _sizedBox,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
