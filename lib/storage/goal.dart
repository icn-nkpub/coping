import 'dart:convert';

import 'package:dependencecoping/tools/maybe_map.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Goal {
  Goal({
    required this.id,
    required this.titles,
    required this.iconName,
    required this.relatedAddiction,
    required this.author,
    required this.links,
    required this.descriptions,
    required this.rate,
  });

  String id;
  Map<String, String> titles; // title
  String iconName; // icon_name
  String relatedAddiction; // related_addiction
  String author; // author
  List<String> links; // links
  Map<String, String> descriptions; // descriptions
  Duration rate; // rate_ms
}

Future<void> syncGoals(User user, List<Goal> goals) async {
  final data = await query().select<PostgrestList>().eq(
        'user_id',
        user.id,
      );

  for (var g in goals) {
    Map<String, String> ds = {};
    for (var d in g.descriptions.entries) {
      ds[d.key.toString()] = d.value;
    }

    var rec = {
      'title': g.titles,
      'icon_name': g.iconName,
      'related_addiction': g.relatedAddiction,
      'author': g.author,
      'links': g.links,
      'descriptions': jsonEncode(ds),
      'rate_seconds': g.rate.inSeconds,
    };

    var existant = data.where((element) => element['meta_id'] == g.id).firstOrNull;

    if (existant != null) {
      await query().update(rec).eq('user_id', user.id).eq('meta_id', g.id);
      continue;
    }

    rec['user_id'] = user.id;
    rec['meta_id'] = g.id;

    await query().insert(rec);
  }

  var nonExistant = data.where((src) => goals.where((g) => src['meta_id'] == g.id).firstOrNull == null);
  for (var element in nonExistant) {
    await query().delete().eq('user_id', user.id).eq('meta_id', element['meta_id']);
  }
}

Future<List<Goal>> getGoals(User user) async {
  final data = await query().select<PostgrestList>().eq('related_addiction', 'smoking');

  if (data.isEmpty) {
    return [];
  }

  List<Goal> gs = [];

  for (var record in data) {
    final descriptions = maybeLocalized(record['descriptions']);
    final titles = maybeLocalized(record['title']);

    final g = Goal(
      id: record['meta_id'],
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

SupabaseQueryBuilder query() {
  return Supabase.instance.client.from('goals');
}
