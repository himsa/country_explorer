import 'package:flutter_test/flutter_test.dart';

import 'package:countries_explorer/core/error/failure.dart';

/// Test suite for Failure classes
/// Tests the core error handling mechanism used throughout the app
/// Ensures proper equality, message handling, and type safety
void main() {
  group('Failure', () {
    group('ServerFailure', () {
      test('should create ServerFailure with message', () {
        // arrange & act
        const failure = ServerFailure('Server error');

        // assert
        expect(failure.message, 'Server error');
      });

      test('should be equal when messages are same', () {
        // arrange
        const failure1 = ServerFailure('Server error');
        const failure2 = ServerFailure('Server error');

        // act & assert
        expect(failure1, equals(failure2));
        expect(failure1.hashCode, equals(failure2.hashCode));
      });

      test('should not be equal when messages are different', () {
        // arrange
        const failure1 = ServerFailure('Server error 1');
        const failure2 = ServerFailure('Server error 2');

        // act & assert
        expect(failure1, isNot(equals(failure2)));
        expect(failure1.hashCode, isNot(equals(failure2.hashCode)));
      });
    });

    group('CacheFailure', () {
      test('should create CacheFailure with message', () {
        // arrange & act
        const failure = CacheFailure('Cache error');

        // assert
        expect(failure.message, 'Cache error');
      });
    });

    group('NetworkFailure', () {
      test('should create NetworkFailure with message', () {
        // arrange & act
        const failure = NetworkFailure('Network error');

        // assert
        expect(failure.message, 'Network error');
      });
    });

    group('ParseFailure', () {
      test('should create ParseFailure with message', () {
        // arrange & act
        const failure = ParseFailure('Parse error');

        // assert
        expect(failure.message, 'Parse error');
      });
    });

    group('NotFoundFailure', () {
      test('should create NotFoundFailure with message', () {
        // arrange & act
        const failure = NotFoundFailure('Not found error');

        // assert
        expect(failure.message, 'Not found error');
      });
    });
  });
}
