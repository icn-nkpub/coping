import 'dart:math';
import 'package:dependencecoping/pages/copeai/data.dart';
import 'package:dependencecoping/tokens/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final _random = Random(DateTime.now().microsecondsSinceEpoch);

class CopeScreen extends StatelessWidget {
  const CopeScreen({
    required this.setPage,
    super.key,
  });

  final void Function(int) setPage;

  @override
  Widget build(final BuildContext context) {
    final b = brain[Localizations.localeOf(context).languageCode] ?? [];

    return Column(
      children: [
        TopBar(
          setPage: setPage,
          subTitle: AppLocalizations.of(context)!.screenAssistant,
        ),
        Expanded(
          child: Messanger(b: b),
        ),
      ],
    );
  }
}

class Message {
  String prompt = '';
  String message = '';
}

class Messanger extends StatefulWidget {
  const Messanger({
    required this.b,
    super.key,
  });

  final List<Map<String, List<String>>> b;

  @override
  State<Messanger> createState() => _MessangerState();
}

class _MessangerState extends State<Messanger> {
  List<Message> messages = [];
  late final Random r;

  @override
  void initState() {
    r = Random(_random.nextInt(1 << 32));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          Expanded(
            child: ListView(
              reverse: true,
              children: messages
                  .map(
                    (final e) => Card(
                      margin: const EdgeInsets.all(16),
                      elevation: 2,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Opacity(
                              opacity: .5,
                              child: Text('— ${e.prompt}'),
                            ),
                            Text(e.message),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
                children: widget.b.map(
              (final e) {
                final p = e['p']!;
                final kp = r.nextInt(p.length);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: OutlinedButton(
                      onPressed: () {
                        final a = e['a']!;

                        setState(() {
                          messages.insert(
                              0,
                              Message()
                                ..prompt = p[kp]
                                ..message = a[r.nextInt(a.length)]);
                        });
                      },
                      child: Text(
                        p[kp],
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                );
              },
            ).toList()),
          ),
        ],
      );
}
