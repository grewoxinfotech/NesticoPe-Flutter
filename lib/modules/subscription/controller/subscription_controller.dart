// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
// import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
// import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
//
// import '../../../data/network/subscription/model/subscription_model.dart';
// import '../../../data/network/subscription/services/subscription_services.dart';
//
// class SubscriptionPlanController extends PaginatedController<SubscriptionPlan> {
//   final SubscriptionPlanService _service = SubscriptionPlanService();
//
//   /// User role comes from constructor (ex: "reseller" / "builder")
//   final String userRole;
//
//   /// Filters
//   Map<String, String>? filters = {};
//
//   /// --- Constructor ---
//   SubscriptionPlanController({required this.userRole}) {
//     /// Apply default always-on filter
//     log("Subscription Plan for ${userRole}");
//    if(UserHelper.isSellerBuilder){
//      log("Subscription Plan for ${userRole}");
//      filters!["plansFor"] = "sellerBuilder";
//    }
//    else{
//      filters!["plansFor"] = userRole;
//    }
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadInitial(); // Auto load page 1
//   }
//
//   ///==================== Fetch (Pagination) ====================
//   @override
//   Future<PaginationResponse<SubscriptionPlan>> fetchItems(int page) async {
//     try {
//       final response = await _service.fetchPlans(page: page, filters: filters);
//
//       debugPrint("Fetched plans: ${response.items.length}");
//       return response;
//     } catch (e) {
//       debugPrint("Exception in fetchItems: $e");
//       rethrow;
//     }
//   }
//
//   ///==================== Apply Single Filter ====================
//   /// Example: applyFilter("isPremium", "true")
//   void applyFilter(String key, String val) {
//     filters ??= {};
//
//     /// Clear previous filters but keep default role filter
//     filters!.clear();
//     filters!["plansFor"] = userRole;
//     filters![key] = val;
//
//     /// Reset pagination
//     currentPage.value = 1;
//     totalPages.value = 1;
//     hasMore.value = true;
//     items.clear();
//
//     refreshList();
//   }
//
//   ///==================== Apply Multiple Filters ====================
//   Future<void> applyFilters(Map<String, String> newFilters) async {
//     isLoading.value = true;
//
//     filters ??= {};
//     filters!.clear();
//
//     /// Keep default required filter
//     filters!["plansFor"] = userRole;
//
//     /// Add new filters
//     filters!.addAll(newFilters);
//
//     await refreshList();
//     isLoading.value = false;
//   }
//
//   ///==================== Get Plan by ID ====================
//   Future<SubscriptionPlan?> getPlanById(String id) async {
//     try {
//       final existing = items.firstWhereOrNull((item) => item.id == id);
//       if (existing != null) return existing;
//
//       final plan = await _service.getPlanById(id);
//       if (plan != null) {
//         items.add(plan);
//         items.refresh();
//         return plan;
//       }
//     } catch (e) {
//       debugPrint("Get plan by ID error: $e");
//     }
//     return null;
//   }
//
//   Future<bool> buySubscriptionPlan(String planId) async {
//     try {
//       return await _service.buySubscriptionPlan(planId);
//     } catch (e) {
//       print("Exception in BuyPlan: $e");
//       return false;
//     }
//   }
//   Future<bool> subscriptionPlanInquiry(Map<String,dynamic> payload) async {
//     try {
//       return await _service.subscriptionInquiryPlan(payload);
//     } catch (e) {
//       print("Exception in BuyPlan: $e");
//       return false;
//     }
//   }
// }

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../app/care/pagination/models/pagination_models.dart';
import '../../../app/constants/enum.dart';
import '../../../data/network/subscription/model/subscription_model.dart';
import '../../../data/network/subscription/services/subscription_services.dart';

class SubscriptionPlanController extends PaginatedController<SubscriptionPlan> {
  final SubscriptionPlanService _service = SubscriptionPlanService();

  /// Role always comes from UI (seller, sellerBuilder, reseller, contractor)
  final String userRole;

  /// Filters
  Map<String, String> filters = {};

  /// --- Constructor ---
  SubscriptionPlanController({required this.userRole}) {
    log("Subscription Plan for role: $userRole");

    /// Apply default required filter
    filters["plansFor"] = _resolvePlansFor(userRole);
    loadInitial();
  }

  /// Normalize role mapping in one place
  String _resolvePlansFor(String role) {
    if (role == Roles.sellerBuilder.name) {
      return "sellerBuilder";
    }
    if (role == Roles.sellerOwner.name) {
      return "seller";
    }
    return role; // seller, reseller, contractor
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   loadInitial();
  // }

  ///==================== Fetch (Pagination) ====================
  @override
  Future<PaginationResponse<SubscriptionPlan>> fetchItems(int page) async {
    try {
      final response = await _service.fetchPlans(page: page, filters: filters);

      debugPrint("Fetched plans for $userRole: ${response.items.length}");
      return response;
    } catch (e) {
      debugPrint("Exception in fetchItems: $e");
      rethrow;
    }
  }

  ///==================== Apply Single Filter ====================
  void applyFilter(String key, String val) {
    /// Reset but keep role filter
    filters
      ..clear()
      ..["plansFor"] = _resolvePlansFor(userRole)
      ..[key] = val;

    _resetPagination();
    refreshList();
  }

  ///==================== Apply Multiple Filters ====================
  Future<void> applyFilters(Map<String, String> newFilters) async {
    isLoading.value = true;

    filters
      ..clear()
      ..["plansFor"] = _resolvePlansFor(userRole)
      ..addAll(newFilters);

    await refreshList();
    isLoading.value = false;
  }

  ///==================== Helpers ====================
  void _resetPagination() {
    currentPage.value = 1;
    totalPages.value = 1;
    hasMore.value = true;
    items.clear();
  }

  ///==================== Get Plan by ID ====================
  Future<SubscriptionPlan?> getPlanById(String id) async {
    try {
      final existing = items.firstWhereOrNull((item) => item.id == id);
      if (existing != null) return existing;

      final plan = await _service.getPlanById(id);
      if (plan != null) {
        items.add(plan);
        items.refresh();
        return plan;
      }
    } catch (e) {
      debugPrint("Get plan by ID error: $e");
    }
    return null;
  }

  Future<bool> buySubscriptionPlan(String planId) async {
    try {
      return await _service.buySubscriptionPlan(planId);
    } catch (e) {
      debugPrint("Exception in BuyPlan: $e");
      return false;
    }
  }

  Future<bool> subscriptionPlanInquiry(Map<String, dynamic> payload) async {
    try {
      return await _service.subscriptionInquiryPlan(payload);
    } catch (e) {
      debugPrint("Exception in InquiryPlan: $e");
      return false;
    }
  }
}
