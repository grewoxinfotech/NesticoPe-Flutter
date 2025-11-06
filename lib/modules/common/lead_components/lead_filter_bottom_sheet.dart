import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';

/// Reusable Lead Filter Bottom Sheet
class LeadFilterBottomSheet {
  static void show({
    required BuildContext context,
    required RxList<String> selectedFilters,
    required Function() onApplyFilters,
  }) {
    final RxList<String> tempSelectedFilters =
        <String>[...selectedFilters].obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorRes.transparentColor,
      builder: (context) => StatefulBuilder(
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
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                tempSelectedFilters.clear();
                              });
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
                    ],
                  ),
                ),

                Divider(height: 1, color: ColorRes.leadGreyColor[300]),

                // Filter content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stage Section
                        _buildFilterSection(
                          context: context,
                          title: 'Stage',
                          icon: Icons.stairs,
                          filterType: 'Stage',
                          options: [
                            'New Lead',
                            'Contacted',
                            'Interested',
                            'Site Visit',
                            'Sell',
                          ],
                          tempSelectedFilters: tempSelectedFilters,
                          setState: setState,
                        ),

                        const SizedBox(height: 24),

                        // Status Section
                        _buildFilterSection(
                          context: context,
                          title: 'Status',
                          icon: Icons.flag,
                          filterType: 'Status',
                          options: [
                            'New',
                            'Contacted',
                            'Qualified',
                            'Negotiating',
                            'Lost',
                            'Converted',
                          ],
                          tempSelectedFilters: tempSelectedFilters,
                          setState: setState,
                        ),
                      ],
                    ),
                  ),
                ),

                // Apply button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        selectedFilters.clear();
                        selectedFilters.addAll(tempSelectedFilters);
                        onApplyFilters();
                        Navigator.pop(context);
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
                      child: Obx(
                        () => Text(
                          'Apply Filters (${tempSelectedFilters.length})',
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

  static Widget _buildFilterSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String filterType,
    required List<String> options,
    required RxList<String> tempSelectedFilters,
    required StateSetter setState,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorRes.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: ColorRes.primary),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Filter chips
        Wrap(
          spacing: 8,
          runSpacing: -4,
          children: options.map((option) {
            return Obx(() {
              final fullFilterKey = '$filterType:$option';
              final isSelected = tempSelectedFilters.any(
                (e) => e.startsWith('$filterType:') && e == fullFilterKey,
              );

              return FilterChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (selected) {
                  tempSelectedFilters.removeWhere(
                    (e) => e.startsWith('$filterType:'),
                  );
                  if (selected) {
                    tempSelectedFilters.add(fullFilterKey);
                  }
                  setState(() {});
                },
                selectedColor: ColorRes.primary.withOpacity(0.15),
                checkmarkColor: ColorRes.primary,
                backgroundColor: ColorRes.leadGreyColor[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? ColorRes.primary
                        : ColorRes.leadGreyColor[300]!,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                labelStyle: TextStyle(
                  color: isSelected ? ColorRes.primary : ColorRes.blackShade87,
                  fontWeight: isSelected
                      ? AppFontWeights.semiBold
                      : AppFontWeights.regular,
                  fontSize: AppFontSizes.small,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              );
            });
          }).toList(),
        ),
      ],
    );
  }
}
