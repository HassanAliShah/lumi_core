import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lumi_core/features/weather/controller/weather_controller.dart';
import 'package:lumi_core/utils/constants/sizes.dart';
import 'package:lumi_core/utils/constants/text_strings.dart';

/// Search input used to submit weather requests by city name.
class TWeatherSearchBar extends StatelessWidget {
  const TWeatherSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeatherController>();

    return Row(
      children: [
        /// -- Search city field
        Expanded(
          child: TextFormField(
            controller: controller.searchController,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (_) => controller.searchWeather(),
            focusNode: controller.searchFocusNode,
            decoration: InputDecoration(prefixIcon: Icon(Iconsax.search_normal), hintText: TTexts.enterCityName.tr),
          ),
        ),
        const SizedBox(width: TSizes.sm),

        /// -- Search button
        Obx(
          () => SizedBox(
            height: 48,
            width: 48,
            child: ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.searchWeather,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.borderRadiusMd)),
              ),
              child: const Icon(Iconsax.arrow_right_3),
            ),
          ),
        ),
      ],
    );
  }
}
