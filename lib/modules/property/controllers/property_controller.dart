import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/data/network/property/models/inquiry_model.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:housing_flutter_app/data/network/property/models/top_property_model.dart';
import 'package:housing_flutter_app/data/network/property/services/property_service.dart';

import '../../../app/care/pagination/models/pagination_models.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../data/network/property/services/property_contacted_service.dart';
import '../../../data/network/trending_area/model/trending_area_model.dart';
import '../../../data/network/trending_area/service/trending_area_service.dart';
import '../../propert_detail/view/property_details.dart';

class PropertyController extends PaginatedController<Items> {
  final PropertyService _service = PropertyService();

  final RxString selectedCity = "".obs;
  RxList<Items> topProperties = <Items>[].obs;
  final PropertyContactedService _contactedService = PropertyContactedService();
  RxList<Items> recommendedProperties = <Items>[].obs;
  final RxBool hasSubmittedInquiry = false.obs;

  // Reactive fields
  Rxn<PropertyMedia> propertyMedia = Rxn<PropertyMedia>();
  Rxn<PropertyDetails> propertyDetails = Rxn<PropertyDetails>();
  Rxn<String> location = Rxn<String>();
  RxList<NearbyLocations> nearbyLocations = <NearbyLocations>[].obs;
  RxString approvalStatus = "pending".obs;
  RxString assignmentStatus = "available".obs;
  RxList<Inquiry> inquiryResponse = <Inquiry>[].obs;

  RxBool isVerified = false.obs;
  RxBool isExpanded = false.obs;
  RxBool isDeveloper = false.obs;
  var allowContact = true.obs;
  var interestedInHomeLoan = false.obs;
  RxBool apiLoading = false.obs;

  // Optional filters
  Map<String, String>? filters = {};

  // var favoriteIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getCity();
    loadTopProperties();

    fetchTradingArea(selectedCity.value);
  }

  Rxn<TrendingAreasResponse> trendingAreaList = Rxn<TrendingAreasResponse>();

  /// Fetch trending areas for the selected city
  Future<void> fetchTradingArea(String city) async {
    if (city.isEmpty) {
      print("City is empty, skipping trending areas fetch");return;
    }
    try {
      print("Fetching trending areas for city: $city");
      final data = await CityInsightsService.cityInsightsService.getTrendingAreas(city);

      if (data != null && data.data != null && data.data.isNotEmpty) {
        trendingAreaList.value = data;
        print("Trending areas loaded: ${data.data.length} areas");
        print("Data: ${data.data.map((e) => e.toJson()).toList()}");
      } else {
        print("No trending areas found for city: $city");
        trendingAreaList.value = null;
      }
    } catch (e) {
      print("Error fetching trending areas: $e");
      trendingAreaList.value = null;
    }
  }

  Future<void> loadTopProperties({int page = 1}) async {
    try {
      print("Loading top properties, page $page...");
      final response = await fetchTopProperty(page);
      if (page == 1) {
        topProperties.assignAll(response.items);
      } else {
        topProperties.addAll(response.items);
      }
      print(
        "Loaded ${response.items.length} top properties ${topProperties.value.map((e) => e.toJson())}",
      );
    } catch (e) {
      print("Error loading top properties: $e");
    }
  }

  /// Get city from secure storage and load properties
  Future<void> getCity() async {
    try {
      final city = await SecureStorage.getSelectedCity();
      if (city != null && city.isNotEmpty) {
        print("City retrieved: $city");
        selectedCity.value = city;

        // Fetch trending areas with the city
        await fetchTradingArea(selectedCity.value);
      } else {
        print("⚠️ No city selected");
      }

      // Apply city filter and load properties
      final filter = {'city': selectedCity.value};
      await applyFilters(filter);
      await loadInitial();
      await loadTopProperties();
    } catch (e) {
      print("Error getting city: $e");
    }
  }

  // void applyFilter(String key, String val) {
  //   filters ??= {};
  //   filters!.clear();
  //   filters![key] = val;
  //
  //   // reset pagination state
  //   currentPage.value = 1;
  //   totalPages.value = 1;
  //   hasMore.value = true;
  //   items.clear();
  //
  //   refreshList();
  // }

  void applyFilter(String key, String val) {
    filters ??= {};
    print('dfhb $key');
    if (key == 'propertyType') {
      // Add/replace property type while keeping city
      final cityValue = filters!['city'];
      filters = {if (cityValue != null) 'city': cityValue, 'propertyType': val};
      print("Applied: propertyType=$val, city=${cityValue ?? '-'}");
    } else if (key == 'city') {
      // When changing city, REMOVE propertyType & listingType
      filters = {'city': val};
      selectedCity.value = val;
      print("City changed → Reset filters. city=$val");
      // Reload top properties when city changes
      loadTopProperties();
    } else if (key == 'listingType') {
      // Add/replace listingType while keeping city
      final cityValue = filters!['city'];
      filters = {
        if (cityValue != null) 'city': cityValue,
        'listingType': val.toUpperCase(),
      };
      print("Applied: listingType=$val, city=${cityValue ?? '-'}");
    } else {
      // Generic filter
      filters![key] = val;
      print("Applied filter: $key=$val");
    }

    print("Current filters: $filters");

    // Reset pagination
    currentPage.value = 1;
    totalPages.value = 1;
    hasMore.value = true;
    items.clear();

    refreshList();
  }

  @override
  Future<PaginationResponse<Items>> fetchItems(int page) async {
    try {
      final response = await _service.fetchProperties(
        page: page,
        filters: filters,
      );
      print("hbufhfyb filter ${filters}");

      print("Fetched items: ${response.items.length}");
      return response;
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }

  Future<PaginationResponse<Items>> fetchTopProperty(int page) async {
    try {
      final response = await _service.fetchTopProperties(
        page: page,
        filters: filters,
      );
      print("Top Properry sdfhgu filter ${filters}");

      print("Fetched items: ${response.items.length}");
      return response; // contains items + meta (page/total)
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }

  /// Get single property by ID (returns cached one if found)
  Future<Items?> getPropertyById(String id) async {
    try {
      final existing = items.firstWhereOrNull((item) => item.id == id);
      if (existing != null) return existing;

      final property = await _service.getPropertyById(id);
      if (property != null) {
        items.add(property);
        items.refresh();
        log('husdfhdh ${property.toJson()}');
        return property;
      }
    } catch (e) {
      print("Get property error: $e");
    }
    return null;
  }

  Future<void> getRecommendedPropertyById(String id) async {
    try {
      final properties = await _service.getRecommendedPropertyById(id);
      if (properties.isNotEmpty) {
        // Get existing property IDs
        final existingIds =
            recommendedProperties.map((p) => p.propertyId).toSet();

        // Filter out duplicates
        final newProperties =
            properties
                .map((p) => Items.fromJson(p))
                .where((property) => !existingIds.contains(property.propertyId))
                .toList();

        if (newProperties.isNotEmpty) {
          recommendedProperties.addAll(newProperties);
          recommendedProperties.refresh();
        }
      }
    } catch (e) {
      print("Get property error: $e");
    }
  }

  // Future<void> getRecommendedPropertyById(String id) async {
  //   try {
  //     final property = await _service.getRecommendedPropertyById(id);
  //     if (property != null) {
  //       recommendedProperties.add( Items.fromJson(property));
  //       print("Recommended Property ** ${recommendedProperties.map((e) => e.toJson()).toList()}");
  //       recommendedProperties.refresh();
  //     }
  //   } catch (e) {
  //     print("Get property error: $e");
  //   }
  //
  // }

  Future<void> getAllInQuireData(String propertyId) async {
    log('Property Id For Inquiry $propertyId');

    try {
      final UserModel user = await SecureStorage.getUserData() ?? UserModel();
      final userId = user.user?.id ?? '';
      final inquiries = await _contactedService.fetchContactedInquiries(userId);
      inquiryResponse.assignAll(inquiries);

      print(
        "Inquiry Data ** ${inquiryResponse.map((e) => e.toJson()).toList()}",
      );

      final result = inquiryResponse.any((e) => e.propertyId == propertyId);
      hasSubmittedInquiry.value = result;
    } catch (e) {
      print("Error fetching inquiries: $e");
    }
  }

  /// Update property
  Future<bool> updateProperty(String id, Items updatedProperty) async {
    try {
      final success = await _service.updateProperty(id, updatedProperty);
      if (success) {
        int index = items.indexWhere((item) => item.id == id);
        if (index != -1) {
          items[index] = updatedProperty;
          items.refresh();
        }
      }
      return success;
    } catch (e) {
      print("Update property error: $e");
      return false;
    }
  }

  /// Delete property
  Future<bool> deleteProperty(String id) async {
    try {
      final success = await _service.deleteProperty(id);
      if (success) items.removeWhere((item) => item.id == id);
      return success;
    } catch (e) {
      print("Delete property error: $e");
      return false;
    }
  }

  /// Apply filters and refresh (expects a plain Map)
  Future<void> applyFilters(Map<String, String> newFilters) async {
    try {
      isLoading.value = true;
      filters = Map<String, String>.from(newFilters);
      currentPage.value = 1;
      items.clear();
      await refreshList();
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear a specific filter while maintaining other filters
  void clearFilter(String key) {
    filters ??= {};
    filters!.remove(key);

    print("🗑️ Cleared filter - $key");
    print("📊 Current filters: $filters");

    // reset pagination state
    currentPage.value = 1;
    totalPages.value = 1;
    hasMore.value = true;
    items.clear();

    refreshList();
  }

  /// Clear all filters except city (to show all property types for selected city)
  void clearPropertyTypeFilter() {
    clearFilter('propertyType');
  }

  void lessOrReadMore() {
    isExpanded.value = !isExpanded.value;
  }

  void checkTheSellerType() {
    isDeveloper.value = !isDeveloper.value;
  }

  Future<bool> addInquiry(Map<String, dynamic> data, String id) async {
    final success = await _service.addInquiry(data, id);
    return success;
  }

  Future<bool> addView(String id) async {
    final success = await _service.addView(id);
    return success;
  }

  final localities = <String>[].obs;
  final listingTypes = ['Rent', 'Sell', 'PG/Co-living'].obs;
  final bhkList = ['1 BHK', '2 BHK', '3 BHK', '4 BHK', '5 BHK', '5+ BHK'].obs;
  final propertyFilterTypes = ['Residential', 'Commercial'].obs;

  final selectedCityZ = TextEditingController();
  final selectedLocalityController = TextEditingController();
  final selectedLocality = RxnString();
  final selectedListingType = RxnString();
  final selectedBhk = RxnString();
  final selectedPropertyType = RxnString();
  final minBudget = TextEditingController();
  final maxBudget = TextEditingController();

  void findProperties() {
    // Build filters map
    Map<String, String> filters = {};

    // Add city if selected
    if (selectedCityZ.text.isNotEmpty) {
      filters['city'] = selectedCityZ.text;
    }

    // Add locality if selected
    if (selectedLocalityController.text.isNotEmpty) {
      filters['locality'] = selectedLocalityController.text;
    }

    // Add listing type if selected
    if (selectedListingType.value != null &&
        selectedListingType.value!.isNotEmpty) {
      filters['listingType'] = selectedListingType.value!;
    }
    if (selectedPropertyType.value != null &&
        selectedPropertyType.value!.isNotEmpty) {
      filters['type'] = selectedPropertyType.value!.toLowerCase();
    }

    // Add BHK if selected
    if (selectedBhk.value != null && selectedBhk.value!.isNotEmpty) {
      final upperSearchText = selectedBhk.toUpperCase();

      if (upperSearchText!.contains('BHK')) {
        final bhkMatch = RegExp(r'(\d+)').firstMatch(upperSearchText);
        final bhkNumber = bhkMatch?.group(1) ?? '';
        filters['bhk'] = bhkNumber;
      }
    }

    // Add price range if specified
    if (minBudget.text.isNotEmpty) {
      filters['minPrice'] = minBudget.text;
    }

    if (maxBudget.text.isNotEmpty) {
      filters['maxPrice'] = maxBudget.text;
    }

    // Close dialog
    Get.back();
    Get.to(() => PropertyDetail(filters: [filters]));

    print('🔍 Finding properties with filters: $filters');
    selectedPropertyType.value = null;
    selectedBhk.value = null;
    selectedListingType.value = null;
    selectedLocality.value = null;
    selectedCityZ.clear();
    minBudget.clear();
    maxBudget.clear();
  }

  @override
  void onClose() {
    // selectedCityZ.dispose();
    selectedLocalityController.dispose();
    minBudget.dispose();
    maxBudget.dispose();
    super.onClose();
  }
}
