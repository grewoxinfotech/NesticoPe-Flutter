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
      Get.snackbar(
        'Error',
        errorMessage.value!,
        snackPosition: SnackPosition.BOTTOM,
      );
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

  /// Clear cached data
  void clearData() {
    marketInsight.value = null;
    errorMessage.value = null;
  }
}
