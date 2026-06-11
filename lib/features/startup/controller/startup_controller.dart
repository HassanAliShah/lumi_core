import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lumi_core/routes/routes.dart';

/// Decides the first screen to show after the splash based on onboarding status.
class StartupController extends GetxController {

  /// Variable
  static const _firstTimeKey = 'isFirstTime';

  @override
  void onReady() {
    super.onReady();
    _redirect();
  }

  void _redirect() {
    final storage = GetStorage();

    // Default to true if the key has never been written (fresh install)
    final isFirstTime = storage.read<bool>(_firstTimeKey) ?? true;

    // Remove native splash before navigating
    FlutterNativeSplash.remove();

    // Send first-time users to onboarding, returning users straight to weather
    Get.offAllNamed(isFirstTime ? TRoutes.onBoarding : TRoutes.weather);
  }
}