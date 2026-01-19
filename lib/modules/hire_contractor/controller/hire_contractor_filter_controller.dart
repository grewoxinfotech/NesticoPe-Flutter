import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/data/network/contractor/model/hire-contractor_service_model.dart';
import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../data/network/contractor/model/contractor_hire_profile_model.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_category_model.dart';
import '../../../data/network/contractor/service/hire_contractor_service.dart';

class HireContractorFilterProfileController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var categories = <ContractorServiceCategory>[].obs;
  Rxn<HireContractorServiceResponse> item=Rxn<HireContractorServiceResponse>();
  Rxn<User> userData=Rxn<User>();
  final Rx<HireContractorServiceResponse?> filteredData = Rx<HireContractorServiceResponse?>(null);
  final Rxn<HireContractorUserProfile> userProfile = Rxn<HireContractorUserProfile>();

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
    filters.value = {'isActive': true.toString()};

  }


  Future<void> applyFilters(Map<String, String> filter) async {
    if(filter.containsKey('category_ui')){
      filter.remove('category_ui');
    }
    filters.assignAll(filter);
    log("🎛️ Apply Filter in Hire Contractor Section: $filters");

  }
  void setTheName<T>(Rx<T> target, T value){
    target.value=value;
  }

  Future<Rxn<HireContractorUserProfile>> fetchUserDataById(String userId)
  async {
    log("Fetch User Data by ID called $userId");
    userProfile.value=await HireContractorService.contractorMyService.fetchContractorProfileById(userId);
    log("Fetched User Profile Data: ${userProfile.value?.toMap()}");

    return userProfile;

  }
  Future<Rxn<User>> fetchUserByID(String userId)
  async {
    log("Fetch User by ID called $userId");
    userData.value=await HireContractorService.contractorMyService.fetchUserById(userId);
    log("Fetched User Data: ${userData.value?.toJson()}");
    return userData;

  }


  Future<void> setValue<T>(Rx<T> target, T value) async {
    target.value = value;
    await HireContractorService.contractorMyService
        .fetchHireContractorService(categoryId: target.toString(), filter: filters);
  }
  // 🔹 Reset all filters

  void resetFilters() {
    selectedCategoryId.value = '';
    selectedCategoryName.value = '';
    selectedContractorRating.value = 0.0;
    selectedServiceRating.value = 0.0;
    filteredData.value = null; // Clear filtered data
  }

  /// ✅ Updated: fetchHireContractorByCategoryID
  Future<HireContractorServiceResponse?> fetchHireContractorByCategoryID(
      String categoryId,
      String categoryName,
      ) async {
    try {
      selectedCategoryId.value = categoryId;
      selectedCategoryName.value = categoryName;

      final filters = {
        'isActive': 'true',
        if (selectedContractorRating.value > 0)
          'contractorMinRating': selectedContractorRating.value.toInt().toString(),
        if (selectedServiceRating.value > 0)
          'serviceMinRating': selectedServiceRating.value.toInt().toString(),
      };

      final response = await HireContractorService.contractorMyService
          .fetchHireContractorService(categoryId: categoryId, filter: filters);

      filteredData.value = response; // Store in observable
      return response;
    } catch (e) {
      log('Error fetching contractors: $e');
      filteredData.value = null;
      return null;
    }
  }


  /// 🔁 Refresh contractor list manually
  Future<void> refreshContractorData() async {
    try {

      await fetchHireContractorByCategoryID(selectedCategoryId.value, selectedCategoryName.value);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh contractor data',
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
      );
    } finally {

    }
  }

  /// 🔁 Refresh with delay (for pull-to-refresh)
  Future<void> refreshService() async {
    try {

      await Future.delayed(const Duration(milliseconds: 800));
      await fetchHireContractorByCategoryID(selectedCategoryId.value, selectedCategoryName.value);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh services',
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
      );
    } finally {

    }
  }

  /// 🚫 Not used anymore since pagination removed

}
