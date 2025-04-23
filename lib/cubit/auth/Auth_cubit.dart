// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moneytrack/data/remote/FirebaseService/firebaseService_fireStore.dart';
import 'package:moneytrack/data/remote/FirebaseService/firebaseService_realTime.dart';
import 'package:moneytrack/presentation/resources/const_widgets/const_widgets.dart';
import 'package:moneytrack/presentation/resources/constants_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/app_prefs.dart';
import '../../data/local/shared_preference.dart';
import '../../data/remote/FirebaseService/firebaseService_auth.dart';
import '../wallet/wallet_cubit.dart';
import 'Auth_States.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthIntialState());

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String number,
  }) async {
    try {
      emit(AuthSignUpState());
      await FirebaseServiceAuth.register(email, password).then((value) async {
        AppPreferences.user = value.user!;
        await addUser(name: name,number:number);
      //  await updateNotificationToken(userId: AppPreferences.user.uid);
        await AppPreferences.getUserData();
        SharedPreference.saveShared({'email': email, 'password': password},
            AppConstants.loginSharedkey);
      });
      emit(AuthSignUpSuccessState());
    } catch (error) {
      emit(AuthSignUpFailedState());
      rethrow;
    }
  }

  Future<void> reloadUser() async {
    AppPreferences.user = FirebaseServiceAuth.getUser()!;
    emit(AuthUserReloadedState());
  }

  Future<void> autoLogin() async {
    try {
      if (await SharedPreference.isSharedSaved(AppConstants.loginSharedkey)) {
        if (await FirebaseServiceAuth.isConnected()) {
          AppPreferences.user = FirebaseServiceAuth.getUser()!;
          await AppPreferences.getUserData();

          emit(AuthConnectedState());
        } else {
          var data = await SharedPreference.fetchSavedShared(
              AppConstants.loginSharedkey);
          await loginWithEmail(data['email'], data['password']);
        }
      }
    } catch (error) {
      emit(AuthDisConnectedState());
      rethrow;
    }
  }

  Future<void> updateNotificationToken({required String userId}) async {
    FirebaseMessaging.instance.getToken().then((value) async {
      String? token = value;
      if (token != null) {
        await FirebaseServiceFireStore()
            .updateDocument('users', userId, {'token': token});
      }
    });
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      emit(AuthConnectingState());
      String nEmail = email;
      if (RegExp(r'^[0-9]+$').hasMatch(email)) {
        if (await FirebaseServiceRealTime.userExist(number: '+2$email')) {
          await FirebaseServiceRealTime.getUser(number: '+2$email')
              .then((value) => nEmail = value.email);
        }
      }
      await FirebaseServiceAuth.logIn(nEmail, password).then((value) async {
        AppPreferences.user = value.user!;
       // await updateNotificationToken(userId: AppPreferences.user.uid);
        await AppPreferences.getUserData();
        SharedPreference.saveShared({'email': nEmail, 'password': password},
            AppConstants.loginSharedkey);
      });
      emit(AuthConnectedState());
    } catch (error) {
      emit(AuthErrorLoggedInState());
      rethrow;
    }
  }

  Future<void> updatePassword(
      {required String oldPassword,
      required String newPassword,
      required BuildContext context}) async {
    emit(AuthChangePasswordState());
    try {
      await FirebaseServiceAuth.logIn(
              FirebaseAuth.instance.currentUser!.email!, oldPassword)
          .then((value) async {})
          .then((value) async {
        await FirebaseAuth.instance.currentUser!
            .updatePassword(newPassword)
            .then((value) {
          emit(AuthChangePasswordSuccessState());
        });
      });
    } catch (error) {
      emit(AuthChangePasswordFailedState());
      ConstWidgets.errorDialog(context, error.toString());
      rethrow;
    }
  }

  Future<void> newPassword(String password) async {
    try {
      emit(AuthChangePasswordState());
      await AppPreferences.user
          .updatePassword(password)
          .then((value) => emit(AuthChangePasswordSuccessState()));
    } catch (error) {
      emit(AuthChangePasswordFailedState());
      rethrow;
    }
  }

  Future<void> addUser({required String name,required String number}) async {
    Map<String, dynamic> data = {
      'id': AppPreferences.user.uid,
      'name': name,
      'email': AppPreferences.user.email,
      'phoneNumber': '+2$number',
      'profilePic': '',
      'address': '',
      'isAdmin': true,
      'disabled': false,
      'deleted': false,
      'token': '',
      'wallets': [],
    };
    await FirebaseServiceFireStore()
        .setDocument('users', AppPreferences.user.uid, data);
    await FirebaseServiceRealTime.setUser(
        uId: AppPreferences.user.uid, data: data);
  }

  Future<void> logOut(BuildContext context) async {
   try{
     emit(AuthConnectingState());
     if (!WalletCubit().isClosed) {
       for (final element in BlocProvider.of<WalletCubit>(context).wallets) {
         //await FirebaseMessaging.instance.unsubscribeFromTopic(element.id);
       }
     }
     if (AppPreferences.userDataSub != null) {
       AppPreferences.userDataSub!.cancel();
     }
     if (AppPreferences.walletSub != null) AppPreferences.walletSub!.cancel();
     await FirebaseServiceAuth.logout();
     await SharedPreference.deleteShared(AppConstants.loginSharedkey);
     emit(AuthDisConnectedState());
   }catch(error){

     showDialog(context: context, builder:(context){

       return AlertDialog(
         content: Text("${error.toString()} PLEASE TRY AGAIN "),
       );
     });
   }
  }
}
