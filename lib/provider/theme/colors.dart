import 'package:flutter/material.dart';

enum ColorValue {
  ocean(name: 'Ocean', canvas: Color(0xFF4bcffa)),
  cherry(name: 'Cherry', canvas: Color(0xFFff5e57)),
  rose(name: 'Rose', canvas: Color(0xFFef5777)),
  forest(name: 'Forest', canvas: Color(0xFF575fcf)),
  garden(name: 'Garden', canvas: Color(0xFF05c46b)),
  sun(name: 'Sun', canvas: Color(0xFFffc048));

  const ColorValue({
    required this.name,
    required this.canvas,
  });

  final String name;
  final Color canvas;

  Color get primary => HSLColor.fromColor(canvas).withLightness(.1).withSaturation(.1).toColor();
}

ColorValue findThemeColor(String c) {
  return ColorValue.values.where((v) => v.name == c).firstOrNull ?? ColorValue.ocean;
}
