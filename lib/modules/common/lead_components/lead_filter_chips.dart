import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'lead_helpers.dart';

/// Reusable Lead Filter Chips Widget
class LeadFilterChips extends StatelessWidget {
  final List<String> selectedFilters;
  final Function(String) onRemoveFilter;
  final VoidCallback onClearAll;

  const LeadFilterChips({
    Key? key,
    required this.selectedFilters,
    required this.onRemoveFilter,
    required this.onClearAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedFilters.isEmpty) {
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
              TextButton(
                onPressed: onClearAll,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Clear All',
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    color: ColorRes.primary,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children:
                  selectedFilters.map((filter) {
                    final parts = filter.split(':');
                    final filterType = parts[0];
                    final filterValue = parts[1];
                    final chipColor =
                        filterType == 'Stage'
                            ? ColorRes.primary
                            : ColorRes.green;

                    return Container(
                      decoration: BoxDecoration(
                        color: chipColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: chipColor.withOpacity(0.3),
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
                                    .toString(),
                                style: TextStyle(
                                  fontSize: AppFontSizes.extraSmall,
                                  color: ColorRes.white,
                                  fontWeight: AppFontWeights.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              filterValue,
                              style: TextStyle(
                                fontSize: AppFontSizes.small,
                                color: chipColor,
                                fontWeight: AppFontWeights.semiBold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () => onRemoveFilter(filter),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: chipColor,
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
  }
}
