import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:countries_explorer/features/countries/data/datasources/countries_local_data_source.dart';
import 'package:countries_explorer/features/countries/data/models/country_model.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late CountriesLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = CountriesLocalDataSourceImpl(mockSharedPreferences);
  });

  group('cacheCountries', () {
    const tCountries = [
      CountryModel(
        name: 'Indonesia',
        flagEmoji: '🇮🇩',
        capital: 'Jakarta',
        population: 273523615,
        area: 1904569.0,
        languages: ['Indonesian'],
        coatOfArmsUrl: 'https://flagcdn.com/w320/id.png',
      ),
    ];

    test('should cache countries successfully', () async {
      // arrange
      when(
        () => mockSharedPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);

      // act
      await dataSource.cacheCountries(tCountries);

      // assert
      verify(() => mockSharedPreferences.setString(any(), any())).called(1);
    });
  });

  group('getLastCountries', () {
    const tJsonString = '''
    [
      {
        "name": {"common": "Indonesia"},
        "cca2": "ID",
        "capital": ["Jakarta"],
        "population": 273523615,
        "area": 1904569.0,
        "languages": {"ind": "Indonesian"},
        "coatOfArms": {"png": "https://flagcdn.com/w320/id.png"}
      }
    ]
    ''';

    test('should return cached countries when available', () async {
      // arrange
      when(
        () => mockSharedPreferences.getString(any()),
      ).thenReturn(tJsonString);

      // act
      final result = await dataSource.getLastCountries();

      // assert
      expect(result, isA<List<CountryModel>>());
      expect(result.length, 1);
      expect(result.first.name, 'Indonesia');
      verify(() => mockSharedPreferences.getString(any())).called(1);
    });

    test('should throw exception when no cached data', () async {
      // arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      // act & assert
      expect(() => dataSource.getLastCountries(), throwsException);
    });
  });
}
