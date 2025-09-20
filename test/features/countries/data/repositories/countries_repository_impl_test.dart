import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:countries_explorer/core/error/failure.dart';
import 'package:countries_explorer/features/countries/data/datasources/countries_local_data_source.dart';
import 'package:countries_explorer/features/countries/data/datasources/countries_remote_data_source.dart';
import 'package:countries_explorer/features/countries/data/models/country_model.dart';
import 'package:countries_explorer/features/countries/data/repositories/countries_repository_impl.dart';
import 'package:countries_explorer/features/countries/domain/entities/country.dart';

/// Mock data sources for testing repository implementation
class MockCountriesRemoteDataSource extends Mock
    implements CountriesRemoteDataSource {}

class MockCountriesLocalDataSource extends Mock
    implements CountriesLocalDataSource {}

/// Test suite for CountriesRepositoryImpl
/// Tests the repository layer that coordinates between remote and local data sources
/// Covers the caching strategy: remote first, local fallback, error handling
/// Tests various failure scenarios including network issues and JSON parsing errors
void main() {
  late CountriesRepositoryImpl repository;
  late MockCountriesRemoteDataSource mockRemoteDataSource;
  late MockCountriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockCountriesRemoteDataSource();
    mockLocalDataSource = MockCountriesLocalDataSource();
    repository = CountriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('getAllCountries', () {
    test('returns remote data and caches it when remote succeeds', () async {
      // arrange
      const tCountries = [
        CountryModel(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
      ];
      when(
        () => mockRemoteDataSource.getAllCountries(),
      ).thenAnswer((_) async => tCountries);
      when(
        () => mockLocalDataSource.cacheCountries(any()),
      ).thenAnswer((_) async {});

      // act
      final result = await repository.getAllCountries();

      // assert
      expect(result, isA<Right<Failure, List<Country>>>());
      final countries = result.fold((l) => [], (r) => r);
      expect(countries.length, 1);
      expect(countries.first.name, 'Indonesia');
      verify(() => mockRemoteDataSource.getAllCountries()).called(1);
      verify(() => mockLocalDataSource.cacheCountries(any())).called(1);
    });

    test('returns local data when remote fails but local succeeds', () async {
      // arrange
      const tCountries = [
        CountryModel(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
      ];
      when(
        () => mockRemoteDataSource.getAllCountries(),
      ).thenThrow(Exception('No internet'));
      when(
        () => mockLocalDataSource.getLastCountries(),
      ).thenAnswer((_) async => tCountries);

      // act
      final result = await repository.getAllCountries();

      // assert
      expect(result, isA<Right<Failure, List<Country>>>());
      final countries = result.fold((l) => [], (r) => r);
      expect(countries.length, 1);
      expect(countries.first.name, 'Indonesia');
      verify(() => mockRemoteDataSource.getAllCountries()).called(1);
      verify(() => mockLocalDataSource.getLastCountries()).called(1);
    });

    test('returns ServerFailure when both fail', () async {
      // arrange
      when(
        () => mockRemoteDataSource.getAllCountries(),
      ).thenThrow(Exception('No internet'));
      when(
        () => mockLocalDataSource.getLastCountries(),
      ).thenThrow(Exception('No cached data'));

      // act
      final result = await repository.getAllCountries();

      // assert
      expect(result, isA<Left<Failure, List<Country>>>());
      verify(() => mockRemoteDataSource.getAllCountries()).called(1);
      verify(() => mockLocalDataSource.getLastCountries()).called(1);
    });

    test('returns ParseFailure when FormatException occurs', () async {
      // arrange
      when(
        () => mockRemoteDataSource.getAllCountries(),
      ).thenThrow(FormatException('Invalid JSON'));

      // act
      final result = await repository.getAllCountries();

      // assert
      expect(result, isA<Left<Failure, List<Country>>>());
    });
  });
}
