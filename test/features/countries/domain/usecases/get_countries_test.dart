import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:countries_explorer/core/error/failure.dart';
import 'package:countries_explorer/core/usecases/usecase.dart';
import 'package:countries_explorer/features/countries/domain/entities/country.dart';
import 'package:countries_explorer/features/countries/domain/repositories/countries_repository.dart';
import 'package:countries_explorer/features/countries/domain/usecases/get_countries.dart';

class MockCountriesRepository extends Mock implements CountriesRepository {}

void main() {
  late GetCountries usecase;
  late MockCountriesRepository mockRepository;

  setUp(() {
    mockRepository = MockCountriesRepository();
    usecase = GetCountries(mockRepository);
  });

  group('GetCountries', () {
    test('should get list of countries from repository', () async {
      // arrange
      const tCountries = [
        Country(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
        Country(name: 'Malaysia', flagEmoji: '🇲🇾', capital: 'Kuala Lumpur'),
      ];
      when(
        () => mockRepository.getAllCountries(),
      ).thenAnswer((_) async => const Right(tCountries));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Right(tCountries));
      verify(() => mockRepository.getAllCountries()).called(1);
    });

    test('should return failure when repository fails', () async {
      // arrange
      when(
        () => mockRepository.getAllCountries(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server error')));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Left(ServerFailure('Server error')));
      verify(() => mockRepository.getAllCountries()).called(1);
    });
  });
}
