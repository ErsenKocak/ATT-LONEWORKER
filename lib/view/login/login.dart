import 'package:att_loneworker/core/constants/image/image_names.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

import 'widgets/sign_in_form/sign_in_form.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(flex: 2),
              Expanded(
                flex: 5,
                child: buildLogoContainer(),
              ),
              const Spacer(),
              Expanded(
                flex: 12,
                child: buildSignInFormContainer(),
              ),
              const Spacer(),
            ],
          )),
    );
  }

  buildLogoContainer() {
    return Image.asset(AppImagesNames.appLogo);
  }

  buildSignInFormContainer() {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(), child: SignForm());
  }
}
