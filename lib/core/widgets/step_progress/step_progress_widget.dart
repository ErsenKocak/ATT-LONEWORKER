import 'package:att_loneworker/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class StepProgressWidget extends StatelessWidget {
  StepProgressWidget(
      {super.key,
      this.initialStep = 0,
      this.totalStep = 10,
      this.selectedColor = AppColors.primary,
      this.unselectedColor = AppColors.lightGrey,
      this.selectedSize = 8,
      this.size = 6,
      this.onTap});

  final Function(int)? onTap;
  final int? initialStep;
  final int? totalStep;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double? selectedSize;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return StepProgressIndicator(
      totalSteps: totalStep!,
      currentStep: initialStep!,
      selectedColor: selectedColor!,
      unselectedColor: unselectedColor!,
      selectedSize: selectedSize,
      size: size!,
      onTap: (value) => () {
        if (onTap != null) onTap!(value + 1);
      },
    );
  }
}
