import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/country.dart';

/// Abstract repository interface for countries data access
///
/// This interface defines the contract for accessing countries data
/// in the domain layer. It follows the Repository pattern which
/// abstracts the data access logic and allows for easy testing
/// and implementation swapping.
///
/// The repository interface:
/// - Defines data access methods without implementation details
/// - Returns Either[Failure, T] for functional error handling
/// - Is implemented by the data layer
/// - Is used by use cases in the domain layer
abstract class CountriesRepository {
  /// Retrieves all countries from the data source
  ///
  /// Returns either a list of countries or a failure.
  /// The implementation should handle caching, network requests,
  /// and error scenarios appropriately.
  Future<Either<Failure, List<Country>>> getAllCountries();

  /// Retrieves a specific country by name
  ///
  /// Returns either the requested country or a failure.
  /// Used for fetching detailed information about a single country.
  Future<Either<Failure, Country>> getCountryByName(String name);
}
