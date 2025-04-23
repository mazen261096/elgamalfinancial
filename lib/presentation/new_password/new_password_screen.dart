import 'package:moneytrack/presentation/resources/routes_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/app_prefs.dart';
import '../../cubit/auth/Auth_States.dart';
import '../../cubit/auth/Auth_cubit.dart';
import '../../cubit/wallet/wallet_cubit.dart';
import '../resources/colors_manager.dart';
import '../resources/const_widgets/const_widgets.dart';
import '../resources/strings_manager.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController password = TextEditingController();

  final TextEditingController confirmPassword = TextEditingController();

  Future<void> changePassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await BlocProvider.of<AuthCubit>(context)
          .newPassword(password.text)
          .then((_) {
        BlocProvider.of<WalletCubit>(context).fetchWallets();
        Navigator.pushReplacementNamed(context, Routes.homeRoute);
      });
    } catch (error) {
      ConstWidgets.errorDialog(context, error.toString());
    }
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
                  child: SingleChildScrollView(
                    child: Container(
                      height: 736.h,
                      width: 360.w,
                      padding: EdgeInsets.all(10.r),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: (360.w / 3.5) + 2.w,
                                backgroundColor: Colors.white,
                                child: ConstWidgets.circleImage(
                                    url: AppPreferences.userData.profilePic,
                                    diameter: (360.w / 3.5),
                                    ctx: context),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Text(
                                '${AppStrings.welcome.tr()}  ${AppPreferences.userData.name}',
                                style: TextStyle(fontSize: 20.sp),
                              ),
                              Text(AppPreferences.user.email!,
                                  style: TextStyle(fontSize: 20.sp)),
                            ],
                          ),
                          Column(
                            children: [
                              TextFormField(
                                style: TextStyle(fontSize: 20.sp),
                                controller: password,
                                decoration: InputDecoration(
                                    labelStyle: TextStyle(fontSize: 20.sp),
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
                                    labelStyle: TextStyle(fontSize: 20.sp),
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
                              SizedBox(
                                height: 25.h,
                              ),
                              (state is AuthChangePasswordState)
                                  ? ConstWidgets.spinkit
                                  : ElevatedButton(
                                      onPressed: () {
                                        changePassword(context);
                                      },
                                      child: Text(
                                        AppStrings.updatePassword.tr(),
                                        style: TextStyle(fontSize: 20.sp),
                                      )),
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
