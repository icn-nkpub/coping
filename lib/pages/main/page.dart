import 'package:sca6/pages/main/countdown.dart';
import 'package:sca6/pages/main/topbar.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.setPage,
  });

  final void Function(int) setPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(
          setPage: setPage,
          windowHeight: MediaQuery.of(context).size.height / 3 * 2,
        ),
        const Countdown(),
      ],
    );
  }
}

class Countdown extends StatefulWidget {
  const Countdown({
    super.key,
  });

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  int lastTimeSmoked = 1684687455000;
  bool debug = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            CountdownDisplay(
                from: DateTime.fromMillisecondsSinceEpoch(lastTimeSmoked)),
            GestureDetector(
              // todo: remove it
              child: Container(
                color: Colors.transparent,
                height: 8,
                width: 8,
              ),
              onTap: () => setState(() => debug = !debug),
            ),
            if (debug)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  direction: Axis.horizontal,
                  runSpacing: 8,
                  spacing: 8,
                  children: [
                    FilledButton(
                      onPressed: () => setState(
                          () => lastTimeSmoked += Duration.millisecondsPerDay),
                      child: const Text("-1d"),
                    ),
                    FilledButton(
                      onPressed: () => setState(() =>
                          lastTimeSmoked += Duration.millisecondsPerMinute),
                      child: const Text("-1m"),
                    ),
                    FilledButton(
                      onPressed: () => setState(() => lastTimeSmoked +=
                          Duration.millisecondsPerMinute * 30),
                      child: const Text("-30m"),
                    ),
                    FilledButton(
                      onPressed: () => setState(() => lastTimeSmoked -=
                          Duration.millisecondsPerMinute * 30),
                      child: const Text("+30m"),
                    ),
                    FilledButton(
                      onPressed: () => setState(() =>
                          lastTimeSmoked -= Duration.millisecondsPerMinute),
                      child: const Text("+1m"),
                    ),
                    FilledButton(
                      onPressed: () => setState(
                          () => lastTimeSmoked -= Duration.millisecondsPerDay),
                      child: const Text("+1d"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
