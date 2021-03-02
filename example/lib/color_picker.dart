import 'dart:math';

import 'package:flutter/material.dart';

class ColorPicker {
  ///
  /// powder blue
  ///
  static Color get color1 => Color.fromRGBO(154, 212, 214, 1);

  ///
  /// claret (red-ish)
  ///
  static Color get color2 => Color.fromRGBO(139, 30, 63, 1);

  ///
  /// gold crayola (yellow-ish)
  ///
  static Color get color3 => Color.fromRGBO(240, 201, 135, 1);

  ///
  /// verdigris
  ///
  static Color get color4 => Color.fromRGBO(71, 170, 174, 1);

  ///
  /// oxford blue
  ///
  static Color get color5 => Color.fromRGBO(16, 37, 66, 1);

  static List<Color> _colors = [
    color1,
    color2,
    color3,
    color4,
    color5,
  ];

  static Color pickMeARandomColor() {
    return _colors[Random().nextInt(_colors.length)];
  }
}
