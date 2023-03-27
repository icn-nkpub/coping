import 'package:flutter/material.dart';

enum ColorSeed {
  blue('Pale Azure', Color(0xFF70d6ff)),
  red('Cyclamen', Color(0xFFff70a6)),
  orange('Atomic Tangerine', Color(0xFFff9770)),
  yellow('Naples Yellow', Color(0xFFffd670)),
  green('Mindaro', Color(0xFFe9ff70));

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}

enum ScreenSelected {
  component(0),
  color(1),
  typography(2),
  elevation(3),
  demo(10);

  const ScreenSelected(this.value);
  final int value;
}
