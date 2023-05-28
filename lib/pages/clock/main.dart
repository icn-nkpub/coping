import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca6/pages/clock/countdown.dart';
import 'package:sca6/provider/login/login.dart';
import 'package:sca6/tokens/topbar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
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
          children: [
            BlocBuilder<LoginCubit, Profile?>(
              builder: (context, u) => CountdownDisplay(
                from: u?.profile?.noSmokingTime ?? DateTime.now(),
              ),
            ),
            GestureDetector(
              // todo: remove it
              child: Container(
                color: Colors.transparent,
                height: 8,
                width: 8,
              ),
              onTap: () => setState(() => debug = !debug),
            ),
          ],
        ),
      ),
    );
  }
}
