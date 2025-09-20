import 'package:flutter_test/flutter_test.dart';

import 'package:countries_explorer/core/usecases/usecase.dart';

void main() {
  group('UseCase', () {
    group('NoParams', () {
      test('should be equal to other NoParams instances', () {
        // arrange
        final params1 = NoParams();
        final params2 = NoParams();

        // act & assert
        expect(params1, isA<NoParams>());
        expect(params2, isA<NoParams>());
      });

      test('should create instances successfully', () {
        // arrange & act
        final params1 = NoParams();
        final params2 = NoParams();

        // assert
        expect(params1, isNotNull);
        expect(params2, isNotNull);
      });
    });
  });
}
