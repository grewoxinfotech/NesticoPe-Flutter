import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart'; // for firstWhereOrNull

import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/manager/favorite.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:housing_flutter_app/data/network/property/services/property_service.dart';

import '../../../app/care/pagination/models/pagination_models.dart';
import '../../../data/database/secure_storage_service.dart';

class PropertyController extends PaginatedController<Items> {
  final PropertyService _service = PropertyService();

  final RxString selectedCity = "".obs;

  // Reactive fields
  Rxn<PropertyMedia> propertyMedia = Rxn<PropertyMedia>();
  Rxn<PropertyDetails> propertyDetails = Rxn<PropertyDetails>();
  Rxn<String> location = Rxn<String>();
  RxList<NearbyLocations> nearbyLocations = <NearbyLocations>[].obs;
  RxString approvalStatus = "pending".obs;
  RxString assignmentStatus = "available".obs;
  RxBool isVerified = false.obs;
  RxBool isExpanded = false.obs;
  RxBool isDeveloper = false.obs;
  var allowContact = true.obs;
  var interestedInHomeLoan = false.obs;

  // Optional filters
  Map<String, String>? filters = {};
  var favoriteIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getCity();
  }

  Future<void> getCity() async {
    final city = await SecureStorage.getSelectedCity();
    if (city != null && city.isNotEmpty) {
      print("City : ${city}");
      selectedCity.value = city;
    }
    final filter = {'city': selectedCity.value};
    applyFilters(filter);
    loadInitial();
  }

  /// Apply a single key-value filter (replaces existing filters)
  void applyFilter(String key, String val) {
    filters ??= {};
    filters!.clear();
    filters![key] = val;

    // reset pagination state
    currentPage.value = 1;
    totalPages.value = 1;
    hasMore.value = true;
    items.clear();

    refreshList();
  }

  void toggleFavorite(String propertyId) async {
    if (favoriteIds.contains(propertyId)) {
      favoriteIds.remove(propertyId);
      FavoriteManager().removeFavorite(propertyId);
    } else {
      favoriteIds.add(propertyId);
      FavoriteManager().addFavorite(propertyId);
    }

    // Optionally, sync with backend (don't block UI)
    unawaited(_service.addFavorite(propertyId));
  }

  /// Fetch a paginated response (override)
  @override
  Future<PaginationResponse<Items>> fetchItems(int page) async {
    try {
      final response = await _service.fetchProperties(
        page: page,
        filters: filters,
      );

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
        return property;
      }
    } catch (e) {
      print("Get property error: $e");
    }
    return null;
  }

  Future<void> getFavoriteProperty() async {
    // ensure we iterate over a snapshot to avoid concurrent modification
    final ids = favoriteIds.toList();
    for (var favorite in ids) {
      await getPropertyById(favorite);
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

  Future<bool> addFavorite(String id) async {
    final success = await _service.addFavorite(id);
    return success;
  }

  Future<void> getFavorite(String userId) async {
    final data = await _service.getFavorite(userId);
    if (data != null) {
      FavoriteManager().addAllFavorites(data);
      favoriteIds.addAll(data);
    }
  }
}
