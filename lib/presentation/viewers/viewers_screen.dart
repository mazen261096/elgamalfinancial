import 'package:moneytrack/cubit/wallet/wallet_cubit.dart';
import 'package:moneytrack/presentation/viewers/viewer_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/viewers/viewers_cubit.dart';
import '../../cubit/viewers/viewers_states.dart';
import '../resources/colors_manager.dart';
import '../resources/const_widgets/const_widgets.dart';
import '../resources/strings_manager.dart';

class ViewersScreen extends StatefulWidget {
  const ViewersScreen({super.key});

  @override
  State<ViewersScreen> createState() => _ViewersScreenState();
}

class _ViewersScreenState extends State<ViewersScreen> {
  final TextEditingController number = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.sp)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.sureMakeViewer.tr(),
                  style: TextStyle(fontSize: 20.sp),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  children: [
                    ConstWidgets.circleImage(
                        url: BlocProvider.of<ViewersCubit>(context)
                            .userField!
                            .profilePic,
                        diameter: 40.r,
                        ctx: context),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              BlocProvider.of<ViewersCubit>(context)
                                  .userField!
                                  .name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.sp),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              BlocProvider.of<ViewersCubit>(context)
                                  .userField!
                                  .phoneNumber
                                  .substring(2),
                              style: (TextStyle(fontSize: 20.sp)),
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
                      await BlocProvider.of<ViewersCubit>(context)
                          .addViewer(
                              walletId: BlocProvider.of<WalletCubit>(context)
                                  .currentWallet!
                                  .id)
                          .then((value) {
                        number.clear();
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0.sp),
                      child: Text(
                        AppStrings.add.tr(),
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    )),
              )
            ],
          );
        });
  }

  void add(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (BlocProvider.of<ViewersCubit>(context)
        .numberExist(number: '+2${number.text}')) {
      ConstWidgets.messageDialog(context, AppStrings.alreadyExist.tr());
    } else {
      await BlocProvider.of<ViewersCubit>(context)
          .getUserByNumber(number.text)
          .then((value) {
        if (BlocProvider.of<ViewersCubit>(context).userField!.isAdmin) {
          ConstWidgets.messageDialog(context, AppStrings.alreadyAdmin.tr());
        } else if (BlocProvider.of<ViewersCubit>(context)
            .isMember(ctx: context)) {
          ConstWidgets.messageDialog(context, AppStrings.isMember.tr());
        } else {
          _showAlertDialog(context);
        }
      }).onError((error, stackTrace) {
        ConstWidgets.messageDialog(context, AppStrings.numberNotConnected.tr());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViewersCubit>(
      create: (_) => ViewersCubit()
        ..fetchViewers(
            BlocProvider.of<WalletCubit>(context).currentWallet!.viewers),
      child: BlocConsumer<ViewersCubit, ViewersStates>(
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
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  leading:IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new)),
                  title: Text(
                    AppStrings.viewers.tr(),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                  ),
                  elevation: 0,
                ),
                body: (state is ViewersAddLoadingState ||
                        state is ViewersLoadingState)
                    ? Center(
                        child: ConstWidgets.spinkit,
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.sp),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      controller: number,
                                      style: TextStyle(
                                          color: ColorsManager.white,
                                          fontSize: 20.sp),
                                      cursorColor: ColorsManager.white,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            size: 30.sp,
                                            Icons.phone,
                                            color: Colors.white,
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorsManager.white),
                                            borderRadius:
                                                BorderRadius.circular(10.0.sp),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorsManager.white),
                                            borderRadius:
                                                BorderRadius.circular(10.0.sp),
                                          ),
                                          labelText: AppStrings.phoneNumber.tr(),
                                          labelStyle: TextStyle(
                                              color: ColorsManager.white,
                                              fontSize: 20.sp),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorsManager.white),
                                            borderRadius:
                                                BorderRadius.circular(10.0.sp),
                                          )),
                                      keyboardType: TextInputType.number,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return AppStrings.phoneValidation.tr();
                                        } else {
                                          return null;
                                        }
                                      },
                                      onFieldSubmitted: (val) {
                                        add(context);
                                      },
                                    ),
                                  )),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white),
                                      onPressed: () {
                                        add(context);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0.sp),
                                        child: Text(
                                          AppStrings.add.tr(),
                                          style: TextStyle(
                                              color: ColorsManager.primary,
                                              fontSize: 20.sp),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              child: ListView.builder(
                                  itemCount:
                                      BlocProvider.of<ViewersCubit>(context)
                                          .currentWalletViewers
                                          .length,
                                  itemBuilder: (BuildContext context, index) {
                                    return ViewerItem(
                                        user: BlocProvider.of<ViewersCubit>(
                                                context)
                                            .currentWalletViewers[index]);
                                  }),
                            ))
                          ],
                        ),
                      ),
              ),
            );
          }),
    );
  }
}
