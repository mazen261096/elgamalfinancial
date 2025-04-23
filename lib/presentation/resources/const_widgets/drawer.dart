// ignore_for_file: depend_on_referenced_packages

import 'package:moneytrack/cubit/auth/Auth_States.dart';
import 'package:moneytrack/cubit/wallet/wallet_cubit.dart';
import 'package:moneytrack/data/remote/FirebaseService/firebaseService_auth.dart';
import 'package:moneytrack/presentation/resources/colors_manager.dart';
import 'package:moneytrack/presentation/resources/const_widgets/const_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/app_prefs.dart';
import '../../../cubit/auth/Auth_cubit.dart';
import '../routes_manager.dart';
import '../strings_manager.dart';

class Drawer1 extends StatelessWidget {
  const Drawer1({super.key, required this.context});

  final BuildContext context;

  logOut() async {
    await BlocProvider.of<AuthCubit>(context)
        .logOut(context)
        .then((value) async {
      Navigator.pushReplacementNamed(context, Routes.loginRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: 300.w,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(
          left: context.locale == const Locale("ar", "SA")
              ? Radius.circular(20.r)
              : const Radius.circular(0),
          right: context.locale == const Locale("en", "US")
              ? Radius.circular(20.r)
              : const Radius.circular(0),
        )),
        child: SizedBox(
          width: 300.w,
          child: Column(
            children: [
              Container(
                color: ColorsManager.primary,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 15.sp),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ConstWidgets.circleImage(
                        url: AppPreferences.userData.profilePic,
                        diameter: 40.r,
                        ctx: context),
                    SizedBox(
                      width: 15.w,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.welcome.tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                                color: ColorsManager.white),
                          ),
                          Text(AppPreferences.userData.name,
                              style: TextStyle(
                                  fontSize: 20.sp, color: ColorsManager.white)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if (AppPreferences.userData.isAdmin)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                  child: ListTile(
                    leading: Icon(
                      Icons.admin_panel_settings,
                      color: Theme.of(context).primaryColor,
                      size: 30.sp,
                    ),
                    title: Text(AppStrings.adminPanel.tr(),
                        style: TextStyle(fontSize: 20.sp)),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.adminPanelRoute);
                    },
                  ),
                ),
              if (AppPreferences.userData.isAdmin) const Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.h),
                child: ListTile(
                  leading: Icon(Icons.person,
                      color: Theme.of(context).primaryColor, size: 30.sp),
                  title: Text(AppStrings.profile.tr(),
                      style: TextStyle(fontSize: 20.sp)),
                  onTap: () {
                    Routes.userId = FirebaseServiceAuth.getUser()!.uid;
                    Navigator.pushNamed(context, Routes.profileRoute);
                  },
                ),
              ),
              const Divider(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.h),
                child: ListTile(
                  leading: Icon(
                    Icons.history_edu_sharp,
                    color: Theme.of(context).primaryColor,
                    size: 30.sp,
                  ),
                  title: Text(AppStrings.allHistory.tr(),
                      style: TextStyle(fontSize: 20.sp)),
                  onTap: () {
                    Routes.trans =
                        BlocProvider.of<WalletCubit>(context).allTrans;
                    Navigator.pushNamed(context, Routes.historyRoute);
                  },
                ),
              ),
              const Divider(),
              BlocConsumer<AuthCubit, AuthStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is AuthConnectingState) {
                    return Center(
                      child: ConstWidgets.spinkit,
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.h),
                      child: ListTile(
                          leading: Icon(Icons.exit_to_app,
                              color: Theme.of(context).primaryColor,
                              size: 30.sp),
                          title: Text(AppStrings.signOut.tr(),
                              style: TextStyle(fontSize: 20.sp)),
                          onTap: () {
                            logOut();
                          }),
                    );
                  }
                },
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
