import 'package:moneytrack/cubit/wallet/wallet_cubit.dart';
import 'package:moneytrack/models/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/app_prefs.dart';
import '../../cubit/viewers/viewers_cubit.dart';
import '../../cubit/viewers/viewers_states.dart';
import '../resources/colors_manager.dart';
import '../resources/const_widgets/const_widgets.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';

class ViewerItem extends StatelessWidget {
  const ViewerItem({super.key, required this.user});
  final UserData user;

  clickItem(BuildContext context) {
    Routes.userId = user.id;
    Navigator.pushNamed(context, Routes.profileRoute);
  }

  void delete(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    BlocProvider.of<ViewersCubit>(context).userField = user;
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
                Text(
                  AppStrings.sureRemoveViewer.tr(),
                  style: TextStyle(fontSize: 20.sp),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  children: [
                    ConstWidgets.circleImage(
                        url: user.profilePic, diameter: 40.r, ctx: context),
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
                              user.phoneNumber.substring(2),
                              style: TextStyle(fontSize: 20.sp),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            actions: [
              Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await BlocProvider.of<ViewersCubit>(context).deleteViewer(
                          user: user,
                          walletId: BlocProvider.of<WalletCubit>(context)
                              .currentWallet!
                              .id);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0.sp),
                      child: Text(
                        AppStrings.delete.tr(),
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0.sp),
                      child: Text(
                        AppStrings.cancel.tr(),
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    )),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViewersCubit, ViewersStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              clickItem(context);
            },
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Card(
                  elevation: 10,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(2.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ConstWidgets.circleImage(
                                url: user.profilePic,
                                diameter: 40.r,
                                ctx: context),
                            SizedBox(
                              width: 15.w,
                            ),
                            Text(user.name,
                                style: TextStyle(
                                    color: ColorsManager.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp))
                          ],
                        ),
                        if (AppPreferences.userData.id != user.id)
                          (state is ViewersDeleteLoadingState &&
                                  BlocProvider.of<ViewersCubit>(context)
                                          .userField
                                          ?.id ==
                                      user.id)
                              ? Center(child: ConstWidgets.spinkit)
                              : IconButton(
                                  onPressed: () async {
                                    delete(context);
                                  },
                                  iconSize: 30.sp,
                                  icon: Icon(
                                    size: 30.sp,
                                    Icons.delete,
                                    color: Colors.red,
                                  ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
