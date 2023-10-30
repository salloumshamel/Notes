import 'package:flutter/material.dart';
import 'dart:math';

class ThemeProvider extends ChangeNotifier {}

class MyColors {

  static List<Color> lightColors = _generateLightColors(colors);
  static Color darkColor = const Color(0xff202124);
  static List<Color> _generateLightColors(List<Color> originalColors) {
    List<Color> lightColors = [];
    for (Color color in originalColors) {
      int red = color.red;
      int green = color.green;
      int blue = color.blue;
      int alpha = color.alpha;
      int newAlpha = (alpha * 0.5).round();
      Color lightColor = Color.fromARGB(newAlpha, red, green, blue);
      lightColors.add(lightColor);
    }
    return lightColors;
  }
  static List<Color> colors = const [
    Color(0xFFCDFFA6), // #CDFFA6 (Light Green)
    Color(0xFFF3E09E), // #F3E09E (Light Yellow)
    Color(0xFFF29CDF), // #F29CDF (Light Pink)
    Color(0xFF9AD3E3), // #9AD3E3 (Light Blue)
  ];
  static Color getRandomColor() {
    final Random random = Random();
    return colors[random.nextInt(colors.length)];
  }
}
