import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country_model.dart';

abstract class CountriesRemoteDataSource {
  Future<List<CountryModel>> getAllCountries();
  Future<CountryModel> getCountryByName(String name);
}

class CountriesRemoteDataSourceImpl implements CountriesRemoteDataSource {
  final http.Client client;

  CountriesRemoteDataSourceImpl(this.client);

  static const baseUrl = 'https://restcountries.com/v3.1';

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
