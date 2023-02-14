import 'package:att_loneworker/core/constants/colors.dart';
import 'package:flutter/material.dart';

class AppCheckboxWidget extends StatelessWidget {
  final bool isChecked;
  final double size;
  final bool hasError;
  Color? borderColor;
  Color? color;

  AppCheckboxWidget({
    required this.isChecked,
    required this.size,
    this.hasError = false,
    this.color = AppColors.primary,
    this.borderColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
            color: hasError ? Color(0xffe02020) : borderColor!, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Container(
        width: size - (size / 4),
        height: size - (size / 4),
        decoration: BoxDecoration(
          color: isChecked ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
