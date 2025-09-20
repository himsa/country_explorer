import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/countries/presentation/bloc/countries_event.dart';
import 'features/countries/presentation/pages/countries_list_page.dart';
import 'features/countries/presentation/bloc/countries_bloc.dart';
import 'core/navigation/navigation_bloc.dart';
import 'features/countries/domain/usecases/get_countries.dart';
import 'features/countries/domain/usecases/get_country_detail.dart';
import 'injection_container.dart';

/// Application entry point
///
/// Initializes the Flutter app with dependency injection and
/// sets up the BLoC providers for state management.
///
/// The app follows Clean Architecture with:
/// - Dependency injection using get_it
/// - BLoC pattern for state management
/// - MultiBlocProvider for coordinating multiple BLoCs
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

/// Root application widget
///
/// Configures the MaterialApp with theme settings and BLoC providers.
/// Sets up the dependency injection and coordinates between CountriesBloc
/// and NavigationBloc for proper state management.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countries Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<NavigationBloc>()),
          BlocProvider(
            create: (context) {
              final countriesBloc = CountriesBloc(
                getCountries: sl<GetCountries>(),
                getCountryDetail: sl<GetCountryDetail>(),
              );
              // Connect CountriesBloc with NavigationBloc
              final navigationBloc = context.read<NavigationBloc>();
              countriesBloc.setNavigationBloc(navigationBloc);
              countriesBloc.add(LoadCountries());
              return countriesBloc;
            },
          ),
        ],
        child: const CountriesListPage(),
      ),
    );
  }
}
