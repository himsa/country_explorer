import 'package:flutter_test/flutter_test.dart';

import 'package:countries_explorer/features/countries/domain/entities/country.dart';
import 'package:countries_explorer/features/countries/presentation/bloc/countries_state.dart';

/// Test suite for CountriesState classes
/// Tests the state management for countries list and detail views
/// Covers all state types: initial, loading, loaded, error, and detail states
/// Ensures proper equality, props, and state transitions
void main() {
  group('CountriesState', () {
    group('CountriesInitial', () {
      test('should create CountriesInitial state', () {
        // arrange & act
        final state = CountriesInitial();

        // assert
        expect(state, isA<CountriesInitial>());
      });

      test('should be equal to other CountriesInitial states', () {
        // arrange
        final state1 = CountriesInitial();
        final state2 = CountriesInitial();

        // act & assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should have empty props', () {
        // arrange
        final state = CountriesInitial();

        // act & assert
        expect(state.props, isEmpty);
      });
    });

    group('CountriesLoading', () {
      test(
        'should create CountriesLoading with default empty countries list',
        () {
          // arrange & act
          const state = CountriesLoading();

          // assert
          expect(state.countries, isEmpty);
        },
      );

      test('should create CountriesLoading with provided countries list', () {
        // arrange
        const countries = [
          Country(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
        ];

        // act
        const state = CountriesLoading(countries: countries);

        // assert
        expect(state.countries, countries);
      });

      test('should be equal when countries lists are same', () {
        // arrange
        const countries = [
          Country(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
        ];
        const state1 = CountriesLoading(countries: countries);
        const state2 = CountriesLoading(countries: countries);

        // act & assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when countries lists are different', () {
        // arrange
        const countries1 = [
          Country(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
        ];
        const countries2 = [
          Country(name: 'Malaysia', flagEmoji: '🇲🇾', capital: 'Kuala Lumpur'),
        ];
        const state1 = CountriesLoading(countries: countries1);
        const state2 = CountriesLoading(countries: countries2);

        // act & assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should have correct props', () {
        // arrange
        const countries = [
          Country(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
        ];
        const state = CountriesLoading(countries: countries);

        // act & assert
        expect(state.props, [countries]);
      });
    });

    group('CountriesLoaded', () {
      test('should create CountriesLoaded with default isFromCache false', () {
        // arrange
        const countries = [
          Country(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
        ];

        // act
        const state = CountriesLoaded(countries);

        // assert
        expect(state.countries, countries);
        expect(state.isFromCache, false);
      });

      test('should create CountriesLoaded with isFromCache true', () {
        // arrange
        const countries = [
          Country(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
        ];

        // act
        const state = CountriesLoaded(countries, isFromCache: true);

        // assert
        expect(state.countries, countries);
        expect(state.isFromCache, true);
      });

      test('should be equal when countries and isFromCache are same', () {
        // arrange
        const countries = [
          Country(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
        ];
        const state1 = CountriesLoaded(countries, isFromCache: true);
        const state2 = CountriesLoaded(countries, isFromCache: true);

        // act & assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when isFromCache is different', () {
        // arrange
        const countries = [
          Country(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
        ];
        const state1 = CountriesLoaded(countries, isFromCache: true);
        const state2 = CountriesLoaded(countries, isFromCache: false);

        // act & assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should not be equal when countries are different', () {
        // arrange
        const countries1 = [
          Country(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
        ];
        const countries2 = [
          Country(name: 'Malaysia', flagEmoji: '🇲🇾', capital: 'Kuala Lumpur'),
        ];
        const state1 = CountriesLoaded(countries1);
        const state2 = CountriesLoaded(countries2);

        // act & assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should have correct props', () {
        // arrange
        const countries = [
          Country(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
        ];
        const state = CountriesLoaded(countries, isFromCache: true);

        // act & assert
        expect(state.props, [countries, true]);
      });
    });

    group('CountryDetailLoaded', () {
      test(
        'should create CountryDetailLoaded with default empty countries list',
        () {
          // arrange
          const country = Country(
            name: 'Indonesia',
            flagEmoji: '🇮🇩',
            capital: 'Jakarta',
          );

          // act
          const state = CountryDetailLoaded(country);

          // assert
          expect(state.country, country);
          expect(state.countries, isEmpty);
        },
      );

      test(
        'should create CountryDetailLoaded with provided countries list',
        () {
          // arrange
          const country = Country(
            name: 'Indonesia',
            flagEmoji: '🇮🇩',
            capital: 'Jakarta',
          );
          const countries = [country];

          // act
          const state = CountryDetailLoaded(country, countries: countries);

          // assert
          expect(state.country, country);
          expect(state.countries, countries);
        },
      );

      test('should be equal when country and countries are same', () {
        // arrange
        const country = Country(
          name: 'Indonesia',
          flagEmoji: '🇮🇩',
          capital: 'Jakarta',
        );
        const countries = [country];
        const state1 = CountryDetailLoaded(country, countries: countries);
        const state2 = CountryDetailLoaded(country, countries: countries);

        // act & assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when country is different', () {
        // arrange
        const country1 = Country(
          name: 'Indonesia',
          flagEmoji: '🇮🇩',
          capital: 'Jakarta',
        );
        const country2 = Country(
          name: 'Malaysia',
          flagEmoji: '🇲🇾',
          capital: 'Kuala Lumpur',
        );
        const state1 = CountryDetailLoaded(country1);
        const state2 = CountryDetailLoaded(country2);

        // act & assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should not be equal when countries are different', () {
        // arrange
        const country = Country(
          name: 'Indonesia',
          flagEmoji: '🇮🇩',
          capital: 'Jakarta',
        );
        const countries1 = [country];
        const countries2 = [
          Country(name: 'Malaysia', flagEmoji: '🇲🇾', capital: 'Kuala Lumpur'),
        ];
        const state1 = CountryDetailLoaded(country, countries: countries1);
        const state2 = CountryDetailLoaded(country, countries: countries2);

        // act & assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should have correct props', () {
        // arrange
        const country = Country(
          name: 'Indonesia',
          flagEmoji: '🇮🇩',
          capital: 'Jakarta',
        );
        const countries = [country];
        const state = CountryDetailLoaded(country, countries: countries);

        // act & assert
        expect(state.props, [country, countries]);
      });
    });

    group('CountriesError', () {
      test('should create CountriesError with message', () {
        // arrange & act
        const state = CountriesError('Test error message');

        // assert
        expect(state.message, 'Test error message');
      });

      test('should be equal when messages are same', () {
        // arrange
        const state1 = CountriesError('Test error message');
        const state2 = CountriesError('Test error message');

        // act & assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when messages are different', () {
        // arrange
        const state1 = CountriesError('Test error message 1');
        const state2 = CountriesError('Test error message 2');

        // act & assert
        expect(state1, isNot(equals(state2)));
        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should have correct props', () {
        // arrange
        const state = CountriesError('Test error message');

        // act & assert
        expect(state.props, ['Test error message']);
      });
    });
  });
}
