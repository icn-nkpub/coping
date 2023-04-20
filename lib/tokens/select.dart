import 'package:flutter/material.dart';
import 'package:sca6/provider/theme/colors.dart';

class Select extends StatelessWidget {
  const Select({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final Object value;
  final List<DropdownMenuItem<Object>> items;
  final Function(dynamic value) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        value: value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
