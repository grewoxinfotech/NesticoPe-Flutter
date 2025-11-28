import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../button/button.dart';

class ReusableBottomBar extends StatelessWidget {
  final String mainPriceText;
  final Map<String, String>? priceBreakdown; // for detail sheet
  final VoidCallback onPrimaryAction;
  final String primaryTitle;
  final bool showDetailsSheet;

  const ReusableBottomBar({
    super.key,
    required this.mainPriceText,
    required this.onPrimaryAction,
    required this.primaryTitle,
    this.priceBreakdown,
    this.showDetailsSheet = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        color: ColorRes.white,
        boxShadow: [
          BoxShadow(
            color: ColorRes.blackShade12,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Price & Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                mainPriceText,
                style: const TextStyle(
                  fontSize: AppFontSizes.large,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),

              if (showDetailsSheet &&
                  priceBreakdown != null &&
                  priceBreakdown!.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      PricingDetailsSheet(priceBreakdown: priceBreakdown!),
                    );
                  },
                  child: const Text(
                    "See Pricing in Detail",
                    style: TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      color: ColorRes.primary,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),
                ),
            ],
          ),

          // Right side: Button
          SizedBox(
            width: 140,
            child: NesticoPeButton(onTap: onPrimaryAction, title: primaryTitle),
          ),
        ],
      ),
    );
  }
}

class PricingDetailsSheet extends StatelessWidget {
  final Map<String, String> priceBreakdown;

  const PricingDetailsSheet({super.key, required this.priceBreakdown});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: ColorRes.leadGreyColor.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const Text(
              "Pricing Details",
              style: TextStyle(
                fontSize: AppFontSizes.subtitle,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            ...priceBreakdown.entries.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.key,
                      style: TextStyle(
                        fontSize: AppFontSizes.medium,
                        color: ColorRes.leadGreyColor.shade700,
                      ),
                    ),
                    Text(
                      e.value,
                      style: const TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
