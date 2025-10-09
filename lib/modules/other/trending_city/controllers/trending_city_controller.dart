import 'package:get/get.dart';
import '../../../../data/network/city/tending_city/trending_city_model.dart';
import '../../../../data/network/city/tending_city/trending_city_service.dart';

class TrendingCityController extends GetxController {
  final TrendingCityService trendingCityService = Get.put(
    TrendingCityService(),
  );

  // All trending cities
  RxList<TrendingCityData> allTrendingCities = <TrendingCityData>[].obs;

  // Cities grouped by property count range (optional)
  RxMap<String, List<TrendingCityData>> propertyRangeCityMap =
      <String, List<TrendingCityData>>{}.obs;

  // Top viewed cities
  RxList<TrendingCityData> topViewedCities = <TrendingCityData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrendingCities();
  }

  // Fetch trending cities and process data
  Future<void> fetchTrendingCities() async {
    await trendingCityService.fetchTrendingCities();
    allTrendingCities.value = trendingCityService.trendingCities;

    _generatePropertyRangeData();
    _getTopViewedCities();
  }

  // Categorize cities by property count range (optional grouping)
  void _generatePropertyRangeData() {
    Map<String, List<TrendingCityData>> map = {
      '1–2 Properties':
          allTrendingCities.where((city) => city.propertyCount <= 2).toList(),
      '3–5 Properties':
          allTrendingCities
              .where(
                (city) => city.propertyCount > 2 && city.propertyCount <= 5,
              )
              .toList(),
      '6+ Properties':
          allTrendingCities.where((city) => city.propertyCount > 5).toList(),
    };
    propertyRangeCityMap.value = map;
  }

  // Get top viewed cities (sorted descending)
  void _getTopViewedCities() {
    final sortedCities =
        allTrendingCities.toList()
          ..sort((a, b) => b.totalViews.compareTo(a.totalViews));
    topViewedCities.value = sortedCities.take(5).toList();
  }

  // Get cities within a specific property range
  List<TrendingCityData> getCitiesByRange(String rangeLabel) {
    return propertyRangeCityMap[rangeLabel] ?? [];
  }

  // Get city by name
  TrendingCityData? getCityByName(String name) {
    return allTrendingCities.firstWhereOrNull(
      (city) => city.city.toLowerCase() == name.toLowerCase(),
    );
  }
}
