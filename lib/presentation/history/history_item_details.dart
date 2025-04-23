import 'package:moneytrack/cubit/history/history_cubit.dart';
import 'package:moneytrack/cubit/history/history_states.dart';
import 'package:moneytrack/cubit/wallet/wallet_cubit.dart';
import 'package:moneytrack/data/remote/FirebaseService/firebaseService_auth.dart';
import 'package:moneytrack/presentation/history/pdf_preview.dart';
import 'package:moneytrack/presentation/history/photo_view.dart';
import 'package:moneytrack/presentation/resources/colors_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

import '../resources/const_widgets/const_widgets.dart';
import '../resources/strings_manager.dart';

class HistoryItemDetails extends StatelessWidget {
  const HistoryItemDetails({super.key});

  delete(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.sp)),
            content: Text(
              AppStrings.sureDeleteTrans.tr(),
              style: TextStyle(fontSize: 20.sp),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(AppStrings.delete.tr(),
                      style: TextStyle(fontSize: 20.sp))),
              Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text(AppStrings.cancel.tr(),
                        style: TextStyle(fontSize: 20.sp))),
              ),
            ],
          );
        }).then((value) async {
      if (value == true) {
        await BlocProvider.of<HistoryCubit>(context)
            .deleteTran(
                walletId: BlocProvider.of<WalletCubit>(context).currentWallet!.id,
        walletName:  BlocProvider.of<WalletCubit>(context).currentWallet!.name)
            .then((value) => Navigator.pop(context));
      }
    });
  }

  pdf(BuildContext context) {
    BlocProvider.of<HistoryCubit>(context).navigatorKey.currentState?.push(
        MaterialPageRoute(
            builder: (context) => PdfPreviewPage(
                trans: BlocProvider.of<HistoryCubit>(context).currentTrans!)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoryCubit, HistoryStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              appBar:  AppBar(
                leading:IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new)),

                title: Text(AppStrings.theHistory.tr(),style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.sp),),
              ),
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 15.h),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: AppStrings.walletName.tr(),
                                  labelStyle: TextStyle(fontSize: 20.sp),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.0.sp),
                                  ),
                                ),
                                child: Text(
                                  BlocProvider.of<HistoryCubit>(context)
                                      .currentTrans!
                                      .walletName,
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15.h),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(fontSize: 20.sp),
                                  labelText: AppStrings.name.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  BlocProvider.of<HistoryCubit>(context)
                                      .currentTrans!
                                      .name,
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15.sp),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(fontSize: 20.sp),
                                  labelText: AppStrings.theAmount.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.0.sp),
                                  ),
                                ),
                                child: Text(
                                  BlocProvider.of<HistoryCubit>(context)
                                      .currentTrans!
                                      .amount
                                      .toString(),
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15.sp),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(fontSize: 20.sp),
                                  labelText: AppStrings.category.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.0.sp),
                                  ),
                                ),
                                child: Text(
                                  BlocProvider.of<HistoryCubit>(context)
                                      .currentTrans!
                                      .category,
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15.sp),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(fontSize: 20.sp),
                                  labelText: AppStrings.theDate.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.0.sp),
                                  ),
                                ),
                                child: Text(
                                  DateFormat('yyyy-MM-dd').format(
                                      BlocProvider.of<HistoryCubit>(context)
                                          .currentTrans!
                                          .createdAt),
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15.sp),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(fontSize: 20.sp),
                                  labelText: AppStrings.description.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.0.sp),
                                  ),
                                ),
                                child: Text(
                                  BlocProvider.of<HistoryCubit>(context)
                                      .currentTrans!
                                      .description,
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ),
                            ),
                            if (BlocProvider.of<HistoryCubit>(context)
                                    .currentTrans!
                                    .type ==
                                'pay')
                              GestureDetector(
                                onTap: () {
                                  BlocProvider.of<HistoryCubit>(context)
                                      .navigatorKey
                                      .currentState
                                      ?.push(MaterialPageRoute(
                                          builder: (context) => ViewPhoto(
                                              url:
                                                  BlocProvider.of<HistoryCubit>(
                                                          context)
                                                      .currentTrans!
                                                      .bill)));
                                },
                                child: Container(
                                  margin:
                                      EdgeInsets.only(top: 15.h, bottom: 15.h),
                                  width: (360 - 10).h,
                                  height: (736 / 5).h,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10.sp),
                                      border: Border.all(
                                        color: ColorsManager.primary,
                                        width: 1.5.w,
                                      )),
                                  child: PhotoView(
                                      wantKeepAlive: true,
                                      disableGestures: false,
                                      enablePanAlways: false,
                                      enableRotation: false,
                                      backgroundDecoration: BoxDecoration(
                                          color: Colors.transparent),
                                      errorBuilder: (context, tt, event) =>
                                          Center(
                                              child: Text(AppStrings
                                                  .noImageFound
                                                  .tr())),
                                      loadingBuilder: (context, event) =>
                                          Center(
                                              child: Center(
                                                  child: ConstWidgets.spinkit)),
                                      imageProvider: NetworkImage(
                                          BlocProvider.of<HistoryCubit>(context)
                                              .currentTrans!
                                              .bill)),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: (state is HistoryDeleteLoadingState||state is HistoryFilterLoadingState)
                              ? Center(child: ConstWidgets.spinkit)
                              : (BlocProvider.of<WalletCubit>(context)
                                              .currentWallet !=
                                          null &&
                                      BlocProvider.of<HistoryCubit>(context)
                                              .currentTrans!
                                              .uId ==
                                          FirebaseServiceAuth.getUser()!.uid)
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        await delete(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15.h),
                                          elevation: 25,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20.sp))),
                                      child: Text(
                                        AppStrings.delete.tr(),
                                        style: TextStyle(fontSize: 20.sp),
                                      ),
                                    )
                                  : const SizedBox(),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              pdf(context);
                            },
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15.h),
                                elevation: 25,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20.sp))),
                            child: Column(
                              children: [
                                Text(
                                  AppStrings.extract.tr(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.sp),
                                ),
                                Text(
                                  'Pdf',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.sp),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
