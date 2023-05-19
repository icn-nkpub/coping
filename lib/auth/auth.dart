import 'package:supabase_flutter/supabase_flutter.dart';

Future<User?> supalogin(String email, String password) async {
  final db = Supabase.instance.client;

  final AuthResponse res = await db.auth.signInWithPassword(
    email: email,
    password: password,
  );

  return res.user;
}

Future<User?> suparegister(String email, String password) async {
  final db = Supabase.instance.client;

  final AuthResponse res = await db.auth.signUp(
    email: email,
    password: password,
  );

  return res.user;
}
