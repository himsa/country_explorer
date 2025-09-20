import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'features/countries/data/datasources/countries_local_data_source.dart';
import 'features/countries/data/datasources/countries_remote_data_source.dart';
import 'features/countries/data/repositories/countries_repository_impl.dart';
import 'features/countries/domain/repositories/countries_repository.dart';
import 'features/countries/domain/usecases/get_countries.dart';
import 'features/countries/domain/usecases/get_country_detail.dart';
import 'core/navigation/navigation_bloc.dart';

/// Service locator instance for dependency injection
///
/// This is the central registry for all dependencies in the application.
/// It follows the Service Locator pattern using the get_it package.
final sl = GetIt.instance;

/// Configures all dependencies for the application
///
/// This function sets up the dependency injection container with all
/// the necessary dependencies following Clean Architecture principles.
///
/// Dependency Registration Order:
/// 1. External dependencies (SharedPreferences, HTTP client)
/// 2. Data sources (Remote, Local)
/// 3. Repository implementation
/// 4. Use cases (Domain layer)
/// 5. BLoCs (Presentation layer)
///
/// This ensures proper dependency resolution and follows the
/// dependency inversion principle.
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

  sl.registerLazySingleton<NavigationBloc>(() => NavigationBloc());
}
