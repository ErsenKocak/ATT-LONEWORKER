import 'package:att_loneworker/core/constants/colors.dart';
import 'package:att_loneworker/core/constants/localization/localization_keys_constants.dart';
import 'package:att_loneworker/core/enums/font/font_family.dart';
import 'package:att_loneworker/core/enums/font/font_weight.dart';
import 'package:att_loneworker/core/widgets/step_progress/step_progress_widget.dart';
import 'package:att_loneworker/core/widgets/toggle_switch/toggle_switch_widget.dart';
import 'package:att_loneworker/model/alarm_settings/alarm_settings.dart';
import 'package:att_loneworker/view/alarm_settings/widgets/appbar_actions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../bloc/alarm_settings/alarm_settings_cubit.dart';
import '../../core/init/locator.dart';
import '../../core/widgets/appbar/app_bar_widget.dart';
import '../../core/widgets/custom_icon_button/custom_icon_button.dart';
import '../../helpers/device_screen_info/device_info.dart';

class AlarmSettingsView extends StatefulWidget {
  const AlarmSettingsView({super.key});

  @override
  State<AlarmSettingsView> createState() => _AlarmSettingsViewState();
}

class _AlarmSettingsViewState extends State<AlarmSettingsView> {
  late AlarmSettingsCubit _alarmSettingsCubit;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  final _logger = getIt<Logger>();

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _alarmSettingsCubit = context.read<AlarmSettingsCubit>();
    _logger
        .w('shared settings -- ${_alarmSettingsCubit.alarmSettings.toJson()}');
    // _alarmSettingsCubit.initializeAlarmSettings();

    // WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  _buildAlarmActivate() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Alarm activate',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(14),
            fontFamily: AppFontFamily.LatoTR.value,
          ),
        ),
        ToggleSwitchWidget(
            initialLabelIndex:
                _alarmSettingsCubit.alarmSettings.isAlarmActive == true ? 0 : 1,
            onToggle: (index) {
              _alarmActivateToggle(index!);
            })
      ],
    );
  }

  _alarmActivateToggle(int index) {
    _alarmSettingsCubit.alarmSettings.isAlarmActive = index == 0 ? true : false;
    _alarmSettingsCubit.saveAlarmSettingsToStorage();
  }

  _buildSosAlarmActivate() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'SOS Alarm activate',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(14),
            fontFamily: AppFontFamily.LatoTR.value,
          ),
        ),
        ToggleSwitchWidget(
            initialLabelIndex:
                _alarmSettingsCubit.alarmSettings.isSOSAlarmActive == true
                    ? 0
                    : 1,
            onToggle: (index) {
              _sosAlarmActivateToggle(index!);
            })
      ],
    );
  }

  _sosAlarmActivateToggle(int index) {
    _alarmSettingsCubit.alarmSettings.isSOSAlarmActive =
        index == 0 ? true : false;
    _alarmSettingsCubit.saveAlarmSettingsToStorage();
  }

  _buildDurationOfAlarm() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.timer_sharp,
              color: AppColors.primary,
            ),
            SizedBox(
              width: getProportionateScreenWidth(10),
            ),
            Text(
              'Duration of alarm - ${(_alarmSettingsCubit.alarmSettings.durationOfAlarm ?? 1 * 10)} seconds',
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
          initialStep: _alarmSettingsCubit.alarmSettings.durationOfAlarm! ~/ 10,
          onTap: _onTapDurationOfAlarmStepProgress,
        )
      ],
    );
  }

  _onTapDurationOfAlarmStepProgress(int value) {
    _alarmSettingsCubit.alarmSettings.durationOfAlarm = value * 10;
    _alarmSettingsCubit.saveAlarmSettingsToStorage();
  }

  _buildDisableAlarmIsCharging() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Disable alarm when device is charging',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(14),
              fontFamily: AppFontFamily.LatoTR.value,
            ),
          ),
        ),
        ToggleSwitchWidget(
            initialLabelIndex:
                _alarmSettingsCubit.alarmSettings.isDisableAlarmIsCharging ==
                        true
                    ? 0
                    : 1,
            onToggle: (index) {
              _disableAlarmIsChargingToggle(index!);
            })
      ],
    );
  }

  _disableAlarmIsChargingToggle(int index) {
    _alarmSettingsCubit.alarmSettings.isDisableAlarmIsCharging =
        index == 0 ? true : false;
    _alarmSettingsCubit.saveAlarmSettingsToStorage();
  }

  _buildAlarmVolume() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.volume_up_rounded,
              color: AppColors.primary,
            ),
            SizedBox(
              width: getProportionateScreenWidth(10),
            ),
            Text(
              '${tr(LocalizationKeys.ALARM_VOLUME)} - ${(_alarmSettingsCubit.alarmSettings.alarmVolume ?? 1 * 10)}',
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
          initialStep: _alarmSettingsCubit.alarmSettings.alarmVolume! ~/ 10,
          onTap: _onTapAlarmVolumeStepProgress,
        )
      ],
    );
  }

  _onTapAlarmVolumeStepProgress(int value) {
    _alarmSettingsCubit.alarmSettings.alarmVolume = value * 10;
    _alarmSettingsCubit.saveAlarmSettingsToStorage();
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
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget(
          AppBar().preferredSize.height + 100,
          context,
          'Alarm Settings',
          _scaffoldKey,
          alarmSettingsViewAppBarActions(context),
          CustomIconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            callBack: () => Navigator.pop(context),
          )),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(getProportionateScreenWidth(10)),
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(14)),
          child: BlocBuilder<AlarmSettingsCubit, AlarmSettings>(
            builder: (context, state) {
              return Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAlarmActivate(),
                    _sizedBox,
                    _divider,
                    _sizedBox,
                    _buildSosAlarmActivate(),
                    _sizedBox,
                    _divider,
                    _sizedBox,
                    _buildDurationOfAlarm(),
                    _sizedBox,
                    _divider,
                    _sizedBox,
                    _buildDisableAlarmIsCharging(),
                    _sizedBox,
                    _divider,
                    _sizedBox,
                    _buildAlarmVolume(),
                    _sizedBox,
                    _divider,
                  ]);
            },
          ),
        ),
      ),
    );
  }
}
