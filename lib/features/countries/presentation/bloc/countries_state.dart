import 'package:equatable/equatable.dart';
import '../../domain/entities/country.dart';

abstract class CountriesState extends Equatable {
  const CountriesState();

  @override
  List<Object?> get props => [];
}

class CountriesInitial extends CountriesState {}

class CountriesLoading extends CountriesState {
  final List<Country> countries;
  const CountriesLoading({this.countries = const []});

  @override
  List<Object?> get props => [countries];
}

class CountriesLoaded extends CountriesState {
  final List<Country> countries;
  final bool isFromCache;
  const CountriesLoaded(this.countries, {this.isFromCache = false});

  @override
  List<Object?> get props => [countries, isFromCache];
}

class CountryDetailLoaded extends CountriesState {
  final Country country;
  const CountryDetailLoaded(this.country);

  @override
  List<Object?> get props => [country];
}

class CountriesError extends CountriesState {
  final String message;
  const CountriesError(this.message);

  @override
  List<Object?> get props => [message];
}
