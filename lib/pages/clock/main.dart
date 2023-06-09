import 'package:cloudcircle/pages/clock/countdown.dart';
import 'package:cloudcircle/tokens/topbar.dart';
import 'package:flutter/material.dart';

class ClockScreen extends StatelessWidget {
  const ClockScreen({
    super.key,
    required this.setPage,
  });

  final void Function(int) setPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(setPage: setPage),
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
  bool debug = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: const [
            CountdownDisplay(),
          ],
        ),
      ),
    );
  }
}
