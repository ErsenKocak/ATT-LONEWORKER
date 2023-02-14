import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../constants/colors.dart';

class ToggleSwitchWidget extends StatelessWidget {
  ToggleSwitchWidget(
      {super.key,
      this.customWidths,
      this.cornerRadius,
      this.activeBgColors,
      this.icons,
      this.totalSwitches,
      this.onToggle,
      this.initialLabelIndex = 0,
      this.iconSize,
      this.customHeights});

  final List<double>? customWidths;
  final List<double>? customHeights;
  final List<List<Color>?>? activeBgColors;
  final List<IconData?>? icons;
  final double? iconSize;
  final double? cornerRadius;
  final int? totalSwitches;
  final int? initialLabelIndex;
  final Function(int?)? onToggle;

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      customWidths: customWidths ?? [50.0, 50.0],
      customHeights: customHeights,
      cornerRadius: cornerRadius ?? 12.0,
      activeBgColors: activeBgColors ??
          [
            [AppColors.progressBarColor],
            [AppColors.primary]
          ],
      activeFgColor: Colors.white,
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.white,
      initialLabelIndex: initialLabelIndex,
      totalSwitches: totalSwitches ?? 2,
      icons: icons ?? [Icons.check, Icons.cancel_outlined],
      iconSize: iconSize ?? 17.0,
      onToggle: (index) {
        if (onToggle != null) onToggle!(index);
      },
    );
  }
}
