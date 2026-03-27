import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:nesticope_app/data/network/top_seller_profile/model/top_builder_profile_model.dart';
import 'package:nesticope_app/modules/profile/model/seller_profile.dart';
import '../../../../app/constants/api_constants.dart';
import '../../../data/network/top_seller_profile/model/top_seller_profile_model.dart';
import '../../../data/network/top_seller_profile/service/top_seller_profile_service.dart';
import '../../../utils/logger/app_logger.dart';

class TopBuilderController extends PaginatedController<BuilderItem> {
  final TopSellerService _service = TopSellerService();

  final sellerProfile = Rxn<ProfileSellerModel>();
  final userModel = Rxn<User>();

  // Reactive states
  RxBool isExpanded = false.obs;
  RxString selectedState = ''.obs;
  RxString selectedCity = ''.obs;

  // Optional filters
  Map<String, String>? filters = {};

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  /// --- Pagination Fetch ---
  @override
  Future<PaginationResponse<BuilderItem>> fetchItems(int page) async {
    final cityData = await SecureStorage.getSelectedCity();
    final response = await _service.fetchTopBuilderProfiles(
      page: page,
      city: selectedCity.value??cityData,
    );

    AppLogger.structured(
      "Top Builder Response :",
      response.items.map((e) => e.toMap()),
    );
    return response;
  }

  Future<void> loadSellerProfile(String sellerId) async {
    isLoading.value = true;
    try {
      await Future.wait([
        getSellerProfileById(sellerId),
        getUserModelById(sellerId),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<ProfileSellerModel> getSellerProfileById(String sellerId) async {
    try {
      final response = await _service.fetchSellerProfileById(sellerId);
      print("SELLER PROFILE RESPONSE: ${response.toJson()}");
      sellerProfile.value = response;
      return response;
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User> getUserModelById(String userId) async {
    try {
      final response = await _service.fetchUserModelById(userId);
      userModel.value = response;
      return response;
    } catch (e) {
      isLoading.value = false;
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
}
