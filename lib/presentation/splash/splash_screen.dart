import 'dart:async';

import 'package:moneytrack/data/remote/FirebaseService/firebaseService_auth.dart';
import 'package:moneytrack/presentation/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/app_prefs.dart';
import '../../cubit/auth/Auth_States.dart';
import '../../cubit/auth/Auth_cubit.dart';
import '../../cubit/verification/verification_cubit.dart';
import '../../cubit/wallet/wallet_cubit.dart';
import '../resources/assets_manager.dart';
import '../resources/constants_manager.dart';
import '../resources/routes_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  _startDelay() {
    _timer = Timer(const Duration(seconds: AppConstants.splashDelay), _goNext);
  }

  _goNext() async {
    print('height : ${MediaQuery.of(context).size.height}');
    print('width : ${MediaQuery.of(context).size.width}');
    await AppPreferences.notificationStatue();

    if (await FirebaseServiceAuth.isConnected()) {
      AppPreferences.user = FirebaseServiceAuth.getUser()!;
      await AppPreferences.getUserData();

        BlocProvider.of<WalletCubit>(context).fetchWallets();
        Navigator.pushReplacementNamed(context, Routes.homeRoute);

    } else {
      Navigator.pushReplacementNamed(context, Routes.loginRoute);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: Container(
                height: 736.h,
                width: 360.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ColorsManager.primary, ColorsManager.white],
                    begin: const Alignment(0, -1),
                    end: const Alignment(0, 1),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
                child: const Image(image: AssetImage(ImageAssets.splashLogo))),
          );
        });
  }
}
