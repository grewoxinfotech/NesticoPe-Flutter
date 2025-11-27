import 'dart:developer';
import 'dart:math' show cos, sqrt, asin;
import 'package:get/get.dart';
import 'package:housing_flutter_app/confige/search_api/search_api.dart';
import 'package:housing_flutter_app/data/network/property/services/property_service.dart';
import 'package:housing_flutter_app/modules/search_property/model/search_model.dart';

import '../../../data/network/builder/service/builder_service.dart';

class GoogleMapController extends GetxController {
  /// Reactive variables
  var isLoading = false.obs;
  var predictions = <Prediction>[].obs;
PropertyService _propertyService = PropertyService();
  BuilderService _builderService = BuilderService();
  var nearbyLandmarks = <Map<String, dynamic>>[].obs;

  RxList<Map<String, String?>> cityStateList = <Map<String, String?>>[].obs;


  /// Fetch predictions from Google API or Properties for BHK search
  ///
  /// =========================OLD CODE Past=========================
  // Future<void> fetchPredictionsCity(String city) async {
  //   if (city.trim().isEmpty) {
  //     predictions.clear();
  //     return;
  //   }
  //
  //   final String trimmedCity = city.trim().toUpperCase();
  //   print("\n====== SEARCH DEBUG ======");
  //   print("Search query: $trimmedCity");
  //   print("Contains BHK: ${trimmedCity.contains("BHK")}");
  //   print("=========================\n");
  //
  //  if(!trimmedCity.contains("BHK"))
  //    {
  //      try {
  //        isLoading.value = true;
  //
  //        final response = await GoogleMapApi.instance.searchCities(city);
  //
  //        print("resposne ===== $response");
  //
  //        if (response != null) {
  //          final model = SearchFilterModel.fromJson(response);
  //          print("model ===== ${model.toJson()}");
  //          predictions.value = model.predictions ?? [];
  //        } else {
  //          predictions.clear();
  //        }
  //      } catch (e) {
  //        print("❌ Error fetching predictions: $e");
  //        predictions.clear();
  //      } finally {
  //        isLoading.value = false;
  //      }
  //    }
  //  else{
  //    try {
  //      isLoading.value = true;
  //      print("🏘️ BHK Search Started for: $city");
  //
  //      // Extract BHK number from search query (e.g., "4bhk" -> "4", "2 bhk" -> "2")
  //      final bhkMatch = RegExp(r'(\d+)').firstMatch(trimmedCity);
  //      final bhkNumber = bhkMatch?.group(1) ?? city[0];
  //
  //      print("🔢 Extracted BHK number: $bhkNumber");
  //
  //      final response = await _propertyService.fetchProperties(
  //        filters: {
  //          'bhk': bhkNumber,
  //        },
  //      );
  //
  //      print("✅ BHK Properties Response: ${response.items.length} items found");
  //      if (response.items.isEmpty) {
  //        print("⚠️ No properties found for $bhkNumber BHK");
  //      } else {
  //        print("🏠 First property: ${response.items.first.toJson()}");
  //      }
  //
  //      if (response.items.isNotEmpty) {
  //
  //        predictions.value = response.items.map((property) {
  //          return Prediction(
  //            description: "${property.propertyDetails?.bhk ?? ''} BHK ${property.propertyType ?? ''} in ${property.city ?? ''}",
  //            placeId: property.id ?? '',
  //            structuredFormatting: StructuredFormatting(
  //              mainText: "${property.propertyDetails?.bhk ?? ''} BHK ${property.propertyType ?? ''}",
  //              secondaryText: "${property.address ?? ''}, ${property.city ?? ''}",
  //            ),
  //            items: property, // Store the entire property object
  //          );
  //        }).toList();
  //      } else {
  //        predictions.clear();
  //      }
  //    } catch (e, stackTrace) {
  //      log("❌ Error fetching BHK properties: $e");
  //      log("Stack trace: $stackTrace");
  //      predictions.clear();
  //    } finally {
  //      isLoading.value = false;
  //    }
  //  }
  // }
///================================OLD CODE Fresh END=============================
  // Future<void> fetchPredictionsCity(String city) async {
  //   if (city.trim().isEmpty) {
  //     predictions.clear();
  //     return;
  //   }
  //
  //   final respon = await _builderService.fetchProjects(
  //     filters: {'projectName': city},
  //   );
  //
  //   if (respon.items.isNotEmpty) {
  //     predictions.value = respon.items.map((property) {
  //       return Prediction(
  //         description:
  //         "${property.projectName ?? ''}",
  //         placeId: property.id ?? '',
  //         structuredFormatting: StructuredFormatting(
  //             secondaryText: "${'Project' ?? ''}, ${property.projectContactInfo?.name ?? ''}",
  //         ),
  //         projectItem: property, // Store the full property
  //       );
  //     }).toList();
  //   } else {
  //     predictions.clear();
  //   }
  //
  //
  //
  //
  //   final String trimmedCity = city.trim().toUpperCase();
  //   print("\n====== SEARCH DEBUG ======");
  //   print("Search query: $trimmedCity");
  //   print("Contains BHK: ${trimmedCity.contains("BHK")}");
  //   print("=========================\n");
  //
  //   // 🔹 Case 1: Normal City Search (Google Autocomplete)
  //   if (!trimmedCity.contains("BHK")) {
  //     try {
  //       isLoading.value = true;
  //
  //       final response = await GoogleMapApi.instance.searchCities(city);
  //       print("response ===== $response");
  //
  //       if (response != null) {
  //         final model = SearchFilterModel.fromJson(response);
  //         print("model ===== ${model.toJson()}");
  //
  //         // 🔹 1️⃣ Parse Google predictions
  //         final predictionsList = model.predictions ?? [];
  //
  //         // 🔹 2️⃣ Convert to structured maps (city/state/country)
  //         final parsedList = predictionsList.map((p) => p.toLocationMap).toList();
  //
  //         print("Parsed location list ===== $parsedList");
  //         predictions.value = predictionsList;
  //         cityStateList.assignAll(parsedList);
  //
  //         // You can also keep a parallel list if needed:
  //         // cityStateList.assignAll(parsedList);
  //
  //       } else {
  //         predictions.clear();
  //       }
  //     } catch (e) {
  //       print("❌ Error fetching predictions: $e");
  //       predictions.clear();
  //     } finally {
  //       isLoading.value = false;
  //     }
  //   }
  //
  //   // 🔹 Case 2: BHK Search (Custom property logic)
  //   else {
  //     try {
  //       isLoading.value = true;
  //       print("🏘️ BHK Search Started for: $city");
  //
  //       final bhkMatch = RegExp(r'(\d+)').firstMatch(trimmedCity);
  //       final bhkNumber = bhkMatch?.group(1) ?? city[0];
  //
  //       print("🔢 Extracted BHK number: $bhkNumber");
  //
  //       final response = await _propertyService.fetchProperties(
  //         filters: {'bhk': bhkNumber},
  //       );
  //
  //       print("✅ BHK Properties Response: ${response.items.length} items found");
  //
  //       if (response.items.isNotEmpty) {
  //         predictions.value = response.items.map((property) {
  //           return Prediction(
  //             description:
  //             "${property.propertyDetails?.bhk ?? ''} BHK ${property.propertyType ?? ''} in ${property.city ?? ''}",
  //             placeId: property.id ?? '',
  //             structuredFormatting: StructuredFormatting(
  //               mainText:
  //               "${property.propertyDetails?.bhk ?? ''} BHK ${property.propertyType ?? ''}",
  //               secondaryText: "${property.address ?? ''}, ${property.city ?? ''}",
  //             ),
  //             items: property, // Store the full property
  //           );
  //         }).toList();
  //       } else {
  //         predictions.clear();
  //       }
  //     } catch (e, stackTrace) {
  //       log("❌ Error fetching BHK properties: $e");
  //       log("Stack trace: $stackTrace");
  //       predictions.clear();
  //     } finally {
  //       isLoading.value = false;
  //     }
  //   }
  // }


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

        print("✅ BHK Properties Response: ${response.items.length} items found");

        if (response.items.isNotEmpty) {
          predictions.value = response.items.map((property) {
            return Prediction(
              description:
              "${property.propertyDetails?.bhk ?? ''} BHK ${property.propertyType ?? ''} in ${property.city ?? ''}",
              placeId: property.id ?? '',
              structuredFormatting: StructuredFormatting(
                mainText:
                "${property.propertyDetails?.bhk ?? ''} BHK ${property.propertyType ?? ''}",
                secondaryText: "${property.address ?? ''}, ${property.city ?? ''}",
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

            final filteredProjects = projectResponse.items.where((project) {
              final projectName = project.projectName?.toLowerCase() ?? '';
              return projectName.contains(searchQuery);
            }).toList();

            print("✅ Filtered Projects: ${filteredProjects.length} matching projects for '$city'");

            if (filteredProjects.isNotEmpty) {
              final projectPredictions = filteredProjects.map((project) {
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
          } }catch (e) {
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
            final parsedList = predictionsList.map((p) => p.toLocationMap).toList();

            print("Parsed location list ===== $parsedList");

            if (predictionsList.isNotEmpty) {
              combinedPredictions.addAll(predictionsList);
              cityStateList.assignAll(parsedList);
            }
          }} catch (e) {
          print("❌ Error fetching Google Places: $e");
        }

        // 🔸 3. Update predictions with combined results
        if (combinedPredictions.isNotEmpty) {
          predictions.value = combinedPredictions;
          print("✅ Total Predictions: ${combinedPredictions.length} (Projects + Locations)");
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
      } else {
        predictions.clear();
      }
    } catch (e) {
      print("❌ Error fetching Google Places: $e");
      predictions.clear();
    }}


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



/*Future<void> fetchPredictionsCity(String city) async {
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

      print("✅ BHK Properties Response: ${response.items.length} items found");

      if (response.items.isNotEmpty) {
        predictions.value = response.items.map((property) {
          return Prediction(
            description:
            "${property.propertyDetails?.bhk ?? ''} BHK ${property.propertyType ?? ''} in ${property.city ?? ''}",
            placeId: property.id ?? '',
            structuredFormatting: StructuredFormatting(
              mainText:
              "${property.propertyDetails?.bhk ?? ''} BHK ${property.propertyType ?? ''}",
              secondaryText: "${property.address ?? ''}, ${property.city ?? ''}",
            ),
            items: property,
          );
        }).toList();
      } else {
        predictions.clear();
      }
    }
    // 🔹 Case 2: Project Name Search
    else {
      print("🏗️ Project Search Started for: $city");

      // 🔸 Fetch ALL projects first (no filters)
      final response = await _builderService.fetchProjects();

      log("Search project response: ${response.toJson((model) => model.toJson())}");
      print("✅ All Projects Fetched: ${response.items.length} total projects");

      if (response.items.isNotEmpty) {
        final searchQuery = city.toLowerCase();

        // 🔸 Filter projects by comparing search query with project name
        final filteredProjects = response.items.where((project) {
          final projectName = project.projectName?.toLowerCase() ?? '';
          return projectName.contains(searchQuery);
        }).toList();

        print("✅ Filtered Projects: ${filteredProjects.length} matching projects for '$city'");

        if (filteredProjects.isNotEmpty) {
          predictions.value = filteredProjects.map((project) {
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
        } else {
          // If no projects match, try Google Places
          print("ℹ️ No projects found matching '$city', falling back to Google Places");
          await _fetchGooglePlaces(city);
        }
      } else {
        // If no projects at all, try Google Places
        print("ℹ️ No projects in database, falling back to Google Places");
        await _fetchGooglePlaces(city);
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

// 🔹 Separate method for Google Places API
Future<void> _fetchGooglePlaces(String city) async {
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
    } else {
      predictions.clear();
    }
  } catch (e) {
    print("❌ Error fetching Google Places: $e");
    predictions.clear();
  }
}*/
