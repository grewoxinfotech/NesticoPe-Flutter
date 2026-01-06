import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../data/network/seller/seller_overview_service.dart';
import '../../../data/network/seller_dashboard/model/seller_dashboardmodel.dart';
import '../../../data/network/seller_dashboard/service/seller_dashboard_service.dart';
import '../../../data/network/user/service/user_service.dart';
import '../model/overview_model.dart';

class SellerOverviewController extends GetxController {
  // final SellerOverviewService _service = SellerOverviewService();

  var isLoading = false.obs;
  var overviewData = Rxn<SellerInsightsModel>();
  final RxInt selectedGraphYear = DateTime.now().year.obs;
  final RxInt createdUserYear = DateTime.now().year.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCreatedYearOfUser();
    getFetchSellerApi(selectedGraphYear.value);
  }
  Future<void> refreshSellerDashboard() async {
    try {


      await Future.delayed(const Duration(seconds: 1));
      getFetchSellerApi(selectedGraphYear.value);

      // Update metrics with new values
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh ',
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
      );
    } finally {

    }
  }
  Future<void> getCreatedYearOfUser() async {
    final user = await SecureStorage.getUserData();
    final createdDate = user?.user?.createdAt ?? '';

    if (createdDate.isNotEmpty) {
      try {
        final parsedDate = DateTime.parse(createdDate);
        createdUserYear.value = parsedDate.year;
        log('Created year of user: ${createdUserYear.value}');
      } catch (e) {
        log('Error parsing createdAt date: $e');
      }
    } else {
      log('User createdAt date is empty or null');
    }
  }


  Future<Rxn<SellerInsightsModel>> getFetchSellerApi(int leadyear) async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id;
    
    final data = await SellerDashBoardService.sellerDashBoardService.getSellerDashBoard(userId??'',leadsYear: DateTime.now().year);

    overviewData.value=SellerInsightsModel.fromJson(data??{});
    log("Seller jdsgfdyuh ${overviewData.value?.data.propertyMetrics.totalProperties}");
    return overviewData;
    
  }
  // Method to update leads year
  void updateLeadsYear(int year) {
    selectedGraphYear.value = year;
    getFetchSellerApi( year);
  }

  Future<void> getSellerProfileData()
  async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id;
    // final data = await UserService.

  }
}
