import 'package:flutter/material.dart';

class TextStyles {
  static const String fontFamily = 'Outfit';

  static TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      height: 1.12,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      height: 1.16,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      height: 1.22,
      fontWeight: FontWeight.w600,
      fontFamily: fontFamily,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      height: 1.25,
      fontWeight: FontWeight.w600,
      fontFamily: fontFamily,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      height: 1.29,
      fontWeight: FontWeight.w600,
      fontFamily: fontFamily,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      height: 1.33,
      fontWeight: FontWeight.w600,
      fontFamily: fontFamily,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      height: 1.27,
      fontWeight: FontWeight.w500,
      fontFamily: fontFamily,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      height: 1.5,
      fontWeight: FontWeight.w500,
      fontFamily: fontFamily,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      height: 1.43,
      fontWeight: FontWeight.w500,
      fontFamily: fontFamily,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      height: 1.43,
      fontWeight: FontWeight.w500,
      fontFamily: fontFamily,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      height: 1.33,
      fontWeight: FontWeight.w500,
      fontFamily: fontFamily,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      height: 1.45,
      fontWeight: FontWeight.w500,
      fontFamily: fontFamily,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      height: 1.5,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      height: 1.43,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      height: 1.33,
      fontWeight: FontWeight.normal,
      fontFamily: fontFamily,
    ),
  );
}
