import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumi_core/features/on_boarding/controller/onboarding_controller.dart';
import 'package:lumi_core/utils/constants/sizes.dart';
import 'package:lumi_core/utils/constants/text_strings.dart';
import 'package:lumi_core/utils/device/device_utility.dart';


class TOnBoardingSkipButton extends StatelessWidget {
  const TOnBoardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;

    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      right: TSizes.defaultSpace,
      child: TextButton(onPressed: controller.skipPage, child: Text(TTexts.skip.tr)),
    );
  }
}
