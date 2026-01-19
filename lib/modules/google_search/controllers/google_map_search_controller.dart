import 'package:get/get.dart';
import '../../../confige/search_api/search_api.dart';
import '../../search_property/model/search_model.dart';

class GoogleMapSearchController extends GetxController {
  final GoogleMapApi _api = GoogleMapApi.instance;

  // --- Observables for UI ---
  final RxList<Prediction> predictions = <Prediction>[].obs;
  final RxList<Map<String, String>> zipcodes = <Map<String, String>>[].obs;
  final RxList<Map<String, dynamic>> nearbyLandmarks =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> nearbyPlaces =
      <Map<String, dynamic>>[].obs;
  final RxMap<String, double?> propertyCoords =
      <String, double?>{'lat': null, 'lng': null}.obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingZipcodes = false.obs;
  final RxBool isLoadingLandmarks = false.obs;
  final RxBool isVerifying = false.obs;

  // --- 1. City / State / Area Search ---

  /// Search for Cities only (mimics getLocationSuggestions)
  Future<void> fetchPredictionsCity(String input) async {
    if (input.isEmpty) return;
    try {
      isLoading.value = true;
      final response = await _api.searchCities(input);
      if (response['status'] == 'OK') {
        final List results = response['predictions'];
        predictions.assignAll(
          results.map((e) => Prediction.fromJson(e)).toList(),
        );
      } else {
        predictions.clear();
      }
    } catch (e) {
      print('Error fetching cities: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Search for Localities within a specific city
  Future<void> fetchLocalities(String query, String cityName) async {
    try {
      isLoading.value = true;
      final response = await _api.searchLocalities(query, cityFilter: cityName);
      final List results = response['predictions'] ?? [];
      predictions.assignAll(
        results.map((e) => Prediction.fromJson(e)).toList(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- 2. Zipcode Logic (Matches your JS Logic) ---

  /// Fetches all zipcodes for a city and filters them
  Future<void> fetchZipcodesForCity(String cityName) async {
    try {
      isLoadingZipcodes.value = true;
      final results = await _api.searchZipcodes(cityName);
      zipcodes.assignAll(results);
    } finally {
      isLoadingZipcodes.value = false;
    }
  }

  /// Verifies a specific zipcode against a city (Dynamic verification)
  Future<bool> verifyZipcodeDynamic(String zipcode, String cityName) async {
    try {
      isVerifying.value = true;
      // Using the specialized postal_code search from your API
      final results = await _api.searchZipcodes(zipcode);

      if (results.isEmpty) return false;

      // Check if any returned zipcode matches and mentions the city
      final cityLower = cityName.toLowerCase();
      return results.any(
        (item) =>
            item['zipcode'] == zipcode &&
            item['description']!.toLowerCase().contains(cityLower),
      );
    } catch (e) {
      return false;
    } finally {
      isVerifying.value = false;
    }
  }

  // --- 3. Buildings & Societies ---

  /// Finds specific apartment buildings or societies in a city
  Future<void> fetchBuildings(String cityName, String input) async {
    try {
      isLoading.value = true;
      final response = await _api.getBuildingsAndSocieties(cityName, input);
      if (response != null) {
        final List results = response['results'];
        // You can map these to a specific Building model if needed
        nearbyPlaces.assignAll(results.cast<Map<String, dynamic>>());
      }
    } finally {
      isLoading.value = false;
    }
  }

  // --- 4. Nearby Landmarks & Categorized Places ---

  /// Get nearby landmarks (limit to 4 as per your API)
  Future<void> fetchNearbyLandmarks(String address) async {
    try {
      isLoadingLandmarks.value = true;
      final results = await _api.getNearbyLandmarks(address);
      nearbyLandmarks.assignAll(results);
    } finally {
      isLoadingLandmarks.value = false;
    }
  }

  /// Get places by category (Education, Healthcare, etc.)
  Future<void> fetchNearbyByCategory(String address, String type) async {
    try {
      isLoading.value = true;
      final result = await _api.getNearbyPlacesByCategoryWithCoords(
        address,
        type,
      );

      nearbyPlaces.assignAll(result['places'] as List<Map<String, dynamic>>);

      if (result['propertyCoords'] != null) {
        propertyCoords['lat'] = result['propertyCoords']['lat'];
        propertyCoords['lng'] = result['propertyCoords']['lng'];
      }
    } finally {
      isLoading.value = false;
    }
  }

  // --- 5. Utilities ---

  void clearPredictions() {
    predictions.clear();
  }

  void clearZipcodes() {
    zipcodes.clear();
  }

  /// Get details (zipcode/city) from a Place ID
  Future<Map<String, String>?> getDetails(String placeId) async {
    return await _api.getLocationDetails(placeId);
  }
}
