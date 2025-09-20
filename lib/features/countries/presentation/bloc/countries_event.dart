import 'package:equatable/equatable.dart';

abstract class CountriesEvent extends Equatable {
  const CountriesEvent();

  @override
  List<Object?> get props => [];
}

class LoadCountries extends CountriesEvent {}

class RefreshCountries extends CountriesEvent {}

class LoadCountryDetail extends CountriesEvent {
  final String name;
  const LoadCountryDetail(this.name);

  @override
  List<Object?> get props => [name];
}

class ReturnToCountriesList extends CountriesEvent {}
