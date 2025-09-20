import 'package:flutter_test/flutter_test.dart';

import 'package:countries_explorer/core/usecases/usecase.dart';

void main() {
  group('UseCase', () {
    test('NoParams should be equal to other NoParams instances', () {
      // arrange
      final noParams1 = NoParams();
      final noParams2 = NoParams();

      // act & assert
      expect(noParams1, isA<NoParams>());
      expect(noParams2, isA<NoParams>());
    });

    test('NoParams should be constant', () {
      // arrange & act
      final noParams = NoParams();

      // assert
      expect(noParams, isA<NoParams>());
    });
  });
}
