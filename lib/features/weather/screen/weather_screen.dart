import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lumi_core/common/widgets/app_bar/app_bar.dart';
import 'package:lumi_core/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:lumi_core/common/widgets/icons/t_circular_icon.dart';
import 'package:lumi_core/features/weather/controller/weather_controller.dart';
import 'package:lumi_core/features/weather/screen/widgets/current_weather_card.dart';
import 'package:lumi_core/features/weather/screen/widgets/recent_searches.dart';
import 'package:lumi_core/features/weather/screen/widgets/weather_search_bar.dart';
import 'package:lumi_core/features/weather/screen/widgets/weather_shimmer.dart';
import 'package:lumi_core/utils/constants/colors.dart';
import 'package:lumi_core/utils/constants/sizes.dart';
import 'package:lumi_core/utils/constants/text_strings.dart';
import 'package:lumi_core/utils/helpers/helper_functions.dart';

/// Main weather screen with search, recent searches and pull-to-refresh.
class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WeatherController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: TAppBar(
        title: Text(TTexts.lumiCoreWeather.tr),
        actions: [
          TCircularIcon(
            icon: Get.isDarkMode ? Iconsax.sun_1 : Iconsax.moon,
            onPressed: () {
              Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),

      /// -- Pull down to refresh weather for the current city
      body: RefreshIndicator(
        onRefresh: controller.refreshWeather,
        child: ListView(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          children: [
            /// -- City search input and submit button
            const TWeatherSearchBar(),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// -- Error banner hidden when there is no error
            Obx(() {
              if (controller.errorMessage.value.isEmpty) return const SizedBox.shrink();

              return TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.md),
                margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                backgroundColor: dark ? TColors.darkContainer : TColors.primaryBackground,
                child: Text(controller.errorMessage.value, style: Theme.of(context).textTheme.bodyMedium),
              );
            }),

            /// -- Show shimmer while loading, empty state before first search, or weather card
            Obx(() {
              if (controller.isLoading.value) return const TWeatherShimmer();

              final weather = controller.weather.value;
              if (weather == null) return const _EmptyWeatherState();

              return TCurrentWeatherCard(weather: weather);
            }),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// -- Recently searched cities
            const TRecentSearches(),
          ],
        ),
      ),
    );
  }
}

/// Empty state shown before the first weather search.
class _EmptyWeatherState extends StatelessWidget {
  const _EmptyWeatherState();

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return TRoundedContainer(
      padding: const EdgeInsets.all(TSizes.lg),
      backgroundColor: dark ? TColors.darkContainer : TColors.primaryBackground,
      child: Column(
        children: [
          // Cloud icon
          TCircularIcon(icon: Iconsax.cloud, size: TSizes.iconLg, color: TColors.primary),
          const SizedBox(height: TSizes.spaceBtwItems),

          // Search City Text
          Text(TTexts.searchCityToViewCurrentWeather.tr, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
