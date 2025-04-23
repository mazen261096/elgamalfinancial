import 'dart:async';

import 'package:moneytrack/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/local/shared_preference.dart';
import '../data/remote/FirebaseService/firebaseService_fireStore.dart';

class AppPreferences {
  AppPreferences._internal();

  static final AppPreferences _instance =
      AppPreferences._internal(); // singleton or single instance

  factory AppPreferences() => _instance;

  static late User user;
  static late UserData userData;
  static StreamSubscription<QuerySnapshot<Object?>>? walletSub;

  static StreamSubscription<DocumentSnapshot<Object?>>? userDataSub;
  static bool notification = true;

  static Future<void> notificationStatue() async {
    bool exist = await SharedPreference.isSharedSaved('notification');
    if (!exist) {
      notification = true;
    } else {
      String? statue = await SharedPreference.getString('notification');
      if (statue == 'false') {
        notification = false;
      } else {
        notification = true;
      }
    }
  }

  static Future<void> changeLocaleNotificationStatue(String statue) async {
    await SharedPreference.setString('notification', statue);
  }

  static Future<void> getUserData() async {
    await FirebaseServiceFireStore.readDocument(
            collection: 'users', document: user.uid)
        .then((value) {
      userData = UserData.fromJson(value.data() as Map<String, dynamic>);
    });
  }
}
