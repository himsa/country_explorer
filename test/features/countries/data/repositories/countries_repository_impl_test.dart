import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:countries_explorer/core/error/failure.dart';
import 'package:countries_explorer/features/countries/data/datasources/countries_local_data_source.dart';
import 'package:countries_explorer/features/countries/data/datasources/countries_remote_data_source.dart';
import 'package:countries_explorer/features/countries/data/models/country_model.dart';
import 'package:countries_explorer/features/countries/data/repositories/countries_repository_impl.dart';
import 'package:countries_explorer/features/countries/domain/entities/country.dart';

class MockRemoteDataSource extends Mock implements CountriesRemoteDataSource {}

class MockLocalDataSource extends Mock implements CountriesLocalDataSource {}

void main() {
  late CountriesRepositoryImpl repository;
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;

  const tCountryModel = CountryModel(
    name: 'Indonesia',
    flagEmoji: '🇮🇩',
    capital: 'Jakarta',
  );
  final List<CountryModel> tCountryModels = [tCountryModel];
  final List<Country> tCountries = [tCountryModel];

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    repository = CountriesRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('getCountries', () {
    test('returns remote data and caches it when remote succeeds', () async {
      when(
        () => mockRemote.getAllCountries(),
      ).thenAnswer((_) async => tCountryModels);
      when(
        () => mockLocal.cacheCountries(tCountryModels),
      ).thenAnswer((_) async {});

      final result = await repository.getAllCountries();

      expect(result.isRight(), true);
      expect(result.fold((l) => null, (r) => r), tCountries);
      verify(() => mockRemote.getAllCountries()).called(1);
      verify(() => mockLocal.cacheCountries(tCountryModels)).called(1);
      verifyNever(() => mockLocal.getLastCountries());
    });

    test('returns local data when remote fails but local succeeds', () async {
      when(() => mockRemote.getAllCountries()).thenThrow(Exception('network'));
      when(
        () => mockLocal.getLastCountries(),
      ).thenAnswer((_) async => tCountryModels);

      final result = await repository.getAllCountries();

      expect(result.isRight(), true);
      expect(result.fold((l) => null, (r) => r), tCountries);
      verify(() => mockRemote.getAllCountries()).called(1);
      verify(() => mockLocal.getLastCountries()).called(1);
    });

    test('returns ServerFailure when both fail', () async {
      when(() => mockRemote.getAllCountries()).thenThrow(Exception('network'));
      when(() => mockLocal.getLastCountries()).thenThrow(Exception('cache'));

      final result = await repository.getAllCountries();

      expect(
        result,
        equals(
          const Left(
            NetworkFailure(
              'Failed to fetch countries. Please check your internet connection.',
            ),
          ),
        ),
      );
      verify(() => mockRemote.getAllCountries()).called(1);
      verify(() => mockLocal.getLastCountries()).called(1);
    });

    test('returns ParseFailure when FormatException occurs', () async {
      when(() => mockRemote.getAllCountries()).thenThrow(
        const FormatException('Invalid JSON format', 'malformed data'),
      );

      final result = await repository.getAllCountries();

      expect(
        result,
        equals(
          const Left(
            ParseFailure('Failed to parse countries data: Invalid JSON format'),
          ),
        ),
      );
      verify(() => mockRemote.getAllCountries()).called(1);
      verifyNever(() => mockLocal.getLastCountries());
    });
  });

  group('getCountryDetail', () {
    test('returns remote data when successful', () async {
      when(
        () => mockRemote.getCountryByName('Indonesia'),
      ).thenAnswer((_) async => tCountryModel);

      final result = await repository.getCountryByName('Indonesia');

      expect(result, const Right(tCountryModel));
      verify(() => mockRemote.getCountryByName('Indonesia')).called(1);
    });

    test('returns ServerFailure when remote fails', () async {
      when(
        () => mockRemote.getCountryByName('Indonesia'),
      ).thenThrow(Exception('server down'));

      final result = await repository.getCountryByName('Indonesia');

      expect(
        result,
        equals(
          const Left(
            NetworkFailure(
              'Failed to fetch country details. Please check your internet connection.',
            ),
          ),
        ),
      );
      verify(() => mockRemote.getCountryByName('Indonesia')).called(1);
    });

    test('returns ParseFailure when FormatException occurs', () async {
      when(() => mockRemote.getCountryByName('Indonesia')).thenThrow(
        const FormatException('Invalid JSON format', 'malformed data'),
      );

      final result = await repository.getCountryByName('Indonesia');

      expect(
        result,
        equals(
          const Left(
            ParseFailure('Failed to parse country data: Invalid JSON format'),
          ),
        ),
      );
      verify(() => mockRemote.getCountryByName('Indonesia')).called(1);
    });

    test('returns NotFoundFailure when 404 exception occurs', () async {
      when(
        () => mockRemote.getCountryByName('NonExistentCountry'),
      ).thenThrow(Exception('404: Not Found'));

      final result = await repository.getCountryByName('NonExistentCountry');

      expect(
        result,
        equals(
          const Left(NotFoundFailure('Country "NonExistentCountry" not found')),
        ),
      );
      verify(() => mockRemote.getCountryByName('NonExistentCountry')).called(1);
    });
  });
}
