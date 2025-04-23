import 'package:moneytrack/models/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/app_prefs.dart';
import '../../cubit/admin/admin_cubit.dart';
import '../../cubit/admin/admin_states.dart';
import '../resources/colors_manager.dart';
import '../resources/const_widgets/const_widgets.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';

class AdminItem extends StatelessWidget {
  const AdminItem({super.key, required this.user});
  final UserData user;

  clickItem(BuildContext context) {
    Routes.userId = user.id;
    Navigator.pushNamed(context, Routes.profileRoute);
  }

  void delete(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    BlocProvider.of<AdminCubit>(context).userField = user;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.sp)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppStrings.sureRemoveAdmin.tr(),
                    style: TextStyle(fontSize: 20.sp)),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  children: [
                    ConstWidgets.circleImage(
                        url: user.profilePic, diameter: 50.r, ctx: context),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.sp),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                                style: TextStyle(fontSize: 20.sp),
                                user.phoneNumber.substring(2)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await BlocProvider.of<AdminCubit>(context).deleteAdmin();
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.w),
                    child: Text(AppStrings.delete.tr()),
                  )),
              Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0.h, horizontal: 8.w),
                      child: Text(AppStrings.cancel.tr()),
                    )),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              clickItem(context);
            },
            child: Card(
              elevation: 10,
              margin: EdgeInsets.only(bottom: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                    child: ConstWidgets.circleImage(
                        url: user.profilePic, diameter: 40.r, ctx: context),
                  ),
                  Flexible(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                      child: Center(
                        child: Text(user.name,
                            style: TextStyle(
                                color: ColorsManager.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp)),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: AppPreferences.userData.id != user.id,
                      child: (state is AdminDeleteLoadingState &&
                              BlocProvider.of<AdminCubit>(context)
                                      .userField
                                      ?.id ==
                                  user.id)
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 5.w),
                              child: ConstWidgets.spinkit,
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 5.w),
                              child: IconButton(
                                  iconSize: 30.sp,
                                  onPressed: () async {
                                    delete(context);
                                  },
                                  icon: Icon(
                                    size: 30.sp,
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ))
                ],
              ),
            ),
          );
        });
  }
}
