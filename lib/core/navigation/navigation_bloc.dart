import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

// Navigation BLoC
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  // Cache for flag emojis
  final Map<String, String> _cachedFlagEmojis = {};

  NavigationBloc() : super(NavigationInitial()) {
    on<NavigateToCountryDetail>(_onNavigateToCountryDetail);
    on<NavigateBack>(_onNavigateBack);
    on<ScheduleReturnNavigation>(_onScheduleReturnNavigation);
    on<RequestCachedFlagEmoji>(_onRequestCachedFlagEmoji);
    on<ScheduleDataLoading>(_onScheduleDataLoading);
  }

  // Cache flag emojis when countries are loaded
  void cacheFlagEmojis(Map<String, String> flagEmojis) {
    _cachedFlagEmojis.addAll(flagEmojis);
  }

  Future<void> _onNavigateToCountryDetail(
    NavigateToCountryDetail event,
    Emitter<NavigationState> emit,
  ) async {
    // Emit navigation state immediately
    emit(NavigateToDetail(event.countryName));

    // Schedule delayed data loading
    add(ScheduleDataLoading(event.countryName));
  }

  Future<void> _onNavigateBack(
    NavigateBack event,
    Emitter<NavigationState> emit,
  ) async {
    // Emit navigation back state
    emit(const NavigateBackToCountries());
  }

  Future<void> _onScheduleReturnNavigation(
    ScheduleReturnNavigation event,
    Emitter<NavigationState> emit,
  ) async {
    // Schedule delayed return navigation with proper timing
    await Future.delayed(const Duration(milliseconds: 300));
    emit(const ReturnNavigationScheduled());
  }

  Future<void> _onRequestCachedFlagEmoji(
    RequestCachedFlagEmoji event,
    Emitter<NavigationState> emit,
  ) async {
    // Provide cached flag emoji or default
    final flagEmoji = _cachedFlagEmojis[event.countryName] ?? '🏳️';
    emit(FlagEmojiProvided(flagEmoji));
  }

  Future<void> _onScheduleDataLoading(
    ScheduleDataLoading event,
    Emitter<NavigationState> emit,
  ) async {
    // Schedule delayed data loading with proper timing
    await Future.delayed(const Duration(milliseconds: 200));
    emit(DataLoadingScheduled(event.countryName));
  }
}
