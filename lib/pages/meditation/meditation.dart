import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:math';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';

class CanvasDrawer extends Funvas {
  CanvasDrawer({
    this.fullCycleDuration = 6,
    this.particlesDivider = 15,
    this.size = 3.4,
    this.slide = 4,
    this.rounds = 9,
    required this.color,
  });

  final int fullCycleDuration;
  final int particlesDivider;
  final double size;
  final double slide;
  final int rounds;
  final HSLColor color;

  @override
  void u(double t) {
    var w = x.width / 2;
    var h = x.height / 2;
    var s = x.width < x.height ? x.width : x.height;

    var metaClock = (t % fullCycleDuration) / fullCycleDuration;
    var windup = metaClock;
    var winddown = (1 / 2) - (metaClock / 2);
    var cycle = windup < winddown ? windup : winddown;

    cycle = cycle * 3;

    for (var round = 0; round < rounds; round++) {
      var r = (s / size) - ((round + 1) * (s / 50)) + ((s / 10) * cycle);
      var angleSkew = (t * 5) + (round * (particlesDivider / 2.5));
      var alpha = round / (rounds / 1.5);

      for (var i = 0; i < 360; i += particlesDivider) {
        final angle = i + angleSkew;
        final x1 = r * cos(angle * pi / 180);
        final y1 = r * sin(angle * pi / 180);
        final v = (1 + sin(4 * t + (i * i * round))) * (size * size / 2);
        c.drawCircle(
          Offset(w + x1, h + -y1 + (cycle * (s / size / slide))),
          (size / (s / 100)) + (v / particlesDivider),
          Paint()..color = color.withAlpha(alpha > 1 ? 1 : alpha).toColor(),
        );
      }
    }

    final paint = Paint();
    paint.color = color.toColor();
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = s / (360 / particlesDivider) / 24;

    c.drawCircle(
      Offset(w, h + (cycle * (s / size / slide))),
      s / (360 / particlesDivider) / slide,
      paint,
    );
    c.drawLine(
      Offset(w, h),
      Offset(w, h + (1 * (s / size / slide))),
      paint..color = paint.color.withAlpha(50),
    );
  }
}

class Canvas extends StatelessWidget {
  const Canvas({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: FunvasContainer(
        funvas: CanvasDrawer(
          color: HSLColor.fromColor(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  @override
  Widget build(BuildContext context) {
    return Canvas();
  }
}
