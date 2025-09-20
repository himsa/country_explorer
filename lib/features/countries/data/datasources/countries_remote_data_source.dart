import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country_model.dart';

/// Abstract interface for remote data source operations
///
/// This interface defines the contract for fetching countries data
/// from remote APIs. It follows the Data Source pattern which
/// abstracts the external data access logic.
abstract class CountriesRemoteDataSource {
  /// Fetches all countries from the remote API
  Future<List<CountryModel>> getAllCountries();

  /// Fetches a specific country by name from the remote API
  Future<CountryModel> getCountryByName(String name);
}

/// Implementation of remote data source using REST Countries API
///
/// This class handles HTTP requests to the REST Countries API v3.1
/// and converts the responses to CountryModel instances. It includes
/// proper error handling and field selection for optimal performance.
///
/// API Documentation: https://restcountries.com/
class CountriesRemoteDataSourceImpl implements CountriesRemoteDataSource {
  /// HTTP client for making network requests
  final http.Client client;

  CountriesRemoteDataSourceImpl(this.client);

  /// Base URL for the REST Countries API
  static const baseUrl = 'https://restcountries.com/v3.1';

  /// Fetches all countries from the REST Countries API
  ///
  /// Makes a GET request to /all endpoint with specific fields
  /// to optimize response size and parsing performance.
  ///
  /// Returns a list of CountryModel instances or throws an exception
  /// if the request fails.
  @override
  Future<List<CountryModel>> getAllCountries() async {
    final response = await client.get(
      Uri.parse(
        '$baseUrl/all?fields=name,capital,flags,population,area,languages,coatOfArms,cca2',
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);
      return decoded.map((e) => CountryModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }

  /// Fetches a specific country by name from the REST Countries API
  ///
  /// Makes a GET request to /name/{name} endpoint with specific fields
  /// to get detailed information about a single country.
  ///
  /// Returns a CountryModel instance or throws an exception
  /// if the request fails or country is not found.
  @override
  Future<CountryModel> getCountryByName(String name) async {
    final response = await client.get(
      Uri.parse(
        '$baseUrl/name/$name?fields=name,capital,flags,population,area,languages,coatOfArms,cca2',
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);
      return CountryModel.fromJson(decoded.first);
    } else {
      throw Exception('Failed to load country detail');
    }
  }
}
