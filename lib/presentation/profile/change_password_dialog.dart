import 'package:moneytrack/cubit/auth/Auth_States.dart';
import 'package:moneytrack/cubit/auth/Auth_cubit.dart';
import 'package:moneytrack/presentation/resources/routes_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/const_widgets/const_widgets.dart';
import '../resources/strings_manager.dart';

class ChangePasswordDialog extends StatelessWidget {
  ChangePasswordDialog({super.key});

  final TextEditingController oldPassword = TextEditingController();

  final TextEditingController newPassword = TextEditingController();

  final TextEditingController confirmPassword = TextEditingController();

  Future<void> _changePassword(BuildContext context) async {
    try {
      await BlocProvider.of<AuthCubit>(context)
          .updatePassword(
              oldPassword: oldPassword.text,
              newPassword: newPassword.text,
              context: context)
          .then((value) {
        BlocProvider.of<AuthCubit>(context).logOut(context).then((value) {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.loginRoute, (route) => false);
        });
      });
    } catch (error) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 15.h,
                width: 360.w / 2,
              ),
              TextFormField(
                style: TextStyle(fontSize: 20.sp),
                controller: oldPassword,
                decoration: InputDecoration(
                    labelText: AppStrings.password.tr(),
                    labelStyle: TextStyle(fontSize: 20.sp)),
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
                controller: newPassword,
                decoration: InputDecoration(
                    labelText: AppStrings.password.tr(),
                    labelStyle: TextStyle(fontSize: 20.sp)),
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
                    labelText: AppStrings.confirmPassword.tr(),
                    labelStyle: TextStyle(fontSize: 20.sp)),
                obscureText: true,
                validator: (val) {
                  if (val!.isEmpty || val.length < 6) {
                    return AppStrings.passwordValidation.tr();
                  }
                  if (confirmPassword.text != newPassword.text) {
                    return AppStrings.passwordValidationNotMatch.tr();
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 25.h,
              ),
              state is AuthChangePasswordState
                  ? ConstWidgets.spinkit
                  : Padding(
                      padding: EdgeInsets.all(8.0.sp),
                      child: ElevatedButton(
                          onPressed: () {
                            _changePassword(context);
                          },
                          child: Text(
                            AppStrings.confirm.tr(),
                            style: TextStyle(fontSize: 20.sp),
                          )),
                    )
            ],
          );
        });
  }
}
