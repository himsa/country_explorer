import 'package:flutter_test/flutter_test.dart';

import 'package:countries_explorer/features/countries/data/models/country_model.dart';

void main() {
  group('CountryModel', () {
    test('should create a CountryModel instance with all properties', () {
      // arrange & act
      const countryModel = CountryModel(
        name: 'Indonesia',
        flagEmoji: '🇮🇩',
        capital: 'Jakarta',
        population: 273523615,
        area: 1904569.0,
        languages: ['Indonesian'],
        coatOfArmsUrl: 'https://flagcdn.com/w320/id.png',
      );

      // assert
      expect(countryModel.name, 'Indonesia');
      expect(countryModel.flagEmoji, '🇮🇩');
      expect(countryModel.capital, 'Jakarta');
      expect(countryModel.population, 273523615);
      expect(countryModel.area, 1904569.0);
      expect(countryModel.languages, ['Indonesian']);
      expect(countryModel.coatOfArmsUrl, 'https://flagcdn.com/w320/id.png');
    });

    group('fromJson', () {
      test('should create CountryModel from valid JSON', () {
        // arrange
        const json = {
          'name': {'common': 'Indonesia'},
          'cca2': 'ID',
          'capital': ['Jakarta'],
          'population': 273523615,
          'area': 1904569.0,
          'languages': {'ind': 'Indonesian'},
          'coatOfArms': {'png': 'https://flagcdn.com/w320/id.png'},
        };

        // act
        final result = CountryModel.fromJson(json);

        // assert
        expect(result.name, 'Indonesia');
        expect(result.flagEmoji, '🇮🇩');
        expect(result.capital, 'Jakarta');
        expect(result.population, 273523615);
        expect(result.area, 1904569.0);
        expect(result.languages, ['Indonesian']);
        expect(result.coatOfArmsUrl, 'https://flagcdn.com/w320/id.png');
      });

      test('should handle missing fields gracefully', () {
        // arrange
        const json = {
          'name': {'common': 'Test Country'},
          'cca2': 'TC',
        };

        // act
        final result = CountryModel.fromJson(json);

        // assert
        expect(result.name, 'Test Country');
        expect(result.flagEmoji, '🇹🇨'); // TC flag for country code 'TC'
        expect(result.capital, '');
        expect(result.population, isNull);
        expect(result.area, isNull);
        expect(result.languages, isEmpty);
        expect(result.coatOfArmsUrl, isNull);
      });

      test('should handle null capital field', () {
        // arrange
        const json = {
          'name': {'common': 'Test Country'},
          'cca2': 'TC',
          'capital': null,
        };

        // act
        final result = CountryModel.fromJson(json);

        // assert
        expect(result.capital, '');
      });

      test('should handle empty capital array', () {
        // arrange
        const json = {
          'name': {'common': 'Test Country'},
          'cca2': 'TC',
          'capital': [],
        };

        // act
        final result = CountryModel.fromJson(json);

        // assert
        expect(result.capital, '');
      });
    });

    group('toJson', () {
      test('should convert CountryModel to JSON', () {
        // arrange
        const countryModel = CountryModel(
          name: 'Indonesia',
          flagEmoji: '🇮🇩',
          capital: 'Jakarta',
          population: 273523615,
          area: 1904569.0,
          languages: ['Indonesian'],
          coatOfArmsUrl: 'https://flagcdn.com/w320/id.png',
        );

        // act
        final result = countryModel.toJson();

        // assert
        expect(result['name']['common'], 'Indonesia');
        expect(result['cca2'], isA<String>());
        expect(result['capital'], ['Jakarta']);
        expect(result['population'], 273523615);
        expect(result['area'], 1904569.0);
        expect(result['languages'], ['Indonesian']);
        expect(result['coatOfArms']['png'], 'https://flagcdn.com/w320/id.png');
      });

      test('should handle empty flag emoji in toJson', () {
        // arrange
        const countryModel = CountryModel(
          name: 'Test Country',
          flagEmoji: '',
          capital: 'Test Capital',
        );

        // act
        final result = countryModel.toJson();

        // assert
        expect(result['cca2'], '');
      });
    });

    group('flag emoji conversion', () {
      test('should convert country code to flag emoji through fromJson', () {
        // Test through fromJson method
        const json = {
          'name': {'common': 'United States'},
          'cca2': 'US',
          'capital': ['Washington, D.C.'],
        };
        final result = CountryModel.fromJson(json);
        expect(result.flagEmoji, '🇺🇸');
      });

      test('should handle invalid country codes', () {
        const json = {
          'name': {'common': 'Test Country'},
          'cca2': '',
          'capital': ['Test Capital'],
        };
        final result = CountryModel.fromJson(json);
        expect(result.flagEmoji, '🏳️');
      });
    });
  });
}
