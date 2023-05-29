import 'package:flutter/material.dart';

enum ColorValue { ocean, cherry, leaves, pine, night }

Color themeColor(ColorValue c) {
  switch (c) {
    case ColorValue.ocean:
      return Colors.blue;
    case ColorValue.cherry:
      return Colors.pink;
    case ColorValue.leaves:
      return Colors.green;
    case ColorValue.pine:
      return Color.alphaBlend(Colors.green.withOpacity(.5), Colors.blue.withOpacity(.5));
    case ColorValue.night:
      return Color.alphaBlend(Colors.purple.withOpacity(.3), Colors.blue.withOpacity(.7));
  }
}

String themeColorName(ColorValue c) {
  switch (c) {
    case ColorValue.ocean:
      return 'Ocean';
    case ColorValue.cherry:
      return 'Cherry';
    case ColorValue.leaves:
      return 'Leaves';
    case ColorValue.pine:
      return 'Forrest';
    case ColorValue.night:
      return 'Midnight';
  }
}
