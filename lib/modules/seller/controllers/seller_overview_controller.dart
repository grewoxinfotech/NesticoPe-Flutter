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

    _initializeData();
  }

  // Initialize data on controller creation
  Future<void> _initializeData() async {
    await getCreatedYearOfUser();
    await getFetchSellerApi(selectedGraphYear.value);
  }

  // Refresh dashboard data
  Future<void> refreshSellerDashboard() async {
    try {
      await getFetchSellerApi(selectedGraphYear.value);

      // NesticoPeSnackBar.showAwesomeSnackbar(
      //   title: 'Success',
      //   message: 'Dashboard refreshed successfully',
      //   contentType: ContentType.success,
      // );
    } catch (e) {
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
      final user = await SecureStorage.getUserData();
      final createdDate = user?.user?.createdAt ?? '';

      if (createdDate.isNotEmpty) {
        final parsedDate = DateTime.parse(createdDate);
        createdUserYear.value = parsedDate.year;
      } else {
        createdUserYear.value = DateTime.now().year; // Fallback
      }
    } catch (e) {
      createdUserYear.value = DateTime.now().year; // Fallback
    }
  }

  // Fetch seller dashboard data
  Future<void> getFetchSellerApi(int leadsYear) async {
    try {
      // Set loading state
      isLoading.value = true;

      // Get user data
      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id;

      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found');
      }

      // Fetch dashboard data with the correct year parameter

      final data = await SellerDashBoardService.sellerDashBoardService
          .getSellerDashBoard(userId, leadsYear: leadsYear);

      // Update observable data
      if (data != null) {
        overviewData.value = SellerInsightsModel.fromJson(data);

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
      }
    } catch (e, stackTrace) {
      overviewData.value = null;

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to load dashboard data: $e',
        contentType: ContentType.failure,
      );
    } finally {
      // Always set loading to false
      isLoading.value = false;
    }
  }

  // Update leads year and refresh data
  Future<void> updateLeadsYear(int year) async {
    if (selectedGraphYear.value == year) {
      return; // No need to update if year is the same
    }
    await getFetchSellerApi(year);
    selectedGraphYear.value = year;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
