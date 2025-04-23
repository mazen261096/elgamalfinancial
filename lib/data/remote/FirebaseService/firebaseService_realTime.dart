import 'package:moneytrack/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseServiceRealTime {
  static final dbRef = FirebaseDatabase.instance.ref().child('users');

  static Future<void> setUser(
      {required String uId, required Map<String, dynamic> data}) async {
    await dbRef.child(uId).set(data);
  }

  static Future<void> updateField(
      {required String uId, required Map<String, dynamic> data}) async {
    await dbRef.update(data);
  }

  static Future<UserData> getUser({required String number}) async {
    DataSnapshot d =
        await dbRef.orderByChild('phoneNumber').equalTo(number).get();
    print(d.value);
    var data = d.value as Map;
    Map user = Map<String, dynamic>.from(data.values.first);
    user['wallets'] = [];
    return UserData.fromJson(user as Map<String, dynamic>);
  }

  static Future<bool> userExist({required String number}) async {
    DataSnapshot d =
        await dbRef.orderByChild('phoneNumber').equalTo(number).get();
    return d.exists;
  }
}
