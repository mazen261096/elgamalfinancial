import 'dart:async';

import 'package:moneytrack/cubit/wallet/wallet_states.dart';
import 'package:moneytrack/models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/app_prefs.dart';
import '../../data/remote/FirebaseService/firebaseService_fireStore.dart';
import '../../models/wallet.dart';

class WalletCubit extends Cubit<WalletStates> {
  WalletCubit() : super(WalletInitialState());

  List<Wallet> wallets = [];
  List<Transactions> allTrans = [];
  Wallet? currentWallet;
  int balance = 0;
  int expenses = 0;
  bool notification = AppPreferences.notification;
  int walletsNumber = 0;

  int walletsLoadedNumber = 0;

  Future<void> enableNotifications() async {
    emit(WalletNotificationLoadingState());
    try {
      for (var document in wallets) {
        await FirebaseMessaging.instance.subscribeToTopic(document.id);
      }
      await AppPreferences.changeLocaleNotificationStatue('true').then((value) {
        notification = true;
        emit(WalletNotificationSuccessState());
      });
    } catch (error) {
      emit(WalletNotificationFailedState());
    }
  }

  Future<void> disableNotifications() async {
    emit(WalletNotificationLoadingState());
    try {
      for (var document in wallets) {
        await FirebaseMessaging.instance.unsubscribeFromTopic(document.id);
      }
      await AppPreferences.changeLocaleNotificationStatue('false')
          .then((value) {
        notification = false;
        emit(WalletNotificationSuccessState());
      });
    } catch (error) {
      emit(WalletNotificationFailedState());
    }
  }

  Future<void> freezingWallet(String id) async {
    emit(WalletFreezingState());
    FirebaseServiceFireStore()
        .setDocument('wallets', id, {'freezed': true}).then((value) {
      emit(WalletFreezingSuccessState());
    }).onError((error, stackTrace) {
      emit(WalletFreezingFailedState());
    });
  }

  Future<void> unFreezingWallet(String id) async {
    emit(WalletFreezingState());
    FirebaseServiceFireStore()
        .setDocument('wallets', id, {'freezed': false}).then((value) {
      emit(WalletFreezingSuccessState());
    }).onError((error, stackTrace) {
      emit(WalletFreezingFailedState());
    });
  }

  Future<void> fetchWallets() async {
    if (AppPreferences.userDataSub != null) AppPreferences.userDataSub!.cancel();
    if (AppPreferences.walletSub != null) AppPreferences.walletSub!.cancel();

    try {
      emit(WalletLoadingState());
      if (AppPreferences.userData.isAdmin) {
        AppPreferences.walletSub =
            FirebaseServiceFireStore.listenCollection(collection: 'wallets')
                .listen((QuerySnapshot querySnapshot) async {
          await initiateWallets(querySnapshot);
          emit(WalletLoadingSuccessState());
          if (notification) {
          //  for (var element in wallets) {  FirebaseMessaging.instance.subscribeToTopic(element.id);}
          }
        });
      } else {
        if (AppPreferences.walletSub != null) AppPreferences.walletSub!.cancel();

        AppPreferences.walletSub = FirebaseServiceFireStore.listenToWallets(
            uId: AppPreferences.user.uid)
            .listen((querySnapshot) async {
          await initiateWallets(querySnapshot);
          emit(WalletLoadingSuccessState());
          if (notification) {
          // for (var element in wallets) {  FirebaseMessaging.instance.subscribeToTopic(element.id);}
          }
        });
      }
    } catch (error) {
      emit(WalletLoadingFailedState());
      rethrow;
    }
  }

  Future<void> initiateWallets(QuerySnapshot querySnapshot) async {
    wallets.clear();
    allTrans.clear();
    walletsLoadedNumber = 0;

    if (querySnapshot.docs.isNotEmpty) {
      walletsNumber = querySnapshot.docs.length;
      for (var document in querySnapshot.docs) {
        List<Transactions> newtran = [];
        Timestamp createdAt = document['createdAt'];
        int balance = 0;
        int expenses = 0;


        for (var element in (document['transactions'] as List)) {
          balance = balance + element['amount'] as int;
          if ((element['amount'] as int) < 0 &&
              (element['type'] as String) == 'pay') {
            expenses = -(element['amount'] as int) + expenses;
          }
          if (element['category'] as String == 'Returns') {
            expenses = expenses - (element['amount'] as int);
          }
          Transactions newTran = Transactions.fromJson({
            'amount': element['amount'],
            'walletName': element['walletName'],
            'name': element['name'],
            'uId': element['uId'],
            'description': element['description'],
            'bill': element['bill'],
            'type': element['type'],
            'category': element['category'],
            'createdAt': DateTime.fromMicrosecondsSinceEpoch(
                element['createdAt'].microsecondsSinceEpoch),
          });
          newtran.add(newTran);
          allTrans.add(newTran);
        }

        Wallet newWallet = Wallet.fromJson({
          'id': document.id,
          'name': document['name'],
          'description': document['description'],
          'balance': balance,
          'expenses': expenses,
          'transactions': newtran,
          'members': document['members'],
          'viewers': document['viewers'],
          'access': document['access'],
          'freezed': document['freezed'],
          'createdAt': DateTime.fromMicrosecondsSinceEpoch(
              createdAt.microsecondsSinceEpoch),
        });
        wallets.add(newWallet);
        walletsLoadedNumber = walletsLoadedNumber + 1;
        emit(WalletLoadingState());
      }
      if (currentWallet != null) {
        currentWallet =
            wallets.firstWhere((element) => element.id == currentWallet?.id);
      }
      await calculateTotal();
      emit(WalletLoadingSuccessState());
    } else {
      wallets.clear();
      balance = 0;
      expenses = 0;
      walletsNumber = 0;
      walletsLoadedNumber = 0;
      emit(WalletLoadingSuccessState());
    }
  }

  Future<void> createWallet({required String name, required String description}) async {
    emit(WalletCreateLoadingState());

    await FirebaseServiceFireStore.createDocument('wallets', {
      'name': name,
      'description': description,
      'createdAt': DateTime.now(),
      'freezed': false,
      'balance': 0,
      'expenses': 0,
      'transactions': [],
      'members': [],
      'viewers': [],
      'access': []
    });
    emit(WalletCreatedState());
  }


  Future<void> initiateCurrentWallet({required int index}) async {
    currentWallet = wallets[index];
  }

  Future<void> calculateTotal() async {
    balance = 0;
    expenses = 0;
    for (var element in wallets) {
      balance = balance + element.balance;
      expenses = expenses + element.expenses;
    }
  }

}
