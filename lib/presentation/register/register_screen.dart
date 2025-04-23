// ignore_for_file: depend_on_referenced_packages
import 'package:moneytrack/presentation/resources/assets_manager.dart';
import 'package:moneytrack/presentation/resources/routes_manager.dart';
import 'package:moneytrack/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/auth/Auth_States.dart';
import '../../cubit/auth/Auth_cubit.dart';
import '../../cubit/verification/verification_cubit.dart';
import '../resources/colors_manager.dart';
import '../resources/const_widgets/const_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  login() async {
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }

  register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    try {
      await BlocProvider.of<AuthCubit>(context)
          .register(email: email.text, password: password.text, name: name.text,number :mobileNumber.text)
          .then((value) async {

        Navigator.pushReplacementNamed(context, Routes.homeRoute);
      });
    } catch (error) {
      await ConstWidgets.errorDialog(context, error.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
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
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 10.h, horizontal: 10.w),
                    height: 736.h,
                    width: 360.w,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 10.w),
                              child: Image.asset(ImageAssets.splashLogo)),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                style: TextStyle(fontSize: 20.sp),
                                controller: name,
                                decoration: InputDecoration(
                                    labelText: AppStrings.name.tr()),
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if (val!.isEmpty || val.length < 3) {
                                    return AppStrings.nameValidation.tr();
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              TextFormField(
                                style: TextStyle(fontSize: 20.sp),
                                controller: email,
                                decoration: InputDecoration(
                                    labelText: AppStrings.email.tr()),
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if (val!.isEmpty || !val.contains('@')) {
                                    return AppStrings.emailValidation.tr();
                                  }
                                  if (!val.contains('@') ||
                                      !val.endsWith(".com")) {
                                    return AppStrings.emailValidation.tr();
                                  }
                                        
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              TextFormField(
                                style: TextStyle(fontSize: 20.sp),
                                controller: mobileNumber,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    labelText: AppStrings.phoneNumber.tr()),
                                obscureText: true,
                                validator: (val) {
                                        
                                  if (val!.isEmpty || val.length < 6) {
                                    return AppStrings.phoneValidation.tr();
                                  }if(val.length<11){
                                    return AppStrings.phoneValidation.tr();
                                  }if(!val.startsWith('01')){
                                    return AppStrings.phoneValidation.tr();
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
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              TextFormField(
                                style: TextStyle(fontSize: 20.sp),
                                controller: confirmPassword,
                                decoration: InputDecoration(
                                    labelText: AppStrings.confirmPassword.tr()),
                                obscureText: true,
                                validator: (val) {
                                  if (confirmPassword.text != password.text) {
                                    return AppStrings.passwordValidationNotMatch
                                        .tr();
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              (state is AuthSignUpState)
                                  ? ConstWidgets.spinkit
                                  : ElevatedButton(
                                      onPressed: register,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h, horizontal: 10.w),
                                        child: Text(
                                          AppStrings.signUp.tr(),
                                          style: TextStyle(fontSize: 20.sp),
                                        ),
                                      )),
                              SizedBox(
                                height: 10.h,
                              ),
                              ElevatedButton(
                                  onPressed: login,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 10.w),
                                    child: Text(
                                      AppStrings.signIn.tr(),
                                      style: TextStyle(fontSize: 20.sp),
                                    ),
                                  ))
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
