import 'dart:async';

import 'package:moneytrack/cubit/admin/admin_states.dart';
import 'package:moneytrack/data/remote/FirebaseService/firebaseService_fireStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';

class AdminCubit extends Cubit<AdminStates> {
  AdminCubit() : super(AdminInitiateState());

  @override
  Future<void> close() {
    adminsSub?.cancel();
    // TODO: implement close
    return super.close();
  }

  List<UserData> admins = [];

  UserData? userField;

  StreamSubscription<QuerySnapshot<Object?>>? adminsSub;

  Future<void> fetchAdmins() async {
    try {
      emit(AdminFetchLoadingState());
      adminsSub = FirebaseFirestore.instance
          .collection('users')
          .where('isAdmin', isEqualTo: true)
          .snapshots()
          .listen((event) {
        admins = [];
        for (var element in event.docs) {
          admins.add(UserData.fromJson(element.data()));
        }
        emit(AdminFetchSuccessState());
      });
    } catch (error) {
      emit(AdminFetchFailedState());
      rethrow;
    }
  }

  Future<void> addAdmin() async {
    try {
      emit(AdminAddLoadingState());
      FirebaseServiceFireStore()
          .setDocument('users', userField!.id, {'isAdmin': true}).then((value) {
        emit(AdminAddSuccessState());
      });
    } catch (error) {
      emit(AdminAddFailedState());
    }
  }

  Future<void> deleteAdmin() async {
    try {
      emit(AdminDeleteLoadingState());
      FirebaseServiceFireStore().setDocument(
          'users', userField!.id, {'isAdmin': false}).then((value) {
        emit(AdminDeleteSuccessState());
      });
    } catch (error) {
      emit(AdminDeleteFailedState());
    }
  }

  Future<void> getUserByNumber(String number) async {
    emit(AdminUserLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: '+2$number')
          .get()
          .then((value) {
        userField = UserData.fromJson(value.docs.first.data());
        emit(AdminUserSuccessState());
      });
    } catch (error) {
      emit(AdminUserFailedState());
      rethrow;
    }
  }

  Future<bool> numberExist(String number) async {
    for (var element in admins) {
      bool exist = element.phoneNumber == number;
      if (exist == true) {
        return exist;
      }
    }
    return false;
  }

  bool isMe(UserData user) {
    return user.id == FirebaseAuth.instance.currentUser?.uid;
  }
}
