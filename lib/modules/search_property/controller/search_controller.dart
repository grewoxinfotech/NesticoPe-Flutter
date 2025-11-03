import 'package:get/get.dart';
import 'package:housing_flutter_app/confige/search_api/search_api.dart';
import 'package:housing_flutter_app/modules/search_property/model/search_model.dart';

class GoogleMapController extends GetxController {
  /// Reactive variables
  var isLoading = false.obs;
  var predictions = <Prediction>[].obs;

  var nearbyLandmarks = <Map<String, dynamic>>[].obs;

  /// Fetch predictions from Google API
  Future<void> fetchPredictionsCity(String city) async {
    try {
      isLoading.value = true;

      final response = await GoogleMapApi.instance.searchCities(city);

      print("resposne ===== $response");

      if (response != null) {
        final model = SearchFilterModel.fromJson(response);
        print("model ===== ${model.toJson()}");
        predictions.value = model.predictions ?? [];
      } else {
        predictions.clear();
      }
    } catch (e) {
      print("❌ Error fetching predictions: $e");
      predictions.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPredictionsState(String state) async {
    try {
      isLoading.value = true;

      final response = await GoogleMapApi.instance.searchStates(state);

      print("resposne ===== $response");

      if (response != null) {
        final model = SearchFilterModel.fromJson(response);
        print("model ===== ${model.toJson()}");
        predictions.value = model.predictions ?? [];
      } else {
        predictions.clear();
      }
    } catch (e) {
      print("❌ Error fetching predictions: $e");
      predictions.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPredictionsArea(String area) async {
    try {
      isLoading.value = true;

      final response = await GoogleMapApi.instance.searchAreas(area);

      print("resposne ===== $response");

      if (response != null) {
        final model = SearchFilterModel.fromJson(response);
        print("model ===== ${model.toJson()}");
        predictions.value = model.predictions ?? [];
      } else {
        predictions.clear();
      }
    } catch (e) {
      print("❌ Error fetching predictions: $e");
      predictions.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPredictionsLocality(String locality) async {
    try {
      isLoading.value = true;

      final response = await GoogleMapApi.instance.searchLocalities(locality);

      print("resposne ===== $response");

      if (response != null) {
        final model = SearchFilterModel.fromJson(response);
        print("model ===== ${model.toJson()}");
        predictions.value = model.predictions ?? [];
      } else {
        predictions.clear();
      }
    } catch (e) {
      print("❌ Error fetching predictions: $e");
      predictions.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNearbyLandmarks(String address) async {
    try {
      isLoading.value = true;
      final landmarks = await GoogleMapApi.instance.getNearbyLandmarks(address);

      if (landmarks.isNotEmpty) {
        print("✅ Found ${landmarks.length} landmarks near $address");
        for (final landmark in landmarks) {
          nearbyLandmarks.value = landmarks;
          print("📍 ${landmark['name']} — ${landmark['address']}");
        }
      } else {
        print("⚠️ No landmarks found near $address");
      }
    } catch (e) {
      print("❌ Error fetching landmarks: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
