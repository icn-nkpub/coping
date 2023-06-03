import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRecord {
  ProfileRecord({
    required this.firstName,
    required this.secondName,
    required this.breathingTime,
    required this.noAddictionTime,
    required this.color,
    required this.isLight,
  });

  String firstName;
  String secondName;
  double breathingTime;
  DateTime noAddictionTime;
  String? color;
  bool? isLight;
}

Future<ProfileRecord?> getProfile(User user) async {
  final data = await query().select<PostgrestList>().eq(
        'user_id',
        user.id,
      );

  if (data.isEmpty) {
    return null;
  }

  final record = data[0];
  var breathingTime = double.parse((record['breathing_time'] ?? '6').toString());
  if (breathingTime < 3 || breathingTime > 32) breathingTime = 6;

  Map<String, dynamic> themeData = jsonDecode(record['theme'] ?? '{}');

  return ProfileRecord(
    firstName: record['first_name'] ?? '',
    secondName: record['second_name'] ?? '',
    breathingTime: breathingTime,
    noAddictionTime: DateTime.parse(record['no_addiction_time'] ?? DateTime.now().toIso8601String()),
    color: themeData['color'],
    isLight: themeData['is_light'],
  );
}

Future<void> syncProfile(User user, ProfileRecord p) async {
  final data = await query().select<PostgrestList>().eq(
        'user_id',
        user.id,
      );

  if (data.isEmpty) {
    await query().insert({
      'user_id': user.id,
      'first_name': p.firstName,
      'second_name': p.secondName,
    });
    return;
  }

  await query().update({
    'user_id': user.id,
    'first_name': p.firstName,
    'second_name': p.secondName,
  }).eq('user_id', user.id);
}

Future<void> syncProfileBreathingTime(User user, double breathingTime) async {
  final data = await query().select<PostgrestList>().eq(
        'user_id',
        user.id,
      );

  if (data.isEmpty) {
    await query().insert({
      'user_id': user.id,
      'breathing_time': breathingTime,
    });
    return;
  }

  await query().update({
    'user_id': user.id,
    'breathing_time': breathingTime,
  }).eq('user_id', user.id);
}

Future<void> syncProfileTheme(User user, String color, bool isLight) async {
  final data = await query().select<PostgrestList>().eq(
        'user_id',
        user.id,
      );

  final String theme = jsonEncode({
    'color': color,
    'is_light': isLight,
  });

  if (data.isEmpty) {
    await query().insert({
      'user_id': user.id,
      'theme': theme,
    });
    return;
  }

  await query().update({
    'user_id': user.id,
    'theme': theme,
  }).eq('user_id', user.id);
}

Future<void> logAddictionReset(User user, String type, DateTime time) async {
  await Supabase.instance.client.from('addiction_reset_log').insert({
    'user_id': user.id,
    'reset_time': time.toIso8601String(),
    'addiction_type': type,
  });
  return;
}

SupabaseQueryBuilder query() {
  return Supabase.instance.client.from('profiles');
}
