import 'package:dependencecoping/storage/goal.dart';
import 'package:dependencecoping/storage/trigger.dart';
import 'package:dependencecoping/tools/maybe_map.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Goal>> getStaticGoals(User user) async {
  final data = await query('goal_templates').select<PostgrestList>().eq('related_addiction', 'smoking');

  if (data.isEmpty) {
    return [];
  }

  List<Goal> gs = [];

  for (var record in data) {
    final descriptions = maybeLocalized(record['v2_descriptions']);
    final titles = maybeLocalized(record['v2_titles']);

    final g = Goal(
      id: 'static/${record['id']}',
      titles: titles,
      iconName: record['icon_name'],
      relatedAddiction: record['related_addiction'],
      author: record['author'],
      links: maybeList(record['links']),
      descriptions: descriptions,
      rate: Duration(seconds: record['rate_seconds']),
    );

    gs.add(g);
  }

  return gs;
}

Future<List<Trigger>> getStaticTriggers(User user) async {
  final data = await query('trigger_templates').select<PostgrestList>().eq('related_addiction', 'smoking');

  if (data.isEmpty) {
    return [];
  }

  List<Trigger> ts = [];

  for (var record in data) {
    var labels = maybeLocalized(record['v2_labels']);

    final t = Trigger(
      id: 'static/${record['id']}',
      labels: labels,
      relatedAddiction: record['related_addiction'],
      author: record['author'],
    );

    ts.add(t);
  }

  return ts;
}

SupabaseQueryBuilder query(String name) {
  return Supabase.instance.client.from('static_$name');
}
