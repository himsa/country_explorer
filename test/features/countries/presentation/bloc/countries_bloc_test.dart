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

/// Mock use cases for testing CountriesBloc
class MockGetCountries extends Mock implements GetCountries {}

class MockGetCountryDetail extends Mock implements GetCountryDetail {}

/// Test suite for CountriesBloc
/// Tests the state management logic for countries list and detail views
/// Uses blocTest for proper stream testing of BLoC state transitions
/// Covers both success and failure scenarios for all events
void main() {
  late CountriesBloc countriesBloc;
  late MockGetCountries mockGetCountries;
  late MockGetCountryDetail mockGetCountryDetail;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockGetCountries = MockGetCountries();
    mockGetCountryDetail = MockGetCountryDetail();
    countriesBloc = CountriesBloc(
      getCountries: mockGetCountries,
      getCountryDetail: mockGetCountryDetail,
    );
  });

  tearDown(() {
    countriesBloc.close();
  });

  group('CountriesBloc', () {
    test('initial state should be CountriesInitial', () {
      expect(countriesBloc.state, equals(CountriesInitial()));
    });

    blocTest<CountriesBloc, CountriesState>(
      'emits [Loading, Loaded] when LoadCountries succeeds',
      build: () {
        when(() => mockGetCountries(any())).thenAnswer(
          (_) async => const Right([
            Country(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
          ]),
        );
        return countriesBloc;
      },
      act: (bloc) => bloc.add(LoadCountries()),
      expect: () => [isA<CountriesLoading>(), isA<CountriesLoaded>()],
    );

    blocTest<CountriesBloc, CountriesState>(
      'emits [Loading, Error] when LoadCountries fails',
      build: () {
        when(
          () => mockGetCountries(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Server error')));
        return countriesBloc;
      },
      act: (bloc) => bloc.add(LoadCountries()),
      expect: () => [isA<CountriesLoading>(), isA<CountriesError>()],
    );

    blocTest<CountriesBloc, CountriesState>(
      'emits [Loading, CountryDetailLoaded] when LoadCountryDetail succeeds',
      build: () {
        when(() => mockGetCountryDetail(any())).thenAnswer(
          (_) async => const Right(
            Country(name: 'Indonesia', flagEmoji: '🇮🇩', capital: 'Jakarta'),
          ),
        );
        return countriesBloc;
      },
      act: (bloc) => bloc.add(LoadCountryDetail('Indonesia')),
      expect: () => [isA<CountriesLoading>(), isA<CountryDetailLoaded>()],
    );

    blocTest<CountriesBloc, CountriesState>(
      'emits [Loading, Error] when LoadCountryDetail fails',
      build: () {
        when(
          () => mockGetCountryDetail(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Server error')));
        return countriesBloc;
      },
      act: (bloc) => bloc.add(LoadCountryDetail('Indonesia')),
      expect: () => [isA<CountriesLoading>(), isA<CountriesError>()],
    );
  });
}
