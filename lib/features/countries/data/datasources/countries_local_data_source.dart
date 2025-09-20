import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/country_model.dart';

abstract class CountriesLocalDataSource {
  Future<List<CountryModel>> getLastCountries();
  Future<void> cacheCountries(List<CountryModel> countries);
}

const cachedCountriesKey = 'CACHED_COUNTRIES';

class CountriesLocalDataSourceImpl implements CountriesLocalDataSource {
  final SharedPreferences prefs;

  CountriesLocalDataSourceImpl(this.prefs);

  @override
  Future<void> cacheCountries(List<CountryModel> countries) async {
    final jsonString = jsonEncode(countries.map((e) => e.toJson()).toList());
    await prefs.setString(cachedCountriesKey, jsonString);
  }

  @override
  Future<List<CountryModel>> getLastCountries() async {
    final jsonString = prefs.getString(cachedCountriesKey);
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      return decoded.map((e) => CountryModel.fromJson(e)).toList();
    } else {
      throw Exception('No cached data found');
    }
  }
}
