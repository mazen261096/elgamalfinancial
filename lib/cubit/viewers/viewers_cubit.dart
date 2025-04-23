import 'package:moneytrack/cubit/viewers/viewers_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';
import '../wallet/wallet_cubit.dart';

class ViewersCubit extends Cubit<ViewersStates> {
  ViewersCubit() : super(ViewersInitiateState());

  UserData? userField;
  List<UserData> currentWalletViewers = [];
  String deletingId = '';

  Future<void> addViewer({required String walletId}) async {
    emit(ViewersAddLoadingState());
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      DocumentReference walletRef =
          FirebaseFirestore.instance.collection('wallets').doc(walletId);
      batch.set(
          walletRef,
          {
            'viewers': FieldValue.arrayUnion([userField!.id])
          },
          SetOptions(merge: true));

      DocumentReference userRef =
          FirebaseFirestore.instance.collection('wallets').doc(walletId);
      batch.set(
          userRef,
          {
            'access': FieldValue.arrayUnion([userField!.id])
          },
          SetOptions(merge: true));

      await batch.commit().then((value) {
        currentWalletViewers.add(userField!);
        emit(ViewersAddSuccessState());
      });
    } catch (error) {
      emit(ViewersAddFailedState());
    }
  }

  Future<void> deleteViewer(
      {required UserData user, required String walletId}) async {
    emit(ViewersDeleteLoadingState());
    deletingId = user.id;
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      DocumentReference walletRef =
          FirebaseFirestore.instance.collection('wallets').doc(walletId);
      batch.set(
          walletRef,
          {
            'viewers': FieldValue.arrayRemove([user.id])
          },
          SetOptions(merge: true));

      DocumentReference userRef =
          FirebaseFirestore.instance.collection('wallets').doc(walletId);
      batch.set(
          userRef,
          {
            'access': FieldValue.arrayRemove([user.id])
          },
          SetOptions(merge: true));

      await batch.commit().then((value) {
        currentWalletViewers.remove(userField!);
        emit(ViewersDeleteSuccessState());
      });
    } catch (error) {
      emit(ViewersDeleteFailedState());
    }
  }

  Future<void> fetchViewers(List usersId) async {
    emit(ViewersLoadingState());
    if (usersId.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .where('id', whereIn: usersId)
            .get()
            .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            for (var document in querySnapshot.docs) {
              UserData newUser =
                  UserData.fromJson(document.data() as Map<String, dynamic>);
              if (!newUser.isAdmin) {
                currentWalletViewers.add(newUser);
              }
            }
          }
        });
      } catch (error) {
        emit(ViewersFailedState());
        rethrow;
      }
    }
    emit(ViewersSuccessState());
  }

  bool numberExist({required String number}) {
    for (var element in currentWalletViewers) {
      bool exist = element.phoneNumber == number;
      if (exist == true) {
        return exist;
      }
    }
    return false;
  }

  Future<void> getUserByNumber(String number) async {
    emit(ViewersAddLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: '+2$number')
          .get()
          .then((value) {
        userField = UserData.fromJson(value.docs.first.data());
        emit(ViewersAddSuccessState());
      });
    } catch (error) {
      emit(ViewersAddFailedState());
      rethrow;
    }
  }

  bool isMember({required BuildContext ctx}) {
    return BlocProvider.of<WalletCubit>(ctx)
        .currentWallet!
        .members
        .contains(userField!.id);
  }

  bool thisItem(UserData user) {
    return user.id == deletingId;
  }
}
