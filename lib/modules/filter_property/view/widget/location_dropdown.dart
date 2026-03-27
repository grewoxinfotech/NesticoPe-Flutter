import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/search_property/view/search_screen.dart';

import '../../../../app/constants/app_font_sizes.dart';

/// Reusable Searchable Dropdown Widget
class SearchableDropdownWidget extends StatelessWidget {
  final String label;
  final String hint;
  final List<String> items;
  final RxString selectedValue;
  final ValueChanged<String?>? onChanged;
  final IconData prefixIcon;
  final bool enabled;

  const SearchableDropdownWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.prefixIcon = Icons.location_on,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        buildCommonText(
          label,
          AppFontSizes.medium,
          AppFontWeights.semiBold,
          ColorRes.textColor.withOpacity(0.7),
          1,
        ),
        const SizedBox(height: 8),

        // Dropdown Button
        Obx(
          () => InkWell(
            onTap:
                enabled && onChanged != null
                    ? () => _showBottomSheet(context)
                    : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: ColorRes.white,
                border: Border.all(
                  color: enabled ? ColorRes.leadGreyColor.shade300 : ColorRes.leadGreyColor.shade200,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    prefixIcon,
                    color:
                        selectedValue.value.isNotEmpty
                            ? ColorRes.primary
                            : ColorRes.leadGreyColor.shade400,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildCommonText(
                      selectedValue.value.isEmpty ? hint : selectedValue.value,
                      AppFontSizes.bodyMedium,
                      AppFontWeights.medium,
                      selectedValue.value.isEmpty
                          ? ColorRes.leadGreyColor.shade400
                          : ColorRes.textColor,
                      1,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: ColorRes.leadGreyColor.shade600,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Selected Indicator
        // Obx(
        //       () => selectedValue.value.isNotEmpty
        //       ? Padding(
        //     padding: const EdgeInsets.only(top: 8, left: 4),
        //     child: Row(
        //       children: [
        //         Icon(
        //           Icons.check_circle,
        //           size: 14,
        //           color: ColorRes.primary,
        //         ),
        //         const SizedBox(width: 4),
        //         buildCommonText(
        //           'Selected: ${selectedValue.value}',
        //           12,
        //           AppFontWeights.medium,
        //           ColorRes.primary,
        //           1,
        //         ),
        //       ],
        //     ),
        //   )
        //       : const SizedBox.shrink(),
        // ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    final searchController = TextEditingController();
    final filteredItems = <String>[].obs;
    filteredItems.value = items;

    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: const BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ColorRes.leadGreyColor.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: buildCommonText(
                      'Select $label',
                      AppFontSizes.large,
                      AppFontWeights.semiBold,
                      ColorRes.textColor,
                      1,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                controller: searchController,

                onChanged: (query) {
                  if (query.isEmpty) {
                    filteredItems.value = items;
                  } else {
                    filteredItems.value =
                        items
                            .where(
                              (item) => item.toLowerCase().contains(
                                query.toLowerCase(),
                              ),
                            )
                            .toList();
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search ${label.toLowerCase()}...',
                  hintStyle: TextStyle(
                    color: ColorRes.leadGreyColor.shade400,
                    fontSize:AppFontSizes.medium,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: ColorRes.leadGreyColor.shade400,
                    size: 20,
                  ),
                  suffixIcon:
                      searchController.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: ColorRes.leadGreyColor.shade400,
                              size: 20,
                            ),
                            onPressed: () {
                              searchController.clear();
                              filteredItems.value = items;
                            },
                          )
                          : null,
                  filled: true,
                  fillColor: ColorRes.leadGreyColor.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorRes.leadGreyColor.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorRes.leadGreyColor.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorRes.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            // Results count
            Obx(
              () =>
                  filteredItems.isNotEmpty
                      ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: buildCommonText(
                            '${filteredItems.length} ${filteredItems.length == 1 ? 'result' : 'results'} found',
                            AppFontSizes.small,
                            AppFontWeights.medium,
                            ColorRes.leadGreyColor.shade600,
                            1,
                          ),
                        ),
                      )
                      : const SizedBox.shrink(),
            ),

            Divider(height: 0.5, color: ColorRes.leadGreyColor.shade200),

            // List of items
            Expanded(
              child: Obx(
                () =>
                    filteredItems.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            final isSelected = selectedValue.value == item;

                            return InkWell(
                              onTap: () {
                                if (onChanged != null) {
                                  onChanged!(item);
                                }
                                Get.back();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? ColorRes.primary.withOpacity(0.05)
                                          : ColorRes.transparentColor,
                                ),
                                child: Row(
                                  children: [
                                    if (isSelected)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: ColorRes.primary,
                                          size: 20,
                                        ),
                                      ),
                                    Expanded(
                                      child: buildCommonText(
                                        item,
                                        AppFontSizes.bodyMedium,
                                        isSelected
                                            ? AppFontWeights.semiBold
                                            : AppFontWeights.regular,
                                        isSelected
                                            ? ColorRes.primary
                                            : ColorRes.textColor,
                                        1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: ColorRes.leadGreyColor.shade300),
          const SizedBox(height: 16),
          buildCommonText(
            'No results found',
            AppFontSizes.body,
            AppFontWeights.semiBold,
            ColorRes.leadGreyColor.shade400,
            1,
          ),
          const SizedBox(height: 8),
          buildCommonText(
            'Try a different search term',
            AppFontSizes.medium,
            AppFontWeights.regular,
            ColorRes.leadGreyColor.shade400,
            1,
          ),
        ],
      ),
    );
  }
}
