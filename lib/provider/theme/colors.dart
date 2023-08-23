import 'package:flutter/material.dart';

enum ColorValue {
  ocean(name: 'Ocean', canvas: Color(0xFF4CB6EE)),
  midnight(name: 'Midnight', canvas: Color(0xFF7C5DE2)),
  cherry(name: 'Cherry', canvas: Color(0xFFF63322)),
  sun(name: 'Sun', canvas: Color(0xFFF97B0C)),
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

ColorValue findThemeColor(final String c) => ColorValue.values.where((final v) => v.name == c).firstOrNull ?? ColorValue.midnight;

String matchingImage(final ColorValue color, final ThemeMode mode) {
  String url;
  switch (color) {
    case ColorValue.ocean:
      url = mode == ThemeMode.light
          ? 'https://images.unsplash.com/photo-1541617219835-3689726fa8e7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=926&q=80'
          : 'https://images.unsplash.com/photo-1485955891060-a3318433e95f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=985&q=80';
    case ColorValue.midnight:
      url = mode == ThemeMode.light
          ? 'https://images.unsplash.com/photo-1558979142-19e920d27587?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=987&q=80'
          : 'https://images.unsplash.com/photo-1600806343209-d8f624917fbe?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=927&q=80';
    case ColorValue.cherry:
      url = mode == ThemeMode.light
          ? 'https://images.unsplash.com/photo-1563306206-900cc99112fc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1065&q=80'
          : 'https://images.unsplash.com/photo-1593073932946-fe6f4b260648?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=987&q=80';
    case ColorValue.sun:
      url = mode == ThemeMode.light
          ? 'https://images.unsplash.com/photo-1488462237308-ecaa28b729d7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=957&q=80'
          : 'https://images.unsplash.com/photo-1609171712489-45b6ba7051a4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=950&q=80';
    case ColorValue.garden:
      url = mode == ThemeMode.light
          ? 'https://images.unsplash.com/photo-1612979168715-3dde2d721351?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=987&q=80'
          : 'https://images.unsplash.com/photo-1574002332972-fd2e0f7f1ea9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1015&q=80';
    case ColorValue.pine:
      url = mode == ThemeMode.light
          ? 'https://images.unsplash.com/photo-1628865742273-e81bb0e38b5f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1035&q=80'
          : 'https://images.unsplash.com/photo-1531951665218-b8b598959072?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=987&q=80';
  }
  return url;
}
