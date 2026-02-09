//
// import 'dart:developer';
//
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
//
// import '../../../app/care/pagination/controller/pagination_controller.dart';
// import '../../../app/care/pagination/models/pagination_models.dart';
// import '../../../app/constants/enum.dart';
// import '../../../data/network/subscription/model/subscription_model.dart';
// import '../../../data/network/subscription/services/subscription_services.dart';
//
// class SubscriptionPlanController extends PaginatedController<SubscriptionPlan> {
//   final SubscriptionPlanService _service = SubscriptionPlanService();
//
//   /// Role always comes from UI (seller, sellerBuilder, reseller, contractor)
//   final String userRole;
//
//   /// Filters
//   Map<String, String> filters = {};
//
//   /// --- Constructor ---
//   SubscriptionPlanController({required this.userRole}) {
//     log("Subscription Plan for role: $userRole");
//
//     /// Apply default required filter
//     filters["plansFor"] = _resolvePlansFor(userRole);
//     loadInitial();
//   }
//
//   /// Normalize role mapping in one place
//   String _resolvePlansFor(String role) {
//     if (role == Roles.sellerBuilder.name) {
//       return "sellerBuilder";
//     }
//     if (role == Roles.sellerOwner.name) {
//       return "seller";
//     }
//     return role; // seller, reseller, contractor
//   }
//
//   // @override
//   // void onInit() {
//   //   super.onInit();
//   //   loadInitial();
//   // }
//
//   ///==================== Fetch (Pagination) ====================
//   @override
//   Future<PaginationResponse<SubscriptionPlan>> fetchItems(int page) async {
//     try {
//       final response = await _service.fetchPlans(page: page, filters: filters);
//
//       debugPrint("Fetched plans for $userRole: ${response.items.length}");
//       return response;
//     } catch (e) {
//       debugPrint("Exception in fetchItems: $e");
//       rethrow;
//     }
//   }
//
//   ///==================== Apply Single Filter ====================
//   void applyFilter(String key, String val) {
//     /// Reset but keep role filter
//     filters
//       ..clear()
//       ..["plansFor"] = _resolvePlansFor(userRole)
//       ..[key] = val;
//
//     _resetPagination();
//     refreshList();
//   }
//
//   ///==================== Apply Multiple Filters ====================
//   Future<void> applyFilters(Map<String, String> newFilters) async {
//     isLoading.value = true;
//
//     filters
//       ..clear()
//       ..["plansFor"] = _resolvePlansFor(userRole)
//       ..addAll(newFilters);
//
//     await refreshList();
//     isLoading.value = false;
//   }
//
//   ///==================== Helpers ====================
//   void _resetPagination() {
//     currentPage.value = 1;
//     totalPages.value = 1;
//     hasMore.value = true;
//     items.clear();
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
//       debugPrint("Exception in BuyPlan: $e");
//       return false;
//     }
//   }
//
//   Future<bool> subscriptionPlanInquiry(Map<String, dynamic> payload) async {
//     try {
//       return await _service.subscriptionInquiryPlan(payload);
//     } catch (e) {
//       debugPrint("Exception in InquiryPlan: $e");
//       return false;
//     }
//   }
// }

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/subscription/controller/user_subscription_controller.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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

  /// Razorpay instance
  late Razorpay _razorpay;

  /// Loading state for payment
  final RxBool isProcessingPayment = false.obs;

  late bool _autoRenew;
  late String _userId;
  late String _planId;

  /// --- Constructor ---
  SubscriptionPlanController({required this.userRole}) {
    log("Subscription Plan for role: $userRole");

    /// Apply default required filter
    filters["plansFor"] = _resolvePlansFor(userRole);

    /// Initialize Razorpay
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    loadInitial();
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
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

  ///==================== Razorpay Payment Integration ====================

  /// Open Razorpay checkout
  Future<void> openRazorpayCheckout(String planId) async {
    try {
      isProcessingPayment.value = true;

      // Create order first
      final orderResponse = await _service.createRazorpayOrder(planId);

      if (orderResponse == null) {
        isProcessingPayment.value = false;
        return;
      }

      _autoRenew = orderResponse.autoRenew ?? false;
      _userId = orderResponse.userId ?? '';
      _planId = orderResponse.planId ?? '';

      // Open Razorpay checkout
      var options = {
        'key': orderResponse.razorpayKeyId,
        'amount': orderResponse.amount,
        'currency': orderResponse.currency,
        'name': 'Subscription Plan',
        'description': 'Plan Purchase',
        'order_id': orderResponse.razorpayOrderId,
        'prefill': {
          // You can add user details here if available
          // 'contact': userPhone,
          // 'email': userEmail
        },
        'theme': {'color': '#3399cc'},
      };

      _razorpay.open(options);
    } catch (e) {
      debugPrint("Exception in openRazorpayCheckout: $e");
      isProcessingPayment.value = false;
    }
  }

  /// Handle successful payment
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    log('Payment Success: ${response.paymentId}');
    log('Order ID: ${response.orderId}');
    log('Signature: ${response.signature}');

    try {
      // Verify payment with backend
      final isVerified = await _service.verifyPayment(
        razorpayOrderId: response.orderId ?? '',
        razorpayPaymentId: response.paymentId ?? '',
        razorpaySignature: response.signature ?? '',
        autoRenew: _autoRenew,
        userId: _userId,
        planId: _planId,
      );

      if (isVerified) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: 'Payment completed successfully!',
          contentType: ContentType.success,
        );

        if (Get.isRegistered<CurrentUserPlanController>()) {
          Get.find<CurrentUserPlanController>().refreshList();
        }
      }
    } catch (e) {
      debugPrint("Error verifying payment: $e");
    } finally {
      isProcessingPayment.value = false;
    }
  }

  /// Handle payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    log('Payment Error: ${response.code} - ${response.message}');

    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Payment Failed',
      message: response.message ?? 'An error occurred during payment',
      contentType: ContentType.failure,
    );

    isProcessingPayment.value = false;
  }

  /// Handle external wallet
  void _handleExternalWallet(ExternalWalletResponse response) {
    log('External Wallet: ${response.walletName}');
    isProcessingPayment.value = false;
  }

  ///==================== Legacy method (kept for backward compatibility) ====================
  @Deprecated('Use openRazorpayCheckout instead')
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
