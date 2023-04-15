import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRecord {
  ProfileRecord({
    required this.id,
    required this.firstName,
    required this.secondName,
    required this.email,
    required this.breathingTime,
    required this.createdAt,
  });

  int id;
  String firstName;
  String secondName;
  String email;
  double breathingTime;
  DateTime createdAt;
}

Future<ProfileRecord?> getProfile(User user) async {
  final db = Supabase.instance.client;
  final data =
      await db.from('profiles').select<PostgrestList>().eq("user_id", user.id);

  if (data.isEmpty) {
    return null;
  }

  final record = data[0];

  return ProfileRecord(
    id: record["id"],
    firstName: record["first_name"],
    secondName: record["second_name"],
    email: record["email"],
    breathingTime: double.parse(record["breathing_time"].toString()),
    createdAt: DateTime.parse(record["created_at"]),
  );
}
