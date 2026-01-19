import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/data/network/contractor/model/hire-contractor_service_model.dart';
import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../data/network/contractor/model/contractor_hire_profile_model.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_category_model.dart';
import '../../../data/network/contractor/model/new_hire_contractor.dart';
import '../../../data/network/contractor/service/hire_contractor_service.dart';
import '../../../utils/logger/app_logger.dart';

class HireContractorFilterProfileController
    extends PaginatedController<OverAllContractorItem> {
  // Observable variables
  var isLoading = false.obs;
  var categories = <ContractorServiceCategory>[].obs;

  Rxn<User> userData = Rxn<User>();

  // final Rx<HireContractorServiceResponse?> filteredData = Rx<HireContractorServiceResponse?>(null);
  final Rxn<HireContractorUserProfile> userProfile =
      Rxn<HireContractorUserProfile>();
  final Rxn<ContractorCityInsightsResponse> contractorCity =
      Rxn<ContractorCityInsightsResponse>();

  RxString selectedCategoryId = ''.obs;

  RxString selectedCategoryName = ''.obs;
  RxDouble selectedServiceRating = 0.0.obs;
  RxDouble selectedContractorRating = 0.0.obs;
  RxString selectedCity = ''.obs;

  RxMap<String, String> filters = <String, String>{}.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    filters.value = {};
  }

  Future<void> applyFilters(Map<String, String> filter) async {
    if (filter.containsKey('category_ui')) {
      filter.remove('category_ui');
    }
    filters.assignAll(filter);
    loadInitial();
    log("🎛️ Apply Filter in Hire Contractor Section: $filters");
  }

  Future<Rxn<HireContractorUserProfile>> fetchUserDataById(
    String userId,
  ) async {
    log("Fetch User Data by ID called $userId");
    userProfile.value = await HireContractorService.contractorMyService
        .fetchContractorProfileById(userId);
    log("Fetched User Profile Data: ${userProfile.value?.toMap()}");

    return userProfile;
  }

  Future<Rxn<User>> fetchUserByID(String userId) async {
    log("Fetch User by ID called $userId");
    userData.value = await HireContractorService.contractorMyService
        .fetchUserById(userId);
    log("Fetched User Data: ${userData.value?.toJson()}");
    return userData;
  }

  Future<void> setValue<T>(Rx<T> target, T value) async {
    target.value = value;
    // await HireContractorService.contractorMyService
    //     .fetchHireContractorService(categoryId: target.toString(), filter: filters);
    // fetchHireContractorCategories(target.string,'');
  }

  // 🔹 Reset all filters

  Future<void> fetchHireContractorCategories(String id, String name) async {
    try {
      selectedCategoryId.value = id;
      selectedCategoryName.value = name;
      log('ckjnjvjn ${selectedCategoryName.value}');
      isLoading.value = true;
      fetchCityOfContractor();
      await loadInitial();
      log("Fetched ${items.length} contractor categories");
    } catch (e) {
      log("Error fetching contractor categories: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void resetFilters() {
    selectedCategoryId.value = '';
    selectedCategoryName.value = '';
    selectedContractorRating.value = 0.0;
    selectedServiceRating.value = 0.0;
    items.value = []; // Clear filtered data
  }

  /// 🔁 Refresh contractor list manually

  /// 🔁 Refresh with delay (for pull-to-refresh)
  Future<void> refreshService() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      refreshList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh services',
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
      );
    } finally {}
  }

  @override
  @override
  Future<PaginationResponse<OverAllContractorItem>> fetchItems(int page) async {
    try {
      isLoading.value = true;

      final filters = {
        if (selectedCity.value.isNotEmpty) 'city': selectedCity.value,

        if (selectedContractorRating.value > 0)
          'contractorMinRating':
              selectedContractorRating.value.toInt().toString(),
        if (selectedServiceRating.value > 0)
          'serviceMinRating': selectedServiceRating.value.toInt().toString(),
      };

      log(
        "Fetching items for category ID: ${selectedCategoryId.value} with filters: $filters",
      );

      final response = await HireContractorService.contractorMyService
          .fetchHireContractorByCategory(
            id: selectedCategoryId.value,
            filter: filters,
            limit: 24,
          );

      AppLogger.structured(
        'Fetched contractors',
        response.items.map((element) => element.toMap()),
      );

      items.assignAll(response.items); // ✅ use assignAll for RxList
      return response;
    } finally {
      isLoading.value = false; // ✅ stop loader after fetch
    }
  }

  Future<void> fetchCityOfContractor() async {
    try {
      final response =
          await HireContractorService.contractorMyService.fetchContractorCity();
      contractorCity.value = ContractorCityInsightsResponse.fromJson(response);
    } catch (e) {
      log("Error fetching contractor cities: $e");
    }
  }

  /// 🚫 Not used anymore since pagination removed
}
