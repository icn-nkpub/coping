
import 'package:flutter/material.dart';

enum ColorValue {
  ocean(name: 'Ocean', canvas: Color(0xFF03A5FF), hueShift: -30),
  peaches(name: 'Peaches', canvas: Color(0xFFFF3E45), hueShift: 30),
  pine(name: 'Pine', canvas: Color(0xFF41BF5D), hueShift: 40),
  midnight(name: 'Midnight', canvas: Color(0xFF8A37FF), hueShift: -60),
  slimes(name: 'Slimes', canvas: Color(0xFF70FFBB), hueShift: 60),
  contrast(name: 'Contrast', canvas: Color(0xFF8A89F1), hueShift: 180);

  const ColorValue({
    required this.name,
    required this.canvas,
    required this.hueShift,
  });

  final String name;
  final Color canvas;
  final double hueShift;

  Color get primary => HSLColor.fromColor(canvas).toColor();
  Color get secondary {
    final c = HSLColor.fromColor(canvas);
    return c.withHue((360 + c.hue + hueShift) % 360).toColor();
  }
}

ColorValue findThemeColor(String c) {
  return ColorValue.values.where((v) => v.name == c).firstOrNull ?? ColorValue.ocean;
}
