import 'package:moneytrack/presentation/resources/assets_manager.dart';
import 'package:moneytrack/presentation/resources/routes_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/colors_manager.dart';
import '../resources/strings_manager.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  categories(BuildContext context) {
    Navigator.pushNamed(context, Routes.categoryRoute);
  }

  freezed(BuildContext context) {
    Navigator.pushNamed(context, Routes.freezedWalletsRoute);
  }

  admins(BuildContext context) {
    Navigator.pushNamed(context, Routes.adminsRoute);
  }

  /*
  Card(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              child:  Container(

                decoration:  BoxDecoration(
                  borderRadius:const BorderRadius.all(Radius.circular(20)) ,
                  image:  DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(ColorsManager.primary.withOpacity(0.7), BlendMode.dstATop),
                    image: const AssetImage(ImageAssets.admins),
                  ),
                ),
                child:  Center(
                  child: Text(
                      'Admins',
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: ColorsManager.primary),
                  ),
                ),
              ),
            ),        */
  @override
  Widget build(BuildContext context) {
    return Container(
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
          title: Text(AppStrings.adminPanel.tr(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.sp,
                  color: ColorsManager.white.withOpacity(.7))),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          child: GridView.count(
            scrollDirection: Axis.vertical,
            crossAxisCount: 2,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            children: [
              GestureDetector(
                onTap: () {
                  admins(context);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.sp))),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            ColorsManager.primary.withOpacity(0.7),
                            BlendMode.dstATop),
                        image: const AssetImage(ImageAssets.admins),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        AppStrings.admins.tr(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.sp,
                            color: ColorsManager.white.withOpacity(.7)),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  categories(context);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.sp))),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            ColorsManager.primary.withOpacity(0.7),
                            BlendMode.dstATop),
                        image: const AssetImage(ImageAssets.category),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        AppStrings.categories.tr(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.sp,
                            color: ColorsManager.white.withOpacity(.7)),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  freezed(context);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.sp))),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorsManager.primary.withOpacity(0.7),
                      borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                    ),
                    child: Center(
                      child: Text(
                        'Freezed\nWallets',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25.sp,
                            color: ColorsManager.white.withOpacity(.7)),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
