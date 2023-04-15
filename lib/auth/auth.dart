import 'package:supabase_flutter/supabase_flutter.dart';

Future<User?> login(String email, String password) async {
  final db = Supabase.instance.client;

  final AuthResponse res = await db.auth.signInWithPassword(
    email: email,
    password: password,
  );
  final Session? session = res.session;
  final User? user = res.user;

  print(session);
  print(user);

  return user;
}
