import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/network/contractor/model/hire-contractor_service_model.dart';

import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../data/network/contractor/model/contractor_hire_profile_model.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_category_model.dart';
import '../../../data/network/contractor/service/hire_contractor_service.dart';
import '../../../widgets/messages/snack_bar.dart';

class HireContractorListOfProfileController extends PaginatedController<User> {
  // Observable variables
  var isLoading = false.obs;
  var categories = <ContractorServiceCategory>[].obs;
  final combinedList = <HireContractorUserWithProfile>[].obs;
  RxString selectedCategoryId = ''.obs;
  RxString selectedCategoryName = ''.obs;
  RxDouble selectedServiceRating = 0.0.obs; // new rating filter
  RxDouble selectedContractorRating = 0.0.obs; // new rating filter
  RxString selectedCity = ''.obs; // new rating filter

  RxMap<String, String> filters = <String, String>{}.obs;
  var errorMessage = ''.obs;
  final Rxn<HireContractorUserProfileResponse> userProfileData =
      Rxn<HireContractorUserProfileResponse>();
  final Rxn<HireContractorServiceResponse> hireContractorData =
      Rxn<HireContractorServiceResponse>();

  @override
  void onInit() {
    super.onInit();
    filters.value = {'userType': 'contractor'};
    ever(filters, (_) => refreshList());
    loadInitial();
  }

  Future<void> applyFilters(Map<String, String> filter) async {
    filters.assignAll(filter);
    log("Apply Filter in Inquiry Contractor Section ${filters} ");
    // await loadInitial();
    refreshList();
  }

  void setValue<T>(Rx<T> target, T value) {
    target.value = value;
  }

  // 🔹 Reset all filters
  void resetFilters() {
    selectedCategoryId.value = '';
    selectedCategoryName.value = '';
    selectedContractorRating.value = 0.0;
    selectedServiceRating.value = 0.0;
    selectedCity.value = '';
  }

  // 🔹 Apply filters and refresh

  @override
  Future<PaginationResponse<User>> fetchItems(int page) async {
    // Step 1️⃣: Fetch the user list
    final response = await HireContractorService.contractorMyService
        .fetchUserContractorProfile(page: page, filter: filters.value);
    log("Fetched ${response.items.length} users");

    // Step 2️⃣: Fetch user profiles
    await fetchUserProfile();

    // Step 3️⃣: Combine both user and profile data
    combinedList.clear(); // reset previous data

    if (userProfileData.value != null) {
      for (final user in response.items) {
        // Try to find a matching profile by userId
        final profile = userProfileData.value!.profiles.firstWhere(
          (p) => p.userId == user.id,
          orElse:
              () => HireContractorUserProfile(
                id: '',
                userId: user.id ?? '',
                totalReviews: 0,
                overallRating: '0.00',
                warningCount: 0,
                totalServices: 0,
                isBlocked: false,
                activeServices: 0,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
        );

        // Create combined model
        combinedList.add(
          HireContractorUserWithProfile(user: user, profile: profile),
        );
      }

      log('✅ Combined list length: ${combinedList.length}');
    } else {
      log('⚠️ No profile data found to combine');
    }

    return response;
  }

  Future<void> fetchUserProfile() async {
    userProfileData.value = await HireContractorService.contractorMyService
        .fetchUserProfileData({'moduleName': 'contractor'});
    if (userProfileData.value != null) {
      print('Fetched ${userProfileData.value?.count} profiles');
      for (HireContractorUserProfile profile
          in userProfileData.value?.profiles ?? []) {
        print('${profile.userId} → Rating: ${profile.overallRating}');
      }
    } else {
      print('No data received.');
    }
  }

  Future<void> refreshContractorData() async {
    try {
      hireContractorData.refresh();
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: 'Failed to refresh ',
        contentType: ContentType.failure,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> refreshService() async {
    try {
      isRefreshing.value = true;
      refreshList();
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: 'Failed to refresh ',
        contentType: ContentType.failure,
      );
    } finally {
      isRefreshing.value = false;
    }
  }
}

class HireContractorUserWithProfile {
  final User user;
  final HireContractorUserProfile profile;

  HireContractorUserWithProfile({required this.user, required this.profile});

  /// ✅ Create from Map or JSON
  factory HireContractorUserWithProfile.fromMap(Map<String, dynamic> map) {
    return HireContractorUserWithProfile(
      user: User.fromJson(map['user'] ?? {}),
      profile: HireContractorUserProfile.fromMap(map['profile'] ?? {}),
    );
  }

  /// ✅ Convert to Map
  Map<String, dynamic> toMap() {
    return {'user': user.toJson(), 'profile': profile.toMap()};
  }

  /// ✅ Optional: JSON helper methods
  factory HireContractorUserWithProfile.fromJson(Map<String, dynamic> json) =>
      HireContractorUserWithProfile.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}
