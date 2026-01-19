import 'package:get/get.dart';
import '../../../data/network/city/city_insigths_service.dart';
import '../model/city_insigths_model.dart';

class CityController extends GetxController {
  final CityService cityService = Get.put(CityService());

  // All cities
  RxList<CityData> allCities = <CityData>[].obs;

  // Unique states
  RxList<String> uniqueStates = <String>[].obs;
 RxString selectedCity = ''.obs;
RxBool isFromLoginSide= false.obs;
  // State-wise city map
  RxMap<String, List<CityData>> stateCityMap = <String, List<CityData>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCities();
  }

  // Fetch cities and process data
  Future<void> fetchCities() async {
    await cityService.fetchCities();
    allCities.value = cityService.cities;

    _generateStateData();
  }

  // Generate unique states and state-wise city map
  void _generateStateData() {
    // Extract unique states
    final states = allCities.map((city) => city.state).toSet().toList();
    uniqueStates.value = states;

    // Create state-wise city map
    Map<String, List<CityData>> map = {};
    for (var state in uniqueStates) {
      map[state] = allCities.where((city) => city.state == state).toList();
    }
    stateCityMap.value = map;
  }

  // Get cities by state
  List<CityData> getCitiesByState(String state) {
    return stateCityMap[state] ?? [];
  }
}
