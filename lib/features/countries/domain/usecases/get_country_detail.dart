import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/country.dart';
import '../repositories/countries_repository.dart';

class GetCountryDetail implements UseCase<Either<Failure, Country>, String> {
  final CountriesRepository repository;
  GetCountryDetail(this.repository);

  @override
  Future<Either<Failure, Country>> call(String name) async {
    return await repository.getCountryByName(name);
  }
}
