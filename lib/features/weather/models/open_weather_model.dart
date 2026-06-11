import 'package:lumi_core/features/weather/entities/weather_entity.dart';

/// Model for parsing OpenWeather current weather responses.
class OpenWeatherModel {
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

  const OpenWeatherModel({
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
  });

  /// Create an OpenWeather model from raw JSON
  factory OpenWeatherModel.fromJson(Map<String, dynamic> json) {
    final coord = Map<String, dynamic>.from(json['coord'] as Map);
    final main = Map<String, dynamic>.from(json['main'] as Map);
    final wind = Map<String, dynamic>.from(json['wind'] as Map);
    final clouds = Map<String, dynamic>.from(json['clouds'] as Map);
    final sys = Map<String, dynamic>.from(json['sys'] as Map);
    final weather = List<dynamic>.from(json['weather'] as List);
    final firstWeather = Map<String, dynamic>.from(weather.first as Map);

    return OpenWeatherModel(
      cityId: (json['id'] as num).toInt(),
      cityName: json['name'] as String,
      countryCode: sys['country'] as String? ?? '',
      latitude: (coord['lat'] as num).toDouble(),
      longitude: (coord['lon'] as num).toDouble(),
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),
      condition: firstWeather['main'] as String,
      description: firstWeather['description'] as String,
      iconCode: firstWeather['icon'] as String,
      humidity: (main['humidity'] as num).toInt(),
      pressure: (main['pressure'] as num).toInt(),
      seaLevel: (main['sea_level'] as num?)?.toInt(),
      groundLevel: (main['grnd_level'] as num?)?.toInt(),
      visibility: (json['visibility'] as num? ?? 0).toInt(),
      windSpeed: (wind['speed'] as num).toDouble(),
      windDegree: (wind['deg'] as num? ?? 0).toInt(),
      windGust: (wind['gust'] as num?)?.toDouble(),
      cloudiness: (clouds['all'] as num? ?? 0).toInt(),
      updatedAt: _fromUnixSeconds(json['dt'] as num),
      sunrise: _fromUnixSeconds(sys['sunrise'] as num),
      sunset: _fromUnixSeconds(sys['sunset'] as num),
      timezoneOffset: (json['timezone'] as num? ?? 0).toInt(),
    );
  }

  /// Map Model into the entity
  WeatherEntity toEntity({bool isFromCache = false}) {
    return WeatherEntity(
      cityId: cityId,
      cityName: cityName,
      countryCode: countryCode,
      latitude: latitude,
      longitude: longitude,
      temperature: temperature,
      feelsLike: feelsLike,
      tempMin: tempMin,
      tempMax: tempMax,
      condition: condition,
      description: description,
      iconCode: iconCode,
      humidity: humidity,
      pressure: pressure,
      seaLevel: seaLevel,
      groundLevel: groundLevel,
      visibility: visibility,
      windSpeed: windSpeed,
      windDegree: windDegree,
      windGust: windGust,
      cloudiness: cloudiness,
      updatedAt: updatedAt,
      sunrise: sunrise,
      sunset: sunset,
      timezoneOffset: timezoneOffset,
      isFromCache: isFromCache,
    );
  }

  static DateTime _fromUnixSeconds(num seconds) {
    return DateTime.fromMillisecondsSinceEpoch(seconds.toInt() * 1000, isUtc: true);
  }
}
