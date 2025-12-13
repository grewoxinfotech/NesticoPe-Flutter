import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/constants/app_font_sizes.dart';
import '../../app/constants/color_res.dart';
import '../../modules/seller/module/lead_screen/controllers/lead_controller.dart';

void showFilterBottomSheet(
  BuildContext context,
  LeadController controller, {
  String? propertyId,
}) {
  // Temporary copy of current filters
  final RxMap<String, String> tempFilters =
      Map<String, String>.from(controller.filters).obs;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: ColorRes.transparentColor,
    builder:
        (context) => StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorRes.leadGreyColor[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter Leads',
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: AppFontWeights.semiBold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            tempFilters.clear();
                            controller.resetFilters();
                            setState(() {});
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: ColorRes.error[400],
                          ),
                          child: Text(
                            'Clear All',
                            style: TextStyle(
                              fontWeight: AppFontWeights.medium,
                              fontSize: AppFontSizes.small,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1, color: ColorRes.leadGreyColor[300]),

                  // Filter Sections
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stage Section
                          buildFilterSection(
                            context: context,
                            title: 'Stage',
                            icon: Icons.stairs,
                            filterType: 'stage',
                            options:
                                controller.stageList
                                    .map(
                                      (s) =>
                                          s
                                              .replaceAll('_', ' ')
                                              .capitalizeFirst ??
                                          s,
                                    )
                                    .toList(),
                            tempFilters: tempFilters,
                            setState: setState,
                          ),

                          const SizedBox(height: 24),

                          // Status Section
                          buildFilterSection(
                            context: context,
                            title: 'Status',
                            icon: Icons.flag,
                            filterType: 'status',
                            options:
                                controller.statusList
                                    .map(
                                      (s) =>
                                          s
                                              .replaceAll('_', ' ')
                                              .capitalizeFirst ??
                                          s,
                                    )
                                    .toList(),
                            tempFilters: tempFilters,
                            setState: setState,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Apply Button
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: () async {
                            // Apply selected filters
                            if (propertyId != null) {
                              await controller.applyFilters(
                                Map<String, String>.from(tempFilters),
                                propertyId: propertyId,
                              );
                            } else {
                              await controller.applyFilters(
                                Map<String, String>.from(tempFilters),
                              );
                            }

                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRes.primary,
                            foregroundColor: ColorRes.white,
                            padding: const EdgeInsets.all(16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(
                            'Apply Filters (${tempFilters.length})',
                            style: TextStyle(
                              fontSize: AppFontSizes.body,
                              fontWeight: AppFontWeights.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
  );
}

Widget buildFilterSection({
  required BuildContext context,
  required String title,
  required IconData icon,
  required String filterType,
  required List<String> options,
  required RxMap<String, String> tempFilters,
  required void Function(void Function()) setState,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 18, color: ColorRes.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.leadGreyColor[800],
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            options.map((option) {
              final isSelected =
                  tempFilters[filterType] ==
                  option.toLowerCase().replaceAll(" ", "_");
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      tempFilters.remove(filterType);
                    } else {
                      tempFilters[filterType] = option.toLowerCase().replaceAll(
                        " ",
                        "_",
                      );
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? ColorRes.primary.withOpacity(0.1)
                            : ColorRes.white,
                    border: Border.all(
                      color:
                          isSelected
                              ? ColorRes.primary
                              : ColorRes.leadGreyColor[300]!,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      color:
                          isSelected
                              ? ColorRes.primary
                              : ColorRes.leadGreyColor[700],
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    ],
  );
}
