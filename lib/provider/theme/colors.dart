import 'package:flutter/material.dart';

enum ColorValue { ocean, cherry, leaves, pine, coffee, night }

Color themeColor(ColorValue c) {
  switch (c) {
    case ColorValue.ocean:
      return const Color(0xFF36B0DC);
    case ColorValue.cherry:
      return const Color(0xFFFFD9FF);
    case ColorValue.leaves:
      return const Color(0xFF57AD52);
    case ColorValue.pine:
      return const Color(0xFF2CB696);
    case ColorValue.coffee:
      return const Color(0xFFA54D29);
    case ColorValue.night:
      return const Color(0xFF3648E2);
  }
}

String themeColorName(ColorValue c) {
  switch (c) {
    case ColorValue.ocean:
      return "Ocean";
    case ColorValue.cherry:
      return "Cherry";
    case ColorValue.leaves:
      return "Leaves";
    case ColorValue.pine:
      return "Forrest";
    case ColorValue.coffee:
      return "Coffee";
    case ColorValue.night:
      return "Midnight";
  }
}
