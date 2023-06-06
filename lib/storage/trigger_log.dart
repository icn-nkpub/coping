import 'package:cloudcircle/storage/trigger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> logTrigger(User user, Trigger t) async {
  await query().insert({
    'user_id': user.id,
    'meta_id': t.id,
  });
}

SupabaseQueryBuilder query() {
  return Supabase.instance.client.from('trigger_logs');
}
