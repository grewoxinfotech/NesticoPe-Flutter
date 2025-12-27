import 'package:get/get.dart';

import '../../../data/network/location_price_matrix/model/location_price_matrix_model.dart';
import '../../../data/network/location_price_matrix/service/location_price_matrix_service.dart';

class LocationPriceMatrixController extends GetxController {
  final MarketInsightService _service = MarketInsightService.instance;

  final String city;
  final String propertyType;

  LocationPriceMatrixController({
    required this.city,
    required this.propertyType,
  });

  @override
  void onInit() {
    super.onInit();

    fetchMarketInsights(
      filters: {'location': city, 'propertyTypes': propertyType},
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

  /// Convenience getter – Rent data
  Map<String, dynamic>? get rentData => marketInsight.value?.data.rent;

  /// Clear cached data
  void clearData() {
    marketInsight.value = null;
    errorMessage.value = null;
  }
}
