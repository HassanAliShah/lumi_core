# LumiCore Weather

A weather app with repository pattern,
OpenWeather integration, recent searches, and offline cache support.

## Features

- Search current weather by city name.
- Display city name, temperature, weather condition, humidity, wind speed,
  pressure, visibility, clouds, sunrise, sunset, and coordinates.
- Show OpenWeather condition icons and feels-like/min/max temperature.
- Cache the last viewed weather response locally with GetStorage.
- Show cached weather when a network/server failure allows a safe fallback.
- Store and display recent city searches locally.
- Prevent duplicate requests while loading.
- Show shimmer loading UI during API calls.
- Support pull-to-refresh for the current city.
- Show user-friendly network and cache error messages.

## Setup

1. Install dependencies:

```bash
flutter pub get
```

2. Add your OpenWeather API key. Create a file at env/open_weather.json and add your key in the following format:
   {
   "OPEN_WEATHER_API_KEY": "your_openweather_api_key_here"
   }


3. Run the app with the local define file:

```bash
flutter run --dart-define-from-file=env/open_weather.json
```

### Debug

```bash
flutter build apk --dart-define-from-file=env/open_weather.json
```

### Release

```bash
flutter build apk --release --dart-define-from-file=env/open_weather.json
```


The app uses OpenWeather current weather endpoint:

```text
https://api.openweathermap.org/data/2.5/weather
```

## Architecture

The project follows a feature-first structure with a shared data layer.

- `lib/utils/http/api_service.dart`
  Shared API client used by repositories.

- `lib/utils/exceptions`
  User-friendly network, cache, Firebase, platform, and format exceptions.

- `lib/data/abstract/t_weather_repository.dart`
  Repository contract consumed by presentation/state layers.

- `lib/data/repositories/weather_repository_impl.dart`
  Weather repository implementation. It coordinates API calls, model mapping,
  recent searches, and offline cache fallback.

- `lib/data/services/cache_service/weather_cache_service.dart`
  Local storage service for last-viewed weather and recent searches.

- `lib/features/weather`
  Weather feature UI, controller, model, and entity.

## Offline Cache Behavior

The repository falls back to cached weather for failures where cached data is
safe to show, such as no connection, timeout, rate limiting, or server errors.
It does not show old cached weather for invalid city errors like `404`, because
that would be misleading for the user.
