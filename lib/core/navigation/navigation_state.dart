import 'package:equatable/equatable.dart';

// Navigation States
abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object?> get props => [];
}

class NavigationInitial extends NavigationState {}

class NavigateToDetail extends NavigationState {
  final String countryName;
  const NavigateToDetail(this.countryName);

  @override
  List<Object?> get props => [countryName];
}

class NavigateBackToCountries extends NavigationState {
  const NavigateBackToCountries();
}

class FlagEmojiProvided extends NavigationState {
  final String flagEmoji;
  const FlagEmojiProvided(this.flagEmoji);

  @override
  List<Object?> get props => [flagEmoji];
}

class DataLoadingScheduled extends NavigationState {
  final String countryName;
  const DataLoadingScheduled(this.countryName);

  @override
  List<Object?> get props => [countryName];
}

class ReturnNavigationScheduled extends NavigationState {
  const ReturnNavigationScheduled();
}
