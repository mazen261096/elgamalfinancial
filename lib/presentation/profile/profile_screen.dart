import 'package:moneytrack/cubit/profile/profile_cubit.dart';
import 'package:moneytrack/cubit/profile/profile_states.dart';
import 'package:moneytrack/data/remote/FirebaseService/firebaseService_auth.dart';
import 'package:moneytrack/presentation/profile/change_password_dialog.dart';
import 'package:moneytrack/presentation/resources/langauge_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart';
import '../../cubit/verification/verification_cubit.dart';
import '../resources/colors_manager.dart';
import '../resources/const_widgets/const_widgets.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, required this.userId});
  final String userId;
  final _nameFormKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formEmailKey = GlobalKey<FormState>();

  selectPhoto(BuildContext ctx) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.sp),
          topLeft: Radius.circular(20.sp),
        )),
        context: ctx,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      BlocProvider.of<ProfileCubit>(ctx)
                          .selectImage(source: 'gallery');
                    },
                    child: Text(AppStrings.gallery.tr(),
                        style: TextStyle(
                          fontSize: 20.sp,
                        ))),
              ),
              Divider(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      BlocProvider.of<ProfileCubit>(ctx)
                          .selectImage(source: 'camera');
                    },
                    child: Text(AppStrings.camera.tr(),
                        style: TextStyle(
                          fontSize: 20.sp,
                        ))),
              ),
            ],
          );
        });
  }

  updateName(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (_) {
          return AlertDialog(
            content: Form(
              key: _nameFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: name,
                    decoration:
                        InputDecoration(labelText: AppStrings.name.tr()),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val!.isEmpty || val.length < 3) {
                        return AppStrings.nameValidation.tr();
                      } else {
                        return null;
                      }
                    },
                  )
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (!_nameFormKey.currentState!.validate()) return;
                    Navigator.pop(ctx);
                    await BlocProvider.of<ProfileCubit>(ctx)
                        .updateName(name: name.text);
                  },
                  child: Text(AppStrings.update.tr())),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: Text(AppStrings.cancel.tr())),
            ],
          );
        });
  }

  updateEmail(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (_) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(20.sp),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.sp)),
            content: Form(
              key: _formEmailKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    style: TextStyle(fontSize: 20.sp),
                    controller: password,
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
                  SizedBox(height: 15.h, width: 360.w / 2),
                  TextFormField(
                    style: TextStyle(fontSize: 20.sp),
                    controller: email,
                    decoration: InputDecoration(
                        labelText: AppStrings.email.tr(),
                        labelStyle: TextStyle(fontSize: 20.sp)),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val!.isEmpty ||
                          !val.contains('@') ||
                          !val.endsWith('.com')) {
                        return AppStrings.emailValidation.tr();
                      } else {
                        return null;
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0.sp),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (!_formEmailKey.currentState!.validate()) {
                            return;
                          }
                          Navigator.pop(ctx);
                          try {
                            await BlocProvider.of<ProfileCubit>(ctx)
                                .updateEmail(
                                    email: email.text, password: password.text);
                          } catch (error) {
                            ConstWidgets.errorDialog(ctx, error.toString());
                          }
                        },
                        child: Text(
                          AppStrings.update.tr(),
                          style: TextStyle(fontSize: 20.sp),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0.sp),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          AppStrings.cancel.tr(),
                          style: TextStyle(fontSize: 20.sp),
                        )),
                  ),
                ],
              )
            ],
          );
        });
  }

  updateNumber(BuildContext ctx) {
    BlocProvider.of<VerificationCubit>(ctx).verificationRoute =
        Routes.profileRoute;
    BlocProvider.of<VerificationCubit>(ctx).codeSent = false;
    Navigator.pushNamed(ctx, Routes.verificationRoute);
  }

  changePassword(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.sp)),
              contentPadding: EdgeInsets.all(20.sp),
              content: ChangePasswordDialog());
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (_) => ProfileCubit()..fetchUser(userId: userId),
      child: BlocConsumer<ProfileCubit, ProfileStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorsManager.primary, ColorsManager.white],
                  begin: const Alignment(0, -1),
                  end: const Alignment(0, 1),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  leading:IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new)),

                  title: Text(AppStrings.profile.tr(),style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.sp),),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),

                body: (state is ProfileFetchLoadingStates)
                    ? Center(child: ConstWidgets.spinkit)
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 15.h),
                              child: CircleAvatar(
                                radius: (360.r / 3.5) + 2.r,
                                backgroundColor: Colors.white,
                                child: (state is ProfileUploadingStates)
                                    ? Center(
                                        child: ConstWidgets.spinkit,
                                      )
                                    : Badge(
                                        showBadge: userId ==
                                            FirebaseServiceAuth.getUser()!.uid,
                                        badgeStyle: BadgeStyle(
                                          elevation: 5,
                                          padding: EdgeInsets.all(360.r / 30),
                                          badgeColor: Colors.white.withOpacity(0.4),
                                        ),

                                        position: BadgePosition.bottomEnd(),
                                        badgeContent: GestureDetector(
                                            onTap: () {
                                              selectPhoto(context);
                                            },
                                            child: Icon(
                                              Icons.add_a_photo_outlined,
                                              size: 360.r / 12,
                                              color: ColorsManager.primary,
                                            )),

                                        child: ConstWidgets.circleImage(
                                            ctx: context,
                                            url: BlocProvider.of<ProfileCubit>(
                                                    context)
                                                .user!
                                                .profilePic,
                                            diameter: 210.285.r)),
                              ),
                            ),
                            Divider(),
                            SizedBox(
                              height: 15.h,
                            ),
                            InputDecorator(
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(fontSize: 20.sp),
                                  labelText: AppStrings.name.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.0.sp),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: Text(
                                    BlocProvider.of<ProfileCubit>(context)
                                        .user!
                                        .name,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 15.h,
                            ),
                            InputDecorator(
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(fontSize: 20.sp),
                                  labelText: AppStrings.email.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.0.sp),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        BlocProvider.of<ProfileCubit>(context)
                                            .user!
                                            .email,
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                        )),
                                    if (userId ==
                                        FirebaseServiceAuth.getUser()!.uid)
                                      (state is ProfileUpdateEmailLoadingStates)
                                          ? ConstWidgets.spinkit
                                          : IconButton(
                                              iconSize: 30.sp,
                                              onPressed: () {
                                                updateEmail(context);
                                              },
                                              icon: Icon(Icons.edit,
                                                  color: ColorsManager.primary))
                                  ],
                                )),
                            SizedBox(
                              height: 15.h,
                            ),
                            InputDecorator(
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(fontSize: 20.sp),
                                  labelText: AppStrings.phoneNumber.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      BlocProvider.of<ProfileCubit>(context)
                                          .user!
                                          .phoneNumber
                                          .substring(2),
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                    if (userId ==
                                        FirebaseServiceAuth.getUser()!.uid)
                                      IconButton(
                                          iconSize: 30.sp,
                                          onPressed: () {
                                            updateNumber(context);
                                          },
                                          icon: Icon(Icons.edit,
                                              color: ColorsManager.primary))
                                  ],
                                )),
                            SizedBox(
                              height: 15.h,
                            ),
                            if (userId ==
                                FirebaseServiceAuth.getUser()!.uid) ...{
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(Routes.loginRoute,
                                              (Route<dynamic> route) => false);
                                      BlocProvider.of<ProfileCubit>(context)
                                          .deleteAccount();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(AppStrings.deleteAccount.tr(),
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                            )),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 30.sp,
                                        )
                                      ],
                                    )),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                    onPressed: () {
                                      changePassword(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(AppStrings.updatePassword.tr(),
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                            )),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 30.sp,
                                        )
                                      ],
                                    )),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                    onPressed: () {
                                      LanguageManager()
                                          .changeAppLanguage(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(AppStrings.changeLanguage.tr(),
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                            )),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 30.sp,
                                        )
                                      ],
                                    )),
                              ),
                            }
                          ],
                        ),
                      ),
              ),
            );
          }),
    );
  }
}
