// ignore_for_file: depend_on_referenced_packages

import 'package:moneytrack/cubit/wallet/wallet_cubit.dart';
import 'package:moneytrack/presentation/resources/assets_manager.dart';
import 'package:moneytrack/presentation/resources/const_widgets/const_widgets.dart';
import 'package:moneytrack/presentation/resources/routes_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/app_prefs.dart';
import '../../cubit/auth/Auth_States.dart';
import '../../cubit/auth/Auth_cubit.dart';
import '../../cubit/verification/verification_cubit.dart';
import '../resources/colors_manager.dart';
import '../resources/strings_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await BlocProvider.of<AuthCubit>(context)
          .loginWithEmail(email.text, password.text)
          .then((value) {

          BlocProvider.of<WalletCubit>(context).fetchWallets();
          Navigator.pushReplacementNamed(context, Routes.homeRoute);

      });
    } catch (error) {
      await ConstWidgets.errorDialog(context, error.toString());
    }
  }

  void forgotPassword() {
    BlocProvider.of<VerificationCubit>(context).verificationRoute =
        Routes.newPasswordRoute;
    BlocProvider.of<VerificationCubit>(context).codeSent = false;
    Navigator.pushNamed(context, Routes.verificationRoute);
  }

  register() async {
    Navigator.pushReplacementNamed(context, Routes.registerRoute);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            height: 736.h,
            width: 360.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorsManager.primary, ColorsManager.white],
                begin: const Alignment(0, -1),
                end: const Alignment(0, 1),
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Container(
                      height: 736.h,
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 10.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                              height: 300.h,
                              width: 360.w,
                              padding: EdgeInsets.symmetric(
                                  vertical: 20.h, horizontal: 20.w),
                              child: Image.asset(ImageAssets.splashLogo,fit: BoxFit.fill,)),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                style: TextStyle(fontSize: 20.sp),
                                controller: email,
                                decoration: InputDecoration(
                                    labelText:
                                        AppStrings.emailOrPhoneNumber.tr()),
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return AppStrings.enterEmailorNumber.tr();
                                  }
                                  if (RegExp(r'^[0-9]+$').hasMatch(val)) {
                                    if (val.length != 11) {
                                      return AppStrings.phoneValidation.tr();
                                    }
                                  } else {
                                    if (!val.contains('@') &&
                                        val.endsWith(".com")) {
                                      return AppStrings.emailValidation.tr();
                                    }
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              TextFormField(
                                style: TextStyle(fontSize: 20.sp),
                                controller: password,
                                decoration: InputDecoration(
                                    labelText: AppStrings.password.tr()),
                                obscureText: true,
                                validator: (val) {
                                  if (val!.isEmpty || val.length < 6) {
                                    return AppStrings.passwordValidation.tr();
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (val) {
                                  login();
                                },
                              ),
                              TextButton(
                                  onPressed: forgotPassword,
                                  child: Text(AppStrings.forgotPassword.tr(),
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color:
                                              Theme.of(context).primaryColor))),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: (state is AuthConnectingState)
                                    ? ConstWidgets.spinkit
                                    : ElevatedButton(
                                        onPressed: login,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h, horizontal: 10.w),
                                          child: Text(
                                            AppStrings.signIn.tr(),
                                            style: TextStyle(fontSize: 20.sp),
                                          ),
                                        )),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                    onPressed: register,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h, horizontal: 10.w),
                                      child: Text(
                                        AppStrings.signUp.tr(),
                                        style: TextStyle(fontSize: 20.sp),
                                      ),
                                    )),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        );
      },
    );
  }
}
