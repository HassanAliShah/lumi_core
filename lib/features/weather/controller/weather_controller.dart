import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lumi_core/data/abstract/t_weather_repository.dart';
import 'package:lumi_core/features/weather/entities/weather_entity.dart';
import 'package:lumi_core/utils/constants/api_constants.dart';
import 'package:lumi_core/utils/exceptions/cache_exceptions.dart';
import 'package:lumi_core/utils/exceptions/network_exceptions.dart';
import 'package:lumi_core/utils/helpers/network_manager.dart';
import 'package:lumi_core/utils/popups/loaders.dart';

/// Controller responsible for weather search state and user interactions.
class WeatherController extends GetxController {
  /// Singleton instance of the WeatherController
  static WeatherController get instance =>
      Get.isRegistered<WeatherController>() ? Get.find<WeatherController>() : Get.put(WeatherController(Get.find<TWeatherRepository>()));

  /// Repository contract keeps the controller independent from API/cache details.
  final TWeatherRepository _weatherRepository;

  WeatherController(this._weatherRepository);

  /// Text controller for the city search input.
  final searchController = TextEditingController();

  /// Current weather result displayed on the UI.
  final Rxn<WeatherEntity> weather = Rxn<WeatherEntity>();

  /// Recent city searches displayed below the search box.
  final RxList<String> recentSearches = <String>[].obs;

  /// Loading state used for shimmer UI and duplicate request prevention.
  final RxBool isLoading = false.obs;

  /// Focus node for the city search input.
  final searchFocusNode = FocusNode();

  /// User-friendly error message displayed on the screen.
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecentSearches();
  }

  /// Load recent searches from local cache.
  void loadRecentSearches() {
    recentSearches.assignAll(_weatherRepository.getRecentSearches());
  }

  /// Search weather using the current text field value.
  Future<void> searchWeather() async {
    searchFocusNode.unfocus();
    await getWeatherByCity(searchController.text);
  }

  /// Reload weather for a selected recent search.
  Future<void> searchRecentCity(String cityName) async {
    searchController.text = cityName;
    await getWeatherByCity(cityName);
  }

  /// Pull-to-refresh handler for the currently displayed city.
  Future<void> refreshWeather() async {
    final currentCity = weather.value?.cityName ?? searchController.text;
    await getWeatherByCity(currentCity, showEmptyError: false);
  }

  /// Fetch weather by city and update loading, result, cache, and errors.
  Future<void> getWeatherByCity(String cityName, {bool showEmptyError = true}) async {
    final trimmedCity = cityName.trim();

    // Show error if city name is empty
    if (trimmedCity.isEmpty) {
      if (showEmptyError) {
        errorMessage.value = 'Please enter a city name.';
      }
      return;
    }

    // Check Internet Connectivity
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TLoaders.customToast(message: 'No Internet Connection');
      return;
    }

    // Block execution if API key is not set
    if (TAPIs.openWeatherApiKey == 'ADD_YOUR_OPEN_WEATHER_API_KEY') {
      errorMessage.value = 'OpenWeather API key is missing. Add it before running the app.';
      TLoaders.warningSnackBar(title: 'Missing API Key', message: 'Add OPEN_WEATHER_API_KEY to fetch live weather.');
      return;
    }

    // Prevent duplicate requests while one is already in-flight
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _weatherRepository.getWeatherByCity(trimmedCity);
      weather.value = result;

      // Refresh chip list with the latest search
      loadRecentSearches();

      if (result.isFromCache) {
        errorMessage.value = 'Showing last saved weather because you are offline.';
      }
    } on TNetworkException catch (e) {
      errorMessage.value = e.message;
      TLoaders.errorSnackBar(title: 'Weather Error', message: e.message);
    } on TCacheException catch (e) {
      errorMessage.value = e.message;
      TLoaders.errorSnackBar(title: 'Cache Error', message: e.message);
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.';
      TLoaders.errorSnackBar(title: 'Weather Error', message: errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
