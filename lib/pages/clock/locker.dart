import 'dart:async';
import 'dart:developer';

import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/provider/countdown/countdown.dart';
import 'package:dependencecoping/provider/locker/locker.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/provider/theme/fonts.dart';
import 'package:dependencecoping/tokens/animation.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const hourOpts = [0, 1, 2, 3, 4, 5, 6, 9, 12, 18, 24, 36, 48, 96, 99];
const minuteOpts = [0, 1, 5, 10, 15, 20, 25, 30, 35, 45, 50, 55, 59];

class LockerCard extends StatefulWidget {
  const LockerCard({super.key});

  @override
  State<LockerCard> createState() => _LockerCardState();
}

class _LockerCardState extends State<LockerCard> {
  var hours = PageController(initialPage: 2);
  var minutes = PageController(initialPage: 4);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      animateCells();
    });
  }

  @override
  void dispose() {
    hours.dispose();
    minutes.dispose();
    super.dispose();
  }

  void animateCells() {
    try {
      unawaited(hours.animateToPage(0, duration: const Duration(seconds: 1), curve: Curves.bounceOut));
      unawaited(minutes.animateToPage(0, duration: const Duration(seconds: 1), curve: Curves.bounceOut));
      // ignore: avoid_catching_errors
    } on AssertionError catch (e) {
      log(e.toString(), name: 'locker.animate_cells');
    }
  }

  @override
  Widget build(final BuildContext context) => BlocBuilder<LockerCubit, Locker>(
        builder: (final context, final state) {
          if (state.positive) Timer.run(animateCells);
          final w = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: state.duration == Duration.zero ? _unlocked(state) : _locked(state),
          );

          return Card(
            elevation: 2,
            margin: EdgeInsets.zero,
            child: state.positive
                ? Badge(
                    backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                    label: SvgIcon(
                      assetPath: Assets.icons.done,
                      sizeOffset: 8,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                    child: w,
                  )
                : w,
          );
        },
      );

  List<Widget> _unlocked(final Locker state) => [
        Row(
          children: [
            ScrollOptions(controller: hours, options: hourOpts),
            const Text(':'),
            ScrollOptions(controller: minutes, options: minuteOpts),
          ],
        ),
        BlocBuilder<LoginCubit, Profile?>(
          builder: (final context, final p) => IconButton(
            onPressed: () {
              final dt = DateTime.now();

              final d = Duration(
                hours: hourOpts[hours.page!.toInt()],
                minutes: minuteOpts[minutes.page!.toInt()],
              );

              if (d == Duration.zero) return;

              hours.dispose();
              minutes.dispose();
              hours = PageController(initialPage: hours.page!.toInt());
              minutes = PageController(initialPage: minutes.page!.toInt());

              unawaited(context.read<LockerCubit>().start(p!.auth, dt, d));
              final ctc = context.read<CountdownTimerCubit>();
              if (ctc.state?.resumed == null) unawaited(ctc.resume(p.auth, dt));
            },
            icon: SvgIcon(assetPath: Assets.icons.lockOpen),
          ),
        ),
      ];

  List<Widget> _locked(final Locker state) => [
        TimerClock(start: state.start!, duration: state.duration),
        BlocBuilder<LoginCubit, Profile?>(
          builder: (final context, final p) => IconButton(
            onPressed: () {
              unawaited(context.read<LockerCubit>().stop(p!.auth).then((final _) => animateCells()));
              unawaited(context.read<CountdownTimerCubit>().pause(p.auth));
            },
            icon: SvgIcon(assetPath: Assets.icons.lock),
          ),
        ),
      ];
}

class TimerClock extends StatefulWidget {
  const TimerClock({
    required this.start,
    required this.duration,
    super.key,
  });

  final DateTime start;
  final Duration duration;

  @override
  State<TimerClock> createState() => _TimerClockState();
}

class _TimerClockState extends State<TimerClock> {
  @override
  Widget build(final BuildContext context) {
    Duration left = widget.start.add(widget.duration).difference(DateTime.now());
    if (left.isNegative) {
      left = Duration.zero;

      final lc = context.read<LoginCubit>();
      unawaited(context.read<LockerCubit>().notifyDone(lc.state!.auth));
    }
    left = Duration(minutes: left.inMinutes + 1);
    scheduleRefresh();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox.square(
          dimension: 48,
          child: Number(
            label: left.inHours.toString(),
            alternate: true,
          ),
        ),
        const Text(':'),
        SizedBox.square(
          dimension: 48,
          child: Number(
            label: (left.inMinutes % 60).toString(),
            alternate: true,
          ),
        ),
      ],
    );
  }

  Timer? scheduleRefresh() {
    Timer? t;
    return t = Timer(const Duration(milliseconds: 100), () {
      if (!mounted) {
        if (t != null) t.cancel();
        return;
      }

      setState(() {});
    });
  }
}

class ScrollOptions extends StatelessWidget {
  const ScrollOptions({
    required this.controller,
    required this.options,
    super.key,
  });

  final PageController controller;
  final List<int> options;

  @override
  Widget build(final BuildContext context) => SizedBox(
        width: 48,
        height: 48,
        child: PageView(
          scrollDirection: Axis.vertical,
          controller: controller,
          children: options.map((final e) => Number(label: '$e')).toList(),
        ),
      );
}

class Number extends StatelessWidget {
  const Number({
    required this.label,
    this.alternate = false,
    super.key,
  });

  final String label;
  final bool alternate;

  @override
  Widget build(final BuildContext context) => Center(
        child: Card(
          elevation: 2,
          color: alternate ? Theme.of(context).colorScheme.tertiaryContainer : Theme.of(context).colorScheme.secondaryContainer,
          child: Container(
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.all(10),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: AnimatedCountedUp(
                child: Text(
                  label.padLeft(2, 'O').replaceAll('0', 'O'),
                  key: ValueKey(label),
                  style: fAccent(
                    textStyle: Theme.of(context).textTheme.displaySmall,
                  )
                      .copyWith(
                        fontWeight: FontWeight.bold,
                        color: alternate ? Theme.of(context).colorScheme.onTertiaryContainer : Theme.of(context).colorScheme.onSecondaryContainer,
                      )
                      .copyWith(fontSize: 160),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
}
