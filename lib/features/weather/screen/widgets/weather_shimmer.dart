import 'package:flutter/material.dart';
import 'package:lumi_core/common/widgets/shimmers/shimmer.dart';
import 'package:lumi_core/utils/constants/sizes.dart';

/// Shimmer loading UI shown while weather data is being fetched.
class TWeatherShimmer extends StatelessWidget {
  const TWeatherShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TShimmerEffect(width: double.infinity, height: 420, radius: 8),
        SizedBox(height: TSizes.spaceBtwItems),
        Row(
          children: [
            Expanded(child: TShimmerEffect(width: double.infinity, height: 80)),
            SizedBox(width: TSizes.spaceBtwItems),
            Expanded(child: TShimmerEffect(width: double.infinity, height: 80)),
          ],
        ),
      ],
    );
  }
}
