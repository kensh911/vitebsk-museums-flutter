import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  bool get isWide => screenWidth >= 600;
  bool get isVeryWide => screenWidth >= 1200;
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  double widthFraction(double fraction) => screenWidth * fraction;
}