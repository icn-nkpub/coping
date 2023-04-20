import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  const Input({
    super.key,
    required this.title,
    required this.ctrl,
  });

  final String title;
  final TextEditingController ctrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: TextField(
            controller: ctrl,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: title,
              filled: true,
            ),
          ),
        ),
      ],
    );
  }
}
