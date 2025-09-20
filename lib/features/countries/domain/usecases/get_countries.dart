import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/country.dart';
import '../repositories/countries_repository.dart';

/// Use case for fetching all countries
///
/// This use case encapsulates the business logic for retrieving
/// a list of all countries. It follows the Clean Architecture
/// principle by depending only on the repository interface,
/// not on concrete implementations.
///
/// The use case:
/// - Delegates to the repository for data retrieval
/// - Returns Either[Failure, List[Country]] for functional error handling
/// - Requires no parameters (uses NoParams)
/// - Is testable in isolation with mocked repositories
class GetCountries
    implements UseCase<Either<Failure, List<Country>>, NoParams> {
  /// Repository dependency for data access
  final CountriesRepository repository;

  GetCountries(this.repository);

  @override
  Future<Either<Failure, List<Country>>> call(NoParams params) async {
    return await repository.getAllCountries();
  }
}
