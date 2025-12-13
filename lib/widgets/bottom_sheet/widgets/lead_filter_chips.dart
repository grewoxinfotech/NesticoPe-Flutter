import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../../modules/common/lead_components/lead_helpers.dart';
import '../../../modules/seller/module/lead_screen/controllers/lead_controller.dart';

Widget buildSelectedFiltersChips(
  BuildContext context,
  LeadController controller,
  Function() onClearAll, {
  String? propertyId,
}) {
  return Obx(() {
    final filters = controller.filters;

    if (filters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getResponsivePadding(context),
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Active Filters:',
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.leadGreyColor[700],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onClearAll,
                icon: const Icon(
                  Icons.clear,
                  size: 16,
                  color: ColorRes.primary,
                ),
                label: Text(
                  'Clear All',
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    color: ColorRes.primary,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  filters.entries.map((entry) {
                    final filterType = entry.key; // e.g. "status"
                    final filterValue = entry.value; // e.g. "contacted"

                    final chipColor =
                        (filterType.toLowerCase() == 'stage')
                            ? ColorRes.primary
                            : (filterType.toLowerCase() == 'status')
                            ? ColorRes.green
                            : ColorRes.blueGrey;

                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: ColorRes.success.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: ColorRes.success.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Filter Type Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: chipColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                filterType
                                        .replaceAll("_", " ")
                                        .capitalize
                                        .toString() ??
                                    '',
                                style: TextStyle(
                                  fontSize: AppFontSizes.extraSmall,
                                  color: ColorRes.white,
                                  fontWeight: AppFontWeights.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),

                            // Filter Value
                            Text(
                              filterValue
                                      .replaceAll("_", " ")
                                      .capitalizeFirst ??
                                  '',
                              style: TextStyle(
                                fontSize: AppFontSizes.small,
                                color: chipColor,
                                fontWeight: AppFontWeights.semiBold,
                              ),
                            ),
                            const SizedBox(width: 6),

                            // Remove Button
                            InkWell(
                              onTap: () async {
                                final updatedFilters = Map<String, String>.from(
                                  controller.filters,
                                );
                                updatedFilters.remove(filterType);
                                if (propertyId != null) {
                                  await controller.applyFilters(
                                    updatedFilters,
                                    propertyId: propertyId,
                                  );
                                } else {
                                  await controller.applyFilters(updatedFilters);
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: const Padding(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: ColorRes.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  });
}
