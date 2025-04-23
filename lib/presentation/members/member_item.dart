import 'package:moneytrack/cubit/members/members_cubit.dart';
import 'package:moneytrack/cubit/wallet/wallet_cubit.dart';
import 'package:moneytrack/models/user.dart';
import 'package:moneytrack/presentation/resources/const_widgets/const_widgets.dart';
import 'package:moneytrack/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/app_prefs.dart';
import '../../cubit/members/members_states.dart';
import '../resources/colors_manager.dart';
import '../resources/routes_manager.dart';

class MemberItem extends StatelessWidget {
  const MemberItem({super.key, required this.user});
  final UserData user;

  clickItem(BuildContext context) {
    Routes.userId = user.id;
    Navigator.pushNamed(context, Routes.profileRoute);
  }

  void delete(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    BlocProvider.of<MembersCubit>(context).userField = user;
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
                  AppStrings.sureRemoveMember.tr(),
                  style: TextStyle(fontSize: 20.sp),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: ConstWidgets.circleImage(
                          url: user.profilePic, diameter: 40.r, ctx: context),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
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
              ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await BlocProvider.of<MembersCubit>(context).deleteMember(
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
              Padding(
                padding: EdgeInsets.all(8.sp),
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
    return BlocConsumer<MembersCubit, MembersStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                clickItem(context);
              },
              child: Card(
                margin: EdgeInsets.only(top: 10.h),
                elevation: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5.0.sp),
                      child: ConstWidgets.circleImage(
                          url: user.profilePic, diameter: 30.r, ctx: context),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0.sp),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                              child: Text(user.name,
                                  style: TextStyle(
                                      color: ColorsManager.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp))),
                          SizedBox(
                            height: 5.h,
                          ),
                          Flexible(
                              child: Text(
                            '${NumberFormat('###,###,###').format(BlocProvider.of<MembersCubit>(context).memberExpense(ctx: context, uid: user.id))} ${AppStrings.egp.tr()}',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp),
                          )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0.sp),
                      child: Visibility(
                        visible: AppPreferences.userData.id != user.id,
                        child: (state is MembersDeleteLoadingState &&
                                BlocProvider.of<MembersCubit>(context)
                                        .userField
                                        ?.id ==
                                    user.id)
                            ? Padding(
                                padding: EdgeInsets.all(8.sp),
                                child: ConstWidgets.spinkit,
                              )
                            : IconButton(
                                iconSize: 30.sp,
                                onPressed: () async {
                                  delete(context);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 30.sp,
                                )),
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}
