import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/country.dart';
import '../../domain/repositories/countries_repository.dart';
import '../datasources/countries_remote_data_source.dart';
import '../datasources/countries_local_data_source.dart';

/// Implementation of the CountriesRepository interface
///
/// This repository coordinates between remote and local data sources
/// to provide a unified data access layer. It implements a caching
/// strategy that prioritizes remote data but falls back to local
/// cached data when network requests fail.
///
/// Caching Strategy:
/// 1. Try to fetch data from remote API
/// 2. Cache successful responses locally
/// 3. Fall back to cached data if remote fails
/// 4. Return appropriate error types for different failure scenarios
class CountriesRepositoryImpl implements CountriesRepository {
  /// Remote data source for API calls
  final CountriesRemoteDataSource remoteDataSource;

  /// Local data source for caching
  final CountriesLocalDataSource localDataSource;

  CountriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// Retrieves all countries with caching strategy
  ///
  /// Implementation of the caching strategy:
  /// 1. Attempts to fetch fresh data from remote API
  /// 2. Caches successful responses for offline access
  /// 3. Falls back to cached data if remote request fails
  /// 4. Returns appropriate error types for different scenarios
  ///
  /// Error Handling:
  /// - ParseFailure: JSON parsing errors
  /// - NetworkFailure: Network connectivity issues
  @override
  Future<Either<Failure, List<Country>>> getAllCountries() async {
    try {
      final remoteCountries = await remoteDataSource.getAllCountries();
      await localDataSource.cacheCountries(remoteCountries);
      return Right(remoteCountries);
    } on FormatException catch (e) {
      return Left(ParseFailure('Failed to parse countries data: ${e.message}'));
    } on Exception {
      try {
        final localCountries = await localDataSource.getLastCountries();
        return Right(localCountries);
      } catch (cacheError) {
        return const Left(
          NetworkFailure(
            'Failed to fetch countries. Please check your internet connection.',
          ),
        );
      }
    }
  }

  /// Retrieves a specific country by name
  ///
  /// Fetches detailed information about a single country from the
  /// remote API. This method doesn't use caching as it's typically
  /// called for specific country details that are less frequently
  /// accessed.
  ///
  /// Error Handling:
  /// - ParseFailure: JSON parsing errors
  /// - NotFoundFailure: Country not found (404 errors)
  /// - NetworkFailure: Network connectivity issues
  @override
  Future<Either<Failure, Country>> getCountryByName(String name) async {
    try {
      final country = await remoteDataSource.getCountryByName(name);
      return Right(country);
    } on FormatException catch (e) {
      return Left(ParseFailure('Failed to parse country data: ${e.message}'));
    } on Exception catch (e) {
      if (e.toString().contains('404') || e.toString().contains('Not Found')) {
        return Left(NotFoundFailure('Country "$name" not found'));
      }
      return const Left(
        NetworkFailure(
          'Failed to fetch country details. Please check your internet connection.',
        ),
      );
    }
  }
}
