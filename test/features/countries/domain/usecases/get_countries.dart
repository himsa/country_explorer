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
  );
  final tCountries = [tCountry];

  test('should get list of countries from repository', () async {
    when(
      () => mockRepository.getAllCountries(),
    ).thenAnswer((_) async => Right(tCountries));

    final result = await usecase(NoParams());

    expect(result, Right(tCountries));
    verify(() => mockRepository.getAllCountries()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    when(
      () => mockRepository.getAllCountries(),
    ).thenAnswer((_) async => const Left(ServerFailure('error')));

    final result = await usecase(NoParams());

    expect(result, equals(const Left(ServerFailure('error'))));
  });
}
