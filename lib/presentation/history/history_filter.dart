import 'package:moneytrack/cubit/history/history_cubit.dart';
import 'package:moneytrack/cubit/history/history_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multiselect/multiselect.dart';

import '../resources/colors_manager.dart';
import '../resources/strings_manager.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoryCubit, HistoryStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: ColorsManager.primary))),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.0.h),
                      child: Center(
                          child: Text(
                        AppStrings.filter.tr(),
                        style: TextStyle(
                            color: ColorsManager.primary, fontSize: 20.sp),
                      )),
                    ),
                  ),
                  if (BlocProvider.of<HistoryCubit>(context)
                          .walletsName
                          .length >
                      1)
                    DropDownMultiSelect(
                      isDense: false,
                      hintStyle: TextStyle(
                          fontSize: 15.sp, color: ColorsManager.primary),
                      options:
                          BlocProvider.of<HistoryCubit>(context).walletsName,
                      selectedValues:
                          BlocProvider.of<HistoryCubit>(context).filterWallets,
                      onChanged: (value) {
                        BlocProvider.of<HistoryCubit>(context).filterTrans();
                      },
                      hint: Text(AppStrings.choseWallets.tr()),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            fontSize: 15.sp, color: ColorsManager.primary),
                        labelText: AppStrings.theWallets.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0.sp),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 10.h,
                  ),
                  DropDownMultiSelect(
                    isDense: false,
                    hintStyle: TextStyle(
                        fontSize: 15.sp, color: ColorsManager.primary),
                    options: BlocProvider.of<HistoryCubit>(context).membersName,
                    selectedValues:
                        BlocProvider.of<HistoryCubit>(context).filterName,
                    onChanged: (value) {
                      BlocProvider.of<HistoryCubit>(context).filterTrans();
                    },
                    hint: Text(AppStrings.choseMembers.tr()),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          fontSize: 15.sp, color: ColorsManager.primary),
                      labelText: AppStrings.members.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  DropDownMultiSelect(
                    isDense: false,
                    hintStyle: TextStyle(
                        fontSize: 15.sp, color: ColorsManager.primary),
                    options: BlocProvider.of<HistoryCubit>(context).categories,
                    selectedValues:
                        BlocProvider.of<HistoryCubit>(context).filterCategory,
                    onChanged: (value) {
                      BlocProvider.of<HistoryCubit>(context).filterTrans();
                    },
                    hint: Text(AppStrings.choseCategories.tr()),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          fontSize: 15.sp, color: ColorsManager.primary),
                      labelText: AppStrings.categories.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  InputDecorator(
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontSize: 15.sp, color: ColorsManager.primary),
                        labelStyle: TextStyle(
                            fontSize: 15.sp, color: ColorsManager.primary),
                        labelText: AppStrings.after.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocProvider.of<HistoryCubit>(context).filterAfter ==
                                  null
                              ? Text(
                                  'DD/MM/YY',
                                  style: TextStyle(fontSize: 15.sp),
                                )
                              : Text(
                                  DateFormat('yyyy-MM-dd').format(
                                      BlocProvider.of<HistoryCubit>(context)
                                          .filterAfter!),
                                  style: TextStyle(fontSize: 15.sp)),
                          IconButton(
                              iconSize: 30.sp,
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2022),
                                  lastDate: DateTime.now(),
                                ).then((value) {
                                  BlocProvider.of<HistoryCubit>(context)
                                      .changeFilterAfter(value);
                                });
                              },
                              icon: Icon(Icons.calendar_month_rounded)),
                        ],
                      )),
                  SizedBox(
                    height: 10.h,
                  ),
                  InputDecorator(
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontSize: 15.sp, color: ColorsManager.primary),
                        labelStyle: TextStyle(
                            fontSize: 15.sp, color: ColorsManager.primary),
                        labelText: AppStrings.before.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocProvider.of<HistoryCubit>(context).filterBefore ==
                                  null
                              ? Text('DD/MM/YY',
                                  style: TextStyle(fontSize: 15.sp))
                              : Text(
                                  DateFormat('yyyy-MM-dd').format(
                                      BlocProvider.of<HistoryCubit>(context)
                                          .filterBefore!),
                                  style: TextStyle(fontSize: 15.sp)),
                          IconButton(
                              iconSize: 30.sp,
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2022),
                                  lastDate: DateTime.now(),
                                ).then((value) {
                                  BlocProvider.of<HistoryCubit>(context)
                                      .changeFilterBefore(value);
                                });
                              },
                              icon: Icon(Icons.calendar_month_rounded)),
                        ],
                      )),
                  SizedBox(
                    height: 10.h,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(
                            right: 30.sp,
                            left: 30.sp,
                            top: 15.sp,
                            bottom: 15.sp),
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.sp))),
                    child: Text(
                      AppStrings.done.tr(),
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
