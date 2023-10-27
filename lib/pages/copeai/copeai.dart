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
  var scroll = ScrollController();
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
              controller: scroll,
              children: messages.reversed
                  .map(
                    (final e) => Card(
                      key: Key(e.hashCode.toString()),
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
                            Typer(e.message),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Wrap(
                spacing: 8,
                children: widget.b.map(
                  (final e) {
                    final p = e['p']!;
                    final kp = r.nextInt(p.length);

                    return OutlinedButton(
                      onPressed: () {
                        final a = e['a']!;

                        setState(() {
                          messages.add(Message()
                            ..prompt = p[kp]
                            ..message = a[r.nextInt(a.length)]);
                        });
                      },
                      child: Text(
                        p[kp],
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    );
                  },
                ).toList()),
          ),
        ],
      );
}

class Typer extends StatefulWidget {
  const Typer(
    this.data, {
    super.key,
  });

  final String data;

  @override
  State<Typer> createState() => _TyperState();
}

class _TyperState extends State<Typer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.data.length * 33),
      vsync: this,
    );
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => AnimatedBuilder(
      animation: _controller,
      builder: (final BuildContext context, final Widget? child) => RichText(
            text: TextSpan(
              text: widget.data.substring(
                0,
                (widget.data.length * _controller.value).round(),
              ),
              children: [if (_controller.value < 1) TextSpan(text: " -")],
            ),
          ));
}
