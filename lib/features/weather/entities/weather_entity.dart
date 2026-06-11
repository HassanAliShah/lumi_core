/// Entity class representing the weather data.
class WeatherEntity {
  final int cityId;
  final String cityName;
  final String countryCode;
  final double latitude;
  final double longitude;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final String condition;
  final String description;
  final String iconCode;
  final int humidity;
  final int pressure;
  final int? seaLevel;
  final int? groundLevel;
  final int visibility;
  final double windSpeed;
  final int windDegree;
  final double? windGust;
  final int cloudiness;
  final DateTime updatedAt;
  final DateTime sunrise;
  final DateTime sunset;
  final int timezoneOffset;
  final bool isFromCache;

  const WeatherEntity({
    required this.cityId,
    required this.cityName,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.pressure,
    required this.visibility,
    required this.windSpeed,
    required this.windDegree,
    required this.cloudiness,
    required this.updatedAt,
    required this.sunrise,
    required this.sunset,
    required this.timezoneOffset,
    this.seaLevel,
    this.groundLevel,
    this.windGust,
    this.isFromCache = false,
  });

  /// OpenWeather hosts condition icons with the same code returned by the API.
  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';
}
