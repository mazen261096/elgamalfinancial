import 'package:moneytrack/cubit/category/category_cubit.dart';
import 'package:moneytrack/cubit/category/category_states.dart';
import 'package:moneytrack/presentation/resources/const_widgets/const_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/strings_manager.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, required this.categoryName});
  final String categoryName;

  delete(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.sp)),
            content: Text(
              AppStrings.verifyDelete.tr(),
              style: TextStyle(fontSize: 20.sp),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    try {
                      Navigator.pop(context);
                      await BlocProvider.of<CategoryCubit>(context)
                          .deleteCategory(categoryName);
                    } catch (error) {
                      ConstWidgets.errorDialog(
                          context, 'Failed Delete Category');
                    }
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.w),
                    child: Text(AppStrings.delete.tr(),
                        style: TextStyle(fontSize: 20.sp)),
                  )),
              Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0.h, horizontal: 8.w),
                      child: Text(AppStrings.cancel.tr(),
                          style: TextStyle(fontSize: 20.sp)),
                    )),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryCubit, CategoryStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            children: [
              Card(
                margin: EdgeInsets.only(top: 10.h),
                elevation: 10,
                child: Container(
                  constraints: BoxConstraints(minHeight: 70.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Center(
                              child: Text(
                        categoryName,
                        style: TextStyle(fontSize: 20.sp),
                      ))),
                      if (categoryName != 'Returns')
                        Padding(
                          padding: EdgeInsets.all(10.sp),
                          child: Center(
                            child: IconButton(
                                iconSize: 30.sp,
                                onPressed: () {
                                  delete(context);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 30.sp,
                                )),
                          ),
                        )
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}
