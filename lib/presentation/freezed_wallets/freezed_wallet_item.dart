import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/wallet/wallet_cubit.dart';
import '../resources/colors_manager.dart';
import '../resources/strings_manager.dart';

class FreezedWalletItem extends StatelessWidget {
  FreezedWalletItem({
    super.key,
    required this.id,
    required this.title,
    required this.description,
  });
  late String title;
  late String id;
  late String description;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.sp)),
                content: Text(
                  'Sure you want to unFreeze wallet ',
                  style: TextStyle(fontSize: 15.sp),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.all(8.0.sp),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0.sp),
                          child: Text(AppStrings.confirm.tr(),
                              style: TextStyle(fontSize: 20.sp)),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0.sp),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0.sp),
                          child: Text(AppStrings.close.tr(),
                              style: TextStyle(fontSize: 20.sp)),
                        )),
                  )
                ],
              );
            }).then((value) async {
          if (value == true) {
            await BlocProvider.of<WalletCubit>(context).unFreezingWallet(id);
          }
        });
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 8.h),
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: ColorsManager.white, width: 1),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25.sp,
                backgroundColor: ColorsManager.primary,
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: ColorsManager.white,
                  size: 25.sp,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              color: ColorsManager.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp)),
                      Text(description,
                          style: TextStyle(
                              color: ColorsManager.primary, fontSize: 15.sp))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
