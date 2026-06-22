// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../app/constants/color_res.dart';
// import '../../../data/database/secure_storage_service.dart';
// import '../../../data/network/seller/seller_overview_service.dart';
// import '../../../data/network/seller_dashboard/model/seller_dashboardmodel.dart';
// import '../../../data/network/seller_dashboard/service/seller_dashboard_service.dart';
// import '../../../data/network/user/service/user_service.dart';
// import '../model/overview_model.dart';
//
// class SellerOverviewController extends GetxController {
//   // final SellerOverviewService _service = SellerOverviewService();
//
//   var isLoading = false.obs;
//   var overviewData = Rxn<SellerInsightsModel>();
//   final RxInt selectedGraphYear = DateTime.now().year.obs;
//   final RxInt createdUserYear = DateTime.now().year.obs;
//
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     getCreatedYearOfUser();
//     getFetchSellerApi(selectedGraphYear.value);
//   }
//   Future<void> refreshSellerDashboard() async {
//     try {
//
//
//       await Future.delayed(const Duration(seconds: 1));
//       getFetchSellerApi(selectedGraphYear.value);
//
//       // Update metrics with new values
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to refresh ',
//         backgroundColor: Colors.red,
//         colorText: ColorRes.white,
//       );
//     } finally {
//
//     }
//   }
//   Future<void> getCreatedYearOfUser() async {
//     final user = await SecureStorage.getUserData();
//     final createdDate = user?.user?.createdAt ?? '';
//
//     if (createdDate.isNotEmpty) {
//       try {
//         final parsedDate = DateTime.parse(createdDate);
//         createdUserYear.value = parsedDate.year;
//         log('Created year of user: ${createdUserYear.value}');
//       } catch (e) {
//         log('Error parsing createdAt date: $e');
//       }
//     } else {
//       log('User createdAt date is empty or null');
//     }
//   }
//
//
//   Future<Rxn<SellerInsightsModel>> getFetchSellerApi(int leadyear) async {
//     final user = await SecureStorage.getUserData();
//     final userId = user?.user?.id;
//
//     final data = await SellerDashBoardService.sellerDashBoardService.getSellerDashBoard(userId??'',leadsYear: DateTime.now().year);
//
//     overviewData.value=SellerInsightsModel.fromJson(data??{});
//     log("Seller jdsgfdyuh ${overviewData.value?.data.propertyMetrics.totalProperties}");
//     return overviewData;
//
//   }
//   // Method to update leads year
//   void updateLeadsYear(int year) {
//     selectedGraphYear.value = year;
//     getFetchSellerApi( year);
//   }
//
//   Future<void> getSellerProfileData()
//   async {
//     final user = await SecureStorage.getUserData();
//     final userId = user?.user?.id;
//     // final data = await UserService.
//
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../data/network/seller/seller_overview_service.dart';
import '../../../data/network/seller_dashboard/model/seller_dashboardmodel.dart';
import '../../../data/network/seller_dashboard/service/seller_dashboard_service.dart';
import '../../../data/network/user/service/user_service.dart';
import '../../../widgets/messages/snack_bar.dart';
import '../model/overview_model.dart';

class SellerOverviewController extends GetxController {
  var isLoading = false.obs;
  var overviewData = Rxn<SellerInsightsModel>();
  final RxInt selectedGraphYear = DateTime.now().year.obs;
  RxBool showRedDot = false.obs;
  final RxInt createdUserYear = DateTime.now().year.obs;

  @override
  void onInit() {
    super.onInit();
    log('SellerOverviewController onInit called');
    _initializeData();
  }

  // Initialize data on controller creation
  Future<void> _initializeData() async {
    log('_initializeData started');
    await getCreatedYearOfUser();
    await getFetchSellerApi(selectedGraphYear.value);
    log('_initializeData completed');
  }

  // Refresh dashboard data
  Future<void> refreshSellerDashboard() async {
    log('refreshSellerDashboard called');
    try {
      await getFetchSellerApi(selectedGraphYear.value);

      // NesticoPeSnackBar.showAwesomeSnackbar(
      //   title: 'Success',
      //   message: 'Dashboard refreshed successfully',
      //   contentType: ContentType.success,
      // );
    } catch (e) {
      debugPrint('refreshSellerDashboard error: $e');
      //
      // NesticoPeSnackBar.showAwesomeSnackbar(
      //   title: 'Error',
      //   message: 'Failed to refresh dashboard',
      //   contentType: ContentType.failure,
      // );
    }
  }

  // Get user creation year
  Future<void> getCreatedYearOfUser() async {
    try {
      log('getCreatedYearOfUser started');
      final user = await SecureStorage.getUserData();
      final createdDate = user?.user?.createdAt ?? '';

      if (createdDate.isNotEmpty) {
        final parsedDate = DateTime.parse(createdDate);
        createdUserYear.value = parsedDate.year;
        log('Created year of user: ${createdUserYear.value}');
      } else {
        log('User createdAt date is empty or null');
        createdUserYear.value = DateTime.now().year; // Fallback
      }
    } catch (e) {
      log('Error parsing createdAt date: $e');
      createdUserYear.value = DateTime.now().year; // Fallback
    }
  }

  // Fetch seller dashboard data
  Future<void> getFetchSellerApi(int leadsYear) async {
    try {
      log('getFetchSellerApi started with year: $leadsYear');

      // Set loading state
      isLoading.value = true;
      log('isLoading set to true');

      // Get user data
      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id;
      log('userId: $userId');

      if (userId == null || userId.isEmpty) {
        log('userId is null or empty');
        throw Exception('User ID not found');
      }

      // Fetch dashboard data with the correct year parameter
      log('Calling API...');
      final data = await SellerDashBoardService.sellerDashBoardService
          .getSellerDashBoard(userId, leadsYear: leadsYear);
      log(
        'API response received: ${data != null ? "Data exists" : "Data is null"}',
      );

      // Update observable data
      if (data != null) {
        overviewData.value = SellerInsightsModel.fromJson(data);
        log(
          "Seller Dashboard - Total Properties: ${overviewData.value?.data?.propertyMetrics?.totalProperties}",
        );
        log(
          'overviewData.value is now: ${overviewData.value != null ? "NOT NULL" : "NULL"}',
        );
        if (UserHelper.isSellerOwner) {
          final currentLeadCount =
              overviewData.value?.data?.leadAnalytics?.totalLeads ?? 0;
          showRedDot.value = await SecureStorage.hasNewSellerLead(
            currentLeadCount,
          );
        } else if (UserHelper.isSellerBuilder) {
          final currentLeadCount =
              overviewData.value?.data?.leadAnalytics?.totalLeads ?? 0;
          showRedDot.value = await SecureStorage.hasNewBuilderLead(
            currentLeadCount,
          );
        }
      } else {
        overviewData.value = null;
        log('No data received from API');
      }
    } catch (e, stackTrace) {
      log('Error fetching seller data: $e');
      log('Stack trace: $stackTrace');
      overviewData.value = null;

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to load dashboard data: $e',
        contentType: ContentType.failure,
      );
    } finally {
      // Always set loading to false
      isLoading.value = false;
      log('isLoading set to false');
      log(
        'Final state - isLoading: ${isLoading.value}, overviewData: ${overviewData.value != null ? "HAS DATA" : "NULL"}',
      );
    }
  }

  // Update leads year and refresh data
  Future<void> updateLeadsYear(int year) async {
    log('updateLeadsYear called with year: $year');
    if (selectedGraphYear.value == year) {
      log('Year is same, skipping update');
      return; // No need to update if year is the same
    }
    await getFetchSellerApi(year);
    selectedGraphYear.value = year;
  }

  @override
  void onClose() {
    log('SellerOverviewController onClose called');
    super.onClose();
  }
}
