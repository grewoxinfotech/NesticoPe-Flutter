import 'dart:developer';
import 'dart:math' show cos, sqrt, asin;
import 'package:get/get.dart';
import 'package:nesticope_app/confige/helper/api_helper.dart';
import 'package:nesticope_app/confige/search_api/search_api.dart';
import 'package:nesticope_app/data/network/property/services/property_service.dart';
import 'package:nesticope_app/modules/search_property/model/search_model.dart';

import '../../../data/network/builder/service/builder_service.dart';

class GoogleMapSearchController extends GetxController {
  /// Reactive variables
  var isLoading = false.obs;
  var predictions = <Prediction>[].obs;
  PropertyService _propertyService = PropertyService();
  BuilderService _builderService = BuilderService();
  var nearbyLandmarks = <Map<String, dynamic>>[].obs;

  RxList<Map<String, String?>> cityStateList = <Map<String, String?>>[].obs;

  // Zipcode related observables
  var zipcodes = <Map<String, String>>[].obs;
  var isLoadingZipcodes = false.obs;
  var selectedCity = ''.obs;

  /// Fetch zipcodes for selected city
  Future<void> fetchZipcodesForCity(String cityName) async {
    if (cityName.trim().isEmpty) {
      zipcodes.clear();
      return;
    }

    try {
      isLoadingZipcodes.value = true;
      selectedCity.value = cityName;

      print('🔍 Fetching zipcodes for city: $cityName');

      final response = await GoogleMapApi.instance.searchZipcodes(cityName);

      if (response.isNotEmpty) {
        zipcodes.value = response;
        print('✅ Found ${response.length} zipcodes for $cityName');
      } else {
        zipcodes.clear();
        print('⚠️ No zipcodes found for $cityName');
      }
    } catch (e) {
      print('❌ Error fetching zipcodes: $e');
      zipcodes.clear();
    } finally {
      isLoadingZipcodes.value = false;
    }
  }

  /// Clear zipcodes when city changes
  void clearZipcodes() {
    zipcodes.clear();
    selectedCity.value = '';
  }

  /// Get zipcode details from place_id
  Future<Map<String, String>?> getZipcodeDetails(String placeId) async {
    try {
      final details = await GoogleMapApi.instance.getLocationDetails(placeId);
      return details;
    } catch (e) {
      print('❌ Error getting zipcode details: $e');
      return null;
    }
  }

  Future<void> fetchPredictionsCity(String city) async {
    if (city.trim().isEmpty) {
      predictions.clear();
      return;
    }

    try {
      isLoading.value = true;
      final String trimmedCity = city.trim().toUpperCase();

      print("\n====== SEARCH DEBUG ======");
      print("Search query: $trimmedCity");
      print("Contains BHK: ${trimmedCity.contains("BHK")}");
      print("=========================\n");

      // 🔹 Case 1: BHK Search (Custom property logic)
      if (trimmedCity.contains("BHK")) {
        print("🏘️ BHK Search Started for: $city");

        final bhkMatch = RegExp(r'(\d+)').firstMatch(trimmedCity);
        final bhkNumber = bhkMatch?.group(1) ?? city[0];

        print("🔢 Extracted BHK number: $bhkNumber");

        final response = await _propertyService.fetchProperties(
          filters: {'bhk': bhkNumber},
        );

        print(
          "✅ BHK Properties Response: ${response.items.length} items found",
        );

        if (response.items.isNotEmpty) {
          predictions.value =
              response.items.map((property) {
                return Prediction(
                  description:
                      "${property.propertyDetails?.bhk ?? ''} BHK ${property.propertyType ?? ''} in ${property.city ?? ''}",
                  placeId: property.id ?? '',
                  structuredFormatting: StructuredFormatting(
                    mainText:
                        "${property.propertyDetails?.bhk ?? ''} BHK ${property.propertyType ?? ''}",
                    secondaryText:
                        "${property.address ?? ''}, ${property.city ?? ''}",
                  ),
                  items: property,
                );
              }).toList();
        } else {
          predictions.clear();
        }
      }
      // 🔹 Case 2: Combined Project + Location Search
      else {
        print("🔍 Combined Search Started for: $city");

        List<Prediction> combinedPredictions = [];

        // 🔸 1. Fetch and filter PROJECTS
        try {
          final projectResponse = await _builderService.fetchProjects();

          log("Project Response: ${projectResponse.items.length} projects");

          if (projectResponse.items.isNotEmpty) {
            final searchQuery = city.toLowerCase();

            final filteredProjects =
                projectResponse.items.where((project) {
                  final projectName = project.projectName?.toLowerCase() ?? '';
                  return projectName.contains(searchQuery);
                }).toList();

            print(
              "✅ Filtered Projects: ${filteredProjects.length} matching projects for '$city'",
            );

            if (filteredProjects.isNotEmpty) {
              final projectPredictions =
                  filteredProjects.map((project) {
                    return Prediction(
                      description: project.projectName ?? '',
                      placeId: project.id ?? '',
                      structuredFormatting: StructuredFormatting(
                        mainText: project.projectName ?? '',
                        secondaryText:
                            "Project • ${project.city ?? ''}, ${project.state ?? ''} • ${project.projectContactInfo?.name ?? 'Builder'}",
                      ),
                      projectItem: project,
                    );
                  }).toList();

              combinedPredictions.addAll(projectPredictions);
            }
          }
        } catch (e) {
          print("❌ Error fetching projects: $e");
        }

        // 🔸 2. Fetch and add GOOGLE PLACES locations
        try {
          final googleResponse = await GoogleMapApi.instance.searchCities(city);

          log("Google Response: $googleResponse");

          if (googleResponse != null) {
            final model = SearchFilterModel.fromJson(googleResponse);
            print("Google Places model ===== ${model.toJson()}");

            final predictionsList = model.predictions ?? [];
            final parsedList =
                predictionsList.map((p) => p.toLocationMap).toList();

            print("Parsed location list ===== $parsedList");

            if (predictionsList.isNotEmpty) {
              combinedPredictions.addAll(predictionsList);
              cityStateList.assignAll(parsedList);
            }
          }
        } catch (e) {
          print("❌ Error fetching Google Places: $e");
        }

        // 🔸 3. Update predictions with combined results
        if (combinedPredictions.isNotEmpty) {
          predictions.value = combinedPredictions;
          print(
            "✅ Total Predictions: ${combinedPredictions.length} (Projects + Locations)",
          );
        } else {
          predictions.clear();
          print("ℹ️ No results found for '$city'");
        }
      }
    } catch (e, stackTrace) {
      log("❌ Error fetching predictions: $e");
      log("Stack trace: $stackTrace");
      predictions.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchGooglePlaces(String city) async {
    try {
      final response = await GoogleMapApi.instance.searchCities(city);
      print("Google Places response ===== $response");

      if (response != null) {
        final model = SearchFilterModel.fromJson(response);
        print("Google Places model ===== ${model.toJson()}");

        final predictionsList = model.predictions ?? [];
        final parsedList = predictionsList.map((p) => p.toLocationMap).toList();

        print("Parsed location list ===== $parsedList");

        predictions.value = predictionsList;
        cityStateList.assignAll(parsedList);
        log(
          "city List from apo ${cityStateList.map((element) => element.toString()).toList()}",
        );
        log(
          "prediction List from apo ${predictions.map((element) => element.items?.toJson()).toList()}",
        );
      } else {
        predictions.clear();
      }
    } catch (e) {
      print("❌ Error fetching Google Places: $e");
      predictions.clear();
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

  Future<void> fetchPredictionsLocality(String locality, String city) async {
    try {
      isLoading.value = true;

      final response = await GoogleMapApi.instance.searchLocalities(
        locality,
        cityFilter: city,
      );

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

  Future<void> fetchBuildingsAndSocieties(String locality, String city) async {
    if (city.trim().isEmpty && locality.trim().isEmpty) return;

    try {
      isLoading.value = true;

      final response = await GoogleMapApi.instance.getBuildingsAndSocieties(
        city,
        locality,
      );

      print("🏗 Google TextSearch API Response: $response");

      // ✅ Handle null or unexpected formats
      if (response == null) {
        print("⚠️ API returned null response");
        predictions.clear();
        return;
      }

      // ✅ Some APIs return 'results', others return 'predictions'
      final List<dynamic> results =
          (response['results'] ?? response['predictions'] ?? [])
              as List<dynamic>;

      if (results.isEmpty) {
        print("⚠️ No buildings found for '$locality' in $city");
        predictions.clear();
        return;
      }

      // ✅ Map results safely
      predictions.value =
          results.map((place) {
            return Prediction(
              description: place['name'] ?? '',
              placeId: place['place_id'] ?? '',
              structuredFormatting: StructuredFormatting(
                mainText: place['name'] ?? '',
                secondaryText:
                    place['formatted_address'] ?? place['description'] ?? '',
              ),
            );
          }).toList();

      print("✅ Found ${predictions.length} buildings/societies in $city");
    } catch (e, st) {
      print("❌ Error fetching buildings: $e");
      print(st);
      predictions.clear();
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

  Future<void> fetchNearbyPlacesByCategory(String address, String type) async {
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
      await ApiConfig.ensureMapKey();
      isLoading.value = true;
      allCategoriesData.clear();

      // First API call will get coordinates, store them
      bool coordinatesSet = false;

      // Fetch data for all categories in parallel
      final futures = categoryTypes.entries.map((entry) async {
        final response = await GoogleMapApi.instance
            .getNearbyPlacesByCategoryWithCoords(
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
        }

        final places = response['places'] as List<Map<String, dynamic>>;

        if (places.isNotEmpty && propertyLatLng.value != null) {
          // Calculate distance for each place
          final placesWithDistance =
              places.map((place) {
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
          placesWithDistance.sort(
            (a, b) => a['distance'].compareTo(b['distance']),
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
    final a =
        0.5 -
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
