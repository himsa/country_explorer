/// Application constants and configuration values
///
/// This file contains all the constant values used throughout the application,
/// making it easy to maintain and update configuration settings.
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  /// Application information
  static const String appName = 'Countries Explorer';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'A modern Flutter mobile app for exploring countries with Clean Architecture and BLoC pattern.';

  /// API Configuration
  static const String baseUrl = 'https://restcountries.com/v3.1';
  static const String allCountriesEndpoint = '/all';
  static const String countryByNameEndpoint = '/name';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(hours: 24);

  /// UI Configuration
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  /// Border Radius
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 20.0;

  /// Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  /// Card Configuration
  static const double cardElevation = 0.0;
  static const double cardBorderWidth = 1.0;
  static const double cardMargin = 8.0;

  /// Flag Display Configuration
  static const double flagWidth = 120.0;
  static const double flagHeight = 80.0;
  static const double flagFontSize = 48.0;
  static const double flagBorderRadius = 12.0;

  /// Loading Configuration
  static const double loadingIndicatorSize = 32.0;
  static const double loadingStrokeWidth = 4.0;
  static const double loadingPadding = 32.0;

  /// Error Configuration
  static const double errorIconSize = 48.0;
  static const double errorPadding = 32.0;

  /// Typography Configuration
  static const String fontFamily = 'Inter';
  static const double letterSpacingTight = -1.0;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;

  /// Shadow Configuration
  static const double shadowBlurRadius = 8.0;
  static const double shadowSpreadRadius = 2.0;
  static const double shadowOffset = 2.0;
  static const double shadowOpacity = 0.04;

  /// Gradient Configuration
  static const double gradientOpacity = 0.1;
  static const double gradientErrorOpacity = 0.1;
  static const double gradientLoadingOpacity = 0.2;

  /// Cache Configuration
  static const String cachedCountriesKey = 'CACHED_COUNTRIES';
  static const String cacheTimestampKey = 'CACHE_TIMESTAMP';
}
