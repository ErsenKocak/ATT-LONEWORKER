import 'package:flutter/material.dart';

import '../../../core/widgets/custom_icon_button/custom_icon_button.dart';

alarmSettingsViewAppBarActions(context) => [
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
