import 'package:flutter_bloc/flutter_bloc.dart';
import 'countries_event.dart';
import 'countries_state.dart';
import '../../../../core/navigation/navigation_bloc.dart';
import '../../domain/usecases/get_countries.dart';
import '../../domain/usecases/get_country_detail.dart';
import '../../domain/entities/country.dart';
import '../../../../core/usecases/usecase.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  final GetCountries getCountries;
  final GetCountryDetail getCountryDetail;
  NavigationBloc? _navigationBloc;

  // Preserve countries list when navigating to detail
  List<Country> _preservedCountries = [];

  CountriesBloc({required this.getCountries, required this.getCountryDetail})
    : super(CountriesInitial()) {
    on<LoadCountries>(_onLoadCountries);
    on<RefreshCountries>(_onRefreshCountries);
    on<LoadCountryDetail>(_onLoadCountryDetail);
    on<ReturnToCountriesList>(_onReturnToCountriesList);
  }

  // Set navigation bloc reference
  void setNavigationBloc(NavigationBloc navigationBloc) {
    _navigationBloc = navigationBloc;
  }

  Future<void> _onLoadCountries(
    LoadCountries event,
    Emitter<CountriesState> emit,
  ) async {
    emit(const CountriesLoading());
    final result = await getCountries(NoParams());
    result.fold((failure) => emit(CountriesError(failure.message)), (
      countries,
    ) {
      _preservedCountries = countries;
      // Cache flag emojis in NavigationBloc
      if (_navigationBloc != null) {
        final flagEmojis = <String, String>{};
        for (final country in countries) {
          flagEmojis[country.name] = country.flagEmoji;
        }
        _navigationBloc!.cacheFlagEmojis(flagEmojis);
      }
      emit(CountriesLoaded(countries));
    });
  }

  Future<void> _onRefreshCountries(
    RefreshCountries event,
    Emitter<CountriesState> emit,
  ) async {
    final currentState = state;
    if (currentState is CountriesLoaded) {
      emit(CountriesLoading(countries: currentState.countries));
    } else {
      emit(const CountriesLoading());
    }

    final result = await getCountries(NoParams());
    result.fold((failure) => emit(CountriesError(failure.message)), (
      countries,
    ) {
      _preservedCountries = countries;
      emit(CountriesLoaded(countries));
    });
  }

  Future<void> _onLoadCountryDetail(
    LoadCountryDetail event,
    Emitter<CountriesState> emit,
  ) async {
    // Preserve current countries list when loading detail
    final currentState = state;
    List<Country> currentCountries = [];

    if (currentState is CountriesLoaded) {
      currentCountries = currentState.countries;
      // Keep the countries list in memory for when we return
      _preservedCountries = currentCountries;
      emit(CountriesLoading(countries: currentCountries));
    } else if (currentState is CountriesLoading) {
      currentCountries = currentState.countries;
      _preservedCountries = currentCountries;
      emit(CountriesLoading(countries: currentCountries));
    } else {
      emit(const CountriesLoading());
    }

    final result = await getCountryDetail(event.name);
    result.fold(
      (failure) => emit(CountriesError(failure.message)),
      (country) =>
          emit(CountryDetailLoaded(country, countries: currentCountries)),
    );
  }

  Future<void> _onReturnToCountriesList(
    ReturnToCountriesList event,
    Emitter<CountriesState> emit,
  ) async {
    // Restore the preserved countries list
    if (_preservedCountries.isNotEmpty) {
      emit(CountriesLoaded(_preservedCountries, isFromCache: true));
    } else {
      // If no preserved countries, try to load from cache
      final result = await getCountries(NoParams());
      result.fold(
        (failure) => emit(CountriesError(failure.message)),
        (countries) => emit(CountriesLoaded(countries, isFromCache: true)),
      );
    }
  }
}
