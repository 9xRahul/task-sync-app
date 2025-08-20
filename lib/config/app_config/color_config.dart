import 'package:flutter/material.dart';

class ColorConfig {
  ColorConfig._(); // Private constructor → prevents instantiation

  // Primary brand colors
  static const Color primary = Color.fromARGB(255, 164, 216, 216);
  static const Color primaryDark = Color(0xFF357ABD);
  static const Color primaryLight = Color(0xFF82B1FF);

  // Accent colors
  static const Color accent = Color(0xFFFFC107);
  static const Color accentDark = Color(0xFFFFA000);

  // Neutral colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFDDDDDD);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  //Appbar
  static const Color appBArIconColor = Color(0xFFFFFFFF);

  //homeScreen
  static const Color selectedCategoryItemColor = Color(0xFFFFFFFF);
  static const Color unSelectedCategoryItemColor = Colors.pink;
  static const Color backTextColor = Color(0xFF000000);

  static var unSelectedCategoryItem;
}
