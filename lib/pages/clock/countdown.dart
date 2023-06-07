import 'dart:async';

import 'package:cloudcircle/pages/clock/goal.dart';
import 'package:cloudcircle/pages/clock/modals/goal_manager.dart';
import 'package:cloudcircle/provider/countdown/countdown.dart';
import 'package:cloudcircle/provider/goal/goal.dart';
import 'package:cloudcircle/provider/login/login.dart';
import 'package:cloudcircle/tokens/icons.dart';
import 'package:cloudcircle/tokens/modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CountdownDisplay extends StatelessWidget {
  const CountdownDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, Profile?>(
      builder: (context, u) {
        return BlocBuilder<CountdownTimerCubit, CountdownTimer?>(
          builder: (context, ct) {
            final splits = ct?.splits();

            return Column(
              children: [
                const SizedBox(height: 8 * 4),
                Stopwatch(from: splits?.last ?? DateTime.now()),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8 * 3),
                  child: BlocBuilder<CountdownTimerCubit, CountdownTimer?>(
                    builder: (context, ct) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ct?.paused == null
                            ? IconButton(
                                onPressed: () async {
                                  var auth = context.read<LoginCubit>().state!.auth;
                                  await context.read<CountdownTimerCubit>().pause(auth);
                                },
                                icon: SvgIcon(
                                  assetName: 'resume',
                                  color: Theme.of(context).hintColor,
                                ),
                              )
                            : IconButton(
                                onPressed: () async {
                                  var auth = context.read<LoginCubit>().state!.auth;
                                  await context.read<CountdownTimerCubit>().resume(auth, DateTime.now());
                                },
                                icon: SvgIcon(
                                  assetName: 'pause',
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                        Expanded(
                          child: Stopwatch(from: splits?.total ?? DateTime.now(), small: true),
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
    this.small = false,
    super.key,
  });

  final DateTime from;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Ticker(small: small, child: Days(from: from, style: textStyleMono(context, small))),
          Text(':', style: textStyle(context, small)),
          Ticker(small: small, child: Hours(from: from, style: textStyleMono(context, small))),
          Text(':', style: textStyle(context, small)),
          Ticker(small: small, child: Minutes(from: from, style: textStyleMono(context, small))),
          Text(':', style: textStyle(context, small)),
          Ticker(small: small, child: Seconds(from: from, style: textStyleMono(context, small))),
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

class Seconds extends StatefulWidget {
  const Seconds({
    super.key,
    required this.from,
    required this.style,
  });

  final DateTime from;
  final TextStyle style;

  @override
  State<Seconds> createState() => _SecondsState();
}

class _SecondsState extends State<Seconds> {
  @override
  Widget build(BuildContext context) {
    Timer? t;
    t = Timer(const Duration(seconds: 1), () {
      if (!mounted) {
        t!.cancel();
        return;
      }
      setState(() {});
    });
    return Text(
      (DateTime.now().difference(widget.from).inSeconds % 60).toString().padLeft(2, '0').replaceAll('0', 'O'),
      style: widget.style,
      textAlign: TextAlign.center,
    );
  }
}

class Minutes extends StatefulWidget {
  const Minutes({
    super.key,
    required this.from,
    required this.style,
  });

  final DateTime from;
  final TextStyle style;

  @override
  State<Minutes> createState() => _MinutesState();
}

class _MinutesState extends State<Minutes> {
  @override
  Widget build(BuildContext context) {
    Timer? t;
    t = Timer(const Duration(minutes: 1), () {
      if (!mounted) {
        t!.cancel();
        return;
      }
      setState(() {});
    });
    return Text(
      (DateTime.now().difference(widget.from).inMinutes % 60).toString().padLeft(2, '0').replaceAll('0', 'O'),
      style: widget.style,
      textAlign: TextAlign.center,
    );
  }
}

class Hours extends StatefulWidget {
  const Hours({
    super.key,
    required this.from,
    required this.style,
  });

  final DateTime from;
  final TextStyle style;

  @override
  State<Hours> createState() => _HoursState();
}

class _HoursState extends State<Hours> {
  @override
  Widget build(BuildContext context) {
    Timer? t;
    t = Timer(const Duration(hours: 1), () {
      if (!mounted) {
        t!.cancel();
        return;
      }
      setState(() {});
    });
    return Text(
      (DateTime.now().difference(widget.from).inHours % 24).toString().padLeft(2, '0').replaceAll('0', 'O'),
      style: widget.style,
      textAlign: TextAlign.center,
    );
  }
}

class Days extends StatefulWidget {
  const Days({
    super.key,
    required this.from,
    required this.style,
  });

  final DateTime from;
  final TextStyle style;

  @override
  State<Days> createState() => _DaysState();
}

class _DaysState extends State<Days> {
  @override
  Widget build(BuildContext context) {
    Timer? t;
    t = Timer(const Duration(days: 1), () {
      if (!mounted) {
        t!.cancel();
        return;
      }
      setState(() {});
    });
    return Text(
      DateTime.now().difference(widget.from).inDays.toString().padLeft(2, '0').replaceAll('0', 'O'),
      style: widget.style,
      textAlign: TextAlign.center,
    );
  }
}

TextStyle textStyleMono(BuildContext context, bool small) {
  final t = small ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.displaySmall;

  return GoogleFonts.spaceMono(
    textStyle: t,
  ).copyWith(
    fontWeight: FontWeight.w100,
    color: Theme.of(context).colorScheme.secondary,
  );
}

TextStyle? textStyle(BuildContext context, bool small) {
  final t = small ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.displaySmall;

  return t?.copyWith(
    fontWeight: FontWeight.w100,
    color: Theme.of(context).colorScheme.secondary,
  );
}
