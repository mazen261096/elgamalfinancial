import 'package:moneytrack/cubit/members/members_states.dart';
import 'package:moneytrack/cubit/wallet/wallet_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/remote/FirebaseService/firebaseService_fireStore.dart';
import '../../models/user.dart';

class MembersCubit extends Cubit<MembersStates> {
  MembersCubit() : super(MembersInitiateState());

  UserData? userField;
  List<UserData> currentWalletMembers = [];
  String deletingId = '';

  Future<void> addMember({required String walletId}) async {
    emit(MembersAddLoadingState());
    try {
      FirebaseServiceFireStore.createBatch2(
          collection1: 'wallets',
          doc1: walletId,
          data1: {
            'members': FieldValue.arrayUnion([userField!.id])
          },
          collection2: 'wallets',
          doc2: walletId,
          data2: {
            'access': FieldValue.arrayUnion([userField!.id])
          }).commit().then((value) {
        currentWalletMembers.add(userField!);
        emit(MembersAddSuccessState());
      });
    } catch (error) {
      emit(MembersAddFailedState());
      rethrow;
    }
  }

  Future<void> deleteMember(
      {required UserData user, required String walletId}) async {
    emit(MembersDeleteLoadingState());
    deletingId = user.id;
    try {
      FirebaseServiceFireStore.createBatch2(
          collection1: 'wallets',
          doc1: walletId,
          data1: {
            'members': FieldValue.arrayRemove([user.id])
          },
          collection2: 'users',
          doc2: walletId,
          data2: {
            'access': FieldValue.arrayRemove([user.id])
          }).commit().then((value) {
        currentWalletMembers.remove(userField!);
        emit(MembersDeleteSuccessState());
      });
    } catch (error) {
      emit(MembersDeleteFailedState());
    }
  }

  Future<void> fetchMembers(List usersId) async {
    emit(MembersLoadingState());
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
                currentWalletMembers.add(newUser);
              }
            }
          }
        });
      } catch (error) {
        emit(MembersFailedState());
        rethrow;
      }
    }
    emit(MembersSuccessState());
  }

  bool numberExist({required String number}) {
    for (var element in currentWalletMembers) {
      bool exist = element.phoneNumber == number;
      if (exist == true) {
        return exist;
      }
    }
    return false;
  }

  Future<void> getUserByNumber(String number) async {
    emit(MembersAddLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: '+2$number')
          .get()
          .then((value) {
        userField = UserData.fromJson(value.docs.first.data());
        emit(MembersAddSuccessState());
      });
    } catch (error) {
      emit(MembersAddFailedState());
      rethrow;
    }
  }

  bool isViewer({required BuildContext ctx}) {
    return BlocProvider.of<WalletCubit>(ctx)
        .currentWallet!
        .viewers
        .contains(userField!.id);
  }

  int memberExpense({required BuildContext ctx, required String uid}) {
    int expense = 0;
    for (var element
        in BlocProvider.of<WalletCubit>(ctx).currentWallet!.transactions) {
      if (element.uId == uid && element.type == 'pay') {
        expense = -element.amount + expense;
      }
    }
    print(uid);
    return expense;
  }
}
