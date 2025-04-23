import 'package:moneytrack/cubit/history/history_cubit.dart';
import 'package:moneytrack/cubit/history/history_states.dart';
import 'package:moneytrack/models/transaction.dart';
import 'package:moneytrack/presentation/history/history_filter.dart';
import 'package:moneytrack/presentation/history/history_item.dart';
import 'package:moneytrack/presentation/history/history_item_details.dart';
import 'package:moneytrack/presentation/history/pdf_preview_collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/colors_manager.dart';
import '../resources/strings_manager.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.trans});

  final List<Transactions> trans;

  clickItem(BuildContext context, Transactions newTrans) {
    BlocProvider.of<HistoryCubit>(context).currentTrans = newTrans;
    BlocProvider.of<HistoryCubit>(context).navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => const HistoryItemDetails()));
  }

  pdf(BuildContext context) {
    BlocProvider.of<HistoryCubit>(context)
        .navigatorKey
        .currentState
        ?.push(MaterialPageRoute(
            builder: (context) => PdfPreviewCollection(
                  trans: BlocProvider.of<HistoryCubit>(context).visibleTrans,
                  filterWallets:
                      BlocProvider.of<HistoryCubit>(context).walletsName,
                  filterCategory:
                      BlocProvider.of<HistoryCubit>(context).filterCategory,
                  filterName: BlocProvider.of<HistoryCubit>(context).filterName,
                  filterAfter:
                      BlocProvider.of<HistoryCubit>(context).filterAfter,
                  filterBefore:
                      BlocProvider.of<HistoryCubit>(context).filterBefore,
                  total: BlocProvider.of<HistoryCubit>(context).total!,
                )));
  }

  filter(BuildContext context) {
    showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
        context: context,
        builder: (context) {
          return const FilterWidget();
        });
  }

  @override
  Widget build(BuildContext buildContext) {
    return BlocProvider<HistoryCubit>(
      create: (_) => HistoryCubit()..fetchTran(trans),
      child: BlocConsumer<HistoryCubit, HistoryStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              bool back = BlocProvider.of<HistoryCubit>(context)
                  .navigatorKey
                  .currentState!
                  .canPop();
              if (back) {
                BlocProvider.of<HistoryCubit>(context)
                    .navigatorKey
                    .currentState
                    ?.pop();
              }

              return !back;
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorsManager.primary, ColorsManager.white],
                  begin: const Alignment(0, -0.5),
                  end: const Alignment(0, 1),
                ),
              ),
              child: Navigator(
                key: BlocProvider.of<HistoryCubit>(context).navigatorKey,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      leading: IconButton(
                          onPressed: () {
                            Navigator.pop(buildContext);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                          )),
                      toolbarHeight: 40.h,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      title: Text(
                        '${AppStrings.walletHistory.tr()} ( ${BlocProvider.of<HistoryCubit>(context).visibleTrans.length} )',
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      actions: [
                        if (BlocProvider.of<HistoryCubit>(context)
                                .visibleTrans !=
                            BlocProvider.of<HistoryCubit>(context).allTrans)
                          TextButton(
                              onPressed: () {
                                BlocProvider.of<HistoryCubit>(context)
                                    .clearFilters();
                              },
                              child: Text(AppStrings.clearFilter.tr(),
                                  style: TextStyle(fontSize: 20.sp))),
                        IconButton(
                            iconSize: 30.sp,
                            onPressed: () {
                              filter(context);
                            },
                            icon: Icon(
                              Icons.filter_list,
                              size: 30.sp,
                            )),
                      ],
                    ),
                    body: Padding(
                      padding: EdgeInsets.only(
                          right: 10.w,
                          left: 10.w,
                          bottom:
                              !BlocProvider.of<HistoryCubit>(context).filtered
                                  ? 0
                                  : 10.h,
                          top: 10.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount:
                                    BlocProvider.of<HistoryCubit>(context)
                                        .visibleTrans
                                        .length,
                                itemBuilder: (BuildContext context, index) {
                                  return GestureDetector(
                                      onTap: () {
                                        clickItem(
                                            context,
                                            BlocProvider.of<HistoryCubit>(
                                                    context)
                                                .visibleTrans[index]);
                                      },
                                      child: HistoryItem(
                                          newTrans:
                                              BlocProvider.of<HistoryCubit>(
                                                      context)
                                                  .visibleTrans[index]));
                                }),
                          ),
                          if (BlocProvider.of<HistoryCubit>(context).filtered ==
                              true)
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.sp)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h, horizontal: 10.w),
                                          child: Column(
                                            children: [
                                              Text(
                                                AppStrings.total.tr(),
                                                style: TextStyle(
                                                    color:
                                                        ColorsManager.primary,
                                                    fontSize: 20.sp),
                                              ),
                                              Text(
                                                '${NumberFormat('###,###,###').format(BlocProvider.of<HistoryCubit>(context).total)} ${AppStrings.egp.tr()}',
                                                style: TextStyle(
                                                    color:
                                                        ColorsManager.primary,
                                                    fontSize: 20.sp),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  if (BlocProvider.of<HistoryCubit>(context)
                                      .visibleTrans
                                      .isNotEmpty)
                                    Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            pdf(context);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.h, horizontal: 8.w),
                                            child: Column(
                                              children: [
                                                Text(
                                                  AppStrings.extract.tr(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.sp),
                                                ),
                                                Text(
                                                  'Pdf',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.sp),
                                                ),
                                              ],
                                            ),
                                          )),
                                    )
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
