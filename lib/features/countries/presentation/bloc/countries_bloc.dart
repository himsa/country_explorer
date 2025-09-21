import 'package:flutter_bloc/flutter_bloc.dart';
import 'countries_event.dart';
import 'countries_state.dart';
import '../../../../core/navigation/navigation_bloc.dart';
import '../../domain/usecases/get_countries.dart';
import '../../domain/usecases/get_country_detail.dart';
import '../../domain/entities/country.dart';
import '../../../../core/usecases/usecase.dart';

/// Main BLoC for managing countries data and state
///
/// This BLoC handles all countries-related state management including:
/// - Loading countries list from API
/// - Refreshing countries data
/// - Loading individual country details
/// - Managing navigation between list and detail views
/// - Preserving state during navigation
///
/// The BLoC follows the coding test requirements by:
/// - Emitting Loading, Loaded(List[Country]), and Error states
/// - Coordinating with NavigationBloc for navigation
/// - Preserving countries list during detail navigation
/// - Handling both success and failure scenarios
class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  /// Use case for fetching all countries
  final GetCountries getCountries;

  /// Use case for fetching individual country details
  final GetCountryDetail getCountryDetail;

  /// Reference to NavigationBloc for coordinating navigation
  NavigationBloc? _navigationBloc;

  /// Preserved countries list for navigation state management
  /// This ensures the countries list is maintained when navigating
  /// between the list view and detail view
  List<Country> _preservedCountries = [];

  /// Creates a new CountriesBloc instance
  ///
  /// Registers all event handlers for the BLoC:
  /// - LoadCountries: Initial load of countries list
  /// - RefreshCountries: Pull-to-refresh functionality
  /// - LoadCountryDetail: Load individual country details
  /// - ReturnToCountriesList: Return from detail to list view
  CountriesBloc({required this.getCountries, required this.getCountryDetail})
    : super(CountriesInitial()) {
    on<LoadCountries>(_onLoadCountries);
    on<RefreshCountries>(_onRefreshCountries);
    on<LoadCountryDetail>(_onLoadCountryDetail);
    on<ReturnToCountriesList>(_onReturnToCountriesList);
  }

  /// Sets the NavigationBloc reference for coordination
  ///
  /// This method establishes the connection between CountriesBloc
  /// and NavigationBloc for proper navigation state management.
  void setNavigationBloc(NavigationBloc navigationBloc) {
    _navigationBloc = navigationBloc;
  }

  /// Handles the LoadCountries event
  ///
  /// This method:
  /// 1. Emits CountriesLoading state
  /// 2. Calls the GetCountries use case
  /// 3. Handles success/failure scenarios
  /// 4. Caches flag emojis in NavigationBloc for navigation
  /// 5. Preserves countries list for navigation state management
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
      // Cache flag emojis in NavigationBloc for hero animations
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

  /// Handles the RefreshCountries event (pull-to-refresh)
  ///
  /// This method:
  /// 1. Preserves current countries list during loading
  /// 2. Calls the GetCountries use case for fresh data
  /// 3. Handles success/failure scenarios
  /// 4. Updates preserved countries list
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

  /// Handles the LoadCountryDetail event
  ///
  /// This method:
  /// 1. Preserves current countries list for navigation
  /// 2. Emits loading state with preserved countries
  /// 3. Calls the GetCountryDetail use case
  /// 4. Handles success/failure scenarios
  /// 5. Emits CountryDetailLoaded state with both country and countries list
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

  /// Handles the ReturnToCountriesList event
  ///
  /// This method:
  /// 1. Restores the preserved countries list if available
  /// 2. Falls back to loading from cache if no preserved countries
  /// 3. Handles success/failure scenarios
  /// 4. Emits CountriesLoaded state with cache indication
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
