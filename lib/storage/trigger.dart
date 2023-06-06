import 'package:supabase_flutter/supabase_flutter.dart';

class Trigger {
  Trigger({
    required this.id,
    required this.label,
    required this.relatedAddiction,
    this.author,
  });

  String id;
  String label; // label
  String relatedAddiction; // related_addiction
  String? author; // author
}

Future<void> syncTriggers(User user, List<Trigger> triggers) async {
  final data = await query().select<PostgrestList>().eq(
        'user_id',
        user.id,
      );

  for (var t in triggers) {
    var rec = {
      'label': t.label,
      'related_addiction': t.relatedAddiction,
    };

    var existant = data.where((element) => element['meta_id'] == t.id).firstOrNull;

    if (existant != null) {
      await query().update(rec).eq('user_id', user.id).eq('meta_id', t.id);
      continue;
    }

    rec['user_id'] = user.id;
    rec['meta_id'] = t.id;

    await query().insert(rec);
  }

  var nonExistant = data.where((src) => triggers.where((t) => src['meta_id'] == t.id).firstOrNull == null);
  for (var element in nonExistant) {
    await query().delete().eq('user_id', user.id).eq('meta_id', element['meta_id']);
  }
}

Future<List<Trigger>> getTriggers(User user) async {
  final data = await query().select<PostgrestList>().eq('related_addiction', 'smoking');

  if (data.isEmpty) {
    return [];
  }

  List<Trigger> ts = [];

  for (var record in data) {
    final t = Trigger(
      id: record['meta_id'],
      label: record['label'],
      relatedAddiction: record['related_addiction'],
    );

    ts.add(t);
  }

  return ts;
}

SupabaseQueryBuilder query() {
  return Supabase.instance.client.from('triggers');
}
