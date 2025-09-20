import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String name;
  final String flagEmoji;
  final String capital;
  final int? population;
  final double? area;
  final List<String>? languages;
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
