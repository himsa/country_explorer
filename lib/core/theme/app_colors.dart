import 'package:flutter/material.dart';

/// Application color palette
///
/// This file contains all the colors used throughout the application,
/// organized by category for easy maintenance and consistency.
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  /// Primary Colors
  static const Color primary = Color(0xFF6366F1); // Modern indigo
  static const Color primaryLight = Color(0xFF8B5CF6); // Purple accent
  static const Color primaryDark = Color(0xFF4F46E5); // Darker indigo

  /// Background Colors
  static const Color background = Color(0xFFF8FAFC); // Light gray background
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F5F9); // Light gray variant

  /// Text Colors
  static const Color textPrimary = Color(0xFF1F2937); // Dark gray
  static const Color textSecondary = Color(0xFF374151); // Medium gray
  static const Color textTertiary = Color(0xFF6B7280); // Light gray
  static const Color textDisabled = Color(0xFF9CA3AF); // Disabled gray

  /// Border Colors
  static const Color border = Color(0xFFE2E8F0); // Light border
  static const Color borderLight = Color(0xFFE5E7EB); // Lighter border
  static const Color borderDark = Color(0xFFD1D5DB); // Darker border

  /// Status Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFDC2626); // Red
  static const Color info = Color(0xFF3B82F6); // Blue

  /// Background Colors for Status
  static const Color errorBackground = Color(
    0xFFFEF2F2,
  ); // Light red background
  static const Color warningBackground = Color(
    0xFFFFFBEB,
  ); // Light yellow background
  static const Color successBackground = Color(
    0xFFF0FDF4,
  ); // Light green background
  static const Color infoBackground = Color(
    0xFFEFF6FF,
  ); // Light blue background

  /// Shadow Colors
  static const Color shadow = Color(0xFF1F2937); // Dark shadow
  static const Color shadowLight = Color(0xFF6B7280); // Light shadow

  /// Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
  ];

  static const List<Color> backgroundGradient = [
    Colors.white,
    Color(0xFFF8FAFC),
  ];

  static const List<Color> flagGradient = [
    Color(0xFFF8FAFC),
    Color(0xFFF1F5F9),
  ];

  static const List<Color> loadingGradient = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
  ];

  static const List<Color> errorGradient = [
    Color(0xFFFEF2F2),
    Color(0xFFFEE2E2),
  ];

  /// Opacity Variants
  static Color get primaryWithOpacity => primary.withValues(alpha: 0.1);
  static Color get primaryLightWithOpacity =>
      primaryLight.withValues(alpha: 0.1);
  static Color get errorWithOpacity => error.withValues(alpha: 0.1);
  static Color get shadowWithOpacity => shadow.withValues(alpha: 0.04);
  static Color get shadowLightWithOpacity => shadow.withValues(alpha: 0.02);

  /// Material Color Scheme
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: primary,
    secondary: primaryLight,
    surface: surface,
    error: error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: textPrimary,
    onError: Colors.white,
  );
}
