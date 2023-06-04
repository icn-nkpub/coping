import 'dart:async';

import 'package:cloudcircle/pages/clock/goal.dart';
import 'package:cloudcircle/pages/clock/modals/goal_manager.dart';
import 'package:cloudcircle/provider/goal/goal.dart';
import 'package:cloudcircle/storage/goal.dart';
import 'package:cloudcircle/tokens/icons.dart';
import 'package:cloudcircle/tokens/modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CountdownDisplay extends StatelessWidget {
  const CountdownDisplay({
    super.key,
    required this.from,
    this.auth,
  });

  final DateTime from;
  final User? auth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8 * 4),
        Stopwatch(from: from),
        const SizedBox(height: 8 * 3),
        BlocBuilder<GoalsCubit, List<Goal>?>(
          builder: (context, goals) => goals != null
              ? Column(
                  children: goals
                      .map((g) => GoalCard(
                            from: from,
                            iconName: g.iconName,
                            title: g.title,
                            descriptions: g.descriptions,
                            rate: g.rate,
                          ))
                      .toList(),
                )
              : Container(),
        ),
        bar(context),
      ],
    );
  }

  _gotoShop(BuildContext context) => () {
        return Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return modal(
              context,
              GoalModal(
                auth: auth,
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

  Widget bar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: _gotoShop(context),
            icon: SvgIcon(
              assetName: 'add',
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }
}

class Stopwatch extends StatelessWidget {
  const Stopwatch({
    required this.from,
    super.key,
  });

  final DateTime from;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Ticker(child: Days(from: from)),
          Text(' ', style: textStyle(context)),
          Ticker(child: Hours(from: from)),
          Text(':', style: textStyle(context)),
          Ticker(child: Minutes(from: from)),
          Text(':', style: textStyle(context)),
          Ticker(child: Seconds(from: from)),
        ],
      ),
    );
  }
}

class Ticker extends StatelessWidget {
  const Ticker({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class Seconds extends StatefulWidget {
  const Seconds({
    super.key,
    required this.from,
  });

  final DateTime from;

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
      style: textStyleMono(context),
      textAlign: TextAlign.center,
    );
  }
}

class Minutes extends StatefulWidget {
  const Minutes({
    super.key,
    required this.from,
  });

  final DateTime from;

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
      style: textStyleMono(context),
      textAlign: TextAlign.center,
    );
  }
}

class Hours extends StatefulWidget {
  const Hours({
    super.key,
    required this.from,
  });

  final DateTime from;

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
      style: textStyleMono(context),
      textAlign: TextAlign.center,
    );
  }
}

class Days extends StatefulWidget {
  const Days({
    super.key,
    required this.from,
  });

  final DateTime from;

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
      style: textStyleMono(context),
      textAlign: TextAlign.center,
    );
  }
}

TextStyle textStyleMono(BuildContext context) {
  return GoogleFonts.spaceMono(
    textStyle: Theme.of(context).textTheme.displaySmall,
  ).copyWith(fontWeight: FontWeight.w100, color: Theme.of(context).colorScheme.secondary);
}

TextStyle? textStyle(BuildContext context) {
  return Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w100, color: Theme.of(context).colorScheme.secondary);
}
