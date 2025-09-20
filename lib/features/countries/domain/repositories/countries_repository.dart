import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/country.dart';

abstract class CountriesRepository {
  Future<Either<Failure, List<Country>>> getAllCountries();
  Future<Either<Failure, Country>> getCountryByName(String name);
}
