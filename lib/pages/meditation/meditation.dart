import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:dependencecoping/shaders/shaders.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/tokens/measurable.dart';
import 'package:dependencecoping/tokens/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:funvas/funvas.dart';

class CanvasDrawer extends Funvas {
  CanvasDrawer({
    required this.primary,
    required this.secondary,
    required this.backdrop,
    required this.fullCycleDuration,
    required this.scale,
    required this.slideDist,
    required this.rounds,
    required this.seed,
    required this.shader,
    this.muted = false,
  });
  HSLColor primary;
  HSLColor secondary;
  Color backdrop;
  final double fullCycleDuration;
  final double scale;
  final double slideDist;
  final int rounds;
  double seed;
  bool windDown = false;
  double windDownTime = -1;
  FragmentShader shader;
  final bool muted;

  @override
  void u(double t) {
    if (muted) t += fullCycleDuration;
    if (!muted) t = max(0, t - 1);

    final w = x.width / 2;
    final h = x.height / 2;
    final s = x.width < x.height ? x.width : x.height;
    final pt = (s * scale) / 64;

    if (windDownTime > -1) {
      double cycle = graph(windDownTime);
      cycle = max(0, cycle - (t - windDownTime));
      final slide = slideDist * pt - (cycle * (slideDist * pt));

      _drawParticles(pt, w, h, cycle, t, slide);
      if (!muted) _drawGuideLine(primary, pt, w, h);
      if (!muted) {
        _drawCircle(HSLColor.fromColor(backdrop), pt * 1.2, w, h, slide);
      }
      if (!muted) _drawCircle(secondary, pt, w, h, slide);

      return;
    }
    if (windDown) {
      windDownTime = t;
    }

    final double cycle = graph(t);
    final slide = slideDist * pt - (cycle * (slideDist * pt));

    _drawParticles(pt, w, h, cycle, t, slide);
    if (!muted) _drawGuideLine(primary, pt, w, h);
    if (!muted) {
      _drawCircle(HSLColor.fromColor(backdrop), pt * 1.2, w, h, slide);
    }
    if (!muted) _drawCircle(secondary, pt, w, h, slide);
  }

  void _drawParticles(final double pt, final double w, final double h,
      final double cycle, final double t, final double slide) {
    shader.setFloat(1, x.width);
    shader.setFloat(2, x.height);
    shader.setFloat(4, -slide);
    shader.setFloat(6, seed);

    shader.setFloat(5, 1);
    shader.setFloat(0, cycle);
    c.drawRect(
        Rect.fromLTWH(0, 0, x.width, x.height),
        Paint()
          ..shader = shader
          ..colorFilter = ColorFilter.mode(
            secondary.toColor(),
            BlendMode.modulate,
          ));
    shader.setFloat(5, 2);
    shader.setFloat(0, cycle);
    c.drawRect(
        Rect.fromLTWH(0, 0, x.width, x.height),
        Paint()
          ..shader = shader
          ..colorFilter = ColorFilter.mode(
            primary.toColor(),
            BlendMode.modulate,
          ));
  }

  void _drawGuideLine(
      final HSLColor color, final double pt, final double w, final double h) {
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

  void _drawCircle(final HSLColor color, final double pt, final double w,
      final double h, final double slide) {
    final circlePaint = Paint();
    circlePaint.color = color.toColor();
    circlePaint.strokeCap = StrokeCap.round;
    circlePaint.strokeWidth = pt / 4;
    c.drawCircle(
      Offset(w, h + slide),
      pt / 2,
      circlePaint,
    );
  }

  double graph(final double t) {
    final x = 1 - ((t % fullCycleDuration) / fullCycleDuration);

    final fnUp = bezFn(x, 3, 0);
    final fnDown = bezFn(x, -1.5, -1);

    final cycle = x < 1 / 3 ? fnUp : fnDown;
    return cycle;
  }

  double bezFn(final double x, final double compression, final double offset) {
    final v = compression * (x + offset);

    final y = pow(v, 2) / (2 * (pow(v, 2) - v) + 1);

    return y;
  }
}

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(final BuildContext context) => FutureBuilder(
        // ignore: discarded_futures
        future: loadFrag('stars'),
        builder: (final context, final snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              width: double.infinity,
              height: double.infinity,
            );
          }

          return Builder(
            builder: (final context) {
              const breathingTime = 6.0; // todo: add proper breating time

              final cd = CanvasDrawer(
                backdrop: Theme.of(context).scaffoldBackgroundColor,
                primary:
                    HSLColor.fromColor(Theme.of(context).colorScheme.primary),
                secondary:
                    HSLColor.fromColor(Theme.of(context).colorScheme.tertiary),
                fullCycleDuration: breathingTime,
                scale: 2,
                rounds: 12,
                slideDist: 12,
                shader: snapshot.requireData,
                seed: 11.95 + 0.34,
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
                      setSpeed: (final s) {
                        // todo: persist breating time
                      },
                      changingSpeed: () {
                        cd.windDown = true;
                      },
                    ),
                  )
                ],
              );
            },
          );
        },
      );
}

class InfoCard extends StatefulWidget {
  const InfoCard({
    required this.speed,
    required this.setSpeed,
    required this.changingSpeed,
    super.key,
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
  Widget build(final BuildContext context) => Column(
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
              icon: _expandInfo
                  ? Icon(Icons.close, size: computeSizeFromOffset(0))
                  : Icon(Icons.expand_more, size: computeSizeFromOffset(0)),
            ),
          ),
          Shrinkable(
            expanded: _expandInfo,
            child: body(context),
          ),
          const NullTopBar(),
        ],
      );

  Widget body(final BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.meditationHowToTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ...[
                  AppLocalizations.of(context)!.meditationHowTo1,
                  AppLocalizations.of(context)!.meditationHowTo2,
                  AppLocalizations.of(context)!.meditationHowTo3,
                  AppLocalizations.of(context)!.meditationHowTo4,
                  AppLocalizations.of(context)!.meditationHowTo5,
                  AppLocalizations.of(context)!.meditationHowTo6,
                  AppLocalizations.of(context)!.meditationHowTo7,
                  '${AppLocalizations.of(context)!.meditationHowTo8((_speed / 3 * 1).round())} ${AppLocalizations.of(context)!.meditationHowTo9((_speed / 3 * 2).round())}',
                  AppLocalizations.of(context)!.meditationHowTo10,
                ].map((final e) => Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('— ',
                              style: Theme.of(context).textTheme.bodySmall),
                          Flexible(
                            child: Text(e,
                                style: Theme.of(context).textTheme.bodySmall),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 8),
                SliderTheme(
                  data: Theme.of(context).sliderTheme.copyWith(
                        showValueIndicator: ShowValueIndicator.always,
                      ),
                  child: Slider(
                    value: _speed > 3 || _speed < 32 ? _speed : 6,
                    min: 3,
                    max: 32,
                    label: '${(_speed / 3 * 2).round()}',
                    onChangeEnd: (final x) {
                      setState(() {
                        _speed = (x * 10).round() / 10;
                        widget.setSpeed(x);
                      });
                    },
                    onChanged: (final x) {
                      setState(() {
                        _speed = (x * 10).round() / 10;
                        widget.changingSpeed();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
