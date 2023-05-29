import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:sca6/pages/clock/risk.dart';

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
        const SizedBox(height: 8 * 4),
        Stopwatch(from: from),
        const SizedBox(height: 8 * 3),
        Risk(
          from: from,
          iconName: 'cardiology',
          title: 'Cardiovascular risk',
          descriptions: {
            0: '0',
            0.1: '0.1',
            0.5: '0.5',
            0.7: '0.7',
            0.9: '0.9',
          },
          rate: Duration.millisecondsPerDay.toDouble(),
        ),
        Risk(
          from: from,
          iconName: 'humidity_percentage',
          title: 'Carbon monoxide in blood',
          descriptions: {
            0 / 22:
                'Increased levels of carbon monoxide (CO) caused by smoking can profoundly harm health. CO, a poisonous gas, binds to hemoglobin, significantly diminishing its capacity to efficiently transport oxygen in the bloodstream.',
            8 / 22:
                'As blood carbon monoxide (CO) levels decrease, there is a clear and certain improvement in oxygen delivery, leading to a significant enhancement of overall oxygenation of muscles, organs and tissues.',
            15 / 22:
                'With a high degree of confidence, the carbon monoxide (CO) level in exhaled breath is notably reduced, approximately twice, and decrease in CO levels in the bloodstream. Consequently, there is a discernible improvement in oxygen delivery, contributing to an enhanced oxygenation state.',
            22 / 22:
                'The discernible impact of smoking on carbon monoxide levels in the bloodstream is nearly absent.',
          },
          rate: Duration.millisecondsPerDay.toDouble() * 22,
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
      (DateTime.now().difference(widget.from).inSeconds % 60)
          .toString()
          .padLeft(2, '0')
          .replaceAll('0', 'O'),
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
      (DateTime.now().difference(widget.from).inMinutes % 60)
          .toString()
          .padLeft(2, '0')
          .replaceAll('0', 'O'),
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
      (DateTime.now().difference(widget.from).inHours % 24)
          .toString()
          .padLeft(2, '0')
          .replaceAll('0', 'O'),
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
      DateTime.now()
          .difference(widget.from)
          .inDays
          .toString()
          .padLeft(2, '0')
          .replaceAll('0', 'O'),
      style: textStyleMono(context),
      textAlign: TextAlign.center,
    );
  }
}

TextStyle textStyleMono(BuildContext context) {
  return GoogleFonts.spaceMono(
    textStyle: Theme.of(context)
        .textTheme
        .displaySmall
        ?.copyWith(fontWeight: FontWeight.w300),
  );
}

TextStyle? textStyle(BuildContext context) {
  return Theme.of(context)
      .textTheme
      .displaySmall
      ?.copyWith(fontWeight: FontWeight.w600);
}
