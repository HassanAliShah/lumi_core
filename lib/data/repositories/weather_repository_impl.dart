import 'package:lumi_core/data/abstract/t_weather_repository.dart';
import 'package:lumi_core/data/services/cache_service/weather_cache_service.dart';
import 'package:lumi_core/features/weather/entities/weather_entity.dart';
import 'package:lumi_core/features/weather/models/open_weather_model.dart';
import 'package:lumi_core/utils/constants/api_constants.dart';
import 'package:lumi_core/utils/exceptions/network_exceptions.dart';
import 'package:lumi_core/utils/http/api_service.dart';

/// Weather repository that coordinates remote API and local cache access.
class WeatherRepositoryImpl implements TWeatherRepository {
  final TApiService _apiService;
  final TWeatherCacheService _cacheService;

  WeatherRepositoryImpl(this._apiService, this._cacheService);

  @override
  Future<WeatherEntity> getWeatherByCity(String cityName) async {
    final trimmedCity = cityName.trim();

    try {
      // Fetch live weather from OpenWeather API
      final jsonResponse = await _apiService.get(
        'weather',
        queryParameters: {'q': trimmedCity, 'appid': TAPIs.openWeatherApiKey, 'units': 'metric'},
      );

      // Parse response and convert to entity
      final remoteModel = OpenWeatherModel.fromJson(jsonResponse);
      final entity = remoteModel.toEntity();

      // Save result and city to local cache for offline use
      await _cacheService.saveLastViewedWeather(jsonResponse);
      await _cacheService.saveRecentSearch(trimmedCity);

      return entity;
    } on TNetworkException catch (error) {
      // If offline and cache is not usable, rethrow to let controller handle it
      if (!error.canUseCachedWeather) rethrow;

      // Try to return the last cached weather when offline
      final cachedWeather = await _cacheService.getLastViewedWeather();
      if (cachedWeather == null) rethrow;

      // Mark the entity as coming from cache so the UI can show an offline badge
      final cachedModel = OpenWeatherModel.fromJson(cachedWeather);
      return cachedModel.toEntity(isFromCache: true);
    }
  }

  // Returns the list of recently searched cities from local cache
  @override
  List<String> getRecentSearches() => _cacheService.getRecentSearches();
}
