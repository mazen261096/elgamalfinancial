import 'package:moneytrack/presentation/resources/assets_manager.dart';
import 'package:moneytrack/presentation/resources/colors_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/strings_manager.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
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
        body: Column(
          children: [
            Expanded(
                child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImageAssets.done),
                  SizedBox(
                    height: 35.h,
                  ),
                  Text(
                    AppStrings.congrats.tr(),
                    style: TextStyle(
                        color: ColorsManager.lightprimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 40.sp),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Text(
                    message,
                    style:
                        TextStyle(color: ColorsManager.white, fontSize: 16.sp),
                  ),
                ],
              ),
            )),
            Container(
                padding: EdgeInsets.only(bottom: 70.sp),
                child: ElevatedButton(
                    style: ButtonStyle(
                      elevation:
                          WidgetStateProperty.all(30.00), //Defines Elevation
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.sp, horizontal: 8.sp),
                      child: Text(
                        AppStrings.great.tr(),
                        style: TextStyle(color: ColorsManager.white),
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
