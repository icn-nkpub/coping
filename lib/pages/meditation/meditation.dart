import 'dart:math';
import 'dart:core';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:flutter/material.dart';
import 'package:funvas/funvas.dart';
import 'package:dependencecoping/tokens/measurable.dart';
import 'package:dependencecoping/tokens/topbar.dart';

class CanvasDrawer extends Funvas {
  CanvasDrawer({
    required this.color,
    required this.fullCycleDuration,
    required this.scale,
    required this.slideDist,
    required this.rounds,
    this.muted = false,
  });
  HSLColor color;
  final double fullCycleDuration;
  final double scale;
  final double slideDist;
  final int rounds;
  bool windDown = false;
  double windDownTime = -1;
  final bool muted;

  @override
  void u(double t) {
    if (muted) t += fullCycleDuration;
    if (!muted) t = max(0, t - 1);

    final w = x.width / 2;
    final h = x.height / 2;
    final s = x.width < x.height ? x.width : x.height;
    final pt = (s * scale) / 64;

    if (!muted) _drawGuideLine(color, pt, w, h);

    if (windDownTime > -1) {
      double cycle = graph(windDownTime);
      cycle = max(0, cycle - (t - windDownTime));
      final slide = slideDist * pt - (cycle * (slideDist * pt));

      _drawCircle(color, pt, w, h, slide);
      _drawParticles(color, pt, w, h, cycle, t, slide);

      return;
    }
    if (windDown) {
      windDownTime = t;
    }

    final double cycle = graph(t);
    final slide = slideDist * pt - (cycle * (slideDist * pt));

    if (!muted) _drawCircle(color, pt, w, h, slide);
    _drawParticles(color, pt, w, h, cycle, t, slide);
  }

  void _drawParticles(HSLColor color, double pt, double w, double h, double cycle, double t, double slide) {
    for (int round = 0; round < rounds; round++) {
      final rCycle = round / rounds;
      final r = (4 * pt) + ((((muted ? 0 : cycle) * 3.85) + 1) * rCycle * 16 * pt) / 3;

      final angleSkew = (13.1 + (t / 31)) * ((round + 1) * 14);

      double alpha = min(max((t / fullCycleDuration) - .25, 0), (round / rounds));

      if (windDownTime > -1) {
        alpha = max(0, alpha - (t - windDownTime));
      }

      for (double i = 0; i < 360; i += 360 / (rounds + (round * 4))) {
        final iCycle = ((1 + sin((pow(i + 1, 2) * (round + 1)) + t * 2)) / 2);
        final v = iCycle * pt / 5;

        final angle = (i + 1) * (pi / 2) + angleSkew;

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
  }

  void _drawGuideLine(HSLColor color, double pt, double w, double h) {
    final pointPaint = Paint();
    pointPaint.color = color.toColor().withAlpha(25);
    pointPaint.strokeCap = StrokeCap.round;
    pointPaint.strokeWidth = pt / 4;
    c.drawLine(
      Offset(w, h),
      Offset(w, h + (slideDist * pt)),
      pointPaint,
    );
  }

  void _drawCircle(HSLColor color, double pt, double w, double h, double slide) {
    final circlePaint = Paint();
    circlePaint.color = color.toColor();
    circlePaint.strokeCap = StrokeCap.round;
    circlePaint.strokeWidth = pt / 4;
    c.drawCircle(
      Offset(w, h + slide),
      pt,
      circlePaint,
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

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
      final breathingTime = u?.profile?.breathingTime ?? 6.0;

      var cd = CanvasDrawer(
        color: HSLColor.fromColor(Theme.of(context).colorScheme.primary),
        fullCycleDuration: breathingTime,
        scale: 1.3,
        rounds: 12,
        slideDist: 12,
      );
      return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: FunvasContainer(
              funvas: cd,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: InfoCard(
              speed: breathingTime,
              setSpeed: (s) {
                Future.delayed(const Duration(seconds: 1), () {
                  context.read<LoginCubit>().setBreathingTime(s);
                });
              },
              changingSpeed: () {
                cd.windDown = true;
              },
            ),
          )
        ],
      );
    });
  }
}

class InfoCard extends StatefulWidget {
  const InfoCard({
    super.key,
    required this.speed,
    required this.setSpeed,
    required this.changingSpeed,
  });

  final double speed;
  final Function(double) setSpeed;
  final Function() changingSpeed;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  double _speed = 6;
  bool _expandInfo = false;

  @override
  void initState() {
    _speed = widget.speed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      verticalDirection: VerticalDirection.up,
      children: [
        const Expanded(child: SizedBox()),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: IconButton.filledTonal(
            onPressed: () {
              setState(() {
                _expandInfo = !_expandInfo;
              });
            },
            icon: _expandInfo ? const SvgIcon(assetName: 'close') : const SvgIcon(assetName: 'expand_more'),
          ),
        ),
        Shrinkable(
          expanded: _expandInfo,
          child: body(context),
        ),
        const NullTopBar(),
      ],
    );
  }

  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'How to follow breathing circle',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ...[
                'Lie down on your back and relax',
                'Breathe in and out slowly and steadily',
                'Put one hand on your abdomen to feel it move up and down as you breathe',
                'If you use your chest, you need breath deeper',
                'Breathe in so your abdomen goes out',
                'Breathe out abdonmen and chest goes down',
                'When you breathe out, purse your lips like you are blowing out a candle',
                'Breath in for ${(_speed / 3 * 1).round()} seconds '
                    'and out for ${(_speed / 3 * 2).round()} seconds',
                'Follow the circle'
              ].map((e) => Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('+ ', style: Theme.of(context).textTheme.bodySmall),
                        Flexible(
                          child: Text(e, style: Theme.of(context).textTheme.bodySmall),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 8),
              Slider(
                value: _speed > 3 || _speed < 32 ? _speed : 6,
                min: 3,
                max: 32,
                onChangeEnd: (x) {
                  setState(() {
                    _speed = (x * 10).round() / 10;
                    widget.setSpeed(x);
                  });
                },
                onChanged: (x) {
                  setState(() {
                    _speed = (x * 10).round() / 10;
                    widget.changingSpeed();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
