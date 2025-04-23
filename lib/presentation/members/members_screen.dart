import 'package:moneytrack/cubit/members/members_cubit.dart';
import 'package:moneytrack/cubit/wallet/wallet_cubit.dart';
import 'package:moneytrack/presentation/members/member_item.dart';
import 'package:moneytrack/presentation/resources/const_widgets/const_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/app_prefs.dart';
import '../../cubit/members/members_states.dart';
import '../resources/colors_manager.dart';
import '../resources/strings_manager.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final TextEditingController number = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.sureMakeMember.tr(),
                  style: TextStyle(fontSize: 20.sp),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: ConstWidgets.circleImage(
                          url: BlocProvider.of<MembersCubit>(context)
                              .userField!
                              .profilePic,
                          diameter: 40.r,
                          ctx: context),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              BlocProvider.of<MembersCubit>(context)
                                  .userField!
                                  .name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.sp),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              BlocProvider.of<MembersCubit>(context)
                                  .userField!
                                  .phoneNumber
                                  .substring(2),
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
                      await BlocProvider.of<MembersCubit>(context)
                          .addMember(
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
    try {
      if (!_formKey.currentState!.validate()) return;
      FocusManager.instance.primaryFocus?.unfocus();
      if (BlocProvider.of<MembersCubit>(context)
          .numberExist(number: '+2${number.text}')) {
        ConstWidgets.messageDialog(context, AppStrings.alreadyExist.tr());
      } else {
        await BlocProvider.of<MembersCubit>(context)
            .getUserByNumber(number.text)
            .then((value) {
          if (BlocProvider.of<MembersCubit>(context).userField!.isAdmin) {
            ConstWidgets.messageDialog(context, AppStrings.alreadyAdmin.tr());
          } else if (BlocProvider.of<MembersCubit>(context)
              .isViewer(ctx: context)) {
            ConstWidgets.messageDialog(context, AppStrings.isViewer.tr());
          } else {
            _showAlertDialog(context);
          }
        });
      }
    } catch (error) {
      ConstWidgets.messageDialog(context, AppStrings.numberNotConnected.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MembersCubit>(
      create: (_) => MembersCubit()
        ..fetchMembers(
            BlocProvider.of<WalletCubit>(context).currentWallet!.members),
      child: BlocConsumer<MembersCubit, MembersStates>(
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
                    AppStrings.members.tr(),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                  ),
                  elevation: 0,
                ),
                body: (state is MembersAddLoadingState ||
                        state is MembersLoadingState)
                    ? Center(
                        child: ConstWidgets.spinkit,
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          children: [
                            if (AppPreferences.userData.isAdmin)
                              Container(
                                padding: EdgeInsets.only(top: 10.h),
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
                                              size: 20.r,
                                              Icons.phone,
                                              color: Colors.white,
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorsManager.white),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0.sp),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorsManager.white),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0.sp),
                                            ),
                                            labelText:
                                                AppStrings.phoneNumber.tr(),
                                            labelStyle: TextStyle(
                                                color: ColorsManager.white,
                                                fontSize: 20.sp),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ColorsManager.white),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0.sp),
                                            )),
                                        keyboardType: TextInputType.number,
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return AppStrings.phoneValidation
                                                .tr();
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
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0.sp),
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
                                child: ListView.builder(
                                    itemCount:
                                        BlocProvider.of<MembersCubit>(context)
                                            .currentWalletMembers
                                            .length,
                                    itemBuilder: (BuildContext context, index) {
                                      return MemberItem(
                                          user: BlocProvider.of<MembersCubit>(
                                                  context)
                                              .currentWalletMembers[index]);
                                    }))
                          ],
                        ),
                      ),
              ),
            );
          }),
    );
  }
}
