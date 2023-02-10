import 'package:flutter/material.dart';

extension SizeExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  double percentWidth(double parcent) => screenWidth * parcent;
  double percentHeight(double parcent) => screenHeight * parcent;
}
