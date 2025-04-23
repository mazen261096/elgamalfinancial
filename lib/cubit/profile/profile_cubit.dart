import 'dart:async';
import 'dart:io';

import 'package:moneytrack/cubit/profile/profile_states.dart';
import 'package:moneytrack/data/local/shared_preference.dart';
import 'package:moneytrack/data/remote/FirebaseService/firebaseService_auth.dart';
import 'package:moneytrack/data/remote/FirebaseService/firebaseService_fireStore.dart';
import 'package:moneytrack/models/user.dart';
import 'package:moneytrack/presentation/resources/constants_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/remote/FirebaseService/firebaseService_realTime.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitialStates());
  UserData? user;

  StreamSubscription<DocumentSnapshot<Object?>>? docStream;

  @override
  Future<void> close() {
    docStream?.cancel();
    // TODO: implement close
    return super.close();
  }

  deleteAccount() async {
    await FirebaseServiceAuth.deleteUser();
    await SharedPreference.deleteShared(AppConstants.loginSharedkey);
  }

  fetchUser({required String userId}) {
    emit(ProfileFetchLoadingStates());
    try {
      docStream = FirebaseServiceFireStore()
          .listenDocument(collection: 'users', document: userId)
          .listen((event) {
        user = UserData.fromJson(event.data() as Map<String, dynamic>);
        emit(ProfileFetchSuccessStates());
      });
    } catch (error) {
      emit(ProfileFetchFailedStates());
      rethrow;
    }
  }

  Future selectImage({required String source}) async {
    emit(ProfileUploadingStates());
    try {
      ImagePicker imagePicker = ImagePicker();
      XFile? pickedFile;
      if (source == 'gallery') {
        pickedFile = await imagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 80);
      } else {
        pickedFile = await imagePicker.pickImage(
            source: ImageSource.camera, imageQuality: 80);
      }
      if (pickedFile == null) {
        emit(ProfileInitialStates());
        return;
      }
      File imageFile = File(pickedFile.path);
      String fileName = FirebaseAuth.instance.currentUser!.uid;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("Users/")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(fileName);
      await storageRef.putFile(imageFile);
      await storageRef.getDownloadURL().then((value) async {
        await FirebaseServiceFireStore().updateDocument('users',
            FirebaseAuth.instance.currentUser!.uid, {'profilePic': value});
        await FirebaseServiceRealTime.updateField(
            uId: FirebaseAuth.instance.currentUser!.uid,
            data: {
              '${FirebaseAuth.instance.currentUser!.uid}/profilePic': value
            }).then((value) => emit(ProfileUploadingSuccessStates()));
      });
    } catch (e) {
      emit(ProfileUploadingFailedStates());
      rethrow;
    }
  }

  Future updateName({required String name}) async {
    emit(ProfileUpdateNameLoadingStates());
    try {
      await FirebaseServiceFireStore()
          .updateDocument(
              'users', FirebaseAuth.instance.currentUser!.uid, {'name': name})
          .then((value) => emit(ProfileUpdateNameSuccessStates()))
          .then((value) async {
            await FirebaseServiceRealTime.updateField(
                uId: FirebaseAuth.instance.currentUser!.uid,
                data: {'${FirebaseAuth.instance.currentUser!.uid}/name': name});
          });
    } catch (error) {
      emit(ProfileUpdateNameFailedStates());
      rethrow;
    }
  }

  Future updateEmail({required String email, required String password}) async {
    emit(ProfileUpdateEmailLoadingStates());
    try {
      await FirebaseServiceAuth.logIn(
              FirebaseServiceAuth.getUser()!.email!, password)
          .then((value) async {
        await FirebaseAuth.instance.currentUser!
            .updateEmail(email)
            .then((value) async {
          await FirebaseServiceFireStore()
              .updateDocument('users', FirebaseAuth.instance.currentUser!.uid,
                  {'email': email})
              .then((value) => emit(ProfileUpdateEmailSuccessStates()))
              .then((value) async {
                await FirebaseServiceRealTime.updateField(
                    uId: FirebaseAuth.instance.currentUser!.uid,
                    data: {
                      '${FirebaseAuth.instance.currentUser!.uid}/email': email
                    });
              });
        });
      });
    } catch (error) {
      emit(ProfileUpdateEmailFailedStates());
      rethrow;
    }
  }
}
