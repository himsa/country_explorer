import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/country.dart';
import '../../domain/repositories/countries_repository.dart';
import '../datasources/countries_remote_data_source.dart';
import '../datasources/countries_local_data_source.dart';

class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesRemoteDataSource remoteDataSource;
  final CountriesLocalDataSource localDataSource;

  CountriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

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
