import 'package:flutter/material.dart';
import 'package:snotes/Controller/theme_provider.dart';

class Note {
  int id;
  String title;
  String description;
  DateTime date;
  Color color;
  Color lightColor = Colors.white;
  bool isComplete = false;

  Note({
    required this.title,
    required this.description,
    required this.date,
    required this.color,
    required this.isComplete,
    required this.id,
  }) {
    setLightColor();
  }

  void setIsComplete() {
    isComplete = !isComplete;
  }

  void setColor(Color color) {
    this.color = color;
    setLightColor();
  }

  void setLightColor() {
    lightColor = MyColors.lightColors[MyColors.colors.indexOf(color)];
  }
}
