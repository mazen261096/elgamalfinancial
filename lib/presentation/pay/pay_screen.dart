import 'package:moneytrack/cubit/category/category_cubit.dart';
import 'package:moneytrack/cubit/category/category_states.dart';
import 'package:moneytrack/cubit/pay/pay_cubit.dart';
import 'package:moneytrack/cubit/pay/pay_states.dart';
import 'package:moneytrack/presentation/resources/const_widgets/const_widgets.dart';
import 'package:moneytrack/presentation/resources/routes_manager.dart';
// import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart';
import '../../app/app_prefs.dart';
import '../../cubit/wallet/wallet_cubit.dart';
import '../resources/colors_manager.dart';
import '../resources/strings_manager.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  TextEditingController description = TextEditingController();
  TextEditingController textAmount = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int amount = 0;
  String? category;
  DateTime date = DateTime.now();

  selectPhoto(BuildContext ctx) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.sp),
          topLeft: Radius.circular(20.sp),
        )),
        context: ctx,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      BlocProvider.of<PayCubit>(ctx)
                          .selectImage(source: 'gallery');
                    },
                    child: Text(
                      AppStrings.gallery.tr(),
                      style: TextStyle(fontSize: 20.sp),
                    )),
              ),
              Divider(height: 10.h),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      BlocProvider.of<PayCubit>(ctx)
                          .selectImage(source: 'camera');
                    },
                    child: Text(
                      AppStrings.camera.tr(),
                      style: TextStyle(fontSize: 20.sp),
                    )),
              ),
            ],
          );
        });
  }

  collect(BuildContext context) async {
    if (category == null) {
      ConstWidgets.errorDialog(context, AppStrings.chooseCategoryPlz.tr());
    }  else if (amount == 0) {
      ConstWidgets.errorDialog(context, AppStrings.enterAmountPlz.tr());
    } else {
      try {
         {
          await BlocProvider.of<PayCubit>(context)
              .createTransaction(
                  walletName:
                      BlocProvider.of<WalletCubit>(context).currentWallet!.name,
                  type: 'pay',
                  name: AppPreferences.userData.name,
                  walletId:
                      BlocProvider.of<WalletCubit>(context).currentWallet!.id,
                  description: description.text,
                  amount: category == 'Returns' ? amount : -amount,
                  category: category!,
                  date: date)
              .then((value) {
            Routes.message = AppStrings.tranDone.tr();
            Navigator.pushReplacementNamed(
                context, Routes.addWalletSuccessRoute);
          });
        }
      } catch (e) {
        ConstWidgets.errorDialog(context, e.toString());
      }
    }
  }

  enterAmount() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.sp)),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                AppStrings.enterAmountPlz.tr(),
                style: TextStyle(fontSize: 20.sp),
              ),
              SizedBox(
                height: 15.h,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  style: TextStyle(fontSize: 20.sp),
                  controller: textAmount,
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return AppStrings.enterAmountPlz.tr();
                    } else if (int.tryParse(val) == null) {
                      return AppStrings.enterNumbersOnlyPlz.tr();
                    }
                    return null;
                  },
                  onFieldSubmitted: (val) {
                    if (!_formKey.currentState!.validate()) return;
                    setState(() {
                      amount = int.parse(val);
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ]),
            actions: [
              Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      setState(() {
                        amount = int.parse(textAmount.text);
                      });
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0.sp, horizontal: 16),
                      child: Text(
                        AppStrings.done.tr(),
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0.sp),
                      child: Text(AppStrings.cancel.tr()),
                    )),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PayCubit>(
      create: (_) => PayCubit(),
      child: BlocConsumer<PayCubit, PayStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ColorsManager.primary, ColorsManager.white],
                    begin: const Alignment(0, -0.5),
                    end: const Alignment(0, 1),
                  ),
                ),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: (state is PayCreateLoadingState ||
                          state is PayPhotoLoadingState)
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ConstWidgets.spinkit,
                            SizedBox(
                              height: 25.sp,
                            ),
                            Text(
                              state is PayPhotoLoadingState
                                  ? AppStrings.uploadingBill.tr()
                                  : AppStrings.uploadingTrans.tr(),
                              style: TextStyle(
                                  fontSize: 25.sp,
                                  color: ColorsManager.white.withOpacity(.8)),
                            )
                          ],
                        ))
                      : SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.h, vertical: 15),
                            height: 736.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  children: [
                                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new,color: ColorsManager.white,)),

                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          '${BlocProvider.of<WalletCubit>(context).currentWallet?.name}',
                                          style: TextStyle(
                                              color: ColorsManager.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35.sp),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: enterAmount,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.white,
                                                width: 1))),
                                    child: Column(
                                      children: [
                                        Text(
                                          AppStrings.enterAmount.tr(),
                                          style: TextStyle(
                                              color: ColorsManager.white,
                                              fontSize: 20.sp),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                      '${NumberFormat('###,###,###').format(amount)}  ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25.sp)),
                                              TextSpan(
                                                  text: AppStrings.egp.tr(),
                                                  style: TextStyle(
                                                      color: ColorsManager
                                                          .lightprimary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 25.sp)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.sp)),
                                  elevation: 10,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 40.h, horizontal: 30.w),
                                    child: Column(
                                      children: [
                                        InputDecorator(
                                          decoration: InputDecoration(
                                            labelText: AppStrings.category.tr(),
                                            labelStyle:
                                                TextStyle(fontSize: 20.sp),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          child: BlocConsumer<CategoryCubit,
                                                  CategoryStates>(
                                              listener: (context, state) {},
                                              builder: (context, state) {
                                                return (state
                                                        is CategoryFetchLoadingState)
                                                    ? Center(
                                                        child: ConstWidgets
                                                            .spinkit)
                                                    : Center(
                                                        child: DropdownButton(
                                                          alignment:
                                                              Alignment.center,
                                                          icon: Icon(
                                                            Icons
                                                                .keyboard_arrow_down_sharp,
                                                            size: 30.sp,
                                                          ),
                                                          isDense: false,
                                                          underline:
                                                              const SizedBox(),
                                                          focusColor:
                                                              Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.sp),
                                                          value: category,
                                                          items: BlocProvider
                                                                  .of<CategoryCubit>(
                                                                      context)
                                                              .category
                                                              .map((e) {
                                                            return DropdownMenuItem(
                                                                value: e,
                                                                child: Center(
                                                                    child: Text(
                                                                  e,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17.sp),
                                                                )));
                                                          }).toList(),
                                                          onChanged: (val) {
                                                            setState(() {
                                                              category = val
                                                                  .toString();
                                                            });
                                                          },
                                                          style: TextStyle(
                                                              fontSize: 20.sp,
                                                              color:
                                                                  ColorsManager
                                                                      .primary),
                                                          hint: Text(
                                                              AppStrings
                                                                  .chooseCategory
                                                                  .tr(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      17.sp,
                                                                  color: ColorsManager
                                                                      .primary)),
                                                        ),
                                                      );
                                              }),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Divider(
                                            color: ColorsManager.primary,
                                            thickness: 1),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        InputDecorator(
                                          decoration: InputDecoration(
                                            labelStyle:
                                                TextStyle(fontSize: 20.sp),
                                            labelText:
                                                AppStrings.billDescription.tr(),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0.sp),
                                            ),
                                          ),
                                          child: TextFormField(
                                            style: TextStyle(fontSize: 20.sp),
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 3,
                                            textAlign: TextAlign.center,
                                            controller: description,
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.all(0),
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0.sp),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2022),
                                              lastDate: DateTime.now(),
                                            ).then((value) {
                                              setState(() {
                                                if (value != null) {
                                                  date = value;
                                                }
                                              });
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.sp)),
                                              elevation: 10),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0.sp),
                                            child: Center(
                                              child: Text(
                                                DateFormat('dd / MM / yyyy')
                                                    .format(date),
                                                style: TextStyle(
                                                    color:
                                                        ColorsManager.primary),
                                              ),
                                            ),
                                          )),
                                    ),
                                    Flexible(
                                      child: Badge(
                                        position:BadgePosition.bottomEnd() ,
                                        badgeStyle: BadgeStyle(
                                          badgeColor: ColorsManager.lightprimary,
                                        ),

                                        showBadge:
                                            BlocProvider.of<PayCubit>(context)
                                                    .imageFile !=
                                                null,

                                        badgeContent: Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 30.sp,
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0.sp),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  selectPhoto(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.sp)),
                                                    elevation: 10),
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.all(8.0.sp),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .document_scanner_outlined,
                                                        color: ColorsManager
                                                            .primary,
                                                        size: 40.sp,
                                                      ),
                                                      SizedBox(
                                                        width: 20.w,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            AppStrings.upload
                                                                .tr(),
                                                            style: TextStyle(
                                                                color:
                                                                    ColorsManager
                                                                        .primary,
                                                                fontSize:
                                                                    20.sp),
                                                          ),
                                                          Text(
                                                            AppStrings.bill
                                                                .tr(),
                                                            style: TextStyle(
                                                                color:
                                                                    ColorsManager
                                                                        .primary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    20.sp),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                FittedBox(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0.sp),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          collect(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              ColorsManager.lightprimary,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.sp)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0.sp),
                                          child: Row(
                                            children: [
                                              Text(
                                                AppStrings.pay.tr(),
                                                style: TextStyle(
                                                    color:
                                                        ColorsManager.primary,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24.sp),
                                              ),
                                              SizedBox(
                                                width: 20.w,
                                              ),
                                              Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                                size: 40.sp,
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            );
          }),
    );
  }
}
