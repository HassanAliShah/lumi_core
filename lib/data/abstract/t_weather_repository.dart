import 'package:lumi_core/features/weather/entities/weather_entity.dart';

/// Abstract contract for weather operations.
abstract class TWeatherRepository {
  /// Fetches current weather for a specific city.
  ///
  /// If online, it fetches from the remote API and updates the local cache.
  /// If offline, it falls back to the last-viewed cached weather when available.
  Future<WeatherEntity> getWeatherByCity(String cityName);

  /// Returns locally saved recent city searches.
  List<String> getRecentSearches();
}
