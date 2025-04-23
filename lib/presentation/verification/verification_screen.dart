// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:moneytrack/cubit/verification/verification_states.dart';
import 'package:moneytrack/data/remote/FirebaseService/firebaseService_realTime.dart';
import 'package:moneytrack/presentation/resources/const_widgets/const_widgets.dart';
import 'package:moneytrack/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:quiver/async.dart';
import '../../cubit/auth/Auth_States.dart';
import '../../cubit/auth/Auth_cubit.dart';
import '../../cubit/verification/verification_cubit.dart';
import '../../cubit/wallet/wallet_cubit.dart';
import '../resources/assets_manager.dart';
import '../resources/colors_manager.dart';
import '../resources/routes_manager.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController number = TextEditingController();
  final GlobalKey<FormState> numberForm = GlobalKey();
  bool resendButton = false;
  StreamSubscription<CountdownTimer>? sub;
  CountdownTimer? countDownTimer;
  final int _start = 30;
  late int current;

  @override
  void dispose() {
    if (sub != null) {
      sub?.cancel();
    }
    countDownTimer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void startTimer() {
    setState(() {
      resendButton = false;
    });
    CountdownTimer countDownTimer = CountdownTimer(
      Duration(seconds: _start),
      const Duration(),
    );

    sub = countDownTimer.listen(null);

    sub?.onData((duration) {
      setState(() {
        current = _start - duration.elapsed.inSeconds;
      });
    });

    sub?.onDone(() {
      setState(() {
        resendButton = true;
      });
      sub?.cancel();
    });
  }

  sendOTP() async {
    if (!numberForm.currentState!.validate()) {
      return;
    }
    bool exist =
        await FirebaseServiceRealTime.userExist(number: '+2${number.text}');

    if (!exist &&
        BlocProvider.of<VerificationCubit>(context).verificationRoute ==
            Routes.newPasswordRoute) {
      return ConstWidgets.errorDialog(
          context, AppStrings.numberNotConnected.tr());
    } else if (exist &&
        BlocProvider.of<VerificationCubit>(context).verificationRoute !=
            Routes.newPasswordRoute) {
      return ConstWidgets.errorDialog(
          context, AppStrings.numberAlreadyConnected.tr());
    }
    BlocProvider.of<VerificationCubit>(context).number = number.text;
    await BlocProvider.of<VerificationCubit>(context)
        .sendOTP(context)
        .then((value) => startTimer());
  }

  editeNumber() {
    BlocProvider.of<VerificationCubit>(context).editeNumber();
  }

  resendCode() {
    BlocProvider.of<VerificationCubit>(context)
        .sendOTP(context)
        .then((value) => startTimer());
  }

  verify({required String code}) async {
    try {
      if (BlocProvider.of<VerificationCubit>(context).verificationRoute == Routes.homeRoute) {
        await BlocProvider.of<VerificationCubit>(context)
            .verifyNumber(code)
            .then((value) async {
          BlocProvider.of<WalletCubit>(context).fetchWallets();
          BlocProvider.of<VerificationCubit>(context).codeSent = false;
          Navigator.pushReplacementNamed(context,
              BlocProvider.of<VerificationCubit>(context).verificationRoute);
        });
      }
      else if (BlocProvider.of<VerificationCubit>(context).verificationRoute == Routes.newPasswordRoute) {
        await BlocProvider.of<VerificationCubit>(context)
            .phoneLogin(code)
            .then((value) async {
          BlocProvider.of<VerificationCubit>(context).codeSent = false;
          Navigator.pushReplacementNamed(context,
              BlocProvider.of<VerificationCubit>(context).verificationRoute);
        });
      }
      else if (BlocProvider.of<VerificationCubit>(context).verificationRoute == Routes.profileRoute) {
        await BlocProvider.of<VerificationCubit>(context)
            .updateNumber(code)
            .then((value) {
          BlocProvider.of<VerificationCubit>(context).codeSent = false;
          Navigator.pop(context);
        });
      }
    } catch (error) {
      ConstWidgets.errorDialog(context, error.toString());
      print('.....\n error.toString() \n ......');
    }
  }

  logOut() async {
    await BlocProvider.of<AuthCubit>(context).logOut(context).then((value) {
      Navigator.pushReplacementNamed(context, Routes.loginRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerificationCubit, VerificationStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              height: 736.h,
              width: 360.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorsManager.primary, ColorsManager.white],
                  begin: const Alignment(0, -1),
                  end: const Alignment(0, 1),
                ),
              ),
              child: Scaffold(
                appBar: AppBar(
                  leading:
                  BlocProvider.of<VerificationCubit>(context).verificationRoute == Routes.homeRoute?
                  BlocConsumer<AuthCubit, AuthStates>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is AuthConnectingState) {
                        return ConstWidgets.spinkit;
                      } else {
                        return Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: logOut,
                                icon: Icon(
                                  Icons.exit_to_app_rounded,
                                  color: ColorsManager.white,
                                  size: 25.sp,
                                )));
                      }
                    },
                  )
                      :
                  IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new)),

                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),

                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w),
                    height: 736.h-MediaQuery.of(context).padding.top - kToolbarHeight,
                    child: (state is VerificationLoadingState)
                        ? Center(
                            child: ConstWidgets.spinkit,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [

                                  Image.asset(ImageAssets.otp,
                                      width: 360.w / 1.5,
                                      height: 736.h / 3,
                                      fit: BoxFit.fitHeight),
                                  SizedBox(
                                    height: 15.h,
                                    width: double.infinity,
                                  ),
                                  Text(
                                    AppStrings.oTPVerification.tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.sp,
                                        color: Color(0xff3A3A3A)),
                                  ),
                                ],
                              ),
                              !BlocProvider.of<VerificationCubit>(context)
                                      .codeSent
                                  ? Text(
                                      AppStrings.verificationWeWill.tr(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 24.sp,
                                          color: Color(0xff3A3A3A)),
                                    )
                                  : Column(
                                      children: [
                                        Text(
                                          AppStrings.verificationOtpHas.tr(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 24.sp),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              BlocProvider.of<
                                                          VerificationCubit>(
                                                      context)
                                                  .number,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24),
                                            ),
                                            TextButton(
                                                onPressed: BlocProvider.of<
                                                            VerificationCubit>(
                                                        context)
                                                    .editeNumber,
                                                child: Text(AppStrings
                                                    .verificationEdite
                                                    .tr()))
                                          ],
                                        )
                                      ],
                                    ),
                              !BlocProvider.of<VerificationCubit>(context)
                                      .codeSent
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppStrings.verificationEnterMobile
                                              .tr(),
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff3A3A3A)),
                                        ),
                                        Form(
                                          key: numberForm,
                                          child: TextFormField(
                                            style: TextStyle(fontSize: 20.sp),
                                            controller: number,
                                            keyboardType: TextInputType.phone,
                                            decoration: InputDecoration(
                                              labelStyle:
                                                  TextStyle(fontSize: 20.sp),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff2743FD)),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff2743FD)),
                                              ),
                                            ),
                                            validator: (val) {
                                              if (val!.isEmpty ||
                                                  val.length != 11) {
                                                return AppStrings
                                                    .phoneValidation
                                                    .tr();
                                              } else {
                                                return null;
                                              }
                                            },
                                            onFieldSubmitted: (val) {
                                              sendOTP();
                                            },
                                          ),
                                        )
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Text(
                                          AppStrings.verificationEnterOtp.tr(),
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff3A3A3A)),
                                        ),
                                        OTPTextField(
                                          keyboardType: TextInputType.number,
                                          length: 6,
                                          width: 360.w - 120.w,
                                          style: TextStyle(fontSize: 20.sp),
                                          textFieldAlignment:
                                              MainAxisAlignment.spaceAround,
                                          fieldStyle: FieldStyle.underline,
                                          onCompleted: (pin) {
                                            verify(code: pin);
                                          },
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                          width: double.infinity,
                                        ),
                                       Container(
                                         margin: EdgeInsets.only(bottom:20.h),

                                         child:
                                         resendButton
                                             ? TextButton(
                                             onPressed: resendCode,
                                             child: Text(
                                               AppStrings
                                                   .verificationResendOtp
                                                   .tr(),
                                               style: TextStyle(
                                                   fontSize: 15.sp,
                                                   fontWeight:
                                                   FontWeight.w700,
                                                   color: Color(0xff42A2E7)),
                                             ))
                                             : RichText(
                                           text: TextSpan(
                                             text: AppStrings
                                                 .verificationYouCan
                                                 .tr(),
                                             style: TextStyle(
                                                 color: Colors.black,
                                                 fontSize: 12.sp),
                                             children: <TextSpan>[
                                               TextSpan(
                                                   text:
                                                   current.toString(),
                                                   style: TextStyle(
                                                       color: Color(
                                                           0xff2743FD),
                                                       fontSize: 12.sp)),
                                             ],
                                           ),
                                         ),
                                       )
                                      ],
                                    ),
                              Container(
                                margin: EdgeInsets.only(bottom:20.h),
                                child:
                                !BlocProvider.of<VerificationCubit>(context)
                                    .codeSent
                                    ? (state is VerificationSendingOtpState)
                                    ? ConstWidgets.spinkit
                                    : ElevatedButton(
                                    onPressed: sendOTP,
                                    style: ElevatedButton.styleFrom(
                                        minimumSize:
                                        Size(double.infinity, 70.r),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                20.sp))),
                                    child: Text(
                                      AppStrings.verificationGetOtp.tr(),
                                      style: TextStyle(fontSize: 20.sp),
                                    ))
                                    : SizedBox()
                                ,
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
