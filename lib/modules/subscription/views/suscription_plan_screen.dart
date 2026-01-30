import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:housing_flutter_app/modules/auth/views/register_screen.dart';
import 'package:housing_flutter_app/modules/auth/views/role_convert/convert_to_seller/convert_to_seller.dart';
import 'package:housing_flutter_app/modules/subscription/views/widgets/sign_up_subscription_card.dart';

import '../../../app/constants/color_res.dart';
import '../../../app/utils/formater/formater.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../auth/views/role_convert/covert_to_reseller/convert_to_reseller.dart';
import '../../contractor/view/widget/convert_to_contractor.dart';
import '../../reseller/view/property_reseller.dart';
import '../controller/subscription_controller.dart';
import '../controller/user_subscription_controller.dart';
import 'widgets/subscription_plan_widget.dart';
import 'package:get/get.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  final String role;
  final bool isShowCurrentPlan;

  const SubscriptionPlansScreen({
    super.key,
    required this.role,
    this.isShowCurrentPlan = false,
  });

  @override
  Widget build(BuildContext context) {
    CurrentUserPlanController? currentPlanController;
    if (isShowCurrentPlan) {
      currentPlanController = Get.put(CurrentUserPlanController());
    }
    final controller = Get.put(SubscriptionPlanController(userRole: role));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscription Plans"),
        // automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (currentPlanController != null && isShowCurrentPlan) ...[
              Obx(() {
                if (currentPlanController!.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final item =
                    currentPlanController.items.isNotEmpty
                        ? currentPlanController.items.first
                        : null;
                if (item == null) {
                  // return const Center(child: Text("No subscription found"));
                  return SizedBox.shrink();
                }

                final plan = item.plan;
                final int used =
                    item.usedProperties > 0
                        ? item.usedProperties
                        : item.usedServices;

                final int max =
                    (item.metadata?['maxProperties'] ??
                                item.metadata?['maxServices'] ??
                                0)
                            is String
                        ? int.tryParse(
                              item.metadata?['maxProperties'] ??
                                  item.metadata?['maxServices'] ??
                                  '0',
                            ) ??
                            0
                        : (item.metadata?['maxProperties'] ??
                            item.metadata?['maxServices'] ??
                            0);

                final double percent = max <= 0 ? 0.0 : used / max;

                log("Plan Usage ${percent}");

                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ColorRes.leadGreyColor.shade300,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Icon(
                            Icons.workspace_premium_rounded,
                            color: ColorRes.primary,
                            size: 26,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "My Plan Details",
                            style: TextStyle(
                              color: ColorRes.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "ACTIVE",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(text: "Currently on "),
                            TextSpan(
                              text: plan?.name ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: ColorRes.primary,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  " - View your plan details and usage statistics",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio:1.6, // Fixed height for each card
                            ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          // Map index to your cards
                          final cards = [
                            (
                              'Start Date',
                              Formatter.formatDate(item.startDate.toString()),
                              Icons.timer_outlined,
                              ColorRes.primary,
                            ),
                            (
                              'Expiry Date',
                              Formatter.formatDate(item.endDate.toString()),
                              Icons.calendar_month_outlined,
                              ColorRes.green,
                            ),
                            (
                              'Plan Amount',
                              Formatter.formatPrice(
                                double.tryParse(plan?.amount ?? "0") ?? 0,
                              ),
                              Icons.currency_rupee_outlined,
                              ColorRes.orangeColor,
                            ),
                            (
                              'Subscription Tier',
                              plan?.isPremium == true ? "Premium" : "Basic",
                              Icons.star_rounded,
                              ColorRes.primary,
                            ),
                          ];
                          return buildMetricCard(
                            cards[index].$1,
                            cards[index].$2,
                            cards[index].$3,
                            cards[index].$4,
                          );
                        },
                      ),
                      SizedBox(height: 10,),
                      const Text(
                        "Plan Usage",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            "$used / $max",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Total Used",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: percent,
                        backgroundColor: Colors.grey.shade200,
                        color: ColorRes.primary.withOpacity(0.4),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${max - used} remaining in your current cycle",
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            if (UserHelper.isBuyer || UserHelper.isGuest) ...[
              SignUpSubscriptionScreen(
                title: _mapRoleToTitle(role),
                onTap: UserHelper.isGuest ? onGuestTap : onBuyerTap,
              ),
            ],
            SubscriptionPlansWidget(controller: controller),
          ],
        ),
      ),
    );
  }

  String _mapRoleToTitle(String role) {
    switch (role) {
      case 'sellerOwner':
        return 'Become a Seller';
      case 'sellerBuilder':
        return 'Become a Seller';
      case 'reseller':
        return 'Become a Partner';
      case 'contractor':
        return 'Become a Contractor';
      default:
        return '';
    }
  }

  VoidCallback get onBuyerTap {
    switch (role) {
      case 'sellerOwner':
        return () => Get.to(() => SellerConversionScreen());
      case 'sellerBuilder':
        return () => Get.to(() => SellerConversionScreen());
      case 'reseller':
        return () => Get.to(() => ResellerConversionScreen());
      case 'contractor':
        return () => Get.to(() => ConvertToContractorConversionScreen());
      default:
        return () {};
    }
  }

  VoidCallback get onGuestTap {
    switch (role) {
      case 'sellerOwner':
        return () => Get.to(() => RegisterScreen(role: userRole));
      case 'sellerBuilder':
        return () => Get.to(() => RegisterScreen(role: userRole));
      case 'reseller':
        return () => Get.to(() => RegisterScreen(role: userRole));
      case 'contractor':
        return () => Get.to(() => RegisterScreen(role: userRole));
      default:
        return () {};
    }
  }

  UserRole get userRole {
    switch (role) {
      case 'sellerOwner':
        return UserRole.seller;
      case 'sellerBuilder':
        return UserRole.seller;
      case 'reseller':
        return UserRole.reseller;
      case 'contractor':
        return UserRole.contractor;
      default:
        return UserRole.buyer;
    }
  }
}
