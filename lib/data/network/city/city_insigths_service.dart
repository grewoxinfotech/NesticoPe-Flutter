import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../app/constants/api_constants.dart';
import '../../../modules/filter_property/model/city_insigths_model.dart';

class CityService extends GetxService {
  // List to store fetched cities
  final baseUrl = ApiConstants.cityInsights;
  RxList<CityData> cities = <CityData>[].obs;

  // Loading indicator
  RxBool isLoading = false.obs;

  // Fetch cities from API
  Future<void> fetchCities() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        CityResponse cityResponse = CityResponse.fromJson(jsonResponse);

        cities.value = cityResponse.data;
      } else {
        Get.snackbar('Error', 'Failed to fetch cities: ${response.statusCode}');
      }
      print("cities ===== ${response.body}");
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Optionally, get cities by state
  List<CityData> getCitiesByState(String state) {
    return cities.where((city) => city.state == state).toList();
  }

  // Optionally, get cities by listing type
  List<CityData> getCitiesByListingType(String type) {
    return cities.where((city) => city.listingTypes.contains(type)).toList();
  }
}
