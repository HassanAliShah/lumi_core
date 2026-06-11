import 'package:flutter_test/flutter_test.dart';
import 'package:lumi_core/features/weather/models/open_weather_model.dart';

void main() {
  group('OpenWeatherModel', () {
    test('parses the current weather response into model fields', () {
      final model = OpenWeatherModel.fromJson(_openWeatherResponse);

      expect(model.cityId, 2643743);
      expect(model.cityName, 'London');
      expect(model.countryCode, 'GB');
      expect(model.latitude, 51.5085);
      expect(model.longitude, -0.1257);
      expect(model.temperature, 291.88);
      expect(model.feelsLike, 290.93);
      expect(model.tempMin, 290.98);
      expect(model.tempMax, 292.75);
      expect(model.condition, 'Clouds');
      expect(model.description, 'broken clouds');
      expect(model.iconCode, '04d');
      expect(model.humidity, 43);
      expect(model.pressure, 1014);
      expect(model.seaLevel, 1014);
      expect(model.groundLevel, 1010);
      expect(model.visibility, 10000);
      expect(model.windSpeed, 4.92);
      expect(model.windDegree, 299);
      expect(model.windGust, 8.94);
      expect(model.cloudiness, 72);
      expect(model.timezoneOffset, 3600);
    });

    test('maps the API model into the weather entity used by the UI', () {
      final entity = OpenWeatherModel.fromJson(_openWeatherResponse).toEntity(isFromCache: true);

      expect(entity.cityName, 'London');
      expect(entity.countryCode, 'GB');
      expect(entity.description, 'broken clouds');
      expect(entity.iconUrl, 'https://openweathermap.org/img/wn/04d@2x.png');
      expect(entity.isFromCache, isTrue);
      expect(entity.sunrise, DateTime.fromMillisecondsSinceEpoch(1780976664 * 1000, isUtc: true));
      expect(entity.sunset, DateTime.fromMillisecondsSinceEpoch(1781036117 * 1000, isUtc: true));
    });
  });
}

const Map<String, dynamic> _openWeatherResponse = {
  'coord': {'lon': -0.1257, 'lat': 51.5085},
  'weather': [
    {'id': 803, 'main': 'Clouds', 'description': 'broken clouds', 'icon': '04d'},
  ],
  'base': 'stations',
  'main': {
    'temp': 291.88,
    'feels_like': 290.93,
    'temp_min': 290.98,
    'temp_max': 292.75,
    'pressure': 1014,
    'humidity': 43,
    'sea_level': 1014,
    'grnd_level': 1010,
  },
  'visibility': 10000,
  'wind': {'speed': 4.92, 'deg': 299, 'gust': 8.94},
  'clouds': {'all': 72},
  'dt': 1781023440,
  'sys': {'type': 2, 'id': 2075535, 'country': 'GB', 'sunrise': 1780976664, 'sunset': 1781036117},
  'timezone': 3600,
  'id': 2643743,
  'name': 'London',
  'cod': 200,
};
