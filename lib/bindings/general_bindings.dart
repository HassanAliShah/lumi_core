import 'package:get/get.dart';
import 'package:lumi_core/data/abstract/t_weather_repository.dart';
import 'package:lumi_core/data/services/cache_service/weather_cache_service.dart';
import 'package:lumi_core/data/repositories/weather_repository_impl.dart';
import 'package:lumi_core/features/startup/controller/startup_controller.dart';
import 'package:lumi_core/localization/localization_helper.dart';
import 'package:lumi_core/utils/http/api_service.dart';

import '../utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    /// -- Core
    Get.put(NetworkManager());
    Get.put(StartupController());

    /// -- Services
    Get.lazyPut<TApiService>(() => TApiService(), fenix: true);
    Get.lazyPut<TWeatherCacheService>(() => TWeatherCacheService(), fenix: true);

    /// -- Repositories
    Get.lazyPut<TWeatherRepository>(() => WeatherRepositoryImpl(Get.find<TApiService>(), Get.find<TWeatherCacheService>()), fenix: true);
  }
}
