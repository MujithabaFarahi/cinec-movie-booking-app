import 'package:flutter/material.dart';

extension MediaQueryValues on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get topPadding => MediaQuery.of(this).padding.top;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;
  Orientation get orientation => MediaQuery.of(this).orientation;
  double get safeHeight =>
      (MediaQuery.of(this).size.height -
      MediaQuery.of(this).padding.top -
      MediaQuery.of(this).padding.bottom -
      kToolbarHeight);
  double get safeBottomHeight =>
      (MediaQuery.of(this).size.height - MediaQuery.of(this).padding.bottom);
}
