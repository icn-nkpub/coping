import 'package:supabase_flutter/supabase_flutter.dart';

class CountdownReset {
  const CountdownReset({
    required this.resetTime,
    required this.resumeTime,
  });

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
      resetTime: DateTime.parse(record['reset_time']).toLocal(),
      resumeTime: resume,
    );

    crs.add(cr);
  }

  return crs;
}

Future<void> logCountdownResume(User user, String type, DateTime time) async {
  final data = await query().select<PostgrestList>().eq('user_id', user.id).eq('addiction_type', type).is_('resume_time', null);

  if (data.isEmpty) {
    return;
  }

  await query()
      .update({
        'id': data[0]['id'],
        'user_id': user.id,
        'resume_time': time.toUtc().toIso8601String(),
      })
      .eq('user_id', user.id)
      .eq('id', data[0]['id']);

  return;
}

Future<void> logCountdownReset(User user, String type, DateTime time) async {
  await query().insert({
    'user_id': user.id,
    'reset_time': time.toUtc().toIso8601String(),
    'addiction_type': type,
  });
  return;
}

SupabaseQueryBuilder query() {
  return Supabase.instance.client.from('addiction_reset_log');
}
