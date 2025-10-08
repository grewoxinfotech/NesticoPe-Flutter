import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import 'package:housing_flutter_app/modules/filter_property/controller/property_filter_controller.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/buy_componet/buy_component.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/buy_componet/buyer_filter.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/commercial_property_filter/commercial_property_filter.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/location_dropdown.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/pg_property/pg_co_living.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/rent_component/rented_filter.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

class RealEstateFilterScreen extends StatefulWidget {
  final Map<String, String> initialFilters;
  final bool showSearchById;
  final bool showStatusFilter;

  const RealEstateFilterScreen({
    super.key,
    this.initialFilters = const {},
    this.showSearchById = false,
    this.showStatusFilter = false,
  });

  @override
  State<RealEstateFilterScreen> createState() => _RealEstateFilterScreenState();
}

class _RealEstateFilterScreenState extends State<RealEstateFilterScreen> {
  late final PropertyFilterControllerForFilter controllerForFilter;

  @override
  void initState() {
    super.initState();
    controllerForFilter = Get.put(PropertyFilterControllerForFilter());
    if (widget.initialFilters.isNotEmpty) {
      controllerForFilter.initializeWithFilters(widget.initialFilters);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: ColorRes.textColor),
          onPressed: () => Get.back(),
        ),
        title: buildCommonText(
          'Filters',
          18,
          FontWeight.w600,
          ColorRes.textColor,
          1,
        ),
        actions: [
          TextButton(
            onPressed: () {
              controllerForFilter.resetAllFilters();
            },
            child: Text(
              'Reset',
              style: TextStyle(
                color: ColorRes.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search by ID
            if (widget.showSearchById)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
                child: buildTextField(
                  'Search by ID',
                  Icons.search,
                  controllerForFilter.searchFilterByID,
                  maxLines: 1,
                  minLines: 1,
                  onTap: () {},
                ),
              ),

            // ),

            // State Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: SearchableDropdownWidget(
                label: 'State',
                hint: 'Select your state',
                items: controllerForFilter.availableStates, // now RxList
                selectedValue: controllerForFilter.selectedState,
                prefixIcon: Icons.location_city,
                onChanged: (value) {
                  if (value != null) controllerForFilter.updateState(value);
                },
              ),
            ),

            // City Dropdown
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: SearchableDropdownWidget(
                  label: 'City',
                  hint:
                      controllerForFilter.selectedState.value.isEmpty
                          ? 'Select state first'
                          : 'Select your city',
                  items: controllerForFilter.availableCities,
                  selectedValue: controllerForFilter.selectedCity,
                  prefixIcon: Icons.location_on,
                  enabled: controllerForFilter.selectedState.value.isNotEmpty,
                  onChanged:
                      controllerForFilter.selectedState.value.isEmpty
                          ? null
                          : (value) {
                            if (value != null)
                              controllerForFilter.updateCity(value);
                          },
                ),
              ),
            ),

            const SizedBox(height: 7),

            if (widget.showStatusFilter) ...[
              buildPropertyFilterHeadingPadding('Property Status'),
              const SizedBox(height: 7),
              FilterPropertyTypesList(
                items: controllerForFilter.statusOfApplicant,
                controllerForFilter: controllerForFilter,
                selectedItems: controllerForFilter.statusApplicateIndex,
                onSelectionChanged: (index) {
                  debugPrint('Status Type property Type $index');
                },
              ),
              const SizedBox(height: 16),
            ],
            buildPropertyFilterHeadingPadding('Verified Status'),
            const SizedBox(height: 7),
            FilterPropertyTypesList(
              items: controllerForFilter.verificationStatus,
              controllerForFilter: controllerForFilter,
              selectedItems: controllerForFilter.verifiedStatusIndex,
              onSelectionChanged: (index) {
                debugPrint('Verified Status $index');
              },
            ),
            const SizedBox(height: 16),
            // Property Type Section
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: buildCommonText(
                'Property Type',
                14,
                FontWeight.w600,
                ColorRes.textColor.withOpacity(0.7),
                1,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Obx(
                () => Row(
                  children: List.generate(
                    controllerForFilter.propertyType.length,
                    (index) {
                      final isSelected =
                          controllerForFilter.selectedPropertyTypeIndex.value ==
                          index;
                      return Padding(
                        padding: EdgeInsets.only(
                          right:
                              index !=
                                      controllerForFilter.propertyType.length -
                                          1
                                  ? 12
                                  : 0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            controllerForFilter.changePropertyType(index);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? ColorRes.primary : Colors.white,
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.transparent
                                        : Colors.grey.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: buildCommonText(
                              controllerForFilter.propertyType[index],
                              12,
                              FontWeight.w600,
                              isSelected ? Colors.white : ColorRes.textColor,
                              1,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Selected filters as chips
            Obx(() {
              final chips = controllerForFilter.getSelectedFilterChips();
              if (chips.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        buildCommonText(
                          'Selected',
                          14,
                          FontWeight.w600,
                          ColorRes.textColor.withOpacity(0.7),
                          1,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: controllerForFilter.resetAllFilters,
                          child: Text(
                            'Clear all',
                            style: TextStyle(
                              color: ColorRes.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final chip in chips)
                          Chip(
                            label: Text(chip['label'] ?? ''),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              final key = chip['key'];
                              if (key != null) {
                                controllerForFilter.clearFilterByKey(key);
                              }
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),

            // Dynamic Filter Content
            Obx(() {
              if (controllerForFilter.propertyType[controllerForFilter
                      .selectedPropertyTypeIndex
                      .value] ==
                  "Sell") {
                return BuyFilters(controllerForFilter: controllerForFilter);
              } else if (controllerForFilter.propertyType[controllerForFilter
                      .selectedPropertyTypeIndex
                      .value] ==
                  "Rent") {
                return RentFilter(controllerForFilter: controllerForFilter);
              } else if (controllerForFilter.propertyType[controllerForFilter
                      .selectedPropertyTypeIndex
                      .value] ==
                  "Commercial") {
                return CommercialPropertyFilter(
                  controller: controllerForFilter,
                );
              } else if (controllerForFilter.propertyType[controllerForFilter
                      .selectedPropertyTypeIndex
                      .value] ==
                  "PG/Co-living") {
                return PgCoLiving(controllerForFilter: controllerForFilter);
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 100),
          ],
        ),
      ),

      // Fixed Bottom Button
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Results count
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildCommonText(
                        '1,234 Properties',
                        12,
                        FontWeight.w500,
                        ColorRes.textColor.withOpacity(0.6),
                        1,
                      ),
                      const SizedBox(height: 2),
                      buildCommonText(
                        'Available',
                        10,
                        FontWeight.w400,
                        ColorRes.textColor.withOpacity(0.5),
                        1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Apply Button
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorRes.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final filters = controllerForFilter.getAllFilters();
                      final stringFilters = convertFiltersToString(filters);
                      Get.back(result: stringFilters);
                      // debugPrint(
                      //   '================= Current Filters =================',
                      // );
                      // filters.forEach((key, value) {
                      //   debugPrint('$key : $value');
                      // });
                      // debugPrint(
                      //   '===================================================',
                      // );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildCommonText(
                          'Apply Filters',
                          16,
                          FontWeight.w600,
                          Colors.white,
                          1,
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, String> convertFiltersToString(Map<String, dynamic> filters) {
    final Map<String, String> result = {};

    filters.forEach((key, value) {
      if (value == null) return;

      // 🔁 Rename rentRangeValues → priceRange for backend compatibility
      String mappedKey = key == 'rentRangeValues' ? 'priceRange' : key;

      if (value is Map || value is List) {
        if (value.isEmpty) return;
        // ✅ Proper JSON encoding instead of toString()
        result[mappedKey] = jsonEncode(value);
      } else {
        // ✅ Skip empty strings or invalid values
        if (value.toString().trim().isEmpty) return;
        result[mappedKey] = value.toString();
      }
    });

    return result;
  }
}
