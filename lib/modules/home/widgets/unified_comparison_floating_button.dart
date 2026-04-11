/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/manager/compare_manager.dart';
import 'package:nesticope_app/app/manager/project_compare_manager.dart';
import 'package:nesticope_app/modules/home/controllers/contractor_profile_controller/contractor_compare_manager.dart';
import 'package:nesticope_app/modules/home/views/compare_screen/comapre_screen.dart';
import 'package:nesticope_app/modules/home/views/compare_screen/project_compare_screen.dart';
import 'package:nesticope_app/widgets/bar/navigation_bar/navigation_Bar.dart';

/// Unified floating button that handles both property and project comparison
/// Automatically switches context based on what user selects
/// Usage: Add this as a Positioned widget in a Stack
class UnifiedComparisonFloatingButton extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double left;
  final double right;

  const UnifiedComparisonFloatingButton({
    Key? key,
    this.top,
    this.bottom = 16,
    this.left = 16,
    this.right = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final propertyCompare = Get.find<CompareManager>();
    final projectCompare = Get.find<ProjectCompareManager>();
    final contractorCompare=Get.find<ContractorCompareManager>();

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Obx(() {
        // Determine which comparison is active
        final propertyCount = propertyCompare.count;
        final projectCount = projectCompare.count;
        final contractorCount=contractorCompare.count;

        // If nothing is selected, hide the button
        if (propertyCount == 0 && projectCount == 0 && contractorCount==0) {
          return const SizedBox();
        }

        // Determine active comparison type
        final isPropertyComparison = propertyCount > 0;
        final activeCount = isPropertyComparison ? propertyCount : projectCount;
        final canCompare = activeCount >= 2;
        final itemType = isPropertyComparison ? 'property' : 'project';
        final itemTypePlural = isPropertyComparison ? 'properties' : 'projects';

        return Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () {
              if (canCompare) {
                if (Get.isRegistered<NavigationController>()) {
                  print('Navigating to ${isPropertyComparison ? "Property" : "Project"} Compare Screen');
                  try {
                    if (isPropertyComparison) {
                      Get.to(() => const CompareScreen());
                    } else {
                      Get.to(() => const ProjectCompareScreen());
                    }
                  } catch (e) {
                    print('Error navigating to comparison: $e');
                  }
                }
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: canCompare
                      ? [
                    ColorRes.primary,
                    ColorRes.primary.withOpacity(0.8)
                  ]
                      : [
                    ColorRes.grey.withOpacity(0.6),
                    ColorRes.grey.withOpacity(0.4)
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isPropertyComparison
                              ? Icons.home_outlined
                              : Icons.apartment_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            canCompare
                                ? 'Ready to Compare!'
                                : 'Add ${2 - activeCount} more $itemType',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSizes.caption,
                              fontWeight: AppFontWeights.semiBold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$activeCount/2 $itemTypePlural selected',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: AppFontSizes.extraSmall,
                              fontWeight: AppFontWeights.regular,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (canCompare)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Compare',
                            style: TextStyle(
                              color: ColorRes.primary,
                              fontSize: AppFontSizes.extraSmall,
                              fontWeight: AppFontWeights.semiBold,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          // Clear the active comparison
                          if (isPropertyComparison) {
                            propertyCompare.clear();
                          } else {
                            projectCompare.clear();
                          }
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: ColorRes.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/manager/compare_manager.dart';
import 'package:nesticope_app/app/manager/project_compare_manager.dart';
import 'package:nesticope_app/modules/home/controllers/contractor_profile_controller/contractor_compare_manager.dart';
import 'package:nesticope_app/modules/home/views/compare_screen/comapre_screen.dart';
import 'package:nesticope_app/modules/home/views/compare_screen/project_compare_screen.dart';
// import 'package:nesticope_app/modules/home/views/compare_screen/contractor_compare_screen.dart';
import 'package:nesticope_app/widgets/bar/navigation_bar/navigation_Bar.dart';

import 'contractor_comparison_screen.dart';

class UnifiedComparisonFloatingButton extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double left;
  final double right;

  const UnifiedComparisonFloatingButton({
    Key? key,
    this.top,
    this.bottom = 16,
    this.left = 16,
    this.right = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final propertyCompare = Get.find<CompareManager>();
    final projectCompare = Get.find<ProjectCompareManager>();
    final contractorCompare = Get.find<ContractorCompareManager>();

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Obx(() {
        final propertyCount = propertyCompare.count;
        final projectCount = projectCompare.count;
        final contractorCount = contractorCompare.count;

        // Hide if nothing selected
        if (propertyCount == 0 && projectCount == 0 && contractorCount == 0) {
          return const SizedBox();
        }

        // Detect active comparison type
        final isPropertyComparison = propertyCount > 0;
        final isProjectComparison = projectCount > 0;
        final isContractorComparison = contractorCount > 0;

        // Decide which one is active
        int activeCount = 0;
        String itemType = '';
        String itemTypePlural = '';
        IconData icon = Icons.home_outlined;
        int totalAllowed = 2;

        if (isPropertyComparison) {
          activeCount = propertyCount;
          itemType = 'property';
          itemTypePlural = 'properties';
          icon = Icons.home_outlined;
          totalAllowed = 5;
        } else if (isProjectComparison) {
          activeCount = projectCount;
          itemType = 'project';
          itemTypePlural = 'projects';
          icon = Icons.apartment_outlined;
          totalAllowed = 5;
        } else if (isContractorComparison) {
          activeCount = contractorCount;
          itemType = 'contractor';
          itemTypePlural = 'contractors';
          icon = Icons.engineering_outlined;
          totalAllowed = 5;
        }

        final int minRequired = 2;
        final canCompare = activeCount >= minRequired;

        return Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () {
              if (!canCompare) return;

              if (Get.isRegistered<NavigationController>()) {
                try {
                  if (isPropertyComparison) {
                    Get.to(() => const CompareScreen());
                  } else if (isProjectComparison) {
                    Get.to(() => const ProjectCompareScreen());
                  } else if (isContractorComparison) {
                    Get.to(() => const ContractorComparisonScreen());
                  }
                } catch (e) {
                  print('Error navigating to comparison: $e');
                }
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors:
                      canCompare
                          ? [
                            const Color.fromARGB(255, 66, 81, 212),
                            ColorRes.primary.withOpacity(0.8),
                          ]
                          : [
                            const Color.fromARGB(255, 56, 162, 248),
                            const Color.fromARGB(
                              255,
                              33,
                              89,
                              243,
                            ).withOpacity(0.8),
                          ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Left section — icon + text
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(icon, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              canCompare
                                  ? 'Ready to Compare!'
                                  : 'Add ${(minRequired - activeCount).clamp(0, minRequired)} more $itemType',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: AppFontSizes.caption,
                                fontWeight: AppFontWeights.semiBold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$activeCount/$totalAllowed $itemTypePlural selected',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: AppFontSizes.extraSmall,
                                fontWeight: AppFontWeights.regular,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// Right section — compare + cancel
                  Row(
                    children: [
                      if (canCompare)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Compare',
                            style: TextStyle(
                              color: ColorRes.primary,
                              fontSize: AppFontSizes.extraSmall,
                              fontWeight: AppFontWeights.semiBold,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          // Clear based on active type
                          if (isPropertyComparison) {
                            propertyCompare.clear();
                          } else if (isProjectComparison) {
                            projectCompare.clear();
                          } else if (isContractorComparison) {
                            contractorCompare.clear();
                          }
                        },
                        child: const Icon(Icons.cancel, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
