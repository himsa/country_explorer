import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:countries_explorer/core/error/failure.dart';
import 'package:countries_explorer/features/countries/domain/entities/country.dart';
import 'package:countries_explorer/features/countries/domain/repositories/countries_repository.dart';
import 'package:countries_explorer/features/countries/domain/usecases/get_country_detail.dart';

class MockCountriesRepository extends Mock implements CountriesRepository {}

void main() {
  late GetCountryDetail usecase;
  late MockCountriesRepository mockRepository;

  setUp(() {
    mockRepository = MockCountriesRepository();
    usecase = GetCountryDetail(mockRepository);
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

  test('should get country detail from repository', () async {
    // arrange
    when(
      () => mockRepository.getCountryByName('Indonesia'),
    ).thenAnswer((_) async => const Right(tCountry));

    // act
    final result = await usecase('Indonesia');

    // assert
    expect(result, const Right(tCountry));
    verify(() => mockRepository.getCountryByName('Indonesia')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    when(
      () => mockRepository.getCountryByName('Indonesia'),
    ).thenAnswer((_) async => const Left(ServerFailure('error')));

    // act
    final result = await usecase('Indonesia');

    // assert
    expect(result, equals(const Left(ServerFailure('error'))));
    verify(() => mockRepository.getCountryByName('Indonesia')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
