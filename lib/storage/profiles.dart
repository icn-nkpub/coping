import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRecord {
  ProfileRecord({
    required this.firstName,
    required this.secondName,
    required this.email,
    required this.breathingTime,
  });

  String firstName;
  String secondName;
  String email;
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
    email: record["email"],
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
      "email": p.email,
      "breathing_time": p.breathingTime,
    });
    return;
  }

  await query().upsert({
    "first_name": p.firstName,
    "second_name": p.secondName,
    "email": p.email,
    "breathing_time": p.breathingTime,
  }).eq("user_id", user.id);
}

SupabaseQueryBuilder query() {
  return Supabase.instance.client.from("profiles");
}
