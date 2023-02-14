import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Icon icon;
  final String? message;
  final VoidCallback? callBack;

  const CustomIconButton(
      {Key? key, required this.icon, this.message, this.callBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        disabledColor: Theme.of(context).primaryColor.withOpacity(0.5),
        color: Theme.of(context).primaryColor,
        icon: icon,
        tooltip: message,
        onPressed: callBack);
  }
}
