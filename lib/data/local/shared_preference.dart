import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static Future<Map> fetchSavedShared(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data = json.decode(prefs.getString(key)!) as Map<String, dynamic>;
    return data;
  }

  static saveShared(Map<String, dynamic> data, String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonfile = jsonEncode(data);
    await prefs.setString(key, jsonfile);
  }

  static deleteShared(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static isSharedSaved(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(key)) {
      return false;
    } else {
      return true;
    }
  }

  static clearShared() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    return value;
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}
