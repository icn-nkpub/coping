import 'package:flutter/material.dart';

enum ColorValue {
  ocean(name: 'Ocean', canvas: Color(0xFF4CB6EE)),
  midnight(name: 'Midnight', canvas: Color(0xFF7C5DE2)),
  cherry(name: 'Cherry', canvas: Color(0xFFF63322)),
  honey(name: 'Honey', canvas: Color(0xFFF97B0C)),
  garden(name: 'Garden', canvas: Color(0xFF9ACF5C)),
  pine(name: 'Pine', canvas: Color(0xFF29B898));

  const ColorValue({
    required this.name,
    required this.canvas,
  });

  final String name;
  final Color canvas;

  Color get primary => HSLColor.fromColor(canvas).withLightness(.1).withSaturation(.1).toColor();
}

ColorValue findThemeColor(final String c) => ColorValue.values.where((final v) => v.name == c).firstOrNull ?? ColorValue.ocean;
