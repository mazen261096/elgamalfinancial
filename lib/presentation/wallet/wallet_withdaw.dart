import 'dart:ui';

import 'package:moneytrack/cubit/pay/pay_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/app_prefs.dart';
import '../../cubit/pay/pay_states.dart';
import '../../cubit/wallet/wallet_cubit.dart';
import '../resources/colors_manager.dart';
import '../resources/const_widgets/const_widgets.dart';
import '../resources/strings_manager.dart';

class WalletWithdraw extends StatefulWidget {
  const WalletWithdraw({super.key});

  @override
  State<WalletWithdraw> createState() => _WalletWithdrawState();
}

class _WalletWithdrawState extends State<WalletWithdraw> {
  final TextEditingController amount = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();

  withdraw(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
        context: context,
        builder: (_) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.sp)),
              actions: [
                Padding(
                  padding: EdgeInsets.all(8.0.sp),
                  child: ElevatedButton(
                      onPressed: cancel,
                      child: Padding(
                        padding: EdgeInsets.all(8.0.sp),
                        child: Text(
                          AppStrings.cancel.tr(),
                          style: TextStyle(fontSize: 15.sp),
                        ),
                      )),
                ),
                ElevatedButton(
                    onPressed: () {
                      withdrawVerify(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0.sp),
                      child: Text(AppStrings.withdraw.tr(),
                          style: TextStyle(fontSize: 15.sp)),
                    )),
              ],
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      '${AppStrings.withdrawVerify.tr()} ${NumberFormat('###,###,###').format(int.parse(amount.text))} ${AppStrings.egp.tr()}',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp)),
                ],
              ),
            ),
          );
        });
  }

  withdrawVerify(BuildContext context) async {
    Navigator.pop(context);
    try {
      await BlocProvider.of<PayCubit>(context)
          .createTransaction(
              walletName:
                  BlocProvider.of<WalletCubit>(context).currentWallet!.name,
              type: 'withdraw',
              name: AppPreferences.userData.name,
              walletId: BlocProvider.of<WalletCubit>(context).currentWallet!.id,
              description: '',
              amount: -int.parse(amount.text),
              category: 'withdraw',
              date: date)
          .then((value) {
        Navigator.pop(context);
      });
    } catch (error) {
      ConstWidgets.errorDialog(context, error.toString());
    }
  }

  void cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PayCubit>(
      create: (_) => PayCubit(),
      child: BlocConsumer<PayCubit, PayStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.sp)),
              content: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${AppStrings.enterAmountPlz.tr()}:',
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        style: TextStyle(fontSize: 20.sp),
                        controller: amount,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppStrings.enterAmountPlz.tr();
                          } else if (int.tryParse(value) == null) {
                            return AppStrings.enterNumbersOnlyPlz.tr();
                          }
                          return null;
                        },
                        onFieldSubmitted: (val) {
                          withdraw(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime.now(),
                          ).then((value) {
                            setState(() {
                              date = value!;
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.sp)),
                            elevation: 10),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Center(
                            child: Text(
                              DateFormat('dd / MM / yyyy').format(date),
                              style: TextStyle(
                                  color: ColorsManager.primary,
                                  fontSize: 20.sp),
                            ),
                          ),
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    (state is PayCreateLoadingState)
                        ? Center(child: ConstWidgets.spinkit)
                        : Padding(
                            padding: EdgeInsets.all(8.0.sp),
                            child: ElevatedButton(
                                onPressed: () {
                                  withdraw(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(8.0.sp),
                                  child: Text(AppStrings.withdraw.tr()),
                                )),
                          )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
