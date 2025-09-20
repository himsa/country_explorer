import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'features/countries/data/datasources/countries_local_data_source.dart';
import 'features/countries/data/datasources/countries_remote_data_source.dart';
import 'features/countries/data/repositories/countries_repository_impl.dart';
import 'features/countries/domain/repositories/countries_repository.dart';
import 'features/countries/domain/usecases/get_countries.dart';
import 'features/countries/domain/usecases/get_country_detail.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerSingleton<http.Client>(http.Client());

  sl.registerLazySingleton<CountriesRemoteDataSource>(
    () => CountriesRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CountriesLocalDataSource>(
    () => CountriesLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<CountriesRepository>(
    () =>
        CountriesRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton<GetCountries>(() => GetCountries(sl()));
  sl.registerLazySingleton<GetCountryDetail>(() => GetCountryDetail(sl()));
}
