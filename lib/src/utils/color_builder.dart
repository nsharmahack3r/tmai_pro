import 'package:flutter/widgets.dart';

class ColorBuilder {
  const ColorBuilder._();
  static Color getRandomColorFromClassName(String className) {
    final int hash = className.hashCode;
    final double hue = (hash.abs() % 360).toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.65, 0.50).toColor();
  }
}
