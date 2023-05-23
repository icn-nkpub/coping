import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:sca6/tokens/icons.dart';

class CountdownDisplay extends StatelessWidget {
  const CountdownDisplay({
    super.key,
    required this.from,
  });

  final DateTime from;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stopwatch(from: from),
        const SizedBox(
          height: 8,
        ),
        Risk(
          from: from,
          iconName: "cardiology",
          iconDoneName: "heart_check",
          title: "Cardiovascular risk",
          descriptions: {
            0: "0",
            0.1: "0.1",
            0.5: "0.5",
            0.7: "0.7",
            0.9: "0.9",
          },
          rate: Duration.millisecondsPerDay.toDouble(),
        ),
      ],
    );
  }
}

class Risk extends StatelessWidget {
  const Risk({
    super.key,
    required this.from,
    required this.iconName,
    required this.iconDoneName,
    required this.title,
    required this.descriptions,
    required this.rate,
  });

  final DateTime from;
  final String iconName;
  final String iconDoneName;
  final String title;
  final Map<double, String> descriptions;
  final double rate;

  @override
  Widget build(BuildContext context) {
    final double value =
        (DateTime.now().difference(from).inMilliseconds.toDouble() / rate);
    final bool finished = value > 1 ? true : false;

    String description = descriptions[0]!;
    for (var d in descriptions.entries) {
      if (value > d.key) description = d.value;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 12),
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(.2),
                ),
              )),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: SvgIcon(
                      assetName: finished ? iconDoneName : iconName,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: LinearProgressIndicator(
                        value: value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 4, bottom: 8, top: 12),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
            ),
          ],
        ),
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
          Text(" ", style: Theme.of(context).textTheme.displaySmall),
          Ticker(child: Hours(from: from)),
          Text(":", style: Theme.of(context).textTheme.displaySmall),
          Ticker(child: Minutes(from: from)),
          Text(":", style: Theme.of(context).textTheme.displaySmall),
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
    Timer(const Duration(seconds: 1), () {
      setState(() {});
    });
    return Text(
      (DateTime.now().difference(widget.from).inSeconds % 60)
          .toString()
          .padLeft(2, '0'),
      style: GoogleFonts.jetBrainsMonoTextTheme(Theme.of(context).textTheme)
          .displayMedium,
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
    Timer(const Duration(minutes: 1), () {
      setState(() {});
    });
    return Text(
      (DateTime.now().difference(widget.from).inMinutes % 60)
          .toString()
          .padLeft(2, '0'),
      style: Theme.of(context).textTheme.displayMedium,
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
    Timer(const Duration(hours: 1), () {
      setState(() {});
    });
    return Text(
      (DateTime.now().difference(widget.from).inHours % 24)
          .toString()
          .padLeft(2, '0'),
      style: Theme.of(context).textTheme.displayMedium,
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
    Timer(const Duration(days: 1), () {
      setState(() {});
    });
    return Text(
      DateTime.now().difference(widget.from).inDays.toString().padLeft(2, "0"),
      style: Theme.of(context).textTheme.displayMedium,
      textAlign: TextAlign.center,
    );
  }
}
