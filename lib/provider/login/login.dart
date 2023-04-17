import 'package:sca6/auth/auth.dart';
import 'package:sca6/storage/profiles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Profile {
  Profile({
    required this.id,
    required this.email,
    required this.auth,
    required this.profile,
  });

  String id;
  String email;
  User auth;
  ProfileRecord? profile;
}

class LoginCubit extends Cubit<Profile?> {
  LoginCubit() : super(null);

  Future<void> signIn(String email, String password) async {
    final auth = await supalogin(email, password);
    if (auth == null) {
      return;
    }

    final p = await getProfile(auth);

    emit(Profile(
      id: auth.id,
      email: auth.email ?? "",
      auth: auth,
      profile: p,
    ));
  }

  Future<void> signOut() async {
    emit(null);
  }

  Future<void> saveProfile(
    String email,
    String firstName,
    String secondName,
    double breathingTime,
  ) async {
    if (state == null) {
      return;
    }

    final auth = state!.auth;

    final p = ProfileRecord(
      firstName: firstName,
      secondName: secondName,
      email: email,
      breathingTime: breathingTime,
    );

    syncProfile(auth, p);

    emit(Profile(
      id: auth.id,
      email: auth.email ?? "",
      auth: auth,
      profile: p,
    ));
  }
}
