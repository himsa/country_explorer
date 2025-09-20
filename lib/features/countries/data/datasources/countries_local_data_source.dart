import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/country_model.dart';

/// Abstract interface for local data source operations
///
/// This interface defines the contract for caching and retrieving
/// countries data from local storage. It follows the Data Source
/// pattern for local data persistence.
abstract class CountriesLocalDataSource {
  /// Retrieves the last cached list of countries
  Future<List<CountryModel>> getLastCountries();

  /// Caches a list of countries to local storage
  Future<void> cacheCountries(List<CountryModel> countries);
}

/// Key for storing cached countries data in SharedPreferences
const cachedCountriesKey = 'CACHED_COUNTRIES';

/// Implementation of local data source using SharedPreferences
///
/// This class handles local storage operations for countries data
/// using SharedPreferences. It provides offline functionality by
/// caching API responses and retrieving them when needed.
///
/// Features:
/// - JSON serialization/deserialization for data persistence
/// - Error handling for missing cached data
/// - Efficient storage using SharedPreferences
class CountriesLocalDataSourceImpl implements CountriesLocalDataSource {
  /// SharedPreferences instance for local storage
  final SharedPreferences prefs;

  CountriesLocalDataSourceImpl(this.prefs);

  /// Caches a list of countries to local storage
  ///
  /// Converts the list of CountryModel instances to JSON format
  /// and stores it in SharedPreferences for offline access.
  ///
  /// This method is called after successful API responses to
  /// enable offline functionality.
  @override
  Future<void> cacheCountries(List<CountryModel> countries) async {
    final jsonString = jsonEncode(countries.map((e) => e.toJson()).toList());
    await prefs.setString(cachedCountriesKey, jsonString);
  }

  /// Retrieves the last cached list of countries
  ///
  /// Retrieves and deserializes the cached countries data from
  /// SharedPreferences. This method is used for offline functionality
  /// when network requests fail.
  ///
  /// Returns a list of CountryModel instances or throws an exception
  /// if no cached data is found.
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
