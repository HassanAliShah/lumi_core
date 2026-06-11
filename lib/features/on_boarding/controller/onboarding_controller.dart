import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lumi_core/routes/routes.dart';

class OnBoardingController extends GetxController {
  /// Singleton instance of the OnBoardingController
  static OnBoardingController get instance =>
      Get.isRegistered<OnBoardingController>() ? Get.find<OnBoardingController>() : Get.put(OnBoardingController());

  /// Variables
  Rx<int> currentPageIndex = 0.obs;
  final pageController = PageController();

  /// Update Current Index when Page Scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  /// Jump to the specific dot selected page.
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  /// Update Current Index & jump to next page
  Future<void> nextPage() async {
    if (currentPageIndex.value == 2) {
      await _completeOnBoarding();
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  /// Update Current Index & jump to the last Page
  Future<void> skipPage() async {
    await _completeOnBoarding();
  }

  Future<void> _completeOnBoarding() async {
    final userStorage = GetStorage();
    await userStorage.write('isFirstTime', false);
    Get.offAllNamed(TRoutes.weather);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
