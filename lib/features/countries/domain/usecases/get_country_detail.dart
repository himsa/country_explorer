import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/country.dart';
import '../repositories/countries_repository.dart';

/// Use case for fetching detailed information about a specific country
///
/// This use case encapsulates the business logic for retrieving
/// detailed information about a single country by name. It follows
/// the Clean Architecture principle by depending only on the
/// repository interface.
///
/// The use case:
/// - Takes a country name as parameter
/// - Delegates to the repository for data retrieval
/// - Returns Either[Failure, Country] for functional error handling
/// - Is testable in isolation with mocked repositories
class GetCountryDetail implements UseCase<Either<Failure, Country>, String> {
  /// Repository dependency for data access
  final CountriesRepository repository;

  GetCountryDetail(this.repository);

  @override
  Future<Either<Failure, Country>> call(String name) async {
    return await repository.getCountryByName(name);
  }
}
