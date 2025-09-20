import '../../domain/entities/country.dart';

/// Data model for country information with JSON serialization/deserialization
///
/// This model extends the domain Country entity and adds data layer
/// functionality for JSON parsing and serialization. It handles the
/// conversion between API responses and domain entities.
///
/// Key features:
/// - Extends the domain Country entity
/// - Handles JSON parsing from REST Countries API
/// - Converts country codes to flag emojis
/// - Provides robust error handling for malformed data
/// - Supports serialization back to JSON format
class CountryModel extends Country {
  const CountryModel({
    required super.name,
    required super.flagEmoji,
    required super.capital,
    super.population,
    super.area,
    super.languages,
    super.coatOfArmsUrl,
  });

  /// Creates a CountryModel from JSON data
  ///
  /// Parses the REST Countries API response format and converts it
  /// to a CountryModel instance. Handles various data formats and
  /// provides fallback values for missing or malformed data.
  ///
  /// Expected JSON structure:
  /// ```json
  /// {
  ///   "name": {"common": "Country Name"},
  ///   "cca2": "CC",
  ///   "capital": ["Capital City"],
  ///   "population": 1234567,
  ///   "area": 1234.56,
  ///   "languages": {"lang1": "Language 1", "lang2": "Language 2"},
  ///   "coatOfArms": {"png": "https://example.com/coat.png"}
  /// }
  /// ```
  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name']?['common'] ?? '',
      flagEmoji: _getFlagEmoji(json['cca2'] ?? ''),
      capital:
          (json['capital'] != null &&
              json['capital'] is List &&
              json['capital'].isNotEmpty)
          ? json['capital'][0]
          : '',
      population: json['population'],
      area: (json['area'] is int)
          ? (json['area'] as int).toDouble()
          : (json['area'] as num?)?.toDouble(),
      languages: json['languages'] != null
          ? (json['languages'] as Map<String, dynamic>).values
                .map((e) => e.toString())
                .toList()
          : [],
      coatOfArmsUrl: json['coatOfArms']?['png'],
    );
  }

  /// Converts country code (cca2) to flag emoji using Unicode regional indicator symbols
  ///
  /// This method converts a 2-letter country code (ISO 3166-1 alpha-2)
  /// to its corresponding flag emoji using Unicode regional indicator symbols.
  ///
  /// The conversion works by:
  /// 1. Taking each letter of the country code
  /// 2. Converting it to a regional indicator symbol (U+1F1E6 to U+1F1FF)
  /// 3. Combining the symbols to form the flag emoji
  ///
  /// Example: "US" -> 🇺🇸, "GB" -> 🇬🇧, "FR" -> 🇫🇷
  ///
  /// Returns '🏳️' (default flag) for invalid or empty codes.
  static String _getFlagEmoji(String countryCode) {
    if (countryCode.isEmpty || countryCode.length != 2) {
      return '🏳️'; // Default flag emoji
    }

    // Convert country code to flag emoji
    // Each letter is converted to a regional indicator symbol (U+1F1E6 to U+1F1FF)
    final codePoints = countryCode
        .toUpperCase()
        .split('')
        .map((char) => 0x1F1E6 + char.codeUnitAt(0) - 'A'.codeUnitAt(0))
        .toList();

    return String.fromCharCodes(codePoints);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': {'common': name},
      'cca2': _getCountryCodeFromEmoji(flagEmoji),
      'capital': [capital],
      'population': population,
      'area': area,
      'languages': languages,
      'coatOfArms': {'png': coatOfArmsUrl},
    };
  }

  /// Extract country code from flag emoji (reverse of _getFlagEmoji)
  static String _getCountryCodeFromEmoji(String flagEmoji) {
    if (flagEmoji.isEmpty || flagEmoji == '🏳️') {
      return '';
    }

    try {
      // Convert flag emoji back to country code
      final codeUnits = flagEmoji.codeUnits;
      if (codeUnits.length >= 4) {
        // Take the first two regional indicator symbols
        final char1 = String.fromCharCode(
          codeUnits[0] - 0x1F1E6 + 'A'.codeUnitAt(0),
        );
        final char2 = String.fromCharCode(
          codeUnits[2] - 0x1F1E6 + 'A'.codeUnitAt(0),
        );
        return char1 + char2;
      }
    } catch (e) {
      // If conversion fails, return empty string
    }

    return '';
  }
}
