import 'package:att_loneworker/core/widgets/custom_icon_button/custom_icon_button.dart';
import 'package:flutter/material.dart';

homeViewAppBarActions(context) => [
      Row(
        children: const [
          const CustomIconButton(
              icon: Icon(
            Icons.add,
            color: Colors.transparent,
          ))
        ],
      )
    ];
