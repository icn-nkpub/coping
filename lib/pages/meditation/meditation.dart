import 'dart:core';
import 'dart:ui';

import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/shaders/shaders.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/tokens/measurable.dart';
import 'package:dependencecoping/tokens/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<FragmentProgram> loadMyShader() =>
    FragmentProgram.fromAsset('shaders/stars.frag');

void updateShader(
    final Canvas canvas, final Rect rect, final FragmentProgram program) {
  final shader = program.fragmentShader();
  shader.setFloat(0, 42.0);
  canvas.drawRect(rect, Paint()..shader = shader);
}

void paint(final Canvas canvas, final Size size, final FragmentShader shader) {
  // Draws a rectangle with the shader used as a color source.
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size.width, size.height),
    Paint()..shader = shader,
  );

  // Draws a stroked rectangle with the shader only applied to the fragments
  // that lie within the stroke.
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size.width, size.height),
    Paint()
      ..style = PaintingStyle.stroke
      ..shader = shader,
  );
}

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<LoginCubit, Profile?>(builder: (final context, final u) {
        final breathingTime = u?.profile?.breathingTime ?? 6.0;

        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary,
                  BlendMode.modulate,
                ),
                child: const DrawFrag(
                  frag: 'stars',
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: InfoCard(
                speed: breathingTime,
                setSpeed: (final s) {
                  Future.delayed(const Duration(seconds: 1), () async {
                    await context.read<LoginCubit>().setBreathingTime(s);
                  });
                },
                changingSpeed: () {
                  // cd.windDown = true;
                },
              ),
            )
          ],
        );
      });
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
                  ? SvgIcon(Assets.icons.close)
                  : SvgIcon(Assets.icons.expandMore),
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
