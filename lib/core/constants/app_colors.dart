import 'package:flutter/material.dart';

class AppColors {
  // Brand Palette (User Specified Warm Elegant Palette)
  static const Color background = Color(0xFFFAF6F0);   // Soft Creamy Off-White (#FAF6F0)
  static const Color surface = Color(0xFFFFFFFF);      // Pure White (#FFFFFF)
  static const Color surfaceLight = Color(0xFFF5EFE6); // Warm Sand Off-White Light
  static const Color cardBg = Color(0xFFFFFFFF);       // Pure White
  static const Color borders = Color(0xFFE8DFD3);      // Soft Sand Beige (#E8DFD3)

  // Accents & Brand Primary
  static const Color primary = Color(0xFFB68D68);      // Warm Bronze / Elegant Tan (#B68D68)
  static const Color primaryDark = Color(0xFF9E7350);  // Deep Warm Bronze
  static const Color secondary = Color(0xFF7A695A);    // Muted Warm Taupe (#7A695A)
  static const Color accent = Color(0xFFD4AF37);       // Warm Muted Gold

  // Text
  static const Color textPrimary = Color(0xFF2C1E14);   // Deep Espresso / Coffee Brown (#2C1E14)
  static const Color textSecondary = Color(0xFF7A695A); // Muted Warm Taupe (#7A695A)
  static const Color textMuted = Color(0xFF9C8C7C);     // Muted Taupe Light

  // Table Status Colors (Harmonized with Warm Palette)
  static const Color tableAvailable = Color(0xFF2E7D32); // Forest Green
  static const Color tableOccupied = Color(0xFFC62828);  // Deep Crimson
  static const Color tableBilled = Color(0xFFD97706);    // Warm Amber
  static const Color tableReserved = Color(0xFF2563EB);  // Cobalt Blue

  // Functional & Alerts
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFC62828);
  static const Color info = Color(0xFF2563EB);

  // Food Category Badges
  static const Color veg = Color(0xFF2E7D32);     // Green dot
  static const Color nonVeg = Color(0xFFC62828);  // Red dot

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFB68D68), Color(0xFF9E7350)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF2C1E14), Color(0xFF4A3728)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

