import 'dart:convert';

Map<String, dynamic> maybeMap(dynamic d) {
  if (d.runtimeType == String) {
    return jsonDecode(d);
  }

  return d;
}

List<String> maybeList(dynamic d) {
  if (d == null) return [];

  if (d.runtimeType == String) {
    return jsonDecode(d);
  }

  if (d.runtimeType == List<dynamic>) {
    List<dynamic> l = d;
    return l.map((e) => e.toString()).toList();
  }

  return d;
}
