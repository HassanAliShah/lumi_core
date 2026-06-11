import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lumi_core/features/weather/controller/weather_controller.dart';
import 'package:lumi_core/utils/constants/colors.dart';
import 'package:lumi_core/utils/constants/sizes.dart';
import 'package:lumi_core/utils/constants/text_strings.dart';
import 'package:lumi_core/utils/helpers/helper_functions.dart';

/// Displays locally saved recent city searches.
class TRecentSearches extends StatelessWidget {
  const TRecentSearches({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WeatherController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Obx(() {
      /// -- Hide the section if there are no recent searches
      if (controller.recentSearches.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TTexts.recentSearches.tr, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// -- Each chip represents a previously searched city
          Wrap(
            spacing: TSizes.sm,
            runSpacing: TSizes.sm,
            children: controller.recentSearches
                .map(
                  (city) => ActionChip(
                    avatar: const Icon(Iconsax.clock, size: TSizes.iconSm),
                    label: Text(city),
                    backgroundColor: dark ? TColors.darkContainer : TColors.primaryBackground,
                    side: const BorderSide(color: TColors.borderSecondary),
                    onPressed: () => controller.searchRecentCity(city),
                  ),
                )
                .toList(),
          ),
        ],
      );
    });
  }
}
