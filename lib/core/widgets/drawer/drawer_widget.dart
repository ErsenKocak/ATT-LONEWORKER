import 'package:att_loneworker/bloc/user_information/user_information_cubit.dart';
import 'package:att_loneworker/core/constants/colors.dart';
import 'package:att_loneworker/core/constants/routes/routes_name.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../constants/localization/localization_keys_constants.dart';
import '../default_button/default_button.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late UserInformationCubit _userInformationCubit;

  @override
  void initState() {
    super.initState();

    _userInformationCubit = context.read<UserInformationCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Container(
          width: 0.7.sw,
          decoration: const BoxDecoration(
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.white,
              //     spreadRadius: 1,
              //     blurRadius: 15,
              //     offset: Offset(0, 0), // changes position of shadow
              //   ),
              // ],
              ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(36),
                topRight: Radius.circular(36)),
            child: Drawer(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: buildDrawerHeader(context),
                  ),
                  Expanded(
                    flex: 3,
                    child: buildDrawerBody(context),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String get _userNameAndSurname {
    String userNameAndSurname = '';

    if (_userInformationCubit.userInformation?.firstname != null ||
        _userInformationCubit.userInformation?.firstname?.trim() != '') {
      userNameAndSurname += _userInformationCubit.userInformation!.firstname!;
    }

    if (_userInformationCubit.userInformation?.lastname != null ||
        _userInformationCubit.userInformation?.lastname?.trim() != '') {
      userNameAndSurname +=
          ' ${_userInformationCubit.userInformation!.lastname!}';
    }

    return userNameAndSurname;
  }

  buildDrawerHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.all(0),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: AppColors.progressBarColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            'https://icon-library.com/images/avatar-icon-images/avatar-icon-images-4.jpg',
            width: 75,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            _userNameAndSurname,
            style: const TextStyle(fontSize: 14.0, color: Colors.white),
          ),
          Text(
            'personel@mail.com',
            style: const TextStyle(fontSize: 14.0, color: Colors.grey),
          )
        ],
      ),
    );
  }

  buildDrawerBody(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: Text(tr(LocalizationKeys.NAME_HOME)),
          onTap: () {
            navigate(context, AppRoutesNames.homeView);
          },
        ),
        ListTile(
          leading: const Icon(Icons.security),
          title: Text(tr(LocalizationKeys.ALARM_SETTINGS)),
          onTap: () {
            navigateWithOutReplacement(
                context, AppRoutesNames.alarmSettingsView);
          },
        ),
        ListTile(
          leading: const Icon(Icons.battery_alert_sharp),
          title: Text(tr(LocalizationKeys.BATTERY_ALARM)),
          onTap: () {
            navigateWithOutReplacement(
                context, AppRoutesNames.batterySettingsView);
          },
        ),
        ListTile(
          leading: const Icon(Icons.accessibility_new_rounded),
          title: Text(tr(LocalizationKeys.TILT_ALERT)),
          onTap: () {
            navigateWithOutReplacement(
                context, AppRoutesNames.tiltAlertSettingsView);
          },
        ),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: Text(tr(LocalizationKeys.LOCATION_SETTINGS)),
          onTap: () {
            navigateWithOutReplacement(
                context, AppRoutesNames.locationSettingsSettingsView);
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(tr(LocalizationKeys.NAME_SETTINGS)),
          onTap: () {
            navigateWithOutReplacement(context, AppRoutesNames.settingsView);
          },
        ),
        const Divider(thickness: 1.5),
        ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(tr(LocalizationKeys.LOGOUT)),
            onTap: () {
              context.read<AuthCubit>().logout(context);
            }),
      ],
    );
  }

  navigate(BuildContext context, String url) {
    Navigator.pop(context);

    Navigator.of(context, rootNavigator: true).pushReplacementNamed(url);
  }

  navigateWithOutReplacement(BuildContext context, String url) {
    Navigator.pop(context);

    Navigator.of(context, rootNavigator: true).pushNamed(url);
  }
}
