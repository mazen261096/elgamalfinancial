import 'package:moneytrack/presentation/resources/const_widgets/const_widgets.dart';
import 'package:moneytrack/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/admin/admin_cubit.dart';
import '../../cubit/admin/admin_states.dart';
import '../resources/colors_manager.dart';
import 'admin_item.dart';

class AdminsScreen extends StatefulWidget {
  const AdminsScreen({super.key});

  @override
  State<AdminsScreen> createState() => _AdminsScreenState();
}

class _AdminsScreenState extends State<AdminsScreen> {
  final TextEditingController number = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _showAlertDialog(BuildContext context) {
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
                  AppStrings.sureMakeAdmin.tr(),
                  style: TextStyle(fontSize: 20.sp),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  children: [
                    ConstWidgets.circleImage(
                        url: BlocProvider.of<AdminCubit>(context)
                            .userField!
                            .profilePic,
                        diameter: 50.r,
                        ctx: context),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              BlocProvider.of<AdminCubit>(context)
                                  .userField!
                                  .name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.sp),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              BlocProvider.of<AdminCubit>(context)
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
              ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await BlocProvider.of<AdminCubit>(context)
                        .addAdmin()
                        .then((value) {
                      number.clear();
                    });
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.w),
                    child: Text(AppStrings.add.tr()),
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

  void add(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    if (await BlocProvider.of<AdminCubit>(context)
        .numberExist('+2${number.text}')) {
      ConstWidgets.messageDialog(context, AppStrings.alreadyExist.tr());
    } else {
      await BlocProvider.of<AdminCubit>(context)
          .getUserByNumber(number.text)
          .then((value) {
        _showAlertDialog(context);
      }).onError((error, stackTrace) {
        ConstWidgets.messageDialog(context, AppStrings.numberNotConnected.tr());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminCubit>(
      create: (_) => AdminCubit()..fetchAdmins(),
      child: BlocConsumer<AdminCubit, AdminStates>(
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
                  appBar: AppBar(
                    leading:IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new)),

                    backgroundColor: Colors.transparent,
                    title: Text(
                      AppStrings.admins.tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.sp),
                    ),
                    elevation: 0,
                  ),
                  body: (state is AdminUserLoadingState ||
                          state is AdminAddLoadingState)
                      ? Center(child: ConstWidgets.spinkit)
                      : Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          child: Column(
                            children: [
                              Row(
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
                                            Icons.phone,
                                            color: Colors.white,
                                            size: 20.r,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorsManager.white),
                                            borderRadius:
                                                BorderRadius.circular(10.0.sp),
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
                                                BorderRadius.circular(10.0.sp),
                                          )),
                                      keyboardType: TextInputType.number,
                                      validator: (val) {
                                        if (val!.isEmpty || val.length != 11) {
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
                                    width: 10.w,
                                  ),
                                  SizedBox(
                                    height: 50.r,
                                    width: 50.r,
                                    child: FloatingActionButton(
                                        backgroundColor: Colors.white,
                                        elevation: 20,
                                        onPressed: () {
                                          add(context);
                                        },
                                        child: Text(
                                          AppStrings.add.tr(),
                                          style: TextStyle(
                                              color: ColorsManager.primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.sp),
                                        )),
                                  )
                                ],
                              ),
                              Divider(
                                  color: ColorsManager.white,
                                  thickness: .5.h,
                                  height: 20.h),
                              Expanded(
                                  child: (state is AdminFetchLoadingState)
                                      ? Center(child: ConstWidgets.spinkit)
                                      : ListView.builder(
                                          itemCount:
                                              BlocProvider.of<AdminCubit>(
                                                      context)
                                                  .admins
                                                  .length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return AdminItem(
                                                user:
                                                    BlocProvider.of<AdminCubit>(
                                                            context)
                                                        .admins[index]);
                                          }))
                            ],
                          ),
                        ),
                ),
              ),
            );
          }),
    );
  }
}
