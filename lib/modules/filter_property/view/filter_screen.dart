import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import 'package:housing_flutter_app/modules/filter_property/controller/property_filter_controller.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/buy_componet/buy_component.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/buy_componet/buyer_filter.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/commercial_property_filter/commercial_property_filter.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/common_component/listed_by.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/common_component/sale_type.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/location_dropdown.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/pg_property/pg_co_living.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/rent_component/rented_filter.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/manager/icon_manager.dart';
import '../../../app/utils/svg_widget.dart';
import '../../builder/view/additional_deatil/additional_detail.dart';
import '../../contractor/view/widget/cotractor_active_switch.dart';

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
  String saleType = "New Properties";

  @override
  void initState() {
    super.initState();
    controllerForFilter = Get.put(PropertyFilterControllerForFilter());
    if (widget.initialFilters.isNotEmpty) {
      // Initialize filters after widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await controllerForFilter.initializeWithFilters(widget.initialFilters);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorRes.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: ColorRes.textColor),
          onPressed: () => Get.back(),
        ),
        title: buildCommonText(
          'Filters',
          AppFontSizes.large,
          AppFontWeights.semiBold,
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
                fontSize: AppFontSizes.medium,
                fontWeight: AppFontWeights.semiBold,
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
                          AppFontSizes.medium,
                          AppFontWeights.semiBold,
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
                              fontWeight: AppFontWeights.semiBold,
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),

              decoration: BoxDecoration(
                  color: ColorRes.white,
                  borderRadius: BorderRadius.circular(12)
              ),
              child: Column(
                children: [
                  buildToggle(
                    "Verify RERA ID",
                    controllerForFilter.isRERAVerified,
                  ),
                  SizedBox(height: 10,),
                  buildToggle(
                    "Property Has Photos",
                    controllerForFilter.isPropertyHaveImage,
                  ),
                  SizedBox(height: 10,),
                  buildToggle(
                    "Property Has Videos",
                    controllerForFilter.isPropertyHaveVideo,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            buildPropertyFilterHeadingPadding("Transaction Type"),
            const SizedBox(height: 7),

            SelectableWrap(
              items: controllerForFilter.purchaseTypeCommercialProperty,
              filterControllerForFilter: controllerForFilter,
              selectedItem: controllerForFilter.selectedPurchaseType,
              onSelected: (type) {
                debugPrint('Purchase Type Commercial $type');

                setState(() {
                  saleType = type;
                });
              },
            ),

            buildPropertyFilterHeadingPadding('Amenities'),

            // // Property Type & Status Card
            // _buildCard(
            //   theme: theme,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       buildBuilderDefaultText('Property Type'),
            //       const SizedBox(height: 16),
            //       builderPropertyType(controller),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 20),

            // Amenities Card
            // ------------------ AMENITIES SECTION ------------------

            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 12),
              child: _buildCard(
                theme: theme,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    Obx(() {
                      final amenitiesList = IconManager.amenitiesItems;
                      final showAll = controllerForFilter.showAllAmenities.value;
                      final displayList = showAll
                          ? amenitiesList
                          : amenitiesList.take(9).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Amenities Grid
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: displayList.map((amenity) {
                              final isSelected = controllerForFilter.amenities.contains(amenity.title);

                              return GestureDetector(
                                onTap: () {
                                  controllerForFilter.addBuilderAmenities(amenity.title);
                                  debugPrint("Selected Amenities: ${controllerForFilter.amenities}");
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.28,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.primaryColor.withOpacity(0.1)
                                        : ColorRes.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? theme.primaryColor
                                          : ColorRes.leadGreyColor.shade300,
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.08),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // If you have SVG icons for amenities, uncomment:
                                      // AppSvgIcon(
                                      //   assetName: amenity.key,
                                      //   size: 26,
                                      //   folder: 'amenities',
                                      //   color: isSelected
                                      //       ? theme.primaryColor
                                      //       : ColorRes.leadGreyColor.shade600,
                                      // ),
                                      // const SizedBox(height: 4),
                                      Text(
                                        amenity.title,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: isSelected
                                              ? theme.primaryColor
                                              : ColorRes.textColor.withOpacity(0.9),
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          fontSize: AppFontSizes.extraSmall,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          // Show More / Less toggle
                          if (amenitiesList.length > 9)
                            Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Center(
                                child: GestureDetector(
                                  onTap: controllerForFilter.toggleAmenitiesView,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        showAll ? 'Show Less' : 'Show More',
                                        style: TextStyle(
                                          color: theme.primaryColor,
                                          fontSize: AppFontSizes.small,
                                          fontWeight: AppFontWeights.semiBold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        showAll
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: theme.primaryColor,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Property Type Section
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: buildCommonText(
                'Property Type',
                AppFontSizes.medium,
                AppFontWeights.semiBold,
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
                                  isSelected ? ColorRes.primary : ColorRes.white,
                              border: Border.all(
                                color:
                                    isSelected
                                        ? ColorRes.transparentColor
                                        : ColorRes.leadGreyColor.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: buildCommonText(
                              controllerForFilter.propertyType[index],
                              AppFontSizes.small,
                              AppFontWeights.semiBold,
                              isSelected ? ColorRes.white : ColorRes.textColor,
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
            const SizedBox(height: 7),
            buildPropertyFilterHeadingPadding('Construction Status'),
            const SizedBox(height: 7),
            ListedBy(
              listedByList: controllerForFilter.constructionStatus,
              selectedString: controllerForFilter.constructionStatusInBuy,
              onTap: (index) {
                debugPrint('Construction Status $index');
              },
              controllerForFilter:controllerForFilter,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),

      // Fixed Bottom Button
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: ColorRes.white,
          boxShadow: [
            BoxShadow(
              color: ColorRes.black.withOpacity(0.08),
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
                        AppFontSizes.small,
                        AppFontWeights.medium,
                        ColorRes.textColor.withOpacity(0.6),
                        1,
                      ),
                      const SizedBox(height: 2),
                      buildCommonText(
                        'Available',
                        AppFontSizes.extraSmall,
                        AppFontWeights.regular,
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
                      foregroundColor: ColorRes.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final filters = controllerForFilter.getAllFilters();
                      final stringFilters = convertFiltersToString(filters);
                      log("Change the filter ${stringFilters}");
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
                          AppFontSizes.body,
                          AppFontWeights.semiBold,
                          ColorRes.white,
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
Widget buildToggle(String label, RxBool observable) {
  return Obx(
        () => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppFontSizes.bodySmall,
            fontWeight: AppFontWeights.medium,
            color: ColorRes.textColor,
          ),
        ),
        CustomSwitch(
          value: observable.value,
          activeColor: ColorRes.primary,

          inactiveColor: ColorRes.leadGreyColor.shade400,
          onChanged: (val) {
            // Call controller toggle
            observable.value = val;
          },
        )
        // Switch(
        //   value: observable.value,
        //   onChanged: (val) => observable.value = val,
        //   activeColor: ColorRes.primary,
        // ),
      ],
    ),
  );
}
Widget _buildCard({required ThemeData theme, required Widget child}) {
  return child;
}

