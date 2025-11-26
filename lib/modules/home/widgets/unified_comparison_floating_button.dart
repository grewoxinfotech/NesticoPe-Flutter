import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/manager/compare_manager.dart';
import 'package:housing_flutter_app/app/manager/project_compare_manager.dart';
import 'package:housing_flutter_app/modules/home/views/compare_screen/comapre_screen.dart';
import 'package:housing_flutter_app/modules/home/views/compare_screen/project_compare_screen.dart';
import 'package:housing_flutter_app/widgets/bar/navigation_bar/navigation_Bar.dart';

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

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Obx(() {
        // Determine which comparison is active
        final propertyCount = propertyCompare.count;
        final projectCount = projectCompare.count;

        // If nothing is selected, hide the button
        if (propertyCount == 0 && projectCount == 0) {
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
