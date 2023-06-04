import 'package:cloudcircle/storage/goal.dart';
import 'package:cloudcircle/tools/maybe_map.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Goal>> getStaticGoals(User user) async {
  final data = await query('goal_templates').select<PostgrestList>().eq('related_addiction', 'smoking');

  if (data.isEmpty) {
    return [];
  }

  List<Goal> gs = [];

  for (var record in data) {
    Map<String, dynamic> rawDescriptions = maybeMap(record['descriptions']);
    Map<double, String> descriptions = {};

    for (var d in rawDescriptions.entries) {
      descriptions[double.parse(d.key)] = d.value;
    }

    final g = Goal(
      id: 'static/${record['id']}',
      title: record['title'],
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

SupabaseQueryBuilder query(String name) {
  return Supabase.instance.client.from('static_$name');
}
