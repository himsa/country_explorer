import 'package:equatable/equatable.dart';

/// Core business entity representing a country
///
/// This is the central entity in the domain layer that represents
/// a country with all its essential information. It follows the
/// Clean Architecture principle of having pure business entities
/// that are independent of external frameworks.
///
/// The entity contains:
/// - Basic information: name, capital, flag emoji
/// - Statistical data: population, area
/// - Cultural data: languages, coat of arms
///
/// All properties are immutable to ensure data integrity and
/// proper state management in BLoC patterns.
class Country extends Equatable {
  /// The official name of the country
  final String name;

  /// Unicode flag emoji representing the country
  /// Generated from country code (cca2) using regional indicator symbols
  final String flagEmoji;

  /// The capital city of the country
  final String capital;

  /// Total population of the country (optional)
  final int? population;

  /// Total area of the country in square kilometers (optional)
  final double? area;

  /// List of official languages spoken in the country (optional)
  final List<String>? languages;

  /// URL to the country's coat of arms image (optional)
  final String? coatOfArmsUrl;

  const Country({
    required this.name,
    required this.flagEmoji,
    required this.capital,
    this.population,
    this.area,
    this.languages,
    this.coatOfArmsUrl,
  });

  @override
  List<Object?> get props => [
    name,
    flagEmoji,
    capital,
    population,
    area,
    languages,
    coatOfArmsUrl,
  ];
}
