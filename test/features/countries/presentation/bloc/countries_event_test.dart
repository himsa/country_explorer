import 'package:flutter_test/flutter_test.dart';

import 'package:countries_explorer/features/countries/presentation/bloc/countries_event.dart';

void main() {
  group('CountriesEvent', () {
    group('LoadCountries', () {
      test('should create LoadCountries event', () {
        // arrange & act
        final event = LoadCountries();

        // assert
        expect(event, isA<LoadCountries>());
      });

      test('should be equal to other LoadCountries events', () {
        // arrange
        final event1 = LoadCountries();
        final event2 = LoadCountries();

        // act & assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should have empty props', () {
        // arrange
        final event = LoadCountries();

        // act & assert
        expect(event.props, isEmpty);
      });
    });

    group('RefreshCountries', () {
      test('should create RefreshCountries event', () {
        // arrange & act
        final event = RefreshCountries();

        // assert
        expect(event, isA<RefreshCountries>());
      });

      test('should be equal to other RefreshCountries events', () {
        // arrange
        final event1 = RefreshCountries();
        final event2 = RefreshCountries();

        // act & assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should have empty props', () {
        // arrange
        final event = RefreshCountries();

        // act & assert
        expect(event.props, isEmpty);
      });
    });

    group('LoadCountryDetail', () {
      test('should create LoadCountryDetail with country name', () {
        // arrange & act
        const event = LoadCountryDetail('Indonesia');

        // assert
        expect(event.name, 'Indonesia');
      });

      test('should be equal when country names are same', () {
        // arrange
        const event1 = LoadCountryDetail('Indonesia');
        const event2 = LoadCountryDetail('Indonesia');

        // act & assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should not be equal when country names are different', () {
        // arrange
        const event1 = LoadCountryDetail('Indonesia');
        const event2 = LoadCountryDetail('Malaysia');

        // act & assert
        expect(event1, isNot(equals(event2)));
      });

      test('should have correct props', () {
        // arrange
        const event = LoadCountryDetail('Indonesia');

        // act & assert
        expect(event.props, ['Indonesia']);
      });
    });

    group('ReturnToCountriesList', () {
      test('should create ReturnToCountriesList event', () {
        // arrange & act
        final event = ReturnToCountriesList();

        // assert
        expect(event, isA<ReturnToCountriesList>());
      });

      test('should be equal to other ReturnToCountriesList events', () {
        // arrange
        final event1 = ReturnToCountriesList();
        final event2 = ReturnToCountriesList();

        // act & assert
        expect(event1, equals(event2));
        expect(event1.hashCode, equals(event2.hashCode));
      });

      test('should have empty props', () {
        // arrange
        final event = ReturnToCountriesList();

        // act & assert
        expect(event.props, isEmpty);
      });
    });
  });
}
