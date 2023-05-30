import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<User?> restoreAuthInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String? stored = prefs.getString('v1/auth');
  if (stored == null) {
    return null;
  }

  var auth = User.fromJson(jsonDecode(stored));

  return auth;
}

storeAuthInfo(User auth) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('v1/auth', jsonEncode(auth.toJson()));
}
