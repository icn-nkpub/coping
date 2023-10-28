import 'dart:math';
import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/pages/copeai/data.dart';
import 'package:dependencecoping/tokens/icons.dart';
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
    final Map<String, List<String>> b = {};
    final lc = Localizations.localeOf(context).languageCode;
    b[Assets.guy.smart] = nos[lc] ?? [];
    b[Assets.guy.positive] = cheers[lc] ?? [];

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

  final Map<String, List<String>> b;

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
  Widget build(final BuildContext context) {
    final List<Widget> children = [];

    for (final e in widget.b.entries) {
      children.add(
        IconButton.outlined(
          onPressed: () {
            setState(() {
              messages.add(Message()
                ..prompt = e.key
                ..message = e.value[r.nextInt(e.value.length)]);
            });
          },
          icon: SvgIcon(
            e.key,
            sizeOffset: -22,
          ),
        ),
      );
    }

    return Column(
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
                            child: SvgIcon(
                              e.prompt,
                              sizeOffset: -22,
                            ),
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
            children: children,
          ),
        ),
      ],
    );
  }
}

class Typer extends StatefulWidget {
  const Typer(
    this.data, {
    super.key,
    this.textAlign,
    this.style,
  });

  final String data;
  final TextAlign? textAlign;
  final TextStyle? style;

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
            textAlign: widget.textAlign ?? TextAlign.start,
            text: TextSpan(
              style: widget.style,
              text: widget.data.substring(
                0,
                (widget.data.length * _controller.value).round(),
              ),
              children: [if (_controller.value < 1) const TextSpan(text: '')],
            ),
          ));
}
