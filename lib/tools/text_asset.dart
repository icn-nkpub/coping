import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget markdownAsset(final BuildContext context, final String path) {
  String data = '';

  return StatefulBuilder(builder: (final BuildContext context, final StateSetter setState) {
    if (data == '') {
      unawaited(rootBundle.loadString(path).then((final v) => setState(() => data = v)));
    }

    return MarkdownBody(data: data);
  });
}

class MarkdownManual extends StatelessWidget {
  const MarkdownManual({
    required this.section,
    required this.fragment,
    super.key,
  });

  final String section;
  final String fragment;

  @override
  Widget build(final BuildContext context) => markdownAsset(context, AppLocalizations.of(context)!.helpManuals(fragment, section));
}
