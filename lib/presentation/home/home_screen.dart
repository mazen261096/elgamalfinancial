// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';

import 'package:moneytrack/data/remote/FirebaseService/firebaseService_auth.dart';
import 'package:moneytrack/data/remote/FirebaseService/firebaseService_fireStore.dart';
import 'package:moneytrack/models/transaction.dart';
import 'package:moneytrack/presentation/home/wallet_item.dart';
import 'package:moneytrack/presentation/resources/const_widgets/const_widgets.dart';
import 'package:moneytrack/presentation/resources/const_widgets/drawer.dart';
import 'package:moneytrack/presentation/resources/routes_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/app_prefs.dart';
import '../../cubit/wallet/wallet_cubit.dart';
import '../../cubit/wallet/wallet_states.dart';
import '../resources/colors_manager.dart';
import '../resources/strings_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  static Future<void> saveNotification(RemoteMessage message) async {
    await Firebase.initializeApp();
    Map<String, dynamic> data = message.data;
    data['createdAt'] = DateTime.parse(data['createdAt'] ?? DateTime.now());
    data['amount'] = int.parse(data['amount'] ?? '0');
    data['clicked'] = false;

    await FirebaseServiceFireStore.createDocumentInCollection(
        "users", FirebaseServiceAuth.getUser()!.uid, 'notification', data);
  }




  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
  }

  addWallet(BuildContext context) {
    Navigator.pushNamed(context, Routes.addWalletRoute);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Container(
            height: 736.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorsManager.primary, ColorsManager.white],
                begin: const Alignment(0, -0.5),
                end: const Alignment(0, 1),
              ),
            ),
            child: Scaffold(
/*
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  flutterLocalNotificationsPlugin.show(
                    1,
                    'title',
                    'body',
                    NotificationDetails(
                      android: AndroidNotificationDetails(
                        channel.id,
                        channel.name,
                      ),
                      iOS: DarwinNotificationDetails(),
                    ),
                  );
                },
                child: Icon(Icons.add),
              ),
*/
              drawer: Drawer1(context: context),
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                actions: [
                  (state is WalletNotificationLoadingState ||
                          state is WalletLoadingState)
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Center(
                            child: ConstWidgets.spinkit,
                          ))
                      : IconButton(
                          icon:
                              BlocProvider.of<WalletCubit>(context).notification
                                  ? Icon(
                                      Icons.notifications,
                                      size: 25.sp,
                                    )
                                  : Icon(
                                      Icons.notifications_off,
                                      size: 25.sp,
                                    ),
                          onPressed: (){},
                        ),
                ],
              ),
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          horizontal: 45.w, vertical: 20.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.sp),
                          border: Border.all(color: Colors.white)),
                      child: (state is WalletLoadingState)
                          ? Padding(
                              padding: EdgeInsets.all(20.sp),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: ConstWidgets.spinkit,
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    '${BlocProvider.of<WalletCubit>(context).walletsLoadedNumber.toString()} of ${BlocProvider.of<WalletCubit>(context).walletsNumber.toString()} ....',
                                    style: TextStyle(
                                        color: ColorsManager.lightprimary,
                                        fontSize: 20.sp),
                                  )
                                ],
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.all(20.sp),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        AppStrings.totalBalance.tr(),
                                        style: TextStyle(
                                            color: ColorsManager.white,
                                            fontSize: 20.sp),
                                      ),
                                      Text(
                                        NumberFormat('###,###,###').format(
                                            BlocProvider.of<WalletCubit>(
                                                    context)
                                                .balance),
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
                                    ],
                                  ),
                                  Text(
                                    NumberFormat('###,###,###').format(
                                        BlocProvider.of<WalletCubit>(context)
                                            .expenses),
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.sp),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${AppStrings.yourWallets.tr()} ( ${BlocProvider.of<WalletCubit>(context).wallets.length} )',
                            style: TextStyle(
                                color: ColorsManager.white, fontSize: 15.sp),
                          ),
                          if (AppPreferences.userData.isAdmin)
                            IconButton(
                              icon: Icon(
                                size: 25.sp,
                                Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                addWallet(context);
                              },
                            ),
                        ],
                      ),
                    ),
                    (state is WalletLoadingState ||
                            state is WalletFreezingState)
                        ? Expanded(
                            child: Center(
                              child: ConstWidgets.spinkit,
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: BlocProvider.of<WalletCubit>(context)
                                    .wallets
                                    .length,
                                itemBuilder: (BuildContext context, index) {
                                  return WalletItem(
                                      index: index,
                                      id: BlocProvider.of<WalletCubit>(context)
                                          .wallets[index]
                                          .id,
                                      title:
                                          BlocProvider.of<WalletCubit>(context)
                                              .wallets[index]
                                              .name,
                                      description:
                                          BlocProvider.of<WalletCubit>(context)
                                              .wallets[index]
                                              .description,
                                      balance:
                                          BlocProvider.of<WalletCubit>(context)
                                              .wallets[index]
                                              .balance,
                                      expenses:
                                          BlocProvider.of<WalletCubit>(context)
                                              .wallets[index]
                                              .expenses);
                                }),
                          ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

/*                       GestureDetector(
                      onTap: (){
                        Routes.userId=FirebaseServiceAuth.getUser()!.uid;
                        Navigator.pushNamed(context, Routes.profileRoute);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ConstWidgets.circleImage(
                              url: AppPreferences.userData.profilePic,
                              diameter: 40.sp,
                              ctx: context),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text(AppPreferences.userData.name,
                                  style: TextStyle(
                                      color: ColorsManager.white,
                                      fontWeight: FontWeight.bold,fontSize: 20.sp)),
                              Text(AppPreferences.userData.isAdmin?AppStrings.admin.tr():'',
                                  style: TextStyle(
                                      color: ColorsManager.white,
                                      fontSize: 20.sp
                                  ))
                            ],),
                          ),
                        ],
                      ),
                    ),
  */
