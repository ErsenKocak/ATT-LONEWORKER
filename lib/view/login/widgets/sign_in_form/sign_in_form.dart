import 'package:att_loneworker/bloc/auth/auth_cubit.dart';
import 'package:att_loneworker/core/constants/routes/routes_name.dart';
import 'package:att_loneworker/model/auth/auth_request.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../core/constants/localization/localization_keys_constants.dart';
import '../../../../core/init/locator.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../core/validation/validation.dart';
import '../../../../core/widgets/default_button/default_button.dart';
import '../../../../core/widgets/form_error/form_error.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  final _logger = getIt<Logger>();

  String? userName;
  String? password;
  bool remember = false;
  final List<String> errors = [];

  bool isChecked = true;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              buildUserNameFormField(),
              const SizedBox(height: 20),
              buildPasswordFormField(),
              const SizedBox(height: 20),
              buildRememberMyChoiceCheckBox(),
              FormError(errors: errors),
              const SizedBox(height: 20),
              BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthLoadingState) {
                    EasyLoading.show();
                  } else if (state is AuthLoadedState) {
                    if (isChecked) {
                      // Box rememberMeBox =
                    }
                    EasyLoading.dismiss();
                    Navigator.pushReplacementNamed(
                        context, AppRoutesNames.homeView);
                  } else {
                    EasyLoading.dismiss();
                  }
                },
                child: DefaultButtonWidget(
                  text: 'Login',
                  press: () {
                    _logger.w('username password $userName ');
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      context.read<AuthCubit>().login(
                          authRequest: AuthRequest(
                            username: userName?.trim(),
                            password: password?.trim(),
                          ),
                          isRememberMe: isChecked);
                    }
                    // Navigator.pushReplacementNamed(
                    //     context, AppRoutesNames.homeView);

                    // Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildUserNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      autofocus: true,
      onSaved: (newValue) => userName = newValue,
      textInputAction: TextInputAction.next,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: LocalizationKeys.LOGIN_USERNAME_EMPTY.tr());
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: LocalizationKeys.LOGIN_USERNAME_EMPTY.tr());
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        labelText: LocalizationKeys.LOGIN_USERNAME.tr(),
        hintText: LocalizationKeys.LOGIN_USERNAME.tr(),
        // labelText: "Kullanıcı Adı",
        // hintText: "Kullanıcı Adı ",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.supervised_user_circle,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  buildPasswordFormField() {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      obscureText: _isObscure,
      autofocus: true,
      onSaved: (newValue) => password = newValue,
      onFieldSubmitted: (value) => {
        if (_formKey.currentState!.validate())
          {
            _formKey.currentState!.save(),
          }
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: LocalizationKeys.LOGIN_PASSWORD_EMPTY.tr());
        } else if (value.length < passwordValidationLength) {
          removeError(error: LocalizationKeys.LOGIN_PASSWORD_EMPTY.tr());
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: LocalizationKeys.LOGIN_PASSWORD_EMPTY.tr());
          return "";
        } else if (value.length < passwordValidationLength) {
          addError(error: LocalizationKeys.LOGIN_PASSWORD_EMPTY.tr());
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        labelText: LocalizationKeys.LOGIN_PASSWORD.tr(),
        hintText: LocalizationKeys.LOGIN_PASSWORD.tr(),
        // labelText: "Şifre",
        // hintText: "Şifre",
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColor),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
    );
  }

  buildRememberMyChoiceCheckBox() {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          activeColor: Theme.of(context).primaryColor,
          // fillColor: Theme.of(context).primaryColor,
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = !isChecked;
            });
          },
        ),
        Text(LocalizationKeys.LOGIN_REMEMBER_ME.tr()),
        // Text(_languageResourceService.keys.getValue('rememberMyChoices')),
      ],
    );
  }

  addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error.toString());
      });
    }
  }

  removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }
}
