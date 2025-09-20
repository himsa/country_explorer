import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:countries_explorer/features/countries/data/datasources/countries_local_data_source.dart';
import 'package:countries_explorer/features/countries/data/models/country_model.dart';

/// Test suite for CountriesLocalDataSource
/// Tests the local caching mechanism using SharedPreferences
/// Covers caching countries data and retrieving cached data
/// Tests error handling when no cached data is available
void main() {
  late CountriesLocalDataSourceImpl dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    dataSource = CountriesLocalDataSourceImpl(prefs);
  });

  group('cacheCountries', () {
    test('should cache countries successfully', () async {
      // arrange
      const tCountries = [
        CountryModel(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
      ];

      // act
      await dataSource.cacheCountries(tCountries);

      // assert
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('CACHED_COUNTRIES'), isNotNull);
    });
  });

  group('getLastCountries', () {
    test('should return cached countries when available', () async {
      // arrange
      const tCountries = [
        CountryModel(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
      ];
      await dataSource.cacheCountries(tCountries);

      // act
      final result = await dataSource.getLastCountries();

      // assert
      expect(result.length, 1);
      expect(result.first.name, 'Indonesia');
      expect(result.first.capital, 'Jakarta');
    });

    test('should throw exception when no cached data', () async {
      // act & assert
      expect(() => dataSource.getLastCountries(), throwsException);
    });
  });
}
