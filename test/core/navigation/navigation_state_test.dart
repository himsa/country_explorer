import 'package:flutter_test/flutter_test.dart';

import 'package:countries_explorer/core/navigation/navigation_state.dart';

/// Test suite for NavigationState classes
/// Tests the navigation state management for app navigation flow
/// Covers all navigation states: initial, navigation events, and scheduled actions
/// Ensures proper equality, props, and state transitions
void main() {
  group('NavigationState', () {
    group('NavigationInitial', () {
      test('should create NavigationInitial state', () {
        // arrange & act
        final state = NavigationInitial();

        // assert
        expect(state, isA<NavigationInitial>());
      });

      test('should be equal to other NavigationInitial states', () {
        // arrange
        final state1 = NavigationInitial();
        final state2 = NavigationInitial();

        // act & assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should have empty props', () {
        // arrange
        final state = NavigationInitial();

        // act & assert
        expect(state.props, isEmpty);
      });
    });

    group('NavigateToDetail', () {
      test('should create NavigateToDetail with country name', () {
        // arrange & act
        const state = NavigateToDetail('Indonesia');

        // assert
        expect(state.countryName, 'Indonesia');
      });

      test('should be equal when country names are same', () {
        // arrange
        const state1 = NavigateToDetail('Indonesia');
        const state2 = NavigateToDetail('Indonesia');

        // act & assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when country names are different', () {
        // arrange
        const state1 = NavigateToDetail('Indonesia');
        const state2 = NavigateToDetail('Malaysia');

        // act & assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should have correct props', () {
        // arrange
        const state = NavigateToDetail('Indonesia');

        // act & assert
        expect(state.props, ['Indonesia']);
      });
    });

    group('NavigateBackToCountries', () {
      test('should create NavigateBackToCountries state', () {
        // arrange & act
        const state = NavigateBackToCountries();

        // assert
        expect(state, isA<NavigateBackToCountries>());
      });

      test('should be equal to other NavigateBackToCountries states', () {
        // arrange
        const state1 = NavigateBackToCountries();
        const state2 = NavigateBackToCountries();

        // act & assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should have empty props', () {
        // arrange
        const state = NavigateBackToCountries();

        // act & assert
        expect(state.props, isEmpty);
      });
    });

    group('FlagEmojiProvided', () {
      test('should create FlagEmojiProvided with flag emoji', () {
        // arrange & act
        const state = FlagEmojiProvided('🇮🇩');

        // assert
        expect(state.flagEmoji, '🇮🇩');
      });

      test('should be equal when flag emojis are same', () {
        // arrange
        const state1 = FlagEmojiProvided('🇮🇩');
        const state2 = FlagEmojiProvided('🇮🇩');

        // act & assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when flag emojis are different', () {
        // arrange
        const state1 = FlagEmojiProvided('🇮🇩');
        const state2 = FlagEmojiProvided('🇺🇸');

        // act & assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should have correct props', () {
        // arrange
        const state = FlagEmojiProvided('🇮🇩');

        // act & assert
        expect(state.props, ['🇮🇩']);
      });
    });

    group('DataLoadingScheduled', () {
      test('should create DataLoadingScheduled with country name', () {
        // arrange & act
        const state = DataLoadingScheduled('Indonesia');

        // assert
        expect(state.countryName, 'Indonesia');
      });

      test('should be equal when country names are same', () {
        // arrange
        const state1 = DataLoadingScheduled('Indonesia');
        const state2 = DataLoadingScheduled('Indonesia');

        // act & assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when country names are different', () {
        // arrange
        const state1 = DataLoadingScheduled('Indonesia');
        const state2 = DataLoadingScheduled('Malaysia');

        // act & assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should have correct props', () {
        // arrange
        const state = DataLoadingScheduled('Indonesia');

        // act & assert
        expect(state.props, ['Indonesia']);
      });
    });

    group('ReturnNavigationScheduled', () {
      test('should create ReturnNavigationScheduled state', () {
        // arrange & act
        const state = ReturnNavigationScheduled();

        // assert
        expect(state, isA<ReturnNavigationScheduled>());
      });

      test('should be equal to other ReturnNavigationScheduled states', () {
        // arrange
        const state1 = ReturnNavigationScheduled();
        const state2 = ReturnNavigationScheduled();

        // act & assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should have empty props', () {
        // arrange
        const state = ReturnNavigationScheduled();

        // act & assert
        expect(state.props, isEmpty);
      });
    });
  });
}
