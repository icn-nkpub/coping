import 'dart:async';
import 'dart:math';

import 'package:dependencecoping/gen/fonts.gen.dart';
import 'package:dependencecoping/pages/clock/locker.dart';
import 'package:dependencecoping/pages/clock/modals/time_manager.dart';
import 'package:dependencecoping/pages/copingdao/data.dart' as aidata;
import 'package:dependencecoping/provider/countdown/countdown.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/provider/theme/colors.dart';
import 'package:dependencecoping/provider/theme/theme.dart';
import 'package:dependencecoping/tokens/animation.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/tokens/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class CountdownDisplay extends StatelessWidget {
  const CountdownDisplay({super.key});

  @override
  Widget build(final BuildContext context) => BlocBuilder<LoginCubit, Profile?>(
        builder: (final context, final u) =>
            BlocBuilder<CountdownTimerCubit, CountdownTimer?>(
          builder: (final context, final ct) {
            final splits = ct?.splits();
            final paused = ct?.resumed == null;

            return Column(
              children: [
                Flexible(
                  child: BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (final context, final state) {
                      final c = Theme.of(context).scaffoldBackgroundColor;
                      return Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          // borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(
                                matchingImage(state.color, state.mode)),
                            fit: BoxFit.cover,
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0, 0.6, 0.95, 1],
                                  colors: <Color>[
                                    c.withOpacity(0),
                                    c.withOpacity(0),
                                    c,
                                    c,
                                  ],
                                ),
                              ),
                            ),
                            IgnorePointer(
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.topRight,
                                padding: const EdgeInsets.all(26),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Wrap(
                                        spacing: 8,
                                        direction: Axis.vertical,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.end,
                                        children: [
                                          scoreTrophyBadge(),
                                        ],
                                      ),
                                    ),
                                    const Row(
                                      children: [Motivation()],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8 * 3),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stopwatch(
                    from: splits?.last,
                    frozen: paused,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 8 * 8),
                  child: FittedBox(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<CountdownTimerCubit, CountdownTimer?>(
                        builder: (final context, final ct) => ScoreCard(
                            score: NumberFormat.decimalPattern()
                                .format(ct?.splits().score ?? 0)
                                .replaceAll('0', 'O')),
                      ),
                      const SizedBox(width: 4),
                      ...controlls(context, paused: paused),
                      const SizedBox(width: 4),
                      const LockerCard(),
                    ],
                  )),
                ),
                const SizedBox(height: 8 * 4),
              ],
            );
          },
        ),
      );

  BlocBuilder<CountdownTimerCubit, CountdownTimer?> scoreTrophyBadge() =>
      BlocBuilder<CountdownTimerCubit, CountdownTimer?>(
        builder: (final context, final ct) {
          final s = ct?.splits().score ?? 0;

          if (s > 1000) {
            return Badge(
              icon: Icon(Icons.wine_bar, size: computeSizeFromOffset(0)),
              label: 'Top 50%',
            );
          }

          if (s > 2000) {
            return Badge(
              icon: Icon(Icons.wine_bar, size: computeSizeFromOffset(0)),
              label: 'Top 35%',
            );
          }

          if (s > 5000) {
            return Badge(
              icon: Icon(Icons.wine_bar, size: computeSizeFromOffset(0)),
              label: 'Top 5%',
            );
          }

          if (s > 20000) {
            return Badge(
              icon: Icon(Icons.wine_bar, size: computeSizeFromOffset(0)),
              label: 'Top 1%',
            );
          }

          return const SizedBox();
        },
      );

  List<IconButton> controlls(final BuildContext context,
          {final bool paused = false}) =>
      [
        paused
            ? IconButton.filledTonal(
                onPressed: () async {
                  final al = AppLocalizations.of(context);
                  final auth = context.read<LoginCubit>().state!.auth;
                  await context
                      .read<CountdownTimerCubit>()
                      .resume(auth, al, DateTime.now());
                },
                icon: Icon(Icons.play_circle, size: computeSizeFromOffset(0)))
            : IconButton.filledTonal(
                onPressed: () async {
                  final al = AppLocalizations.of(context);
                  final auth = context.read<LoginCubit>().state!.auth;
                  await context
                      .read<CountdownTimerCubit>()
                      .pause(auth, al, DateTime.now());
                },
                icon: Icon(Icons.stop_circle, size: computeSizeFromOffset(0))),
        IconButton.filledTonal(
            onPressed: _gotoTime(context),
            icon: Icon(Icons.history, size: computeSizeFromOffset(0))),
      ];

  void Function() _gotoTime(final BuildContext context) => () => openModal(
        context,
        BlocBuilder<LoginCubit, Profile?>(
          builder: (final context, final u) => Modal(
            title: AppLocalizations.of(context)!.modalTimerEvents,
            child: TimeModal(auth: u?.auth),
          ),
        ),
      );
}

class Motivation extends StatelessWidget {
  const Motivation({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final n = DateTime.now();
    final r = Random(n.year + n.month + n.day + n.hour);

    final lc = Localizations.localeOf(context).languageCode;
    final List<String> messages = [];
    messages.addAll(aidata.nos[lc] ?? []);
    messages.addAll(aidata.cheers[lc] ?? []);

    final t = messages[r.nextInt(messages.length)];

    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.bottomLeft,
      width: MediaQuery.of(context).size.width * .65,
      child: Typer(
        t,
        textAlign: TextAlign.left,
        style: theme.textTheme.titleLarge!.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  List<Shadow> outline(
      final double offset, final double blur, final Color color) {
    final List<Offset> offsets = [];
    for (var x = -offset; x <= offset; x++) {
      for (var y = -offset; y <= offset; y++) {
        offsets.add(Offset(x, y));
      }
    }

    return offsets
        .map((final o) => Shadow(
              color: color,
              offset: o,
              blurRadius: blur,
            ))
        .toList();
  }
}

class Badge extends StatelessWidget {
  const Badge({
    required this.icon,
    required this.label,
    super.key,
  });

  final Widget icon;
  final String label;

  @override
  Widget build(final BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
            ),
          ],
        ),
      );
}

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    required this.score,
    super.key,
  });

  final String score;

  @override
  Widget build(final BuildContext context) => Card(
        margin: EdgeInsets.zero,
        color: Theme.of(context).colorScheme.tertiaryContainer,
        elevation: 3,
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Icon(Icons.bolt, size: computeSizeFromOffset(6))),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              padding:
                  const EdgeInsets.only(right: 16, left: 8, top: 8, bottom: 8),
              child: AnimatedCountedUp(
                child: Text(
                  score,
                  key: ValueKey(score),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontFamily: FontFamily.spaceMono,
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                ),
              ),
            ),
          ],
        ),
      );
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
  Widget build(final BuildContext context) {
    final tsm = (small
            ? Theme.of(context).textTheme.titleMedium
            : Theme.of(context).textTheme.displaySmall)!
        .copyWith(
      fontFamily: FontFamily.spaceMono,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onSecondaryContainer,
    );

    final ts = (small
            ? Theme.of(context).textTheme.titleMedium
            : Theme.of(context).textTheme.displaySmall)
        ?.copyWith(
      fontWeight: FontWeight.w100,
      color: Theme.of(context).colorScheme.onSecondaryContainer,
    );

    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Ticker(
              small: small,
              child: ClockHand(ClockHandType.days,
                  from: from, frozen: frozen, style: tsm)),
          Text(':', style: ts),
          Ticker(
              small: small,
              child: ClockHand(ClockHandType.hours,
                  from: from, frozen: frozen, style: tsm)),
          Text(':', style: ts),
          Ticker(
              small: small,
              child: ClockHand(ClockHandType.minutes,
                  from: from, frozen: frozen, style: tsm)),
          Text(':', style: ts),
          Ticker(
              small: small,
              child: ClockHand(ClockHandType.seconds,
                  from: from, frozen: frozen, style: tsm)),
        ],
      ),
    );
  }
}

class Ticker extends StatelessWidget {
  const Ticker({
    required this.child,
    this.small = false,
    super.key,
  });

  final Widget child;
  final bool small;

  @override
  Widget build(final BuildContext context) => Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: child,
              ),
            ),
          ],
        ),
      );
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
    required this.from,
    required this.frozen,
    required this.style,
    super.key,
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
  Widget build(final BuildContext context) {
    if (!widget.frozen) scheduleRefresh();
    final v = value();

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: AnimatedCountedUp(
        child: Text(
          v,
          key: ValueKey<String>(v),
          style: widget.style.copyWith(fontSize: 160),
          textAlign: TextAlign.center,
        ),
      ),
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
        case ClockHandType.hours:
          final p = diff.inHours % 24;
          v = p.toString();
        case ClockHandType.minutes:
          final p = diff.inMinutes % 60;
          v = p.toString();
        case ClockHandType.seconds:
          final p = diff.inSeconds % 60;
          v = p.toString();
      }
    }

    return v.padLeft(2, '0').replaceAll('0', 'O');
  }

  Timer? scheduleRefresh() {
    final Duration timerDuration;
    switch (widget.tm) {
      case ClockHandType.days:
        timerDuration = const Duration(seconds: 1);
      case ClockHandType.hours:
        timerDuration = const Duration(seconds: 1);
      case ClockHandType.minutes:
        timerDuration = const Duration(seconds: 1);
      case ClockHandType.seconds:
        timerDuration = const Duration(milliseconds: 10);
    }

    Timer? t;
    return t = Timer(timerDuration, () {
      if (widget.frozen || !mounted) {
        if (t != null) t.cancel();
        return;
      }

      setState(() {});
    });
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
