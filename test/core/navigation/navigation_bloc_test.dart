import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:countries_explorer/core/navigation/navigation_bloc.dart';
import 'package:countries_explorer/core/navigation/navigation_event.dart';
import 'package:countries_explorer/core/navigation/navigation_state.dart';

void main() {
  late NavigationBloc navigationBloc;

  setUp(() {
    navigationBloc = NavigationBloc();
  });

  tearDown(() {
    navigationBloc.close();
  });

  group('NavigationBloc', () {
    test('initial state should be NavigationInitial', () {
      expect(navigationBloc.state, equals(NavigationInitial()));
    });

    group('NavigateToCountryDetail', () {
      blocTest<NavigationBloc, NavigationState>(
        'emits NavigateToDetail when NavigateToCountryDetail is added',
        build: () => navigationBloc,
        act: (bloc) => bloc.add(const NavigateToCountryDetail('Indonesia')),
        expect: () => [
          isA<NavigateToDetail>().having(
            (s) => s.countryName,
            'countryName',
            'Indonesia',
          ),
        ],
      );
    });

    group('NavigateBack', () {
      blocTest<NavigationBloc, NavigationState>(
        'emits NavigateBackToCountries when NavigateBack is added',
        build: () => navigationBloc,
        act: (bloc) => bloc.add(const NavigateBack()),
        expect: () => [isA<NavigateBackToCountries>()],
      );
    });

    group('ScheduleReturnNavigation', () {
      blocTest<NavigationBloc, NavigationState>(
        'emits ReturnNavigationScheduled after delay when ScheduleReturnNavigation is added',
        build: () => navigationBloc,
        act: (bloc) => bloc.add(const ScheduleReturnNavigation()),
        wait: const Duration(milliseconds: 400),
        expect: () => [isA<ReturnNavigationScheduled>()],
      );
    });

    group('RequestCachedFlagEmoji', () {
      blocTest<NavigationBloc, NavigationState>(
        'emits FlagEmojiProvided with default flag when no cached emoji exists',
        build: () => navigationBloc,
        act: (bloc) => bloc.add(const RequestCachedFlagEmoji('Indonesia')),
        expect: () => [
          isA<FlagEmojiProvided>().having(
            (s) => s.flagEmoji,
            'flagEmoji',
            '🏳️',
          ),
        ],
      );

      blocTest<NavigationBloc, NavigationState>(
        'emits FlagEmojiProvided with cached emoji when cached emoji exists',
        build: () {
          // First cache the flag emoji
          navigationBloc.cacheFlagEmojis({'Indonesia': '🇮🇩'});
          return navigationBloc;
        },
        act: (bloc) => bloc.add(const RequestCachedFlagEmoji('Indonesia')),
        expect: () => [
          isA<FlagEmojiProvided>().having(
            (s) => s.flagEmoji,
            'flagEmoji',
            '🇮🇩',
          ),
        ],
      );
    });

    group('ScheduleDataLoading', () {
      blocTest<NavigationBloc, NavigationState>(
        'emits DataLoadingScheduled after delay when ScheduleDataLoading is added',
        build: () => navigationBloc,
        act: (bloc) => bloc.add(const ScheduleDataLoading('Indonesia')),
        wait: const Duration(milliseconds: 300),
        expect: () => [
          isA<DataLoadingScheduled>().having(
            (s) => s.countryName,
            'countryName',
            'Indonesia',
          ),
        ],
      );
    });

    group('cacheFlagEmojis', () {
      blocTest<NavigationBloc, NavigationState>(
        'should cache flag emojis correctly',
        build: () {
          final flagEmojis = {
            'Indonesia': '🇮🇩',
            'Malaysia': '🇲🇾',
            'Singapore': '🇸🇬',
          };
          navigationBloc.cacheFlagEmojis(flagEmojis);
          return navigationBloc;
        },
        act: (bloc) => bloc.add(const RequestCachedFlagEmoji('Indonesia')),
        expect: () => [
          isA<FlagEmojiProvided>().having(
            (s) => s.flagEmoji,
            'flagEmoji',
            '🇮🇩',
          ),
        ],
      );

      blocTest<NavigationBloc, NavigationState>(
        'should add new emojis to existing cache',
        build: () {
          navigationBloc.cacheFlagEmojis({'Indonesia': '🇮🇩'});
          final additionalEmojis = {'Malaysia': '🇲🇾'};
          navigationBloc.cacheFlagEmojis(additionalEmojis);
          return navigationBloc;
        },
        act: (bloc) => bloc.add(const RequestCachedFlagEmoji('Malaysia')),
        expect: () => [
          isA<FlagEmojiProvided>().having(
            (s) => s.flagEmoji,
            'flagEmoji',
            '🇲🇾',
          ),
        ],
      );
    });
  });
}
