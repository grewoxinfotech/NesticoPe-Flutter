import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import '../../../../app/constants/api_constants.dart';
import '../../../data/network/top_seller_profile/model/top_seller_profile_model.dart';
import '../../../data/network/top_seller_profile/service/top_seller_profile_service.dart';

class TopSellerController extends PaginatedController<TopSeller> {
  final TopSellerService _service = TopSellerService();

  // Reactive states
  RxBool isExpanded = false.obs;
  RxString selectedState = ''.obs;

  // Optional filters
  Map<String, String>? filters = {};

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  /// --- Pagination Fetch ---
  @override
  Future<PaginationResponse<TopSeller>> fetchItems(int page) async {
    try {
      final response = await _service.fetchTopSellers(page: page);
      print("Top Seller Response: $response");
      return response;
    } catch (e) {
      print("🔥 [TopSellerController] Exception in fetchItems: $e");
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

  /// --- Get Single Seller by ID ---
  Future<TopSeller?> getSellerById(String id) async {
    try {
      final existing = items.firstWhereOrNull((item) => item.id == id);
      if (existing != null) return existing;

      // If API supports single seller endpoint, call it here:
      // final seller = await _service.getSellerById(id);
      // if (seller != null) {
      //   items.add(seller);
      //   items.refresh();
      //   return seller;
      // }
    } catch (e) {
      print("Get seller by ID error: $e");
    }
    return null;
  }
}
