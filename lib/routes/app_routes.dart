import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:lumi_core/features/on_boarding/screen/onboarding.dart';
import 'package:lumi_core/features/weather/screen/weather_screen.dart';
import 'routes.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: TRoutes.onBoarding, page: () => const OnBoardingScreen()),
    GetPage(name: TRoutes.weather, page: () => const WeatherScreen()),
  ];
}
