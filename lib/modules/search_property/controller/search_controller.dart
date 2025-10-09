import 'package:get/get.dart';
import 'package:housing_flutter_app/confige/search_api/search_api.dart';
import 'package:housing_flutter_app/modules/search_property/model/search_model.dart';

class GoogleMapController extends GetxController {
  /// Reactive variables
  var isLoading = false.obs;
  var predictions = <Prediction>[].obs;

  /// Fetch predictions from Google API
  Future<void> fetchPredictions(String city) async {
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
}
