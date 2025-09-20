import 'package:flutter_test/flutter_test.dart';

import 'package:countries_explorer/features/countries/domain/entities/country.dart';
import 'package:countries_explorer/features/countries/presentation/bloc/countries_state.dart';

void main() {
  group('CountriesState', () {
    const tCountry = Country(
      name: 'Indonesia',
      flagEmoji: '🇮🇩',
      capital: 'Jakarta',
      population: 273523621,
      area: 1904569,
      languages: ['Indonesian'],
      coatOfArmsUrl: 'https://flagcdn.com/w320/id.png',
    );

    const tCountryList = [tCountry];

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
        // arrange & act
        const state = CountriesLoading(countries: tCountryList);

        // assert
        expect(state.countries, tCountryList);
      });

      test('should be equal when countries lists are same', () {
        // arrange
        const state1 = CountriesLoading(countries: tCountryList);
        const state2 = CountriesLoading(countries: tCountryList);

        // act & assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when countries lists are different', () {
        // arrange
        const state1 = CountriesLoading(countries: tCountryList);
        const state2 = CountriesLoading();

        // act & assert
        expect(state1, isNot(equals(state2)));
      });

      test('should have correct props', () {
        // arrange
        const state = CountriesLoading(countries: tCountryList);

        // act & assert
        expect(state.props, [tCountryList]);
      });
    });

    group('CountriesLoaded', () {
      test('should create CountriesLoaded with default isFromCache false', () {
        // arrange & act
        const state = CountriesLoaded(tCountryList);

        // assert
        expect(state.countries, tCountryList);
        expect(state.isFromCache, false);
      });

      test('should create CountriesLoaded with isFromCache true', () {
        // arrange & act
        const state = CountriesLoaded(tCountryList, isFromCache: true);

        // assert
        expect(state.countries, tCountryList);
        expect(state.isFromCache, true);
      });

      test('should be equal when countries and isFromCache are same', () {
        // arrange
        const state1 = CountriesLoaded(tCountryList, isFromCache: true);
        const state2 = CountriesLoaded(tCountryList, isFromCache: true);

        // act & assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when isFromCache is different', () {
        // arrange
        const state1 = CountriesLoaded(tCountryList, isFromCache: false);
        const state2 = CountriesLoaded(tCountryList, isFromCache: true);

        // act & assert
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when countries are different', () {
        // arrange
        const state1 = CountriesLoaded(tCountryList);
        const state2 = CountriesLoaded([]);

        // act & assert
        expect(state1, isNot(equals(state2)));
      });

      test('should have correct props', () {
        // arrange
        const state = CountriesLoaded(tCountryList, isFromCache: true);

        // act & assert
        expect(state.props, [tCountryList, true]);
      });
    });

    group('CountryDetailLoaded', () {
      test(
        'should create CountryDetailLoaded with default empty countries list',
        () {
          // arrange & act
          const state = CountryDetailLoaded(tCountry);

          // assert
          expect(state.country, tCountry);
          expect(state.countries, isEmpty);
        },
      );

      test(
        'should create CountryDetailLoaded with provided countries list',
        () {
          // arrange & act
          const state = CountryDetailLoaded(tCountry, countries: tCountryList);

          // assert
          expect(state.country, tCountry);
          expect(state.countries, tCountryList);
        },
      );

      test('should be equal when country and countries are same', () {
        // arrange
        const state1 = CountryDetailLoaded(tCountry, countries: tCountryList);
        const state2 = CountryDetailLoaded(tCountry, countries: tCountryList);

        // act & assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when country is different', () {
        // arrange
        const state1 = CountryDetailLoaded(tCountry, countries: tCountryList);
        const state2 = CountryDetailLoaded(
          Country(name: 'Malaysia', flagEmoji: '🇲🇾', capital: 'Kuala Lumpur'),
          countries: tCountryList,
        );

        // act & assert
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when countries are different', () {
        // arrange
        const state1 = CountryDetailLoaded(tCountry, countries: tCountryList);
        const state2 = CountryDetailLoaded(tCountry);

        // act & assert
        expect(state1, isNot(equals(state2)));
      });

      test('should have correct props', () {
        // arrange
        const state = CountryDetailLoaded(tCountry, countries: tCountryList);

        // act & assert
        expect(state.props, [tCountry, tCountryList]);
      });
    });

    group('CountriesError', () {
      test('should create CountriesError with message', () {
        // arrange & act
        const state = CountriesError('Error message');

        // assert
        expect(state.message, 'Error message');
      });

      test('should be equal when messages are same', () {
        // arrange
        const state1 = CountriesError('Error message');
        const state2 = CountriesError('Error message');

        // act & assert
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when messages are different', () {
        // arrange
        const state1 = CountriesError('Error message 1');
        const state2 = CountriesError('Error message 2');

        // act & assert
        expect(state1, isNot(equals(state2)));
      });

      test('should have correct props', () {
        // arrange
        const state = CountriesError('Error message');

        // act & assert
        expect(state.props, ['Error message']);
      });
    });
  });
}
