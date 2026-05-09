import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/modules/contractor/controller/contractor_dashboard_controller.dart';

import '../../../data/network/subscription/model/subscription_model.dart';
import '../../../data/network/subscription/model/user_subscription_model.dart';
import '../../../data/network/subscription/services/subscription_services.dart';

class CurrentUserPlanController extends PaginatedController<CurrentUserSubscriptionItem> {
  final SubscriptionPlanService _service = SubscriptionPlanService();
  final ContractorDashboardController dashboardController = Get.isRegistered<ContractorDashboardController>()
            ? Get.find<ContractorDashboardController>()
            : Get.put(ContractorDashboardController());

  /// User role comes from constructor (ex: "reseller" / "builder")


  /// Filters
  Map<String, String>? filters = {};

  @override
  void onInit() {
    super.onInit();
    loadInitial(); // Auto load page 1
  }

  ///==================== Fetch (Pagination) ====================
  @override
  Future<PaginationResponse<CurrentUserSubscriptionItem>> fetchItems(int page) async {
    try {
      final user =await SecureStorage.getUserData();
      final userId=user?.user?.id??'';
      final response = await _service.fetchUserSubscriptionData(page: page, filters: filters,userId: userId);

      debugPrint("Fetched plans: ${response.items.length}");
      return response;
    } catch (e) {
      debugPrint("Exception in fetchItems: $e");
      rethrow;
    }
  }

  ///==================== Apply Single Filter ====================
  /// Example: applyFilter("isPremium", "true")


  ///==================== Apply Multiple Filters ====================


  ///==================== Get Plan by ID ====================

  Future<bool> activateSubscription(String subscriptionId) async {
    final ok = await _service.activateSubscription(subscriptionId);
    if (ok) {
      await loadInitial();
      await dashboardController.fetchActiveSubscription(showDialogWhenMissing: false);
    }
    return ok;
  }
}

