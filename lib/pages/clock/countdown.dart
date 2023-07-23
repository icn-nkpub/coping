import 'dart:async';

import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/pages/clock/goal.dart';
import 'package:dependencecoping/pages/clock/modals/goal_manager.dart';
import 'package:dependencecoping/pages/clock/modals/time_manager.dart';
import 'package:dependencecoping/provider/countdown/countdown.dart';
import 'package:dependencecoping/provider/goal/goal.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/provider/theme/fonts.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/tokens/modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CountdownDisplay extends StatelessWidget {
  const CountdownDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, Profile?>(
      builder: (context, u) {
        return BlocBuilder<CountdownTimerCubit, CountdownTimer?>(
          builder: (context, ct) {
            final splits = ct?.splits();
            final paused = ct?.resumed == null;

            return Column(
              children: [
                const SizedBox(height: 8 * 4),
                Stopwatch(
                  from: splits?.last,
                  frozen: paused,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...controlls(context, paused),
                      const SizedBox(width: 16),
                      BlocBuilder<CountdownTimerCubit, CountdownTimer?>(
                        builder: (context, ct) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Card(
                                margin: EdgeInsets.zero,
                                color: Theme.of(context).colorScheme.tertiaryContainer,
                                elevation: 3,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 14),
                                      child: SvgIcon(
                                        assetPath: Assets.icons.bolt,
                                        color: Theme.of(context).colorScheme.onTertiaryContainer,
                                        size: 18,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 16, left: 8, top: 8, bottom: 8),
                                      child: Text(
                                        NumberFormat.decimalPattern().format(splits?.score ?? 0).replaceAll('0', 'O'),
                                        style: fAccent(textStyle: Theme.of(context).textTheme.bodyLarge).copyWith(
                                          color: Theme.of(context).colorScheme.onTertiaryContainer,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8 * 3),
                BlocBuilder<GoalsCubit, Goals?>(builder: (BuildContext context, Goals? goals) {
                  var gs = (goals?.data ?? []).toList();
                  gs.sort((a, b) => a.rate.compareTo(b.rate));

                  return Column(
                    children: gs
                        .map((g) => GoalCard(
                              from: splits?.last ?? DateTime.now(),
                              iconName: g.iconName,
                              titles: g.titles,
                              descriptions: g.descriptions,
                              rate: g.rate,
                            ))
                        .toList(),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }

  controlls(BuildContext context, bool paused) => [
        paused
            ? IconButton.filledTonal(
                onPressed: () async {
                  var auth = context.read<LoginCubit>().state!.auth;
                  await context.read<CountdownTimerCubit>().resume(auth, DateTime.now());
                },
                icon: SvgIcon(
                  assetPath: Assets.icons.playCircle,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              )
            : IconButton.filledTonal(
                onPressed: () async {
                  var auth = context.read<LoginCubit>().state!.auth;
                  await context.read<CountdownTimerCubit>().pause(auth);
                },
                icon: SvgIcon(
                  assetPath: Assets.icons.stopCircle,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
        IconButton.filledTonal(
          onPressed: _gotoTime(context),
          icon: SvgIcon(
            assetPath: Assets.icons.history,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        IconButton.filledTonal(
          onPressed: _gotoShop(context),
          icon: SvgIcon(
            assetPath: Assets.icons.checklist,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ];

  _gotoShop(BuildContext context) => () {
        return openModal(
          context,
          BlocBuilder<LoginCubit, Profile?>(
            builder: (context, u) => modal(context, AppLocalizations.of(context)!.modalGoals, GoalModal(auth: u?.auth)),
          ),
        );
      };

  _gotoTime(BuildContext context) => () {
        return openModal(
          context,
          BlocBuilder<LoginCubit, Profile?>(
            builder: (context, u) => modal(context, AppLocalizations.of(context)!.modalTimerEvents, TimeModal(auth: u?.auth)),
          ),
        );
      };
}

class Stopwatch extends StatelessWidget {
  const Stopwatch({
    required this.from,
    required this.frozen,
    this.small = false,
    super.key,
  });

  final DateTime? from;
  final bool frozen;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final tsm = fAccent(
      textStyle: small ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.displaySmall,
    ).copyWith(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSecondaryContainer,
    );

    final ts = (small ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.displaySmall)?.copyWith(
      fontWeight: FontWeight.w100,
      color: Theme.of(context).colorScheme.onSecondaryContainer,
    );

    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Ticker(small: small, child: ClockHand(ClockHandType.days, from: from, frozen: frozen, style: tsm)),
          Text(':', style: ts),
          Ticker(small: small, child: ClockHand(ClockHandType.hours, from: from, frozen: frozen, style: tsm)),
          Text(':', style: ts),
          Ticker(small: small, child: ClockHand(ClockHandType.minutes, from: from, frozen: frozen, style: tsm)),
          Text(':', style: ts),
          Ticker(small: small, child: ClockHand(ClockHandType.seconds, from: from, frozen: frozen, style: tsm)),
        ],
      ),
    );
  }
}

class Ticker extends StatelessWidget {
  const Ticker({
    super.key,
    required this.child,
    required this.small,
  });

  final Widget child;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(small ? 8 : 16),
        child: child,
      ),
    );
  }
}

enum ClockHandType {
  days,
  hours,
  minutes,
  seconds,
}

class ClockHand extends StatefulWidget {
  const ClockHand(
    this.tm, {
    super.key,
    required this.from,
    required this.frozen,
    required this.style,
  });

  final ClockHandType tm;
  final DateTime? from;
  final bool frozen;
  final TextStyle style;

  @override
  State<ClockHand> createState() => _ClockHandState();
}

class _ClockHandState extends State<ClockHand> {
  @override
  Widget build(BuildContext context) {
    if (!widget.frozen) scheduleRefresh();

    return Text(
      value(),
      style: widget.style,
      textAlign: TextAlign.center,
    );
  }

  String value() {
    String v = 'OO';
    if (widget.from != null) {
      final Duration diff = DateTime.now().difference(widget.from!);

      switch (widget.tm) {
        case ClockHandType.days:
          final p = diff.inDays;
          v = p.toString();
          break;
        case ClockHandType.hours:
          final p = (diff.inHours % 24);
          v = p.toString();
          break;
        case ClockHandType.minutes:
          final p = (diff.inMinutes % 60);
          v = p.toString();
          break;
        case ClockHandType.seconds:
          final p = (diff.inSeconds % 60);
          v = p.toString();
          break;
      }
    }

    return v.padLeft(2, '0').replaceAll('0', 'O');
  }

  Timer? scheduleRefresh() {
    final Duration timerDuration;
    switch (widget.tm) {
      case ClockHandType.days:
        timerDuration = const Duration(seconds: 1);
        break;
      case ClockHandType.hours:
        timerDuration = const Duration(seconds: 1);
        break;
      case ClockHandType.minutes:
        timerDuration = const Duration(seconds: 1);
        break;
      case ClockHandType.seconds:
        timerDuration = const Duration(milliseconds: 10);
        break;
    }

    Timer? t;
    t = Timer(timerDuration, () {
      if (widget.frozen || !mounted) {
        if (t != null) t.cancel();
        return;
      }

      setState(() {});
    });

    return t;
  }
}
