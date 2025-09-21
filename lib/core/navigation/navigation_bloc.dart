import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

/// Navigation BLoC for managing app navigation and coordination
///
/// This BLoC handles navigation state management and coordinates
/// between different parts of the app. It manages:
/// - Navigation between countries list and detail views
/// - Flag emoji caching for hero animations
/// - Scheduled navigation and data loading
/// - Return navigation with proper timing
///
/// The BLoC ensures smooth navigation transitions and proper
/// state coordination between CountriesBloc and UI components.
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  /// Cache for flag emojis to support hero animations
  /// Maps country names to their flag emojis for smooth transitions
  final Map<String, String> _cachedFlagEmojis = {};

  /// Creates a new NavigationBloc instance
  ///
  /// Registers all navigation event handlers:
  /// - NavigateToCountryDetail: Navigate to country detail page
  /// - NavigateBack: Navigate back to countries list
  /// - ScheduleReturnNavigation: Schedule return navigation with timing
  /// - RequestCachedFlagEmoji: Request cached flag emoji for animations
  /// - ScheduleDataLoading: Schedule data loading with proper timing
  NavigationBloc() : super(NavigationInitial()) {
    on<NavigateToCountryDetail>(_onNavigateToCountryDetail);
    on<NavigateBack>(_onNavigateBack);
    on<ScheduleReturnNavigation>(_onScheduleReturnNavigation);
    on<RequestCachedFlagEmoji>(_onRequestCachedFlagEmoji);
    on<ScheduleDataLoading>(_onScheduleDataLoading);
  }

  /// Caches flag emojis when countries are loaded
  ///
  /// This method is called by CountriesBloc when countries are loaded
  /// to cache flag emojis for smooth hero animations during navigation.
  void cacheFlagEmojis(Map<String, String> flagEmojis) {
    _cachedFlagEmojis.addAll(flagEmojis);
  }

  /// Handles navigation to country detail page
  ///
  /// This method:
  /// 1. Emits navigation state immediately for UI response
  /// 2. Schedules delayed data loading for smooth transitions
  Future<void> _onNavigateToCountryDetail(
    NavigateToCountryDetail event,
    Emitter<NavigationState> emit,
  ) async {
    // Emit navigation state immediately
    emit(NavigateToDetail(event.countryName));

    // Schedule delayed data loading
    add(ScheduleDataLoading(event.countryName));
  }

  /// Handles navigation back to countries list
  ///
  /// This method emits the navigation back state to trigger
  /// the return to the countries list view.
  Future<void> _onNavigateBack(
    NavigateBack event,
    Emitter<NavigationState> emit,
  ) async {
    // Emit navigation back state
    emit(const NavigateBackToCountries());
  }

  /// Handles scheduled return navigation with proper timing
  ///
  /// This method provides a delay to ensure smooth navigation
  /// transitions and proper state coordination.
  Future<void> _onScheduleReturnNavigation(
    ScheduleReturnNavigation event,
    Emitter<NavigationState> emit,
  ) async {
    // Schedule delayed return navigation with proper timing
    await Future.delayed(const Duration(milliseconds: 300));
    emit(const ReturnNavigationScheduled());
  }

  /// Handles requests for cached flag emojis
  ///
  /// This method provides cached flag emojis for hero animations
  /// or returns a default flag emoji if not cached.
  Future<void> _onRequestCachedFlagEmoji(
    RequestCachedFlagEmoji event,
    Emitter<NavigationState> emit,
  ) async {
    // Provide cached flag emoji or default
    final flagEmoji = _cachedFlagEmojis[event.countryName] ?? '🏳️';
    emit(FlagEmojiProvided(flagEmoji));
  }

  /// Handles scheduled data loading with proper timing
  ///
  /// This method provides a delay to ensure smooth data loading
  /// and proper coordination between navigation and data states.
  Future<void> _onScheduleDataLoading(
    ScheduleDataLoading event,
    Emitter<NavigationState> emit,
  ) async {
    // Schedule delayed data loading with proper timing
    await Future.delayed(const Duration(milliseconds: 200));
    emit(DataLoadingScheduled(event.countryName));
  }
}
