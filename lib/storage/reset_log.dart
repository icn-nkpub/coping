import 'package:supabase_flutter/supabase_flutter.dart';

class CountdownReset {
  const CountdownReset({
    required this.id,
    required this.resetTime,
    required this.resumeTime,
  });

  final int id; // id
  final DateTime resetTime; // reset_time
  final DateTime? resumeTime; // resume_time

  int compareTo(CountdownReset other) {
    final art = resumeTime;
    final brt = other.resumeTime;

    if (art == null && brt == null) {
      return resetTime.compareTo(other.resetTime);
    }

    if (art == null) {
      return 1;
    }
    if (brt == null) {
      return -1;
    }

    return art.compareTo(brt);
  }
}

Future<List<CountdownReset>> getCountdownResets(User user, String type) async {
  final data = await query().select<PostgrestList>().eq('user_id', user.id).eq('addiction_type', type);

  if (data.isEmpty) {
    return [];
  }

  List<CountdownReset> crs = [];

  for (var record in data) {
    var resume = DateTime.tryParse(record['resume_time'] ?? '');
    if (resume != null) resume = resume.toLocal();

    final cr = CountdownReset(
      id: record['id'],
      resetTime: DateTime.parse(record['reset_time']).toLocal(),
      resumeTime: resume,
    );

    crs.add(cr);
  }

  return crs;
}

Future<int> logCountdownResume(User user, String type, DateTime time) async {
  final data = await query().select<PostgrestList>().eq('user_id', user.id).eq('addiction_type', type).is_('resume_time', null);

  if (data.isEmpty) {
    var d = await query().insert({
      'user_id': user.id,
      'reset_time': time.toUtc().toIso8601String(),
      'resume_time': time.toUtc().toIso8601String(),
      'addiction_type': type,
    }).select("id");

    return int.parse(d[0]['id'].toString());
  }

  await query()
      .update({
        'id': data[0]['id'],
        'user_id': user.id,
        'resume_time': time.toUtc().toIso8601String(),
      })
      .eq('user_id', user.id)
      .eq('id', data[0]['id']);

  return int.parse(data[0]['id'].toString());
}

Future<int> logCountdownReset(User user, String type, DateTime time) async {
  var d = await query().insert({
    'user_id': user.id,
    'reset_time': time.toUtc().toIso8601String(),
    'addiction_type': type,
  }).select('id');

  return int.parse(d[0]['id'].toString());
}

Future<void> editCountdownReset(User user, int id, DateTime time) async {
  await query()
      .update({
        'id': id,
        'user_id': user.id,
        'reset_time': time.toUtc().toIso8601String(),
      })
      .eq('user_id', user.id)
      .eq('id', id);

  return;
}

Future<void> editCountdownResume(User user, int id, DateTime time) async {
  await query()
      .update({
        'id': id,
        'user_id': user.id,
        'resume_time': time.toUtc().toIso8601String(),
      })
      .eq('user_id', user.id)
      .eq('id', id);

  return;
}

SupabaseQueryBuilder query() {
  return Supabase.instance.client.from('addiction_reset_log');
}
