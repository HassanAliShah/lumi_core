import 'package:get_storage/get_storage.dart';
import 'package:lumi_core/utils/exceptions/cache_exceptions.dart';

/// Local cache service for last-viewed weather and recent city searches.
class TWeatherCacheService {
  static const String _lastViewedWeatherKey = 'lastViewedWeather';
  static const String _recentSearchesKey = 'recentWeatherSearches';
  static const int _maxRecentSearches = 8;

  final GetStorage _storage;

  /// Creates a weather cache service with optional injected storage.
  TWeatherCacheService({GetStorage? storage})
      : _storage = storage ?? GetStorage();

  /// Save the most recently viewed weather response for offline access.
  Future<void> saveLastViewedWeather(Map<String, dynamic> weatherJson) async {
    try {
      await _storage.write(_lastViewedWeatherKey, weatherJson);
    } catch (_) {
      throw const TCacheException('Unable to save weather data for offline use.');
    }
  }

  /// Read the last viewed weather response from local cache.
  Future<Map<String, dynamic>?> getLastViewedWeather() async {
    try {
      final cachedWeather = _storage.read(_lastViewedWeatherKey);

      if (cachedWeather == null) return null;
      if (cachedWeather is Map) return Map<String, dynamic>.from(cachedWeather);

      throw const TCacheException('Cached weather data is invalid.');
    } catch (e) {
      if (e is TCacheException) rethrow;
      throw const TCacheException();
    }
  }

  /// Save a city search locally and keep recent searches unique.
  Future<void> saveRecentSearch(String cityName) async {
    final trimmedCity = cityName.trim();
    if (trimmedCity.isEmpty) return;

    try {
      final searches = getRecentSearches();
      searches.removeWhere(
        (city) => city.toLowerCase() == trimmedCity.toLowerCase(),
      );
      searches.insert(0, trimmedCity);

      await _storage.write(
        _recentSearchesKey,
        searches.take(_maxRecentSearches).toList(),
      );
    } catch (_) {
      throw const TCacheException('Unable to save recent search.');
    }
  }

  /// Read recent city searches from local cache.
  List<String> getRecentSearches() {
    final searches = _storage.read<List<dynamic>>(_recentSearchesKey);
    if (searches == null) return [];

    return searches.map((city) => city.toString()).toList();
  }
}
