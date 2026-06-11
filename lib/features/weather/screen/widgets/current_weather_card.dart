import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lumi_core/features/weather/entities/weather_entity.dart';
import 'package:lumi_core/utils/constants/colors.dart';
import 'package:lumi_core/utils/constants/sizes.dart';
import 'package:lumi_core/utils/constants/text_strings.dart';

/// Displays the current weather information returned by OpenWeather.
class TCurrentWeatherCard extends StatelessWidget {
  final WeatherEntity weather;

  const TCurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    /// -- Format display values
    final location = weather.countryCode.isEmpty ? weather.cityName : '${weather.cityName}, ${weather.countryCode}';
    final updatedAt = _formatWeatherTime(weather.updatedAt);
    final sunrise = _formatWeatherTime(weather.sunrise);
    final sunset = _formatWeatherTime(weather.sunset);

    return Container(
      padding: const EdgeInsets.all(TSizes.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: TColors.clearSkyGradient),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -- Show offline badge if data is loaded from cache
          if (weather.isFromCache) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.xs),
              decoration: BoxDecoration(
                color: TColors.black.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
              ),
              child: Text(TTexts.offlineCachedData.tr, style: TextStyle(color: TColors.white)),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
          ],

          /// -- City name, description, last updated and weather icon
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: TColors.white, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: TSizes.xs),
                    Text(_toTitleCase(weather.description), style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: TColors.white)),
                    const SizedBox(height: TSizes.xs),
                    Text(
                      '${TTexts.updated.tr} $updatedAt',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: TColors.white.withValues(alpha: 0.85)),
                    ),
                  ],
                ),
              ),

              /// -- Weather condition icon from OpenWeather CDN
              CachedNetworkImage(
                imageUrl: weather.iconUrl,
                height: 64,
                width: 64,
                fit: BoxFit.contain,
                placeholder: (_, __) => const Icon(Icons.cloud_outlined, color: TColors.white, size: 42),
                errorWidget: (_, __, ___) => const Icon(Icons.cloud_outlined, color: TColors.white, size: 42),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          /// -- Current temperature
          Text(
            '${weather.temperature.toStringAsFixed(0)}\u00B0C',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(color: TColors.white, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: TSizes.xs),

          /// --  Feels like, high and low temperatures
          Text(
            '${TTexts.feelsLike.tr} ${weather.feelsLike.toStringAsFixed(0)}\u00B0C  |  H: ${weather.tempMax.toStringAsFixed(0)}\u00B0  L: ${weather.tempMin.toStringAsFixed(0)}\u00B0',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: TColors.white.withValues(alpha: 0.92)),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// -- Detailed weather metrics in a responsive wrap layout
          LayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = constraints.maxWidth < 520 ? constraints.maxWidth : (constraints.maxWidth - TSizes.spaceBtwItems) / 2;

              return Wrap(
                spacing: TSizes.spaceBtwItems,
                runSpacing: TSizes.spaceBtwItems,
                children: [
                  _WeatherMetric(
                    width: tileWidth,
                    icon: Icons.water_drop_outlined,
                    label: TTexts.humidity.tr,
                    value: '${weather.humidity}%',
                  ),
                  _WeatherMetric(width: tileWidth, icon: Icons.air, label: TTexts.wind.tr, value: _windValue(weather)),
                  _WeatherMetric(width: tileWidth, icon: Icons.speed, label: TTexts.pressure.tr, value: '${weather.pressure} hPa'),
                  _WeatherMetric(width: tileWidth, icon: Icons.cloud_queue, label: TTexts.clouds.tr, value: '${weather.cloudiness}%'),
                  _WeatherMetric(
                    width: tileWidth,
                    icon: Icons.visibility_outlined,
                    label: TTexts.visibility.tr,
                    value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
                  ),
                  _WeatherMetric(width: tileWidth, icon: Icons.wb_twilight_outlined, label: 'Sun', value: '$sunrise / $sunset'),
                ],
              );
            },
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// -- Coordinates
          Text(
            '${TTexts.coordinates.tr} ${weather.latitude.toStringAsFixed(2)}, ${weather.longitude.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: TColors.white.withValues(alpha: 0.82)),
          ),

          /// -- Sea and ground pressure levels if available
          if (weather.seaLevel != null || weather.groundLevel != null) ...[
            const SizedBox(height: TSizes.xs),
            Text(
              _pressureLevels(weather),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: TColors.white.withValues(alpha: 0.82)),
            ),
          ],
        ],
      ),
    );
  }

  /// -- Converts UTC time to local city time using the timezone offset
  String _formatWeatherTime(DateTime value) {
    final shifted = value.toUtc().add(Duration(seconds: weather.timezoneOffset));
    return DateFormat('h:mm a').format(shifted);
  }

  /// -- Builds wind speed string with optional gust info
  String _windValue(WeatherEntity weather) {
    final gust = weather.windGust == null ? '' : ', gust ${weather.windGust!.toStringAsFixed(1)}';
    return '${weather.windSpeed.toStringAsFixed(1)} m/s, ${weather.windDegree}\u00B0$gust';
  }

  /// -- Builds sea and ground level pressure string
  String _pressureLevels(WeatherEntity weather) {
    final levels = <String>[
      if (weather.seaLevel != null) 'Sea ${weather.seaLevel} hPa',
      if (weather.groundLevel != null) 'Ground ${weather.groundLevel} hPa',
    ];
    return levels.join('  |  ');
  }

  /// -- Capitalises the first letter of each word in the description
  String _toTitleCase(String value) {
    return value.split(' ').where((word) => word.isNotEmpty).map((word) => '${word[0].toUpperCase()}${word.substring(1)}').join(' ');
  }
}

/// Small metric tile for the detailed weather readings.
class _WeatherMetric extends StatelessWidget {
  final double width;
  final IconData icon;
  final String label;
  final String value;

  const _WeatherMetric({required this.width, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(color: TColors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(TSizes.borderRadiusMd)),
        child: Row(
          children: [
            Icon(icon, color: TColors.white),
            const SizedBox(width: TSizes.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// -- Metric label
                  Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: TColors.white)),

                  /// -- Metric value
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: TColors.white, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
