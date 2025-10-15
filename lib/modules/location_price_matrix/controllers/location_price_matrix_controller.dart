import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/location_price_matrix/model/location_price_matrix_model.dart';
import '../../../data/network/location_price_matrix/service/location_price_matrix_service.dart';

class LocationPriceMatrixController extends GetxController {
  final LocationPriceMatrixService _service = LocationPriceMatrixService();

  var isLoading = false.obs;
  var propertyResponse = Rxn<LocationPriceMatrixModel>();

  @override
  void onInit() {
    super.onInit();
    fetchPropertyData();
  }

  Future<void> fetchPropertyData() async {
    try {
      isLoading.value = true;
      final response = await _service.fetchPropertyData();
      propertyResponse.value = response;
    } catch (e) {
      print('⚠️ Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
