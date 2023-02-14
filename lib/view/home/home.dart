import 'dart:developer';

import 'package:att_loneworker/bloc/alarm_settings/alarm_settings_cubit.dart';
import 'package:att_loneworker/bloc/battery_settings/battery_settings_cubit.dart';
import 'package:att_loneworker/bloc/tilt_alarm_settings/tilt_alarm_settings_cubit.dart';
import 'package:att_loneworker/bloc/user_adress/user_adress_cubit.dart';
import 'package:att_loneworker/bloc/user_information/user_information_cubit.dart';
import 'package:att_loneworker/core/constants/app_services/app_services_constant.dart';
import 'package:att_loneworker/core/constants/colors.dart';
import 'package:att_loneworker/core/constants/localization/localization_keys_constants.dart';
import 'package:att_loneworker/core/constants/routes/routes_name.dart';
import 'package:att_loneworker/core/enums/font/font_family.dart';
import 'package:att_loneworker/core/enums/font/font_weight.dart';
import 'package:att_loneworker/core/widgets/appbar/app_bar_widget.dart';
import 'package:att_loneworker/core/widgets/custom_icon_button/custom_icon_button.dart';
import 'package:att_loneworker/core/widgets/drawer/drawer_widget.dart';
import 'package:att_loneworker/helpers/audio/audio_helper.dart';
import 'package:att_loneworker/helpers/device_screen_info/device_info.dart';
import 'package:att_loneworker/helpers/device_screen_info/device_screen_info.dart';
import 'package:att_loneworker/model/alarm_settings/alarm_settings.dart';
import 'package:att_loneworker/model/home_service_item/home_service_item.dart';
import 'package:att_loneworker/view/alarm_settings/alarm_settings_view.dart';
import 'package:att_loneworker/view/battery_settings/battery_settings_view.dart';
import 'package:att_loneworker/view/tilt_alert_settings/tilt_alert_settings_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../bloc/alarm_state/alarm_state_cubit.dart';
import '../../bloc/app_services/app_services_cubit.dart';
import '../../core/init/locator.dart';
import '../../helpers/gps/geocoding_helper.dart';
import '../../helpers/gps/gps_helper.dart';
import '../../helpers/network/connectivity/connectivity_helper.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  final _logger = getIt<Logger>();
  final _audioPlayerHandler = getIt<AudioPlayerHandler>();
  late AppServicesCubit appServicesCubit;
  String currentAdress = '';

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    context.read<AlarmSettingsCubit>().initializeAlarmSettings();
    context.read<BatterySettingsCubit>().initializeBatteryAlarmSettings();
    context.read<TiltAlarmSettingsCubit>().initializeTiltAlarmSettings();
    context.read<UserInformationCubit>().initializeUserInformation();
    context.read<UserAdressCubit>().checkUserAdress();

    appServicesCubit = context.read<AppServicesCubit>();
    appServicesCubit.initializeServices();
    _audioPlayerHandler.initializeStream();
    getIt<ConnectivityHelper>().initializeStream();
    getIt<ConnectivityHelper>().checkDeviceConnectivity();
  }

  _buildLocation() {
    return BlocBuilder<UserAdressCubit, String>(
      builder: (context, userAdressState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(LocalizationKeys.CURRENT_LOCATION),
              style: TextStyle(
                  fontFamily: AppFontFamily.WTGothic.value,
                  fontWeight: AppFontWeight.bold.value),
            ),
            Card(
              margin: EdgeInsets.symmetric(
                  vertical: getProportionateScreenWidth(10)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppColors.lightGrey, width: 2.5),
              ),
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(getProportionateScreenHeight(10)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),
                        Text(
                          tr(LocalizationKeys.GPS_ENABLED),
                          style: TextStyle(
                              fontFamily: AppFontFamily.WTGothic.value,
                              fontWeight: AppFontWeight.bold.value),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.transparent,
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),
                        Expanded(
                          child: Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message: userAdressState,
                            showDuration: const Duration(seconds: 10),
                            margin: EdgeInsets.symmetric(
                              horizontal: DeviceInfo.width(2),
                            ),
                            child: Text(
                              userAdressState,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: AppFontFamily.nunito.value,
                                  fontWeight: AppFontWeight.regular.value,
                                  color: AppColors.darkGrey),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _buildServices() {
    if (appServicesCubit.selectedHomeServices.isEmpty) return const SizedBox();
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LocalizationKeys.SERVICES),
          style: TextStyle(
              fontFamily: AppFontFamily.WTGothic.value,
              fontWeight: AppFontWeight.bold.value),
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          shrinkWrap: true,
          itemCount: appServicesCubit.selectedHomeServices.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _buildServiceItem(
                homeServiceItem: appServicesCubit.selectedHomeServices[index]);
          },
        )
      ],
    );
  }

  _buildServiceItem({required HomeServiceItem homeServiceItem}) {
    return GestureDetector(
      onTap: () {
        // onGoBack(dynamic value) async {
        //   // isSOSAlarmActive = context
        //   //     .read<AlarmSettingsCubit>()
        //   //     .alarmSettings
        //   //     .isSOSAlarmActive!;
        // }

        // Route route = CupertinoPageRoute(
        //     builder: (context) => homeServiceItem.navigateScreen!);

        // Navigator.push(context, route).then(onGoBack);

        Navigator.pushNamed(context, homeServiceItem.navigateScreen!);
      },
      child: Container(
        color: Colors.transparent,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: getProportionateScreenHeight(50),
                width: getProportionateScreenHeight(50),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.lightGrey),
                child: Icon(
                    IconData(homeServiceItem.iconCode!,
                        fontFamily: 'MaterialIcons'),
                    color: Color(homeServiceItem.iconColorValue!)),
              ),
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
              Text(
                tr(homeServiceItem.title!),
                style: TextStyle(
                    fontFamily: AppFontFamily.WTGothic.value,
                    fontWeight: AppFontWeight.bold.value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildSosAlarmButton() {
    return BlocBuilder<AlarmStateCubit, bool>(builder: (context, state) {
      log('AlarmStateCubitState $state');
      if (state == true) {
        return FloatingActionButton(
            backgroundColor: AppColors.primary,
            child: Icon(Icons.pause),
            onPressed: () async {
              await _audioPlayerHandler.setLoopmode(LoopMode.all);
              _audioPlayerHandler.play();
            });
      }
      return FloatingActionButton(
          backgroundColor: AppColors.primary,
          child: Text(
            'SOS',
            style: TextStyle(
                fontFamily: AppFontFamily.LatoTR.value,
                fontWeight: AppFontWeight.bold.value),
          ),
          onPressed: () async {
            var playerHandler = getIt<AudioPlayerHandler>();
            await playerHandler.setLoopmode(LoopMode.all);
            playerHandler.play();
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocBuilder<AlarmSettingsCubit, AlarmSettings>(
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: appBarWidget(
              AppBar().preferredSize.height + 100,
              context,
              'Home',
              _scaffoldKey,
              [
                const CustomIconButton(
                    icon: Icon(
                  Icons.add,
                  color: Colors.transparent,
                ))
              ],
              CustomIconButton(
                icon: const Icon(Icons.menu),
                callBack: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              )),
          drawer: const DrawerWidget(),
          floatingActionButton:
              state.isSOSAlarmActive == true ? _buildSosAlarmButton() : null,
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: DeviceInfo.height(1)),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      SizedBox(
                        height: getProportionateScreenHeight(20),
                      ),
                      _buildLocation(),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      BlocBuilder<AppServicesCubit, List<HomeServiceItem>>(
                        builder: (context, state) {
                          return _buildServices();
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
