import 'package:att_loneworker/core/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../enums/font/font_family.dart';
import '../../enums/font/font_weight.dart';
import '../custom_icon_button/custom_icon_button.dart';

appBarWidget(height, context, title, GlobalKey<ScaffoldState>? scaffoldKey,
        List<Widget>? actions, CustomIconButton? leadingIcon) =>
    PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, (height)),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            height: height + 40,
            width: MediaQuery.of(context).size.width,
            // Background
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [],
              ),
            ),
          ),
          Container(),
          Positioned(
            // top: 60.0,
            left: 20.0,
            right: 20.0,
            bottom: 0,
            child: AppBar(
              toolbarHeight: 60,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                  bottom: Radius.circular(20),
                ),
              ),
              leading: leadingIcon,

              title: Center(
                child: Text(
                  title,
                  style: TextStyle(
                      color: AppColors.primary,
                      fontFamily: AppFontFamily.WTGothic.value,
                      fontWeight: AppFontWeight.medium.value),
                ),
              ),

              // title: Center(
              //   child: Text(title,
              //       style: TextStyle(
              //           fontSize: 36.sp,
              //           fontWeight: FontWeight.w500,
              //           color: Theme.of(context).primaryColor)),
              // ),
              backgroundColor: Colors.white,
              primary: false,
              actions: actions ?? [const SizedBox()],
            ),
          )
        ],
      ),
    );
