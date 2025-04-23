import 'package:moneytrack/presentation/resources/styles_manager.dart';
import 'package:moneytrack/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors_manager.dart';
import 'fonts_manager.dart';

ThemeData getAppThemeData() {
  return ThemeData(
    fontFamily: 'Tajawal',
    // main colors
    primaryColor: ColorsManager.primary,
    primaryColorLight: ColorsManager.lightprimary,
    primaryColorDark: ColorsManager.darkprimary,
    disabledColor: ColorsManager.grey1,
    splashColor: ColorsManager.lightprimary,
    //ripple effect color

    // cardview theme
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.sp)),
      shadowColor: ColorsManager.grey,
      elevation: AppSize.s4,
      margin: const EdgeInsets.all(AppSize.s0),
    ),

    // appbar theme
    appBarTheme: AppBarTheme(

        iconTheme: IconThemeData(size: 20.sp, color: Colors.white),
        actionsIconTheme: IconThemeData(size: 20.sp),
        color: ColorsManager.primary,
        elevation: 0,
        titleTextStyle: getRegularTextStyle(
            fontSize: FontsSizeManager.s16.sp, color: ColorsManager.white)),

    // button theme
    buttonTheme: ButtonThemeData(
        shape: const StadiumBorder(),
        disabledColor: ColorsManager.grey1,
        buttonColor: ColorsManager.primary,
        splashColor: ColorsManager.lightprimary),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          textStyle: getRegularTextStyle(
              color: ColorsManager.white, fontSize: AppSize.s18.sp),
          backgroundColor: ColorsManager.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s12.sp),
          )),
    ),

    // text theme

    inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.h),
        hintStyle: getRegularTextStyle(
            color: ColorsManager.grey, fontSize: FontsSizeManager.s14.sp),
        labelStyle: getMeduimTextStyle(
            color: ColorsManager.grey, fontSize: FontsSizeManager.s14.sp),
        errorStyle: getRegularTextStyle(color: ColorsManager.error),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorsManager.grey, width: AppSize.s1_5.sp),
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s8.sp)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorsManager.grey, width: AppSize.s1_5.sp),
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s8.sp)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorsManager.error, width: AppSize.s1_5.sp),
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s8.sp)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorsManager.grey, width: AppSize.s1_5.sp),
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s8.sp)),
        )),

    // input decoration theme ( text form field )
  );
}
