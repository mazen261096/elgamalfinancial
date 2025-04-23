import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServiceAuth {
  static Future<UserCredential> logIn(String email, String password) async {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<UserCredential> phoneLogIn(AuthCredential credential) async {
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<void> updateNumber(PhoneAuthCredential credential) async {
    return FirebaseAuth.instance.currentUser!.updatePhoneNumber(credential);
  }

  static Future<UserCredential> register(String email, String password) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  static User? getUser() {
    return FirebaseAuth.instance.currentUser;
  }

  // delete user
  static Future<void> deleteUser() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<bool> isConnected() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      return FirebaseAuth.instance.currentUser != null;
    } catch (error) {
      return false;
    }
  }
}
