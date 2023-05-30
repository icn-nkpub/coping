import 'package:cloudcircle/tokens/topbar.dart';
import 'package:flutter/material.dart';

class TriggersScreen extends StatelessWidget {
  const TriggersScreen({
    super.key,
    required this.setPage,
  });

  final void Function(int) setPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(setPage: setPage),
        const SizedBox(
          height: 8,
        ),
        const Text('coming soon'),
      ],
    );
  }
}
