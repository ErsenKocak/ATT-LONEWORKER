import 'package:flutter/material.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(errors.length,
          (index) => formErrorText(error: errors[index], context: context)),
    );
  }

  Row formErrorText({required String error, required BuildContext context}) {
    return Row(
      children: [
        Icon(
          Icons.error,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(
          width: 12,
        ),
        Text(error),
      ],
    );
  }
}
