import 'package:dependencecoping/storage/trigger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> logTrigger(User user, Trigger t, String situation, String thought, int impulse) async {
  await query().insert({
    'user_id': user.id,
    'meta_id': t.id,
    'addiction_type': t.relatedAddiction,
    'label': t.label,
    'situation': situation,
    'thought': thought,
    'impulse': impulse,
  });
}

class TriggerLog {
  const TriggerLog({
    required this.label,
    required this.situation,
    required this.thought,
    required this.impulse,
    required this.time,
  });

  final String label;
  final String situation;
  final String thought;
  final int impulse;
  final DateTime time;
}

Future<List<TriggerLog>> getTriggersLog(User user, String type) async {
  var data = await query().select<PostgrestList>().eq('user_id', user.id).eq('addiction_type', type);

  List<TriggerLog> result = [];
  for (var r in data) {
    result.add(TriggerLog(
      label: r['label'],
      situation: r['situation'],
      thought: r['thought'],
      impulse: int.parse(r['impulse'].toString()),
      time: DateTime.parse(r['created_at']).toLocal(),
    ));
  }

  return result;
}

SupabaseQueryBuilder query() {
  return Supabase.instance.client.from('trigger_logs');
}
