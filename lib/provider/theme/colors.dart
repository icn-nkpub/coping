import 'package:flutter/material.dart';

enum ColorValue {
  ocean(name: 'Ocean', canvas: Color(0xFF03A5FF), hueShift: -30),
  peaches(name: 'Peaches', canvas: Color(0xFFFF3E45), hueShift: 30),
  midnight(name: 'Midnight', canvas: Color(0xFF8A37FF), hueShift: -60),
  slimes(name: 'Slimes', canvas: Color(0xFF70FFBB), hueShift: 60);

  const ColorValue({
    required this.name,
    required this.canvas,
    required this.hueShift,
  });

  final String name;
  final Color canvas;
  final double hueShift;

  Color get primary => HSLColor.fromColor(canvas).withLightness(.1).withSaturation(.1).toColor();
  Color get special {
    final c = HSLColor.fromColor(primary);
    return c.withHue((360 + c.hue + hueShift) % 360).toColor();
  }
}

ColorValue findThemeColor(String c) {
  return ColorValue.values.where((v) => v.name == c).firstOrNull ?? ColorValue.ocean;
}
