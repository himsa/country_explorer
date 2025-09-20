import 'package:equatable/equatable.dart';

// Navigation Events
abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

class NavigateToCountryDetail extends NavigationEvent {
  final String countryName;
  const NavigateToCountryDetail(this.countryName);

  @override
  List<Object?> get props => [countryName];
}

class NavigateBack extends NavigationEvent {
  const NavigateBack();
}

class ScheduleReturnNavigation extends NavigationEvent {
  const ScheduleReturnNavigation();
}

class RequestCachedFlagEmoji extends NavigationEvent {
  final String countryName;
  const RequestCachedFlagEmoji(this.countryName);

  @override
  List<Object?> get props => [countryName];
}

class ScheduleDataLoading extends NavigationEvent {
  final String countryName;
  const ScheduleDataLoading(this.countryName);

  @override
  List<Object?> get props => [countryName];
}
