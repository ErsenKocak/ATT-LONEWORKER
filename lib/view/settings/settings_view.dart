import 'package:att_loneworker/bloc/app_services/app_services_cubit.dart';
import 'package:att_loneworker/core/constants/colors.dart';
import 'package:att_loneworker/core/constants/routes/routes_name.dart';
import 'package:att_loneworker/core/widgets/app_button/app_button_widget.dart';
import 'package:att_loneworker/core/widgets/checkbox/checkbox_widget.dart';
import 'package:att_loneworker/core/widgets/drawer/drawer_widget.dart';
import 'package:att_loneworker/helpers/device_screen_info/device_screen_info.dart';
import 'package:att_loneworker/model/home_service_item/home_service_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';

import '../../core/constants/app_services/app_services_constant.dart';
import '../../core/constants/localization/localization_keys_constants.dart';
import '../../core/enums/font/font_family.dart';
import '../../core/enums/font/font_weight.dart';
import '../../core/init/locator.dart';
import '../../core/widgets/appbar/app_bar_widget.dart';
import '../../core/widgets/bottom_sheet_header/bottom_sheet_header.dart';
import '../../core/widgets/custom_icon_button/custom_icon_button.dart';
import '../../core/widgets/toggle_switch/toggle_switch_widget.dart';
import '../../helpers/device_screen_info/device_info.dart';
import '../../helpers/navigation/navigation_helper.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  final _logger = getIt<Logger>();
  late AppServicesCubit appServicesCubit;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    appServicesCubit = context.read<AppServicesCubit>();
  }

  get _buildAppBar {
    return appBarWidget(
      AppBar().preferredSize.height + 100,
      context,
      tr(LocalizationKeys.SETTINGS_VIEW__APP_BAR_TITLE),
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
    );
  }

  Widget get _buildServiceSelection {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Shortcut Service Selection',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(14),
            fontFamily: AppFontFamily.LatoTR.value,
          ),
        ),
        ToggleSwitchWidget(
          totalSwitches: 1,
          initialLabelIndex: 0,
          cornerRadius: 8,
          activeBgColors: const [
            [AppColors.primary]
          ],
          icons: const [
            Icons.keyboard_arrow_up,
          ],
          onToggle: (index) => _onTapServiceSelection(),
        )
      ],
    );
  }

  _onTapServiceSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocBuilder<AppServicesCubit, List<HomeServiceItem>>(
          builder: (context, state) {
            return Container(
              constraints: BoxConstraints(maxHeight: DeviceInfo.height(80)),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: DeviceInfo.height(2),
                  ),
                  const BottomSheetModalHeaderWidget(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: DeviceInfo.width(3),
                        vertical: DeviceInfo.height(2)),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Services',
                          style: TextStyle(
                            color: AppColors.darkerGrey,
                            fontFamily: AppFontFamily.LatoTR.value,
                            fontSize: ScreenUtil().setSp(18),
                            fontWeight: AppFontWeight.bold.value,
                          ),
                        ),
                        Container(
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _divider,
                  SizedBox(
                    height: DeviceInfo.height(2),
                  ),
                  Container(
                    constraints:
                        BoxConstraints(maxHeight: DeviceInfo.height(50)),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: _buildHomeServices,
                    ),
                  ),
                  SizedBox(
                    height: DeviceInfo.height(2),
                  ),
                  AppButtonWidget(
                      buttonText: tr(LocalizationKeys.CLOSE),
                      backgroundColor: AppColors.darkerGrey,
                      textColor: Colors.white,
                      onTap: () => Navigator.pop(context)),
                  SizedBox(
                    height: DeviceInfo.height(2),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget get _buildHomeServices {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: appServicesCubit.allHomeServices.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                appServicesCubit.allHomeServices[index].isSelected =
                    !appServicesCubit.allHomeServices[index].isSelected!;

                var selectedServices = appServicesCubit.allHomeServices
                    .where((service) => service.isSelected == true)
                    .toList();

                appServicesCubit.updateHomeServicesList(
                    selectedServices: selectedServices);
              },
              child: Container(
                color: Colors.transparent,
                margin: EdgeInsets.symmetric(vertical: DeviceInfo.width(1)),
                padding: EdgeInsets.symmetric(horizontal: DeviceInfo.width(3)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AppCheckboxWidget(
                        isChecked: appServicesCubit
                                .allHomeServices[index].isSelected ??
                            false,
                        size: DeviceInfo.height(2.5)),
                    SizedBox(
                      width: DeviceInfo.width(2),
                    ),
                    Text(
                      tr(appServicesCubit.allHomeServices[index].title!) ?? '',
                      style: TextStyle(
                        color: AppColors.darkerGrey,
                        fontFamily: AppFontFamily.LatoTR.value,
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: AppFontWeight.regular.value,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Divider get _divider {
    return const Divider(
      height: 1,
      thickness: 0.5,
      color: AppColors.divider,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerWidget(),
      appBar: _buildAppBar,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(getProportionateScreenWidth(10)),
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [_buildServiceSelection],
        ),
      ),
    );
  }
}
