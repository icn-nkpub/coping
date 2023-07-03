import 'dart:async';

import 'package:dependencecoping/pages/clock/goal.dart';
import 'package:dependencecoping/pages/clock/modals/goal_manager.dart';
import 'package:dependencecoping/provider/countdown/countdown.dart';
import 'package:dependencecoping/provider/goal/goal.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/tokens/modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

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
                  padding: const EdgeInsets.symmetric(horizontal: 8 * 3),
                  child: BlocBuilder<CountdownTimerCubit, CountdownTimer?>(
                    builder: (context, ct) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        paused
                            ? IconButton(
                                onPressed: () async {
                                  var auth = context.read<LoginCubit>().state!.auth;
                                  await context.read<CountdownTimerCubit>().resume(auth, DateTime.now());
                                },
                                icon: SvgIcon(
                                  assetName: 'resume',
                                  color: Theme.of(context).hintColor,
                                ),
                              )
                            : IconButton(
                                onPressed: () async {
                                  var auth = context.read<LoginCubit>().state!.auth;
                                  await context.read<CountdownTimerCubit>().pause(auth);
                                },
                                icon: SvgIcon(
                                  assetName: 'pause',
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                        Expanded(
                          child: Stopwatch(
                            from: splits?.total ?? splits?.last,
                            frozen: paused,
                            small: true,
                          ),
                        ),
                        IconButton(
                          onPressed: _gotoShop(context),
                          icon: SvgIcon(
                            assetName: 'settings',
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8 * 3),
                BlocBuilder<GoalsCubit, Goals?>(
                  builder: (context, goals) => goals != null
                      ? Column(
                          children: goals.data
                              .map((g) => GoalCard(
                                    from: splits?.last ?? DateTime.now(),
                                    iconName: g.iconName,
                                    title: g.title,
                                    descriptions: g.descriptions,
                                    rate: g.rate,
                                  ))
                              .toList(),
                        )
                      : Container(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  _gotoShop(BuildContext context) => () {
        return Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return BlocBuilder<LoginCubit, Profile?>(
              builder: (context, u) => modal(
                context,
                GoalModal(
                  auth: u?.auth,
                ),
              ),
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
              child: child,
            );
          },
        ));
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
    final tsm = GoogleFonts.spaceMono(
      textStyle: small ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.displaySmall,
    ).copyWith(
      fontWeight: FontWeight.w100,
      color: Theme.of(context).colorScheme.secondary,
    );

    final ts = (small ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.displaySmall)?.copyWith(
      fontWeight: FontWeight.w100,
      color: Theme.of(context).colorScheme.secondary,
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
      elevation: small ? 2 : 5,
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
        t!.cancel();
        return;
      }

      setState(() {});
    });

    return t;
  }
}
