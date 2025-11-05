import 'dart:math' show cos, sqrt, asin;
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

  Future<void> fetchPredictionsLocality(String locality,String city) async {
    try {
      isLoading.value = true;

      final response = await GoogleMapApi.instance.searchLocalities(locality,cityFilter: city);

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
          print("📏 ${landmark['name']} — ${landmark['address']}");
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

  /// Fetch nearby places by category
  var categoryPlaces = <Map<String, dynamic>>[].obs;
  var isCategoryLoading = false.obs;
  var selectedCategory = ''.obs;
  
  // Store all categories data
  var allCategoriesData = <String, List<Map<String, dynamic>>>{}.obs;
  var propertyLatLng = Rx<Map<String, double>?>(null);

  // Category types
  static const Map<String, String> categoryTypes = {
    'Education': 'school',
    'Healthcare': 'hospital',
    'Food & Dining': 'restaurant',
    'Shopping': 'shopping_mall',
    'Entertainment': 'movie_theater',
  };

  Future<void> fetchNearbyPlacesByCategory(
    String address,
    String type,
  ) async {
    try {
      isCategoryLoading.value = true;
      selectedCategory.value = type;

      final places = await GoogleMapApi.instance.getNearbyPlacesByCategory(
        address,
        type,
      );

      if (places.isNotEmpty) {
        categoryPlaces.value = places;
        print("✅ Found ${places.length} $type places near $address");
      } else {
        categoryPlaces.clear();
        print("⚠️ No $type places found near $address");
      }
    } catch (e) {
      print("❌ Error fetching $type places: $e");
      categoryPlaces.clear();
    } finally {
      isCategoryLoading.value = false;
    }
  }

  /// Clear category places
  void clearCategoryPlaces() {
    categoryPlaces.clear();
    selectedCategory.value = '';
  }

  /// Get coordinates from address using Geocoding API
  Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    try {
      final geoUri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=${GoogleMapApi.instance}',
      );
      
      // This will be handled in the API call itself
      return null;
    } catch (e) {
      print('❌ Error getting coordinates: $e');
      return null;
    }
  }

  /// Fetch all categories at once
  Future<void> fetchAllCategoriesData(String address) async {
    try {
      isLoading.value = true;
      allCategoriesData.clear();

      // First API call will get coordinates, store them
      bool coordinatesSet = false;

      // Fetch data for all categories in parallel
      final futures = categoryTypes.entries.map((entry) async {
        final response = await GoogleMapApi.instance.getNearbyPlacesByCategoryWithCoords(
          address,
          entry.value,
          radius: 3000, // Increase radius to 3km
        );

        // Extract coordinates from first successful API call
        if (!coordinatesSet && response['propertyCoords'] != null) {
          final coords = response['propertyCoords'] as Map<String, dynamic>;
          propertyLatLng.value = {
            'lat': coords['lat'] as double,
            'lng': coords['lng'] as double,
          };
          coordinatesSet = true;
          print('✅ Property coordinates set: ${ propertyLatLng.value}');
        }

        final places = response['places'] as List<Map<String, dynamic>>;

        if (places.isNotEmpty && propertyLatLng.value != null) {
          // Calculate distance for each place
          final placesWithDistance = places.map((place) {
            final distance = calculateDistance(
              propertyLatLng.value!['lat']!,
              propertyLatLng.value!['lng']!,
              place['lat'],
              place['lng'],
            );
            place['distance'] = distance;
            place['distanceText'] = formatDistance(distance);
            place['walkTime'] = calculateWalkTime(distance);
            return place;
          }).toList();

          // Sort by distance
          placesWithDistance.sort((a, b) => 
            a['distance'].compareTo(b['distance'])
          );

          return MapEntry(entry.value, placesWithDistance);
        }
        return MapEntry(entry.value, <Map<String, dynamic>>[]);
      });

      final results = await Future.wait(futures);
      allCategoriesData.value = Map.fromEntries(results);

      // Set first category as selected if available
      if (allCategoriesData.isNotEmpty) {
        final firstCategoryWithData = categoryTypes.values.firstWhere(
          (type) => allCategoriesData[type]?.isNotEmpty ?? false,
          orElse: () => 'school',
        );
        selectedCategory.value = firstCategoryWithData;
        categoryPlaces.value = allCategoriesData[firstCategoryWithData] ?? [];
      }

      print('✅ Loaded all categories data');
    } catch (e) {
      print('❌ Error fetching all categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update selected category
  void selectCategory(String type) {
    selectedCategory.value = type;
    categoryPlaces.value = allCategoriesData[type] ?? [];
  }

  /// Calculate distance between two lat/lng points (in meters)
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742000 * asin(sqrt(a)); // 2 * R * asin... R = 6371 km
  }

  /// Format distance to human readable format
  String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()}m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)}km';
    }
  }

  /// Calculate approximate walk time (assuming 5 km/h walking speed)
  String calculateWalkTime(double meters) {
    final minutes = (meters / 1000) / 5 * 60; // 5 km/h = 83.33 m/min
    if (minutes < 1) {
      return '< 1 min walk';
    } else {
      return '${minutes.round()} min walk';
    }
  }

  /// Clean up resources
  @override
  void onClose() {
    // Clear all data
    predictions.clear();
    nearbyLandmarks.clear();
    categoryPlaces.clear();
    allCategoriesData.clear();
    propertyLatLng.value = null;
    selectedCategory.value = '';
    super.onClose();
  }
}
