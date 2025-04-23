import 'package:moneytrack/cubit/category/category_cubit.dart';
import 'package:moneytrack/cubit/category/category_states.dart';
import 'package:moneytrack/presentation/category/category_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../resources/colors_manager.dart';
import '../resources/const_widgets/const_widgets.dart';
import '../resources/strings_manager.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController newCategory = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> add() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (BlocProvider.of<CategoryCubit>(context).isExist(newCategory.text)) {
      ConstWidgets.messageDialog(context, AppStrings.categoryExist.tr());
    } else {
      await BlocProvider.of<CategoryCubit>(context)
          .addCategory(newCategory.text)
          .then((value) {
        newCategory.clear();
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryCubit, CategoryStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
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

                  title: Text(AppStrings.categories.tr(),style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.sp),),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                body: (state is CategoryFetchLoadingState) ||
                        (state is CategoryAddLoadingState) ||
                        (state is CategoryDeleteLoadingState)
                    ? Center(child: ConstWidgets.spinkit)
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      controller: newCategory,
                                      style: TextStyle(
                                          color: ColorsManager.white,
                                          fontSize: 20.sp),
                                      cursorColor: ColorsManager.white,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorsManager.white),
                                            borderRadius:
                                                BorderRadius.circular(10.0.sp),
                                          ),
                                          labelText:
                                              AppStrings.categoryName.tr(),
                                          labelStyle: TextStyle(
                                              color: ColorsManager.white),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorsManager.white),
                                            borderRadius:
                                                BorderRadius.circular(10.0.sp),
                                          )),
                                      keyboardType: TextInputType.text,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return AppStrings.enterCategory.tr();
                                        } else {
                                          return null;
                                        }
                                      },
                                      onFieldSubmitted: (val) {
                                        add();
                                      },
                                    ),
                                  )),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.sp)),
                                          backgroundColor: Colors.white),
                                      onPressed: add,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0.sp),
                                        child: Text(
                                          AppStrings.add.tr(),
                                          style: TextStyle(
                                              color: ColorsManager.primary,
                                              fontSize: 20.sp),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            Divider(
                                color: ColorsManager.white,
                                thickness: .5.h,
                                height: 20.h),                            Expanded(
                                child: Center(
                              child: ListView.builder(
                                  itemCount:
                                      BlocProvider.of<CategoryCubit>(context)
                                          .category
                                          .length,
                                  itemBuilder: (context, index) {
                                    return CategoryItem(
                                        categoryName:
                                            BlocProvider.of<CategoryCubit>(
                                                    context)
                                                .category[index]);
                                  }),
                            )),
                          ],
                        ),
                      ),
              ),
            ),
          );
        });
  }
}
