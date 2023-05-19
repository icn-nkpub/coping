
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
        TopBar(setPage: setPage),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: const [
                SizedBox(
                  height: 8 * 6,
                ),
                CountdownDisplay(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
