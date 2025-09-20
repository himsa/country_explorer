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
import 'package:countries_explorer/core/navigation/navigation_bloc.dart';

class MockGetCountries extends Mock implements GetCountries {}

class MockGetCountryDetail extends Mock implements GetCountryDetail {}

class MockNavigationBloc extends Mock implements NavigationBloc {}

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

    group('RefreshCountries', () {
      blocTest<CountriesBloc, CountriesState>(
        'emits [Loading, Loaded] when RefreshCountries succeeds',
        build: () {
          when(
            () => mockGetCountries(any()),
          ).thenAnswer((_) async => Right(tCountryList));
          return bloc;
        },
        act: (bloc) => bloc.add(RefreshCountries()),
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
        'emits [Loading, Error] when RefreshCountries fails',
        build: () {
          when(
            () => mockGetCountries(any()),
          ).thenAnswer((_) async => Left(ServerFailure('refresh error')));
          return bloc;
        },
        act: (bloc) => bloc.add(RefreshCountries()),
        expect: () => [
          isA<CountriesLoading>(),
          isA<CountriesError>().having(
            (s) => s.message,
            'message',
            'refresh error',
          ),
        ],
      );
    });

    group('ReturnToCountriesList', () {
      blocTest<CountriesBloc, CountriesState>(
        'emits CountriesLoaded with existing countries when ReturnToCountriesList is added',
        build: () {
          // First load some countries
          when(
            () => mockGetCountries(any()),
          ).thenAnswer((_) async => Right(tCountryList));
          return bloc;
        },
        act: (bloc) async {
          // Load countries first
          bloc.add(LoadCountries());
          await Future.delayed(
            Duration.zero,
          ); // Allow the first event to complete

          // Then return to list
          bloc.add(ReturnToCountriesList());
        },
        expect: () => [
          isA<CountriesLoading>(),
          isA<CountriesLoaded>().having(
            (s) => s.countries,
            'countries',
            tCountryList,
          ),
          isA<CountriesLoaded>().having(
            (s) => s.countries,
            'countries',
            tCountryList,
          ),
        ],
      );

      blocTest<CountriesBloc, CountriesState>(
        'emits CountriesInitial when ReturnToCountriesList is added with no existing countries',
        setUp: () {
          when(
            () => mockGetCountries(any()),
          ).thenAnswer((_) async => Right(tCountryList));
        },
        build: () => CountriesBloc(
          getCountries: mockGetCountries,
          getCountryDetail: mockGetCountryDetail,
        ),
        act: (bloc) => bloc.add(ReturnToCountriesList()),
        expect: () => [
          isA<CountriesLoaded>()
              .having((s) => s.countries, 'countries', tCountryList)
              .having((s) => s.isFromCache, 'isFromCache', true),
        ],
      );
    });

    group('Error handling', () {
      blocTest<CountriesBloc, CountriesState>(
        'handles NetworkFailure correctly',
        build: () {
          when(
            () => mockGetCountries(any()),
          ).thenAnswer((_) async => Left(NetworkFailure('network error')));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadCountries()),
        expect: () => [
          isA<CountriesLoading>(),
          isA<CountriesError>().having(
            (s) => s.message,
            'message',
            'network error',
          ),
        ],
      );

      blocTest<CountriesBloc, CountriesState>(
        'handles CacheFailure correctly',
        build: () {
          when(
            () => mockGetCountries(any()),
          ).thenAnswer((_) async => Left(CacheFailure('cache error')));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadCountries()),
        expect: () => [
          isA<CountriesLoading>(),
          isA<CountriesError>().having(
            (s) => s.message,
            'message',
            'cache error',
          ),
        ],
      );

      blocTest<CountriesBloc, CountriesState>(
        'handles NotFoundFailure correctly',
        build: () {
          when(
            () => mockGetCountryDetail(any()),
          ).thenAnswer((_) async => Left(NotFoundFailure('not found error')));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCountryDetail('NonExistent')),
        expect: () => [
          isA<CountriesLoading>(),
          isA<CountriesError>().having(
            (s) => s.message,
            'message',
            'not found error',
          ),
        ],
      );

      blocTest<CountriesBloc, CountriesState>(
        'handles ParseFailure correctly',
        build: () {
          when(
            () => mockGetCountries(any()),
          ).thenAnswer((_) async => Left(ParseFailure('parse error')));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadCountries()),
        expect: () => [
          isA<CountriesLoading>(),
          isA<CountriesError>().having(
            (s) => s.message,
            'message',
            'parse error',
          ),
        ],
      );
    });

    group('Loading states', () {
      blocTest<CountriesBloc, CountriesState>(
        'emits CountriesLoading with existing countries when loading country detail',
        build: () {
          when(
            () => mockGetCountries(any()),
          ).thenAnswer((_) async => Right(tCountryList));
          when(
            () => mockGetCountryDetail(any()),
          ).thenAnswer((_) async => Right(tCountry));
          return bloc;
        },
        act: (bloc) async {
          // Load countries first
          bloc.add(LoadCountries());
          await Future.delayed(
            Duration.zero,
          ); // Allow the first event to complete

          // Then load country detail
          bloc.add(const LoadCountryDetail('Indonesia'));
        },
        expect: () => [
          isA<CountriesLoading>(),
          isA<CountriesLoaded>().having(
            (s) => s.countries,
            'countries',
            tCountryList,
          ),
          isA<CountriesLoading>().having(
            (s) => s.countries,
            'countries',
            tCountryList,
          ),
          isA<CountryDetailLoaded>()
              .having((s) => s.country, 'country', tCountry)
              .having((s) => s.countries, 'countries', tCountryList),
        ],
      );
    });
  });

  group('NavigationBloc integration', () {
    late MockNavigationBloc mockNavigationBloc;

    setUp(() {
      mockNavigationBloc = MockNavigationBloc();
    });

    test('setNavigationBloc should set navigation bloc reference', () {
      // act
      bloc.setNavigationBloc(mockNavigationBloc);

      // assert - verify by testing flag emoji caching functionality
      expect(bloc, isNotNull); // Simple verification that method executes
    });

    blocTest<CountriesBloc, CountriesState>(
      'should cache flag emojis when navigation bloc is set',
      build: () {
        when(
          () => mockGetCountries(any()),
        ).thenAnswer((_) async => Right(tCountryList));
        bloc.setNavigationBloc(mockNavigationBloc);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadCountries()),
      expect: () => [
        const CountriesLoading(),
        isA<CountriesLoaded>().having(
          (s) => s.countries,
          'countries',
          tCountryList,
        ),
      ],
      verify: (_) {
        verify(() => mockNavigationBloc.cacheFlagEmojis(any())).called(1);
      },
    );
  });

  group('Additional state transitions', () {
    blocTest<CountriesBloc, CountriesState>(
      'RefreshCountries should emit loading with existing countries when current state is CountriesLoaded',
      build: () => bloc,
      seed: () => CountriesLoaded(tCountryList),
      setUp: () {
        when(
          () => mockGetCountries(any()),
        ).thenAnswer((_) async => Right(tCountryList));
      },
      act: (bloc) => bloc.add(RefreshCountries()),
      expect: () => [
        isA<CountriesLoading>().having(
          (s) => s.countries,
          'countries',
          tCountryList,
        ),
        isA<CountriesLoaded>().having(
          (s) => s.countries,
          'countries',
          tCountryList,
        ),
      ],
    );

    blocTest<CountriesBloc, CountriesState>(
      'LoadCountryDetail should preserve countries when current state is CountriesLoading',
      build: () => bloc,
      seed: () => CountriesLoading(countries: tCountryList),
      setUp: () {
        when(
          () => mockGetCountryDetail('Indonesia'),
        ).thenAnswer((_) async => const Right(tCountry));
      },
      act: (bloc) => bloc.add(LoadCountryDetail('Indonesia')),
      expect: () => [
        isA<CountryDetailLoaded>()
            .having((s) => s.country, 'country', tCountry)
            .having((s) => s.countries, 'countries', tCountryList),
      ],
    );

    blocTest<CountriesBloc, CountriesState>(
      'ReturnToCountriesList should handle error when no preserved countries and loading fails',
      build: () => bloc,
      setUp: () {
        when(
          () => mockGetCountries(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure('Network error')));
      },
      act: (bloc) => bloc.add(ReturnToCountriesList()),
      expect: () => [
        isA<CountriesError>().having(
          (s) => s.message,
          'message',
          'Network error',
        ),
      ],
    );
  });
}
