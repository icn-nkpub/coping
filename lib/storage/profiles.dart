import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRecord {
  ProfileRecord({
    required this.firstName,
    required this.secondName,
    required this.breathingTime,
  });

  String firstName;
  String secondName;
  double breathingTime;
}

Future<ProfileRecord?> getProfile(User user) async {
  final data = await query().select<PostgrestList>().eq(
        "user_id",
        user.id,
      );

  if (data.isEmpty) {
    return null;
  }

  final record = data[0];

  return ProfileRecord(
    firstName: record["first_name"],
    secondName: record["second_name"],
    breathingTime: double.parse(record["breathing_time"].toString()),
  );
}

Future<void> syncProfile(User user, ProfileRecord p) async {
  final data = await query().select<PostgrestList>().eq(
        "user_id",
        user.id,
      );

  if (data.isEmpty) {
    await query().insert({
      "user_id": user.id,
      "first_name": p.firstName,
      "second_name": p.secondName,
      "breathing_time": p.breathingTime,
    });
    return;
  }

  await query().update({
    "user_id": user.id,
    "first_name": p.firstName,
    "second_name": p.secondName,
    "breathing_time": p.breathingTime,
  }).eq("user_id", user.id);
}

Future<void> syncProfileBreathingTime(User user, double breathingTime) async {
  final data = await query().select<PostgrestList>().eq(
        "user_id",
        user.id,
      );

  if (data.isEmpty) {
    await query().insert({
      "user_id": user.id,
      "breathing_time": breathingTime,
    });
    return;
  }

  await query().update({
    "user_id": user.id,
    "breathing_time": breathingTime,
  }).eq("user_id", user.id);
}

SupabaseQueryBuilder query() {
  return Supabase.instance.client.from("profiles");
}
