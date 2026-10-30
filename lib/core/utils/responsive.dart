import 'package:flutter/material.dart';

/// Centralized Responsive Utility for Hotel Billing POS App
/// Handles breakpoints across Mobile (<600dp), Tablet (600-900dp), and Desktop/Large Tablet (>=900dp).
class Responsive {
  static const double mobileMax = 600.0;
  static const double tabletMax = 900.0;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileMax;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileMax && width < tabletMax;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletMax;
  }

  /// Evaluates and returns the appropriate value based on current device screen width
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= tabletMax && desktop != null) return desktop;
    if (width >= mobileMax && tablet != null) return tablet;
    return mobile;
  }

  /// Calculates dynamic grid column count based on target item width
  static int gridColumnCount(
    BuildContext context, {
    double itemWidth = 160.0,
    int minColumns = 2,
    int maxColumns = 6,
  }) {
    final availableWidth = MediaQuery.of(context).size.width;
    final count = (availableWidth / itemWidth).floor();
    return count.clamp(minColumns, maxColumns);
  }

  /// Returns responsive horizontal padding
  static EdgeInsets screenPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(12.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(16.0);
    } else {
      return const EdgeInsets.all(24.0);
    }
  }
}
