import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:countries_explorer/core/error/failure.dart';
import 'package:countries_explorer/core/usecases/usecase.dart';
import 'package:countries_explorer/features/countries/domain/entities/country.dart';
import 'package:countries_explorer/features/countries/domain/usecases/get_countries.dart';
import 'package:countries_explorer/features/countries/domain/usecases/get_country_detail.dart';
import 'package:countries_explorer/features/countries/presentation/bloc/countries_bloc.dart';
import 'package:countries_explorer/features/countries/presentation/bloc/countries_event.dart';
import 'package:countries_explorer/features/countries/presentation/bloc/countries_state.dart';

class MockGetCountries extends Mock implements GetCountries {}

class MockGetCountryDetail extends Mock implements GetCountryDetail {}

void main() {
  late CountriesBloc bloc;
  late MockGetCountries mockGetCountries;
  late MockGetCountryDetail mockGetCountryDetail;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockGetCountries = MockGetCountries();
    mockGetCountryDetail = MockGetCountryDetail();
    bloc = CountriesBloc(
      getCountries: mockGetCountries,
      getCountryDetail: mockGetCountryDetail,
    );
  });

  tearDown(() {
    bloc.close();
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

  final tCountryList = [tCountry];

  group('CountriesBloc', () {
    test('initial state should be CountriesInitial', () {
      expect(bloc.state, equals(CountriesInitial()));
    });

    group('LoadCountries', () {
      blocTest<CountriesBloc, CountriesState>(
        'emits [Loading, Loaded] when getCountries succeeds',
        build: () {
          when(
            () => mockGetCountries(any()),
          ).thenAnswer((_) async => Right(tCountryList));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadCountries()),
        expect: () => [
          isA<CountriesLoading>(),
          isA<CountriesLoaded>().having(
            (s) => s.countries,
            'countries',
            tCountryList,
          ),
        ],
      );

      blocTest<CountriesBloc, CountriesState>(
        'emits [Loading, Error] when getCountries fails',
        build: () {
          when(
            () => mockGetCountries(any()),
          ).thenAnswer((_) async => Left(ServerFailure('error')));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadCountries()),
        expect: () => [
          isA<CountriesLoading>(),
          isA<CountriesError>().having((s) => s.message, 'message', 'error'),
        ],
      );
    });

    group('LoadCountryDetail', () {
      blocTest<CountriesBloc, CountriesState>(
        'emits [Loading, CountryDetailLoaded] when getCountryDetail succeeds',
        build: () {
          when(
            () => mockGetCountryDetail(any()),
          ).thenAnswer((_) async => Right(tCountry));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCountryDetail('Indonesia')),
        expect: () => [
          isA<CountriesLoading>(),
          isA<CountryDetailLoaded>().having(
            (s) => s.country,
            'country',
            tCountry,
          ),
        ],
      );

      blocTest<CountriesBloc, CountriesState>(
        'emits [Loading, Error] when getCountryDetail fails',
        build: () {
          when(
            () => mockGetCountryDetail(any()),
          ).thenAnswer((_) async => Left(ServerFailure('fail')));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCountryDetail('Indonesia')),
        expect: () => [
          isA<CountriesLoading>(),
          isA<CountriesError>().having((s) => s.message, 'message', 'fail'),
        ],
      );
    });
  });
}

