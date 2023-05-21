import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

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
        Text(
          "Personal best: 00 00:00:00",
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Theme.of(context).hintColor),
        ),
      ],
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
