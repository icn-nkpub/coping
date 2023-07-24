import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<User?> restoreAuthInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final String? stored = prefs.getString('v1/auth');
  if (stored == null) {
    return null;
  }

  final auth = User.fromJson(jsonDecode(stored));

  return auth;
}

Future<void> storeAuthInfo(final User auth) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('v1/auth', jsonEncode(auth.toJson()));
}

Future<void> clearLocalStorage() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
