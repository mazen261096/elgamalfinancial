import 'package:moneytrack/models/transaction.dart';
import 'package:moneytrack/presentation/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({super.key, required this.newTrans});
  final Transactions newTrans;

  clickItem(BuildContext context) {
    // BlocProvider.of<HistoryCubit>(context).currentTrans=newTrans;
    // Navigator.pushNamed(context, Routes.historydetailsRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(8.0.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.all(5.sp),
                width: 90.w,
                child: Text(
                  newTrans.category,
                  style: TextStyle(
                      color: ColorsManager.lightprimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.sp),
                )),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newTrans.name,
                    style: TextStyle(
                        color: ColorsManager.primary, fontSize: 17.sp),
                  ),
                  Text(
                      DateFormat('yyyy-MM-dd hh:mm').format(newTrans.createdAt),
                      style: TextStyle(
                          fontSize: 17.sp, fontWeight: FontWeight.w300)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                NumberFormat('###,###,###').format(newTrans.amount),
                style: TextStyle(
                    color: (newTrans.category == 'Returns' ||
                            newTrans.category == 'deposit')
                        ? ColorsManager.lightprimary
                        : Colors.red,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
