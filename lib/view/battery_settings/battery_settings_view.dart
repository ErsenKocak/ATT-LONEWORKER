import 'dart:developer';
import 'dart:io';

import 'package:att_loneworker/bloc/battery_settings/battery_settings_cubit.dart';
import 'package:att_loneworker/core/constants/localization/localization_keys_constants.dart';
import 'package:att_loneworker/core/widgets/appbar/app_bar_widget.dart';
import 'package:att_loneworker/model/battery_settings/battery_settings.dart';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';

import '../../core/constants/colors.dart';
import '../../core/enums/font/font_family.dart';
import '../../core/init/locator.dart';
import '../../core/widgets/custom_icon_button/custom_icon_button.dart';
import '../../core/widgets/step_progress/step_progress_widget.dart';
import '../../core/widgets/toggle_switch/toggle_switch_widget.dart';
import '../../helpers/battery/battery_helper.dart';
import '../../helpers/device_screen_info/device_info.dart';

class BatterySettingsView extends StatefulWidget {
  const BatterySettingsView({super.key});

  @override
  State<BatterySettingsView> createState() => _BatterySettingsViewState();
}

class _BatterySettingsViewState extends State<BatterySettingsView> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  final _logger = getIt<Logger>();
  final _batteryHelper = getIt<BatteryHelper>();
  late BatterySettingsCubit _batterySettingsCubit;
  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _batterySettingsCubit = context.read<BatterySettingsCubit>();
    _logger.w(
        'Current Battery Settings ${_batterySettingsCubit.batteryAlarmSettings.toJson()}');

    // WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  _buildBatteryAlarmActivate() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Battery Alarm activate',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(14),
            fontFamily: AppFontFamily.LatoTR.value,
          ),
        ),
        ToggleSwitchWidget(
            initialLabelIndex: _batterySettingsCubit
                        .batteryAlarmSettings.isBatteryAlarmActive ==
                    true
                ? 0
                : 1,
            onToggle: (index) {
              _batteryAlarmActivateToggle(index!);
            })
      ],
    );
  }

  _batteryAlarmActivateToggle(int index) {
    _batterySettingsCubit.batteryAlarmSettings.isBatteryAlarmActive =
        index == 0 ? true : false;
    _batterySettingsCubit.saveBatteryAlarmSettingsToStorage();
  }

  _buildBatteryCondition() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Icon(
              Icons.battery_3_bar_sharp,
              color: AppColors.primary,
            ),
            SizedBox(
              width: getProportionateScreenWidth(10),
            ),
            Text(
              '${tr(LocalizationKeys.BATTERY_CONDITION)} - %${(_batterySettingsCubit.batteryAlarmSettings.batteryCondition ?? 1 * 10)}',
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
          initialStep: _batterySettingsCubit
                      .batteryAlarmSettings.batteryCondition !=
                  null
              ? _batterySettingsCubit.batteryAlarmSettings.batteryCondition! ~/
                  10
              : 1,
          onTap: _onTapDurationOfAlarmStepProgress,
        )
      ],
    );
  }

  _onTapDurationOfAlarmStepProgress(int value) {
    _batterySettingsCubit.batteryAlarmSettings.batteryCondition = value * 10;
    _batterySettingsCubit.saveBatteryAlarmSettingsToStorage();
  }

  _buildBatteryDuration() {
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
              '${tr(LocalizationKeys.DURATION_IN_BATTERY_ALARM_SITUATION)} - ${(_batterySettingsCubit.batteryAlarmSettings.batteryAlarmDuration ?? 1 * 10)} ${tr(LocalizationKeys.SECONDS)}',
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
              _batterySettingsCubit.batteryAlarmSettings.batteryAlarmDuration !=
                      null
                  ? _batterySettingsCubit
                          .batteryAlarmSettings.batteryAlarmDuration! ~/
                      10
                  : 1,
          onTap: _onTapDurationOfBatteryAlarmStepProgress,
        )
      ],
    );
  }

  _onTapDurationOfBatteryAlarmStepProgress(int value) {
    _batterySettingsCubit.batteryAlarmSettings.batteryAlarmDuration =
        value * 10;
    _batterySettingsCubit.saveBatteryAlarmSettingsToStorage();
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
        tr(LocalizationKeys.BATTERY_ALARM),
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
          child: BlocBuilder<BatterySettingsCubit, BatteryAlarmSettings>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBatteryAlarmActivate(),
                  _sizedBox,
                  _divider,
                  _sizedBox,
                  _buildBatteryCondition(),
                  _sizedBox,
                  _divider,
                  _sizedBox,
                  _buildBatteryDuration(),
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
