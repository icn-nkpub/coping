import 'dart:convert';

import 'package:cloudcircle/tools/maybe_map.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Goal {
  Goal({
    required this.id,
    required this.title,
    required this.iconName,
    required this.relatedAddiction,
    required this.author,
    required this.links,
    required this.descriptions,
    required this.rate,
  });

  String id;
  String title; // title
  String iconName; // icon_name
  String relatedAddiction; // related_addiction
  String author; // author
  List<String> links; // links
  Map<double, String> descriptions; // descriptions
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
      'title': g.title,
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
    Map<String, dynamic> rawDescriptions = maybeMap(record['descriptions']);
    Map<double, String> descriptions = {};

    for (var d in rawDescriptions.entries) {
      descriptions[double.parse(d.key)] = d.value;
    }

    final g = Goal(
      id: record['meta_id'],
      title: record['title'],
      iconName: record['icon_name'],
      relatedAddiction: record['related_addiction'],
      author: record['author'],
      links: maybeList(record['links']) ,
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
