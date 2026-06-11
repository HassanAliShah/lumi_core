/// API Constants
class TAPIs {
  // Weather API
  static const String openWeatherBaseUrl =
      'https://api.openweathermap.org/data/2.5';
  static const String   openWeatherApiKey = String.fromEnvironment(
    'OPEN_WEATHER_API_KEY',
    defaultValue: 'ADD_YOUR_OPEN_WEATHER_API_KEY',
  );

}
