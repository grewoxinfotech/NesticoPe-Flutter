import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/contractor/model/dashboard/contractor_dashboard_model.dart';

import '../../../app/constants/color_res.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../data/network/contractor/service/dashboard/contractor_dashboard_service.dart';

class ContractorDashboardController extends GetxController {
  Rxn<ContractorInsightsModel> contractorInsights =
      Rxn<ContractorInsightsModel>();
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getContractorDashboard(leadsYear: selectedGraphYear.value,inquiriesYear: selectedGraphYear.value);
  }
  // Add these observable variables
  final RxInt selectedGraphYear = DateTime.now().year.obs;

// Method to get last 3 years
  List<int> getLastThreeYears() {
    final currentYear = DateTime.now().year;
    return [currentYear, currentYear - 1, currentYear - 2];
  }


  Future<Rxn<ContractorInsightsModel>> getContractorDashboard({
    int? leadsYear,
    int? inquiriesYear,
  }) async {
    isLoading.value = true;
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id;

    if (userId == null || userId.isEmpty) {
      isLoading.value = false;
      throw Exception("User ID not found in secure storage");
    }

    final data = await ContractorDashboardService.contractorDashboardService
        .getContractorDashboard(
      userId,
      leadsYear: leadsYear ?? selectedGraphYear.value,
      inquiriesYear: inquiriesYear ?? selectedGraphYear.value,
    );

    contractorInsights.value = ContractorInsightsModel.fromJson(data);
    print("✅ Contractor dashboard fetched successfully");
    isLoading.value = false;
    return contractorInsights;
  }

// Method to update leads year
  void updateLeadsYear(int year) {
    selectedGraphYear.value = year;
    getContractorDashboard();
  }

// Method to update inquiries year
  void updateInquiriesYear(int year) {
    selectedGraphYear.value = year;
    getContractorDashboard();
  }
  Future<void> refreshDashboard() async {
    try {
      isRefreshing.value = true;
      await getContractorDashboard();
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh dashboard',
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
      );
    } finally {
      isRefreshing.value = false;
    }
  }
  //
  // Future<Rxn<ContractorInsightsModel>> getContractorDashboard() async {
  //   isLoading.value = true;
  //   final user = await SecureStorage.getUserData();
  //   final userId = user?.user?.id;
  //
  //   if (userId == null || userId.isEmpty) {
  //     isLoading.value = false;
  //     throw Exception("User ID not found in secure storage");
  //   }
  //
  //   final data = await ContractorDashboardService.contractorDashboardService
  //       .getContractorDashboard(userId);
  //
  //   contractorInsights.value = ContractorInsightsModel.fromJson(data);
  //   print("✅ Contractor dashboard fetched successfully");
  //   isLoading.value = false;
  //   return contractorInsights;
  // }
}
