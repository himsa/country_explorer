import 'package:flutter_test/flutter_test.dart';

import 'package:countries_explorer/core/navigation/navigation_event.dart';

void main() {
  group('NavigationEvent', () {
    group('NavigateToCountryDetail', () {
      test('should create NavigateToCountryDetail with country name', () {
        // arrange & act
        const event = NavigateToCountryDetail('Indonesia');

        // assert
        expect(event.countryName, 'Indonesia');
      });

      test('should be equal when country names are same', () {
        // arrange
        const event1 = NavigateToCountryDetail('Indonesia');
        const event2 = NavigateToCountryDetail('Indonesia');

        // act & assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should not be equal when country names are different', () {
        // arrange
        const event1 = NavigateToCountryDetail('Indonesia');
        const event2 = NavigateToCountryDetail('Malaysia');

        // act & assert
        expect(event1, isNot(equals(event2)));
      });

      test('should have correct props', () {
        // arrange
        const event = NavigateToCountryDetail('Indonesia');

        // act & assert
        expect(event.props, ['Indonesia']);
      });
    });

    group('NavigateBack', () {
      test('should create NavigateBack event', () {
        // arrange & act
        const event = NavigateBack();

        // assert
        expect(event, isA<NavigateBack>());
      });

      test('should be equal to other NavigateBack events', () {
        // arrange
        const event1 = NavigateBack();
        const event2 = NavigateBack();

        // act & assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should have empty props', () {
        // arrange
        const event = NavigateBack();

        // act & assert
        expect(event.props, isEmpty);
      });
    });

    group('ScheduleReturnNavigation', () {
      test('should create ScheduleReturnNavigation event', () {
        // arrange & act
        const event = ScheduleReturnNavigation();

        // assert
        expect(event, isA<ScheduleReturnNavigation>());
      });

      test('should be equal to other ScheduleReturnNavigation events', () {
        // arrange
        const event1 = ScheduleReturnNavigation();
        const event2 = ScheduleReturnNavigation();

        // act & assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should have empty props', () {
        // arrange
        const event = ScheduleReturnNavigation();

        // act & assert
        expect(event.props, isEmpty);
      });
    });

    group('RequestCachedFlagEmoji', () {
      test('should create RequestCachedFlagEmoji with country name', () {
        // arrange & act
        const event = RequestCachedFlagEmoji('Indonesia');

        // assert
        expect(event.countryName, 'Indonesia');
      });

      test('should be equal when country names are same', () {
        // arrange
        const event1 = RequestCachedFlagEmoji('Indonesia');
        const event2 = RequestCachedFlagEmoji('Indonesia');

        // act & assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should not be equal when country names are different', () {
        // arrange
        const event1 = RequestCachedFlagEmoji('Indonesia');
        const event2 = RequestCachedFlagEmoji('Malaysia');

        // act & assert
        expect(event1, isNot(equals(event2)));
      });

      test('should have correct props', () {
        // arrange
        const event = RequestCachedFlagEmoji('Indonesia');

        // act & assert
        expect(event.props, ['Indonesia']);
      });
    });

    group('ScheduleDataLoading', () {
      test('should create ScheduleDataLoading with country name', () {
        // arrange & act
        const event = ScheduleDataLoading('Indonesia');

        // assert
        expect(event.countryName, 'Indonesia');
      });

      test('should be equal when country names are same', () {
        // arrange
        const event1 = ScheduleDataLoading('Indonesia');
        const event2 = ScheduleDataLoading('Indonesia');

        // act & assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should not be equal when country names are different', () {
        // arrange
        const event1 = ScheduleDataLoading('Indonesia');
        const event2 = ScheduleDataLoading('Malaysia');

        // act & assert
        expect(event1, isNot(equals(event2)));
      });

      test('should have correct props', () {
        // arrange
        const event = ScheduleDataLoading('Indonesia');

        // act & assert
        expect(event.props, ['Indonesia']);
      });
    });
  });
}
