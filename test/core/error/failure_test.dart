import 'package:flutter_test/flutter_test.dart';

import 'package:countries_explorer/core/error/failure.dart';

void main() {
  group('Failure', () {
    group('ServerFailure', () {
      test('should create ServerFailure with message only', () {
        // arrange & act
        const failure = ServerFailure('Server error');

        // assert
        expect(failure.message, 'Server error');
        expect(failure.code, null);
      });

      test('should create ServerFailure with message and code', () {
        // arrange & act
        const failure = ServerFailure('Server error', code: '500');

        // assert
        expect(failure.message, 'Server error');
        expect(failure.code, '500');
      });

      test('should be equal when message and code are same', () {
        // arrange
        const failure1 = ServerFailure('Server error', code: '500');
        const failure2 = ServerFailure('Server error', code: '500');

        // act & assert
        expect(failure1, equals(failure2));
        expect(failure1.hashCode, equals(failure2.hashCode));
      });

      test('should not be equal when message is different', () {
        // arrange
        const failure1 = ServerFailure('Server error');
        const failure2 = ServerFailure('Different error');

        // act & assert
        expect(failure1, isNot(equals(failure2)));
      });

      test('should not be equal when code is different', () {
        // arrange
        const failure1 = ServerFailure('Server error', code: '500');
        const failure2 = ServerFailure('Server error', code: '404');

        // act & assert
        expect(failure1, isNot(equals(failure2)));
      });

      test('should not be equal when one has code and other does not', () {
        // arrange
        const failure1 = ServerFailure('Server error');
        const failure2 = ServerFailure('Server error', code: '500');

        // act & assert
        expect(failure1, isNot(equals(failure2)));
      });
    });

    group('CacheFailure', () {
      test('should create CacheFailure with message only', () {
        // arrange & act
        const failure = CacheFailure('Cache error');

        // assert
        expect(failure.message, 'Cache error');
        expect(failure.code, null);
      });

      test('should create CacheFailure with message and code', () {
        // arrange & act
        const failure = CacheFailure('Cache error', code: 'CACHE_001');

        // assert
        expect(failure.message, 'Cache error');
        expect(failure.code, 'CACHE_001');
      });

      test('should be equal when message and code are same', () {
        // arrange
        const failure1 = CacheFailure('Cache error', code: 'CACHE_001');
        const failure2 = CacheFailure('Cache error', code: 'CACHE_001');

        // act & assert
        expect(failure1, equals(failure2));
        expect(failure1.hashCode, equals(failure2.hashCode));
      });
    });

    group('NetworkFailure', () {
      test('should create NetworkFailure with message only', () {
        // arrange & act
        const failure = NetworkFailure('Network error');

        // assert
        expect(failure.message, 'Network error');
        expect(failure.code, null);
      });

      test('should create NetworkFailure with message and code', () {
        // arrange & act
        const failure = NetworkFailure('Network error', code: 'NET_001');

        // assert
        expect(failure.message, 'Network error');
        expect(failure.code, 'NET_001');
      });

      test('should be equal when message and code are same', () {
        // arrange
        const failure1 = NetworkFailure('Network error', code: 'NET_001');
        const failure2 = NetworkFailure('Network error', code: 'NET_001');

        // act & assert
        expect(failure1, equals(failure2));
        expect(failure1.hashCode, equals(failure2.hashCode));
      });
    });

    group('ParseFailure', () {
      test('should create ParseFailure with message only', () {
        // arrange & act
        const failure = ParseFailure('Parse error');

        // assert
        expect(failure.message, 'Parse error');
        expect(failure.code, null);
      });

      test('should create ParseFailure with message and code', () {
        // arrange & act
        const failure = ParseFailure('Parse error', code: 'PARSE_001');

        // assert
        expect(failure.message, 'Parse error');
        expect(failure.code, 'PARSE_001');
      });

      test('should be equal when message and code are same', () {
        // arrange
        const failure1 = ParseFailure('Parse error', code: 'PARSE_001');
        const failure2 = ParseFailure('Parse error', code: 'PARSE_001');

        // act & assert
        expect(failure1, equals(failure2));
        expect(failure1.hashCode, equals(failure2.hashCode));
      });
    });

    group('NotFoundFailure', () {
      test('should create NotFoundFailure with message only', () {
        // arrange & act
        const failure = NotFoundFailure('Not found error');

        // assert
        expect(failure.message, 'Not found error');
        expect(failure.code, null);
      });

      test('should create NotFoundFailure with message and code', () {
        // arrange & act
        const failure = NotFoundFailure('Not found error', code: '404');

        // assert
        expect(failure.message, 'Not found error');
        expect(failure.code, '404');
      });

      test('should be equal when message and code are same', () {
        // arrange
        const failure1 = NotFoundFailure('Not found error', code: '404');
        const failure2 = NotFoundFailure('Not found error', code: '404');

        // act & assert
        expect(failure1, equals(failure2));
        expect(failure1.hashCode, equals(failure2.hashCode));
      });
    });
  });
}
