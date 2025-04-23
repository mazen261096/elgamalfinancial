import 'dart:io';

import 'package:moneytrack/cubit/pay/pay_states.dart';
import 'package:moneytrack/data/remote/FirebaseService/firebaseService_fireStore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/remote/dio_service_helper.dart';

class PayCubit extends Cubit<PayStates> {
  PayCubit() : super(PayInitiateState());
  bool billUploaded = false;

  String billPhoto = '';

  File? imageFile;

  sendNotificationToSpecificTopic(
      {required String topicName,
      required String notificationTitle,
      required String notificationBody,
      Map<String, dynamic> data = const {'ss': 'ss'}}) {
    final String fcmServerKey =
        'AAAAvryTNvE:APA91bGKSadCy-6c1hovrQbmaR4tV4TM80vRitUpibn-SyQCx5NDuapTuR4zX8LirPgmoApFOnIYPfe5QZV9Vx2rkZ8cibfTiUeKnBgyD9vGYQDDjPkV1asviUli-2OtNetNY4NuSGzy';
    DioServiceHelper.init(url: 'https://fcm.googleapis.com/fcm/');
    DioServiceHelper.postData(
      url: 'send',
      data: {
        "to": '/topics/$topicName',
        "priority": "high",
        "data": data,
        "notification": {
          "title": notificationTitle,
          "body": notificationBody,
        },
      },
      headers: {
        'Authorization': 'key=$fcmServerKey',
        'Content-Type': 'application/json'
      },
    );
  }

  Future<void> createTransaction(
      {required String walletName,
      required DateTime date,
      required String type,
      required String name,
      required String walletId,
      required String description,
      required int amount,
      required String category}) async {
    try {
      emit(PayCreateLoadingState());
      await FirebaseServiceFireStore().updateDocument('wallets', walletId, {
        'transactions': FieldValue.arrayUnion([
          {
            'walletName': walletName,
            'createdAt': date,
            'type': type,
            'amount': amount,
            'name': name,
            'uId': FirebaseAuth.instance.currentUser!.uid,
            'description': description,
            'category': category,
            'bill': type == 'pay' ? billPhoto : ''
          }
        ])
      }).then((value) async {
        sendNotificationToSpecificTopic(
            topicName: walletId,
            notificationTitle: walletName,
            notificationBody: 'Category : $category     amount : $amount',
            data: {
              'notificationType': 'pay',
              'walletName': walletName,
              'createdAt': date.toString(),
              'type': type,
              'amount': amount,
              'name': name,
              'uId': FirebaseAuth.instance.currentUser!.uid,
              'description': description,
              'category': category,
              'bill': type == 'pay' ? billPhoto : ''
            });

        emit(PayCreateSuccessState());
      });
    } catch (error) {
      emit(PayCreateFailedState());
      rethrow;
    }
  }

  Future selectImage({required String source}) async {
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
      if (pickedFile == null) return 'there is no image';
      imageFile = File(pickedFile.path);
      emit(PayPhotoChooseState());
    } catch (e) {
      emit(PayPhotoFailedState());
    }
  }

  Future uploadImage({required String walletId}) async {
    emit(PayPhotoLoadingState());
    String fileName = billPhoto == null
        ? '${FirebaseAuth.instance.currentUser!.uid}${DateTime.now().microsecondsSinceEpoch.toString()}'
        : billPhoto!;
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("Bills/")
        .child(walletId)
        .child(fileName);
    try {
      await storageRef.putFile(imageFile!);
      billPhoto = await storageRef.getDownloadURL();
      emit(PayPhotoSuccessState());
    } catch (e) {
      emit(PayPhotoFailedState());
      rethrow;
    }
  }
}
