import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import '../../../data/network/platform_service/platform_service.dart';
import '../../../data/network/platform_service/platform_service_model.dart';

class PlatformServicesController
    extends PaginatedController<PlatformServiceItem> {
  final PlatformServicesService _service = PlatformServicesService();

  // Reactive states for filtering or UI
  RxBool isActiveOnly = false.obs;
  RxString searchKeyword = ''.obs;

  // Optional filters
  Map<String, String>? filters = {};

  @override
  void onInit() {
    super.onInit();
    loadInitial(); // Auto-load page 1
  }

  /// --- Pagination Fetch ---
  @override
  Future<PaginationResponse<PlatformServiceItem>> fetchItems(int page) async {
    try {
      final response = await _service.fetchServices(
        page: page,
        filters: filters,
      );
      debugPrint("Fetched platform services: ${response.items.length}");
      return response;
    } catch (e) {
      debugPrint("Exception in fetchItems: $e");
      rethrow;
    }
  }

  /// --- Filters ---
  void applyFilter(String key, String val) {
    filters ??= {};
    filters!.clear();
    filters![key] = val;

    currentPage.value = 1;
    totalPages.value = 1;
    hasMore.value = true;
    items.clear();

    refreshList();
  }

  Future<void> applyFilters(Map<String, String> newFilters) async {
    isLoading.value = true;
    filters = newFilters;
    await refreshList();
    isLoading.value = false;
  }

  /// --- Get Single Service by ID ---
  Future<PlatformServiceItem?> getServiceById(String id) async {
    try {
      final existing = items.firstWhereOrNull((item) => item.id == id);
      if (existing != null) return existing;

      final service = await _service.getServiceById(id);
      if (service != null) {
        items.add(service);
        items.refresh();
        return service;
      }
    } catch (e) {
      debugPrint("Get service error: $e");
    }
    return null;
  }
}
