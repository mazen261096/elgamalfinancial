import 'package:moneytrack/cubit/verification/verification_states.dart';
import 'package:moneytrack/data/remote/FirebaseService/firebaseService_realTime.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/app_prefs.dart';
import '../../data/remote/FirebaseService/firebaseService_auth.dart';
import '../../data/remote/FirebaseService/firebaseService_fireStore.dart';
import '../../presentation/resources/const_widgets/const_widgets.dart';
import '../../presentation/resources/routes_manager.dart';

class VerificationCubit extends Cubit<VerificationStates> {
  VerificationCubit() : super(VerificationInitialState());

  bool codeSent = false;

  String number = '';
  String verificationId = '';
  String verificationRoute = Routes.homeRoute;

  void editeNumber() {
    codeSent = false;
    emit(VerificationEditeNumberState());
  }

  Future<void> sendOTP(BuildContext context) async {
    emit(VerificationSendingOtpState());
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 0),
      phoneNumber: '+2$number',
      verificationCompleted: (AuthCredential authCredential) {},
      codeSent: (String verificationId, int? resendToken) {
        codeSent = true;
        this.verificationId = verificationId;
        emit(VerificationOTPSentState());
      },
      verificationFailed: (FirebaseAuthException error) {
        emit(VerificationSendingOtpFailedState());
        ConstWidgets.errorDialog(context, error.message!);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> verifyNumber(String code) async {
    emit(VerificationLoadingState());
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: code);
    await AppPreferences.user
        .linkWithCredential(credential)
        .then((UserCredential result) async {
      await FirebaseServiceFireStore().updateDocument(
          'users',
          FirebaseAuth.instance.currentUser!.uid,
          {'phoneNumber': '+2$number'}).then((value) async {
        await FirebaseServiceRealTime.updateField(
            uId: FirebaseAuth.instance.currentUser!.uid,
            data: {
              '${FirebaseAuth.instance.currentUser!.uid}/phoneNumber':
                  '+2$number'
            }).then((value) async {
          await reloadUser();
          emit(VerificationSuccessState());
        });
      });
    }).catchError((error) {
      emit(VerificationFailedState());
      throw error;
    });
  }

  Future<void> phoneLogin(String code) async {
    try {
      emit(VerificationLoadingState());
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code);
      await FirebaseServiceAuth.phoneLogIn(credential).then((value) async {
        AppPreferences.user = value.user!;
        await AppPreferences.getUserData();
        emit(VerificationSuccessState());
      });
    } catch (error) {
      emit(VerificationFailedState());
      rethrow;
    }
  }

  Future<void> updateNumber(String code) async {
    try {
      emit(VerificationLoadingState());
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code);
      await FirebaseServiceAuth.updateNumber(credential).then((value) async {
        await reloadUser();
        await FirebaseServiceFireStore().updateDocument(
            'users',
            FirebaseAuth.instance.currentUser!.uid,
            {'phoneNumber': '+2$number'}).then((value) async {
          await FirebaseServiceRealTime.updateField(
              uId: FirebaseAuth.instance.currentUser!.uid,
              data: {
                '${FirebaseAuth.instance.currentUser!.uid}/phoneNumber':
                    '+2$number'
              }).then((value) {
            emit(VerificationSuccessState());
          });
        });
      });
    } catch (error) {
      emit(VerificationFailedState());
      rethrow;
    }
  }

  Future<void> reloadUser() async {
    AppPreferences.user = FirebaseServiceAuth.getUser()!;
    emit(VerificationUserReloadedState());
  }
}
