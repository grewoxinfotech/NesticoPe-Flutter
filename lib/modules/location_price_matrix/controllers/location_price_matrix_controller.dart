import 'package:get/get.dart';

import '../../../data/network/location_price_matrix/model/location_price_matrix_model.dart';
import '../../../data/network/location_price_matrix/service/location_price_matrix_service.dart';

class LocationPriceMatrixController extends GetxController {
  final MarketInsightService _service = MarketInsightService.instance;

  final String city;
  final String location;
  final String state;
  final String propertyType;

  LocationPriceMatrixController({
    required this.city,
    required this.propertyType,
    required this.location,
    required this.state,
  });

  @override
  void onInit() {
    super.onInit();

    fetchMarketInsights(
      filters: {
        'location': location,
        'propertyTypes': propertyType,
        'city': city,
        'state': state,
      },
    );
  }

  // Loading state
  final isLoading = false.obs;

  // API response
  final Rxn<MarketInsightResponse> marketInsight = Rxn<MarketInsightResponse>();

  // Error message (optional)
  final RxnString errorMessage = RxnString();

  /// Fetch market insights with optional filters
  ///
  /// Example filters:
  /// {
  ///   "type": "buy",
  ///   "state": "Gujarat",
  ///   "city": "Surat"
  /// }
  Future<void> fetchMarketInsights({
    Map<String, String>? filters,
    bool showLoader = true,
  }) async {
    try {
      if (showLoader) isLoading.value = true;
      errorMessage.value = null;

      final response = await _service.fetchMarketInsights(filters: filters);

      marketInsight.value = response;
    } catch (e) {
      errorMessage.value = e.toString();
      // Get.snackbar(
      //   'Error',
      //   errorMessage.value!,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }

  /// Convenience getter – Buy data
  Map<String, Map<String, List<LocationInsight>>>? get buyData =>
      marketInsight.value?.data.buy;

  Map<String, List<LocationInsight>>? get buyDataByState =>
      marketInsight.value?.data.buy[state];

  List<LocationInsight>? get buyDataByCity =>
      marketInsight.value?.data.buy[state]?[city];

  List<PriceTrend>? get avgPriceTrendByCity =>
      marketInsight.value?.data.buy[state]?[city]?.first.priceTrend;

  /// Convenience getter – Rent data
  Map<String, dynamic>? get rentData => marketInsight.value?.data.rent;

  /// Get average price trend by property type across all states and cities
  /// This compares the current property type with other property types in the same state/city
  List<PriceTrend>? getAvgPriceTrendByPropertyType() {
    try {
      final buyData = marketInsight.value?.data.buy;
      if (buyData == null || propertyType.isEmpty) return null;

      final stateData = buyData[state];
      if (stateData == null) return null;

      final cityData = stateData[city];
      if (cityData == null) return null;

      // Find location data that matches current location
      final locationData = cityData.firstWhereOrNull(
        (loc) =>
            loc.location.toLowerCase() == location.toLowerCase() ||
            loc.location.toLowerCase().contains(location.toLowerCase()),
      );

      if (locationData == null) return null;

      // Get property type data for current property type
      final propertyTypeData = locationData.propertyTypes[propertyType];
      if (propertyTypeData == null) return null;

      return propertyTypeData.priceTrend;
    } catch (e) {
      return null;
    }
  }

  /// Get average price trend by city for a specific locality
  /// This compares the current locality with city averages
  List<PriceTrend>? getAvgPriceTrendByCity() {
    try {
      final buyData = marketInsight.value?.data.buy;
      if (buyData == null) return null;

      final stateData = buyData[state];
      if (stateData == null) return null;

      final cityData = stateData[city];
      if (cityData == null || cityData.isEmpty) return null;

      // Get the first location's price trend for city average
      return cityData.first.priceTrend;
    } catch (e) {
      return null;
    }
  }

  /// Clear cached data
  void clearData() {
    marketInsight.value = null;
    errorMessage.value = null;
  }
}
