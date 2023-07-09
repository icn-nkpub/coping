// ignore_for_file: avoid_print

import 'dart:io';

// dart run ./_load.dart

void main() {
  const style = 'wght500fill1';
  print('starting');

  Directory dir = Directory('.');
  dir.list(recursive: false).forEach((f) {
    if (f.path.endsWith(".svg")) {
      var t = f.path.substring(2, f.path.length - 4);
      print('loading $t');
      loadIcon(t, style);
    }
  });
}

void loadIcon(String icon, String style) async {
  final url = 'https://fonts.gstatic.com/s/i/short-term/release/materialsymbolsoutlined/$icon/$style/48px.svg';

  final request = await HttpClient().getUrl(Uri.parse(url));
  final response = await request.close();
  response.pipe(File('$icon.svg').openWrite());
}
