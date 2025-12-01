import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/font_res.dart';
import 'package:housing_flutter_app/app/widgets/snackbar/snackbar.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../data/network/subscription/model/subscription_model.dart';
import '../../../../widgets/display/ic.dart';
import '../../controller/subscription_controller.dart';

class SubscriptionPlansWidget extends StatelessWidget {
  final SubscriptionPlanController controller;

  /// Selected index stored in GetX (so it works anywhere)
  final RxInt selectedPlanIndex = (-1).obs;

  SubscriptionPlansWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.items.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      final plans = controller.items;

      return ListView.separated(
        shrinkWrap: true,
        itemCount: plans.length,
        padding: const EdgeInsets.all(12),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          return SizedBox(
            height: 300,
            child: _buildPlanCard(plans[index], index),
          );
        },
      );
    });
  }

  // ------------------------------------------------------
  // CARD UI
  // ------------------------------------------------------
  Widget _buildPlanCard(SubscriptionPlan plan, int index) {
    return Obx(() {
      final bool isSelected = selectedPlanIndex.value == index;

      return GestureDetector(
        onTap: () => selectedPlanIndex.value = index,
        child: Container(
          decoration: BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  isSelected
                      ? ColorRes.primary
                      : ColorRes.leadGreyColor.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(plan),
              _buildPriceSection(plan),
              const SizedBox(height: 8),
              _buildFeaturePreview(plan),
              _buildShowMore(plan, index),
              _buildSelectButton(plan, isSelected, index),
            ],
          ),
        ),
      );
    });
  }

  // ------------------------------------------------------
  // Header
  // ------------------------------------------------------
  Widget _buildHeader(SubscriptionPlan plan) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                plan.name,
                style: TextStyle(
                  fontSize: AppFontSizes.large,
                  fontWeight: AppFontWeights.bold,
                  color: ColorRes.primary,
                ),
              ),
              if (plan.isPremium) ...[
                const SizedBox(width: 4),
                NesticoPeIc(
                  iconPath: "assets/icons/gemini.svg",
                  height: 14,
                  width: 14,
                ),
              ],
              const Spacer(),
              if (plan.isPremium) _buildPopularBadge(plan),
            ],
          ),
        ],
      ),
    );
  }

  // Popular Badge
  Widget _buildPopularBadge(SubscriptionPlan plan) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ColorRes.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Premium',
        style: TextStyle(
          color: Colors.white,
          fontSize: AppFontSizes.extraSmall,
          fontWeight: AppFontWeights.extraBold,
        ),
      ),
    );
  }

  // ------------------------------------------------------
  // Price
  // ------------------------------------------------------
  Widget _buildPriceSection(SubscriptionPlan plan) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                plan.amount,
                style: TextStyle(
                  fontSize: AppFontSizes.heading,
                  fontWeight: AppFontWeights.bold,
                  color: ColorRes.textPrimary,
                ),
              ),
            ],
          ),
          Text(
            "${plan.durationMonths} Month",
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.leadGreyColor[600],
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------
  // Feature preview (first 3)
  // ------------------------------------------------------
  Widget _buildFeaturePreview(SubscriptionPlan plan) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children:
              plan.features.toFeatureList().take(3).map((f) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        f.isIncluded ? Icons.check : Icons.close,
                        size: 20,
                        color: f.isIncluded ? ColorRes.primary : ColorRes.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          f.name,
                          style: TextStyle(
                            fontSize: AppFontSizes.bodySmall,
                            fontWeight: AppFontWeights.medium,

                            color:
                                f.isIncluded
                                    ? ColorRes.textPrimary
                                    : ColorRes.leadGreyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  // ------------------------------------------------------
  // "Show more"
  // ------------------------------------------------------
  Widget _buildShowMore(SubscriptionPlan plan, int index) {
    return GestureDetector(
      onTap: () => Get.bottomSheet(_buildPlanExpanded(plan, index)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          children: [
            Text(
              "Show more",
              style: TextStyle(
                color: ColorRes.primary,
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: ColorRes.primary, size: 16),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------
  // Select Button
  // ------------------------------------------------------
  Widget _buildSelectButton(SubscriptionPlan plan, bool isSelected, int index) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed:
              isSelected
                  ? () async {
                    final controller = Get.find<SubscriptionPlanController>();
                    final success = await controller.buySubscriptionPlan(
                      plan.id,
                    );
                    if (success) {
                      NesticoPeSnackBar.showAwesomeSnackbar(
                        title: 'Success',
                        message: "Plan purchased successfully",
                        contentType: ContentType.success,
                      );
                    }
                  }
                  : () => selectedPlanIndex.value = index,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isSelected ? ColorRes.primary : ColorRes.leadGreyColor.shade100,
            foregroundColor: isSelected ? Colors.white : Colors.black,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            isSelected ? "Buy Now" : "Select Plan",
            style: const TextStyle(
              fontWeight: AppFontWeights.semiBold,
              fontSize: AppFontSizes.bodySmall,
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------
  // Expanded bottom sheet
  // ------------------------------------------------------
  Widget _buildPlanExpanded(SubscriptionPlan plan, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(plan),
            _buildPriceSection(plan),
            const SizedBox(height: 12),

            // Full feature list
            ...plan.features.toFeatureList().map((f) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      f.isIncluded ? Icons.check : Icons.close,
                      size: 20,
                      color: f.isIncluded ? ColorRes.primary : ColorRes.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        f.name,
                        style: TextStyle(
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.medium,

                          color:
                              f.isIncluded
                                  ? ColorRes.textPrimary
                                  : ColorRes.leadGreyColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
