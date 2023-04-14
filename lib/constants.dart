import 'package:flutter/material.dart';

enum ScreenSelected {
  component(0),
  color(1),
  typography(2),
  elevation(3),
  demo(10);

  const ScreenSelected(this.value);
  final int value;
}
