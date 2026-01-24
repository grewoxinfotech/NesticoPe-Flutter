import 'dart:convert';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/city/tending_city/trending_city_model.dart';
import 'package:http/http.dart' as http;
import '../../../../app/constants/api_constants.dart';
import '../../../../widgets/messages/snack_bar.dart';

class TrendingCityService extends GetxService {
  // Base URL for the trending cities API
  final baseUrl = ApiConstants.trendingCityInsights;

  // Reactive list to store fetched trending cities
  RxList<TrendingCityData> trendingCities = <TrendingCityData>[].obs;

  // Loading indicator
  RxBool isLoading = false.obs;

  // Fetch trending cities from API
  Future<void> fetchTrendingCities() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        TrendingCitiesResponse cityResponse = TrendingCitiesResponse.fromJson(
          jsonResponse,
        );

        trendingCities.value = cityResponse.data;
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message: 'Failed to fetch trending cities: ${response.statusCode}',
          contentType: ContentType.failure,
        );
      }
    } catch (e) {
      print('Error fetching trending cities: $e');
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: 'Something went wrong: $e',
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Optionally, get trending city by name
  TrendingCityData? getCityByName(String name) {
    try {
      return trendingCities.firstWhere(
        (city) => city.city.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Optionally, get cities with minimum property count
  List<TrendingCityData> getCitiesWithMinProperties(int minCount) {
    return trendingCities
        .where((city) => city.propertyCount >= minCount)
        .toList();
  }

  // Optionally, get top viewed cities
  List<TrendingCityData> getTopViewedCities({int limit = 5}) {
    final sorted =
        trendingCities.toList()
          ..sort((a, b) => b.totalViews.compareTo(a.totalViews));
    return sorted.take(limit).toList();
  }
}
