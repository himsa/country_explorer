import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

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

  const tCountry = Country(
    name: 'Indonesia',
    flagEmoji: '🇮🇩',
    capital: 'Jakarta',
    population: 273523621,
    area: 1904569,
    languages: ['Indonesian'],
    coatOfArmsUrl: 'https://flagcdn.com/w320/id.png',
  );
  final tCountries = [tCountry];

  test('should get list of countries from repository', () async {
    // arrange
    when(
      () => mockRepository.getAllCountries(),
    ).thenAnswer((_) async => Right(tCountries));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, Right(tCountries));
    verify(() => mockRepository.getAllCountries()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    when(
      () => mockRepository.getAllCountries(),
    ).thenAnswer((_) async => const Left(ServerFailure('error')));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, equals(const Left(ServerFailure('error'))));
    verify(() => mockRepository.getAllCountries()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
