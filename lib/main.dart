import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/countries/presentation/bloc/countries_event.dart';
import 'features/countries/presentation/pages/countries_list_page.dart';
import 'features/countries/presentation/bloc/countries_bloc.dart';
import 'features/countries/domain/usecases/get_countries.dart';
import 'features/countries/domain/usecases/get_country_detail.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

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
      home: BlocProvider(
        create: (_) => CountriesBloc(
          getCountries: sl<GetCountries>(),
          getCountryDetail: sl<GetCountryDetail>(),
        )..add(LoadCountries()),
        child: const CountriesListPage(),
      ),
    );
  }
}
