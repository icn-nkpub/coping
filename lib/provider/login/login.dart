import 'dart:async';

import 'package:dependencecoping/auth/auth.dart';
import 'package:dependencecoping/storage/local.dart';
import 'package:dependencecoping/storage/profiles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
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

  Future<void> signIn(final String email, final String password) async {
    final auth = await supalogin(email, password);
    if (auth == null) {
      return;
    }

    await storeAuthInfo(auth);
    await OneSignal.shared.setExternalUserId(auth.id);

    final p = await getProfile(auth);

    emit(Profile(
      id: auth.id,
      email: auth.email ?? '',
      auth: auth,
      profile: p,
    ));
  }

  Future<void> signUp(final String email, final String password) async {
    final auth = await suparegister(email, password);
    if (auth == null) {
      return;
    }

    await OneSignal.shared.setExternalUserId(auth.id);

    await signIn(email, password);
  }

  Future<void> signOut() async {
    await clearLocalStorage();
    emit(null);
  }

  Future<void> setBreathingTime(final double breathingTime) async {
    if (state == null) {
      return;
    }

    final auth = state!.auth;

    final p = state?.profile ??
        ProfileRecord(
          firstName: '',
          secondName: '',
          breathingTime: 0,
          color: '',
          isLight: false,
        );

    p.breathingTime = breathingTime;

    await syncProfileBreathingTime(auth, breathingTime);

    emit(Profile(
      id: auth.id,
      email: auth.email ?? '',
      auth: auth,
      profile: p,
    ));
  }

  Future<void> setTheme(final String color, {final bool isLight = false}) async {
    if (state == null) {
      return;
    }

    final auth = state!.auth;

    final p = state?.profile ??
        ProfileRecord(
          firstName: '',
          secondName: '',
          breathingTime: 0,
          color: '',
          isLight: false,
        );

    p.color = color;
    p.isLight = isLight;

    await syncProfileTheme(auth, color, isLight: isLight);

    emit(Profile(
      id: auth.id,
      email: auth.email ?? '',
      auth: auth,
      profile: p,
    ));
  }

  Future<void> saveProfile(
    final String firstName,
    final String secondName,
  ) async {
    if (state == null) {
      return;
    }

    final auth = state!.auth;

    final p = state?.profile ??
        ProfileRecord(
          firstName: '',
          secondName: '',
          breathingTime: 0,
          color: '',
          isLight: false,
        );
    p.firstName = firstName;
    p.secondName = secondName;

    await syncProfile(auth, p);

    emit(Profile(
      id: auth.id,
      email: auth.email ?? '',
      auth: auth,
      profile: p,
    ));
  }

  void overwrite(
    final User auth,
    final ProfileRecord? profile,
  ) {
    unawaited(OneSignal.shared.setExternalUserId(auth.id));

    emit(Profile(
      id: auth.id,
      email: auth.email ?? '',
      auth: auth,
      profile: profile,
    ));
  }
}
