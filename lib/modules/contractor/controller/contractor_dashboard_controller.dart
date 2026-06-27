import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/data/network/contractor/model/dashboard/contractor_dashboard_model.dart';
import 'package:nesticope_app/data/network/contractor/model/subscription/contractor_active_subscription_model.dart';
import 'package:nesticope_app/data/network/contractor/service/subscription/contractor_subscription_service.dart';
import 'package:nesticope_app/modules/subscription/views/suscription_plan_screen.dart';

import '../../../data/database/secure_storage_service.dart';
import '../../../data/network/contractor/service/dashboard/contractor_dashboard_service.dart';
import '../../../widgets/messages/snack_bar.dart';

class ContractorDashboardController extends GetxController {
  Rxn<ContractorInsightsModel> contractorInsights =
      Rxn<ContractorInsightsModel>();
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  RxBool showRedDot = false.obs;
  final RxInt createdUserYear = DateTime.now().year.obs;
  final Rxn<ContractorActiveSubscriptionData> activeSubscription =
      Rxn<ContractorActiveSubscriptionData>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getCreatedYearOfUser();
    getContractorDashboard(leadsYear: selectedGraphYear.value);
    fetchActiveSubscription();
  }

  // Add these observable variables
  final RxInt selectedGraphYear = DateTime.now().year.obs;

  // Method to get last 3 years
  List<int> getLastThreeYears() {
    final currentYear = DateTime.now().year;
    return [currentYear, currentYear - 1, currentYear - 2];
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

  Future<Rxn<ContractorInsightsModel>> getContractorDashboard({
    int? leadsYear,
    bool silent = false,
  }) async {
    if (!silent) {
      isLoading.value = true;
    }
    try {
      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id;

      if (userId == null || userId.isEmpty) {
        log("Contractor dashboard skipped: user id missing in secure storage");
        contractorInsights.value = null;
        return contractorInsights;
      }

      final data = await ContractorDashboardService.contractorDashboardService
          .getContractorDashboard(
            userId,
            leadsYear: leadsYear ?? selectedGraphYear.value,
          );

      contractorInsights.value = ContractorInsightsModel.fromJson(data);
      final currentLeadCount =
          contractorInsights.value?.data?.performance?.totalInquiries ?? 0;
      showRedDot.value = await SecureStorage.hasNewContractorLead(
        currentLeadCount,
      );

      log("Contractor dashboard fetched successfully ${showRedDot.value}");
    } catch (e, s) {
      log("Failed to fetch contractor dashboard: $e", stackTrace: s);
      contractorInsights.value = null;
    } finally {
      if (!silent) {
        isLoading.value = false;
      }
    }
    return contractorInsights;
  }

  // Method to update leads year
  void updateLeadsYear(int year) {
    selectedGraphYear.value = year;
    getContractorDashboard(leadsYear: year);
  }

  /// Reload metrics without replacing the dashboard with the full shimmer
  /// (e.g. after creating a service while this controller is registered).
  Future<void> reloadAfterServiceChange() async {
    await getContractorDashboard(
      leadsYear: selectedGraphYear.value,
      silent: true,
    );
    await fetchActiveSubscription(showDialogWhenMissing: false);
  }

  Future<void> refreshDashboard() async {
    try {
      isRefreshing.value = true;
      await getContractorDashboard();
      await fetchActiveSubscription(showDialogWhenMissing: false);
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to refresh dashboard',
        contentType: ContentType.failure,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> fetchActiveSubscription({
    bool showDialogWhenMissing = true,
  }) async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id;

    if (userId == null || userId.isEmpty) return;

    final plan = await ContractorSubscriptionService.instance.fetchActivePlan(
      userId,
    );
    activeSubscription.value = plan;

    if (showDialogWhenMissing &&
        plan == null &&
        (Get.isDialogOpen ?? false) == false) {
      if (UserHelper.isContractor) {
        await showUpgradePlanDialog(
          title: 'Active plan required',
          message:
              'You do not have an active subscription. Please activate a plan to continue.',
          buttonText: 'Buy Plan',
        );
      }
    }
  }

  bool get hasActivePlan => activeSubscription.value != null;

  bool get hasReachedServiceLimit {
    final plan = activeSubscription.value;
    if (plan == null) return true;
    return plan.isServiceLimitReached;
  }

  bool get hasReachedLeadLimit {
    final plan = activeSubscription.value;
    if (plan == null) return true;
    return plan.isLeadLimitReached;
  }

  bool get hasReachedUserLimit {
    final plan = activeSubscription.value;
    if (plan == null) return true;
    return plan.isUserLimitReached;
  }

  Future<void> guardAddServiceAction(VoidCallback onAllowed) async {
    await fetchActiveSubscription(showDialogWhenMissing: true);

    if (!hasActivePlan) return;
    if (hasReachedServiceLimit) {
      if (UserHelper.isContractor) {
        await showUpgradePlanDialog(
          title: 'Limit Reached',
          message: 'Limit Reached, please upgrade your plan.',
          buttonText: 'Upgrade Plan',
        );
        return;
      }
    }
    onAllowed();
  }

  Future<void> guardAddLeadAction(VoidCallback onAllowed) async {
    await fetchActiveSubscription(showDialogWhenMissing: true);

    if (!hasActivePlan) return;
    if (hasReachedLeadLimit) {
      await showUpgradePlanDialog(
        title: 'Limit Reached',
        message: 'Limit Reached, please upgrade your plan.',
        buttonText: 'Upgrade Plan',
      );
      return;
    }
    onAllowed();
  }

  Future<void> guardAddUserAction(VoidCallback onAllowed) async {
    await fetchActiveSubscription(showDialogWhenMissing: true);

    if (!hasActivePlan) return;
    if (hasReachedUserLimit) {
      if (UserHelper.isContractor) {
        await showUpgradePlanDialog(
          title: 'Limit Reached',
          message: 'Limit Reached, please upgrade your plan.',
          buttonText: 'Upgrade Plan',
        );
        return;
      }
      return;
    }
    onAllowed();
  }

  Future<void> showUpgradePlanDialog({
    required String title,
    required String message,
    required String buttonText,
  }) async {
    if (Get.isDialogOpen ?? false) return;

    await Get.dialog<void>(
      AlertDialog(
        backgroundColor: ColorRes.white,
        title: Text(
          title,
          style: TextStyle(
            fontSize: AppFontSizes.title,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: AppFontSizes.small,
            fontWeight: AppFontWeights.medium,
          ),
        ),
        actions: [
          (buttonText.toLowerCase() == 'upgrade plan')
              ? TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Later'),
              )
              : SizedBox.shrink(),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.to(
                () => SubscriptionPlansScreen(
                  role: 'contractor',
                  isShowCurrentPlan: true,
                ),
              );
            },
            child: Text('$buttonText'),
          ),
        ],
      ),
    );
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
