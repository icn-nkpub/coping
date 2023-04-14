import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:math';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';

class CanvasDrawer extends Funvas {
  CanvasDrawer({
    required this.fullCycleDuration,
    required this.scale,
    required this.slideDist,
    required this.rounds,
    required this.color,
  });

  final int fullCycleDuration;
  final double scale;
  final double slideDist;
  final int rounds;
  final HSLColor color;

  @override
  void u(double t) {
    double cycle = graph(t);

    final w = x.width / 2;
    final h = x.height / 2;
    final s = x.width < x.height ? x.width : x.height;
    final pt = (s * scale) / 64;

    final slide = slideDist * pt - (cycle * (slideDist * pt));

    for (int round = 0; round < rounds; round++) {
      final rCycle = round / rounds;
      final r = (5 * pt) + (((cycle * 2) + 1) * rCycle * 16 * pt) / 3;

      final angleSkew = (13 + (t / 30)) * ((round + 1) * 15);

      final alpha = (round / rounds);

      for (double i = 0; i < 360; i += 360 / ((rounds + (round * 4)))) {
        final iCycle = ((1 + sin((pow(i + 1, 2) * (round + 1)) + t * 2)) / 2);
        final v = iCycle * pt / 5;

        final angle = i + angleSkew;

        var lr = r + (v * 8);

        var x1 = lr * cos(angle * pi / 180);
        var y1 = lr * sin(angle * pi / 180);
        y1 = y1 - slide;
        c.drawCircle(
          Offset(w + x1, h - y1),
          v,
          Paint()..color = color.withAlpha(alpha).toColor(),
        );
      }
    }

    final paint = Paint();
    paint.color = color.toColor();
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = pt / 4;

    c.drawCircle(
      Offset(w, h + slide),
      pt,
      paint,
    );
    c.drawLine(
      Offset(w, h),
      Offset(w, h + (slideDist * pt)),
      paint..color = paint.color.withAlpha(5),
    );
  }

  double graph(double t) {
    final x = 1 - ((t % fullCycleDuration) / fullCycleDuration);

    final fnUp = bezFn(x, 3, 0);
    final fnDown = bezFn(x, -1.5, -1);

    var cycle = x < 1 / 3 ? fnUp : fnDown;
    return cycle;
  }

  double bezFn(double x, double compression, double offset) {
    final v = compression * (x + offset);

    final y = pow(v, 2) / (2 * (pow(v, 2) - v) + 1);

    return y;
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
          fullCycleDuration: 8,
          scale: 1,
          rounds: 12,
          slideDist: 16,
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
    return const Canvas();
  }
}
