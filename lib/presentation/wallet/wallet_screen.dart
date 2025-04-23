import 'package:moneytrack/app/app_prefs.dart';
import 'package:moneytrack/presentation/resources/colors_manager.dart';
import 'package:moneytrack/presentation/resources/const_widgets/const_widgets.dart';
import 'package:moneytrack/presentation/wallet/wallet_deposit.dart';
import 'package:moneytrack/presentation/wallet/wallet_withdaw.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/wallet/wallet_cubit.dart';
import '../../cubit/wallet/wallet_states.dart';
import '../resources/assets_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  clickMembers() => Navigator.of(context).pushNamed(Routes.membersRoute);

  clickViewers() => Navigator.of(context).pushNamed(Routes.viewersRoute);

  clickHistory() {
    Routes.trans =
        BlocProvider.of<WalletCubit>(context).currentWallet!.transactions;
    Navigator.of(context).pushNamed(Routes.historyRoute);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorsManager.primary, ColorsManager.white],
                begin: const Alignment(0, -0.5),
                end: const Alignment(0, 1),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.sp),
            child: Scaffold(
              appBar: ConstWidgets.appBar(context),
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: SizedBox(
                    height: 736.h-MediaQuery.of(context).padding.top - kToolbarHeight,
                    width: 360.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${BlocProvider.of<WalletCubit>(context).currentWallet?.name}',
                              style: TextStyle(
                                  color: ColorsManager.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35.sp),
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 45.w, vertical: 20.sp),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.sp),
                                  border: Border.all(color: Colors.white)),
                              child: Padding(
                                padding: EdgeInsets.all(20.sp),
                                child: Column(
                                  children: [
                                    Text(
                                      AppStrings.availableBalance.tr(),
                                      style: TextStyle(
                                          color: ColorsManager.white,
                                          fontSize: 20.sp),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      NumberFormat('###,###,###').format(
                                          BlocProvider.of<WalletCubit>(context)
                                              .currentWallet
                                              ?.balance),
                                      style: TextStyle(
                                          color: ColorsManager.lightprimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.sp),
                                    ),
                                    Text(
                                      AppStrings.egp.tr(),
                                      style: TextStyle(
                                          color: ColorsManager.lightprimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      NumberFormat('###,###,###').format(
                                          BlocProvider.of<WalletCubit>(context)
                                              .currentWallet
                                              ?.expenses),
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (BlocProvider.of<WalletCubit>(context)
                                .currentWallet!
                                .members
                                .contains(
                                    FirebaseAuth.instance.currentUser!.uid) ||
                            AppPreferences.userData.isAdmin)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return WalletDeposit();
                                      });
                                },
                                child: Column(
                                  children: [
                                    ImageIcon(
                                      const AssetImage(
                                        ImageAssets.deposit,
                                      ),
                                      color: ColorsManager.primary,
                                      size: 50.sp,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      AppStrings.deposit.tr(),
                                      style: TextStyle(
                                          color: ColorsManager.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return WalletWithdraw();
                                      });
                                },
                                child: Column(
                                  children: [
                                    ImageIcon(
                                      const AssetImage(ImageAssets.withdraw),
                                      color: ColorsManager.primary,
                                      size: 50.sp,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      AppStrings.withdraw.tr(),
                                      style: TextStyle(
                                          color: ColorsManager.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, Routes.payRoute);
                                },
                                child: Column(
                                  children: [
                                    ImageIcon(
                                      const AssetImage(ImageAssets.pay),
                                      color: ColorsManager.primary,
                                      size: 50.sp,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Text(
                                      AppStrings.pay.tr(),
                                      style: TextStyle(
                                          color: ColorsManager.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: clickHistory,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.sp)),
                                color: ColorsManager.white,
                                elevation: 5,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.history_edu_sharp,
                                        color: ColorsManager.primary,
                                        size: 50.sp,
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            AppStrings.walletHistory.tr(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: ColorsManager.primary,
                                                fontSize: 20.sp),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            if (BlocProvider.of<WalletCubit>(context)
                                    .currentWallet!
                                    .members
                                    .contains(FirebaseAuth
                                        .instance.currentUser!.uid) ||
                                AppPreferences.userData.isAdmin)
                              InkWell(
                                onTap: clickMembers,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.sp)),
                                  color: ColorsManager.white,
                                  elevation: 5,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0.sp),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.supervised_user_circle,
                                          color: ColorsManager.primary,
                                          size: 50.sp,
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              AppStrings.members.tr(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorsManager.primary,
                                                  fontSize: 20.sp),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 15.h,
                            ),
                            InkWell(
                              onTap: clickViewers,
                              child: Card(
                                margin: EdgeInsets.only(bottom: 15.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.sp)),
                                color: ColorsManager.white,
                                elevation: 5,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.remove_red_eye_rounded,
                                        color: ColorsManager.primary,
                                        size: 50.sp,
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            AppStrings.viewers.tr(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: ColorsManager.primary,
                                                fontSize: 20.sp),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )),
          );
        });
  }
}
