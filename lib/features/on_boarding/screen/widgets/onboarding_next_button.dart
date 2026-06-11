import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lumi_core/features/on_boarding/controller/onboarding_controller.dart';
import 'package:lumi_core/utils/constants/colors.dart';
import 'package:lumi_core/utils/constants/sizes.dart';
import 'package:lumi_core/utils/device/device_utility.dart';
import 'package:lumi_core/utils/helpers/helper_functions.dart';


class TOnBoardingNextButton extends StatelessWidget {
  const TOnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      right: TSizes.defaultSpace,
      bottom: TDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () => OnBoardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(shape: const CircleBorder(), backgroundColor: dark ? TColors.primary : Colors.black),
        child: const Icon(Iconsax.arrow_right_3, color: TColors.white),
      ),
    );
  }
}
