import 'package:moneytrack/cubit/wallet/wallet_cubit.dart';
import 'package:moneytrack/presentation/resources/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cubit/wallet/wallet_states.dart';
import '../resources/colors_manager.dart';
import '../resources/const_widgets/const_widgets.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';

class AddWalletScreen extends StatefulWidget {
  const AddWalletScreen({super.key});

  @override
  State<AddWalletScreen> createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();

  void createWallet() {
    if (!_formKey.currentState!.validate()) return;
    BlocProvider.of<WalletCubit>(context)
        .createWallet(name: name.text, description: description.text)
        .then((value) {
      Routes.message = AppStrings.walletCreated.tr();
      Navigator.pushReplacementNamed(context, Routes.addWalletSuccessRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletStates>(
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
                appBar: ConstWidgets.appBar(context),
                backgroundColor: Colors.transparent,
                body: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: (736.h)-MediaQuery.of(context).padding.top - kToolbarHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Center(
                            child: Text(AppStrings.createWallet.tr(),
                                style: getSemiBoldTextStyle(
                                    color: ColorsManager.white,
                                    fontSize: 30.sp)),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(right: 40.w),
                                padding: EdgeInsets.only(
                                    bottom: 3.h,
                                    left: 30
                                        .w // This can be the space you need between text and underline
                                    ),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                  color: ColorsManager.white,
                                  width: 1.0
                                      .w, // This would be the width of the underline
                                ))),
                                child: Text(
                                  AppStrings.enterWalletDetails.tr(),
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: ColorsManager.white),
                                ),
                              ),
                              SizedBox(
                                height: 60.h,
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(right: 40.w, left: 40.w),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: name,
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
                                          labelText: AppStrings.name.tr(),
                                          labelStyle: TextStyle(
                                              color: ColorsManager.white),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorsManager.white),
                                            borderRadius:
                                                BorderRadius.circular(10.0.sp),
                                          )),
                                      keyboardType: TextInputType.name,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return AppStrings.enterWalletName
                                              .tr();
                                        } else if (val.length < 3) {
                                          return AppStrings.nameValidation.tr();
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 25.h,
                                    ),
                                    TextFormField(
                                      controller: description,
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
                                              '${AppStrings.description.tr()}(${AppStrings.optional.tr()})',
                                          labelStyle: TextStyle(
                                              color: ColorsManager.white,
                                              fontSize: 20.sp),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorsManager.white),
                                            borderRadius:
                                                BorderRadius.circular(10.0.sp),
                                          )),
                                      keyboardType: TextInputType.text,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            child: (state is WalletCreateLoadingState)
                                ? ConstWidgets.spinkit
                                : Container(
                                    height: 50.h,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ColorsManager.white),
                                        onPressed: createWallet,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: Center(
                                                    child: Text(
                                              AppStrings.createWallet.tr(),
                                              style: TextStyle(
                                                  color: ColorsManager.primary,
                                                  fontSize: 20.sp),
                                            ))),
                                            Icon(Icons.done,
                                                color: ColorsManager.primary)
                                          ],
                                        )),
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
        });
  }
}
