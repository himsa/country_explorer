import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:countries_explorer/features/countries/data/datasources/countries_remote_data_source.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late CountriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = CountriesRemoteDataSourceImpl(mockHttpClient);
  });

  group('getAllCountries', () {
    test('should return list of countries when call is successful', () async {
      // arrange
      const tJsonResponse = '''
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
      when(
        () => mockHttpClient.get(any()),
      ).thenAnswer((_) async => http.Response(tJsonResponse, 200));

      // act
      final result = await dataSource.getAllCountries();

      // assert
      expect(result, isA<List>());
      expect(result.length, 1);
      expect(result.first.name, 'Indonesia');
    });

    test('should throw exception when call is unsuccessful', () async {
      // arrange
      when(
        () => mockHttpClient.get(any()),
      ).thenAnswer((_) async => http.Response('Server Error', 500));

      // act & assert
      expect(() => dataSource.getAllCountries(), throwsException);
    });
  });

  group('getCountryByName', () {
    test('should return country when call is successful', () async {
      // arrange
      const tJsonResponse = '''
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
      when(
        () => mockHttpClient.get(any()),
      ).thenAnswer((_) async => http.Response(tJsonResponse, 200));

      // act
      final result = await dataSource.getCountryByName('Indonesia');

      // assert
      expect(result, isNotNull);
      expect(result.name, 'Indonesia');
    });

    test('should throw exception when call is unsuccessful', () async {
      // arrange
      when(
        () => mockHttpClient.get(any()),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      // act & assert
      expect(() => dataSource.getCountryByName('NonExistent'), throwsException);
    });
  });
}
