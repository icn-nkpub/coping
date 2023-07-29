import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/modals/help_pages/face.dart';
import 'package:dependencecoping/pages/clock/countdown.dart';
import 'package:flutter/material.dart';

class IntroHelpPage extends StatelessWidget {
  const IntroHelpPage({
    required this.t,
    required this.s,
    super.key,
  });

  final ThemeData t;
  final double s;

  @override
  Widget build(final BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Guy(t: t, s: s, text: 'Clock', face: Assets.guy.neutral),
        const SizedBox(height: 16),
        Stopwatch(
          from: DateTime.now(),
          frozen: !true,
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('hellop'),
        ),
      ],
    );
}
