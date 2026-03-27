import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/add_property/view/create_property.dart';
import 'package:nesticope_app/modules/builder/controller/project_filter_controller.dart';
import 'package:nesticope_app/modules/filter_property/controller/city_insigths_controller.dart';
import 'package:nesticope_app/modules/reseller/view/lead_overview/widget/lead_follow_up_screen.dart';
import 'package:nesticope_app/widgets/New%20folder/inputs/dropdown_field.dart';
import 'package:nesticope_app/widgets/New%20folder/inputs/text_field.dart';
import '../../../../app/manager/icon_manager.dart';
import '../../../../app/utils/formater/formater.dart';
import '../../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../../data/database/secure_storage_service.dart';
import '../../../../widgets/messages/snack_bar.dart';
import '../../../filter_property/controller/property_filter_controller.dart';
import '../../../filter_property/view/filter_screen.dart';
import '../../../filter_property/view/widget/buy_componet/buy_component.dart';
import '../../../filter_property/view/widget/common_component/bhk_list.dart';
import '../../../filter_property/view/widget/common_component/budget_filter.dart';
import '../../../filter_property/view/widget/location_dropdown.dart';
import '../../../property/controllers/property_controller.dart';
import '../../../reseller/controller/dashborad_controller/dashboard_controller.dart';
import '../../../reseller/controller/project/reseller_project_controller.dart';
import '../../../reseller/view/lead/lead_screen_backup.dart';
import '../../../search_property/model/search_model.dart';
import '../../../search_property/view/search_screen.dart';
import '../../controller/builder_form_controller.dart';

class ProjectFilterScreen extends StatelessWidget {
  final Function(Map<String, String>) onApply;
  final Map<String, dynamic>? initialFilters;

  const ProjectFilterScreen({
    super.key,
    required this.onApply,
    this.initialFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.put(ProjectFilterController());

    // 🔥 SET INITIAL FILTER VALUES
    if (initialFilters != null) {
      if (initialFilters!["propertyTypes"] != null &&
          initialFilters!["propertyTypes"].toString().isNotEmpty) {
        controller.selectedPropertyType.value =
            initialFilters!["propertyTypes"];
      }
      if (initialFilters!["city"] != null &&
          initialFilters!["city"].toString().isNotEmpty) {
        controller.selectedCity.value = initialFilters!["city"];
      }
      if (initialFilters!["location"] != null &&
          initialFilters!["location"].toString().isNotEmpty) {
        controller.selectedLocality.value = initialFilters!["location"];
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Filters"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final chips = <Widget>[];

                void addChip(String label, VoidCallback onRemove) {
                  chips.add(
                    Chip(
                      label: Text(label),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: onRemove,
                      // backgroundColor: ColorRes.primary.withOpacity(0.08),
                      // labelStyle: TextStyle(
                      //   color: ColorRes.primary,
                      //   fontWeight: FontWeight.w500,
                      // ),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(20),
                      //   side: BorderSide(
                      //     color: ColorRes.primary.withOpacity(0.4),
                      //   ),
                      // ),
                    ),
                  );
                }

                // Property Type
                if (controller.selectedPropertyType.value.isNotEmpty) {
                  addChip(
                    controller.selectedPropertyType.value,
                    () => controller.selectedPropertyType.value = "",
                  );
                }

                // City
                if (controller.selectedCity.value.isNotEmpty &&
                    controller.selectedCity.value != "All Cities") {
                  addChip(controller.selectedCity.value, () {
                    controller.selectedCity.value = "";
                    controller.selectedLocality.value = "";
                  });
                }

                // Locality
                if (controller.selectedLocality.value.isNotEmpty) {
                  addChip(
                    controller.selectedLocality.value,
                    () => controller.selectedLocality.value = "",
                  );
                }

                // BHK
                if (controller.bhkType.value.isNotEmpty) {
                  addChip(
                    controller.bhkType.value,
                    () => controller.bhkType.value = "",
                  );
                }

                // Budget
                if (controller.min.value != 0 || controller.max.value != 0) {
                  addChip(
                    "₹${controller.min.value} - ₹${controller.max.value}",
                    () {
                      controller.min.value = 0;
                      controller.max.value = 1000000;
                    },
                  );
                }

                // Amenities
                for (final amenity in controller.amenities) {
                  addChip(amenity, () => controller.amenities.remove(amenity));
                }

                if (chips.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selected Filters",
                      style: TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(spacing: 8, runSpacing: 8, children: chips),
                    const SizedBox(height: 16),
                  ],
                );
              }),
              // PROPERTY TYPE
              Obx(
                () => _dropdown(
                  title: "Property Type",
                  value: controller.selectedPropertyType.value,
                  items: controller.propertyTypes,
                  onChanged: (val) {
                    controller.selectedPropertyType.value = val!;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // CITY
              Obx(
                () => _dropdown(
                  title: 'City',
                  hint: 'Select city',
                  value: controller.selectedCity.value,
                  items: controller.cityList.value,
                  onChanged: (val) {
                    controller.selectedCity.value = val!;
                    controller.selectedLocality.value = "";
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),

                decoration: BoxDecoration(
                  color: ColorRes.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    buildToggle("Verify RERA ID", controller.isRERAVerified),
                    SizedBox(height: 10),
                    buildToggle(
                      "Project Has Photos",
                      controller.isPropertyHaveImage,
                    ),
                    SizedBox(height: 10),
                    buildToggle(
                      "Project Has Videos",
                      controller.isPropertyHaveVideo,
                    ),
                    SizedBox(height: 10),
                    buildToggle(
                      "Project Has Brochure",
                      controller.isPropertyHaveBroucher,
                    ),
                  ],
                ),
              ),
              Text(
                'Amenities',
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  color: ColorRes.textColor,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),

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
              _buildCard(
                theme: theme,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    Obx(() {
                      final amenitiesList = IconManager.allAmenities;
                      final showAll = controller.showAllAmenities.value;
                      final displayList =
                          showAll
                              ? amenitiesList
                              : amenitiesList.take(9).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Amenities Grid
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children:
                                displayList.map((amenity) {
                                  final isSelected = controller.amenities
                                      .contains(amenity.title);

                                  return GestureDetector(
                                    onTap: () {
                                      controller.addBuilderAmenities(
                                        amenity.title,
                                      );
                                      debugPrint(
                                        "Selected Amenities: ${controller.amenities}",
                                      );
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.28,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? theme.primaryColor
                                                    .withOpacity(0.1)
                                                : ColorRes.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? theme.primaryColor
                                                  : ColorRes
                                                      .leadGreyColor
                                                      .shade300,
                                          width: 1.2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(
                                              0.08,
                                            ),
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
                                            amenity.title
                                                .replaceAll("_", " ")
                                                .capitalize
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color:
                                                  isSelected
                                                      ? theme.primaryColor
                                                      : ColorRes.textColor
                                                          .withOpacity(0.9),
                                              fontWeight:
                                                  isSelected
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
                                  onTap: controller.toggleAmenitiesView,
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
              const SizedBox(height: 16),
              Text(
                'BHK Type',
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  color: ColorRes.textColor,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
              const SizedBox(height: 7),
              BHKProjectTypes(
                bHKList: controller.bHkType,
                onSelectionChanged: (index) {
                  debugPrint('BHK Type $index');
                },
                controllerForFilter: controller,
              ),
              const SizedBox(height: 16),
              Text(
                'Budget Range',
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  color: ColorRes.textColor,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
              Obx(
                () => BudgetFilterChange(
                  minSelected: controller.min.value,
                  maxSelected: controller.max.value,
                  budgetList: controller.budgetValues.value,
                  onMinChanged: (val) {
                    if (val != null) {
                      controller.min.value = val;
                      print("Main ${controller.min.value}");
                    }
                  },
                  onMaxChanged: (val) {
                    if (val != null) {
                      controller.max.value = val;

                      print("mxa ${controller.max.value}");
                    }
                  },
                  minLabel: "Min Budget",
                  maxLabel: "Max Budget",
                ),
              ),

              // LOCALITY
              Obx(() {
                bool enabled = controller.selectedCity.value != "All Cities";
                return GestureDetector(
                  onTap: () async {
                    Prediction selectedCity = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CommonSearchField(
                              selectedCity: controller.selectedCity.value,
                              isLocality: true,
                              onCitySelected: (city) {
                                Navigator.pop(context, city);
                              },
                              isFromAddProperty: true,
                              initialSearchText:
                                  controller.selectedLocality.value,
                              hintText: 'Locality',
                            ),
                      ),
                    );

                    controller.selectedLocality.value =
                        selectedCity.description!.split(",").first ?? '';
                  },
                  child: AbsorbPointer(
                    absorbing: !enabled,
                    child: Opacity(
                      opacity: enabled ? 1 : 0.4,
                      child: NesticoPeTextField(
                        enabled: false,
                        controller: TextEditingController(
                          text: controller.selectedLocality.value,
                        ),
                        title: 'Locality',
                        hintText: 'Select city first',
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 30),

              // BUTTONS
              SafeArea(
                child: Row(
                  children: [
                    // RESET
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.resetFilters,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Reset",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // APPLY
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final filterData = {
                            "propertyTypes":
                                controller.selectedPropertyType.value
                                    .toString(),
                            "city": controller.selectedCity.value.toString(),
                            "location":
                                controller.selectedLocality.value.toString(),
                            'reraId':
                                controller.isRERAVerified.value.toString(),
                            'hasPhotos':
                                controller.isPropertyHaveImage.value.toString(),
                            'hasVideos':
                                controller.isPropertyHaveVideo.value.toString(),
                            'hasBrochure':
                                controller.isPropertyHaveBroucher.value
                                    .toString(),
                            if (controller.max.value != 0.0 ||
                                controller.min.value != 0)
                              'minPrice': controller.min.value.toString(),
                            if (controller.max.value != 0.0)
                              'maxPrice': controller.max.value.toString(),
                            'bhk': controller.bhkType.value.toString(),
                            if (controller.amenities.isNotEmpty)
                              'amenities':
                                  controller.amenities.value
                                      .map(
                                        (e) => e.toLowerCase().replaceAll(
                                          " ",
                                          "_",
                                        ),
                                      )
                                      .toString(),
                          };

                          final nonNullFilters = Map.fromEntries(
                            filterData.entries.where(
                              (e) =>
                                  e.value != null &&
                                  e.value.toString().trim().isNotEmpty,
                            ),
                          );

                          onApply(nonNullFilters);
                          log('Applied Filters: $nonNullFilters');
                          // Get.back();
                        },

                        child: const Text(
                          "Apply",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BHKProjectTypes extends StatelessWidget {
  BHKProjectTypes({
    super.key,
    required this.bHKList,
    required this.onSelectionChanged,
    required this.controllerForFilter,
  });

  final List<String> bHKList;
  final Function(String? selectedItems) onSelectionChanged;
  final ProjectFilterController controllerForFilter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(right: 10),
        itemCount: bHKList.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected =
                controllerForFilter.bhkType.value == bHKList[index];
            return Padding(
              padding: EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  controllerForFilter.updateFilter(
                    controllerForFilter.bhkType,
                    bHKList[index],
                  );
                  onSelectionChanged(bHKList[index]);
                },
                child: Container(
                  // duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
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
                              : ColorRes.leadGreyColor.shade300,
                      width: isSelected ? 1.8 : 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildCommonText(
                        bHKList[index],
                        AppFontSizes.small,
                        AppFontWeights.medium,
                        isSelected ? ColorRes.primary : ColorRes.textColor,
                        1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

Widget _buildCard({required ThemeData theme, required Widget child}) {
  return child;
}

// 🔽 DROPDOWN WIDGET
Widget _dropdown({
  required String title,
  required String? value,
  required List<String> items,
  required Function(dynamic) onChanged,
  String? hint,
}) {
  return NesticoPeDropdownField<String>(
    value: value,
    hintText: hint,
    fontWight: AppFontWeights.semiBold,
    darkText: true,
    title: title,
    items:
        items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    onChanged: onChanged,
  );
}

class ResellerProjectFilterScreen extends StatefulWidget {
  final bool isProjectItemFilter;

  const ResellerProjectFilterScreen({
    super.key,
    this.isProjectItemFilter = true,
  });

  @override
  State<ResellerProjectFilterScreen> createState() =>
      _ResellerProjectFilterScreenState();
}

class _ResellerProjectFilterScreenState
    extends State<ResellerProjectFilterScreen> {
  final DashboardController controller = Get.put(DashboardController());
  final controllerFilter = Get.put(ProjectFilterController());
  PropertyFilterControllerForFilter controllerForFilter = Get.put(
    PropertyFilterControllerForFilter(),
  );
  CityController cityController = Get.put(CityController());

  ResellerProjectController? projectController;
  String? resellerId;

  double tempMinPrice = 0.0;
  double tempMaxPrice = 100000000;
  final RxBool isInitialized = false.obs;

  double DEFAULT_MIN_PRICE = 0;
  double DEFAULT_MAX_PRICE = 100000000; // 10 Cr

  // Track if dropdowns should be visible
  final RxBool showStateDropdown = false.obs;
  final RxBool showCityDropdown = false.obs;

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData();
    });
    if (tempMinPrice < controller.resellerMinPrice.value ||
        tempMaxPrice > controller.resellerMaxPrice.value ||
        tempMinPrice > tempMaxPrice) {
      tempMinPrice = controller.resellerMinPrice.value;
      tempMaxPrice = controller.resellerMaxPrice.value;
    }
  }

  Future<void> _loadData() async {
    final user = await SecureStorage.getUserData();
    if (user != null) {
      resellerId = user.user?.id;
    }
    projectController = Get.put(
      ResellerProjectController(resellerId: resellerId ?? ''),
    );
    _initializeUserData();
    isInitialized.value = true; // Mark as initialized
  }

  Future<void> _initializeUserData() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id;

    if (userId == null) return;

    setState(() {
      controller.resellerStatePropertyList.value =
          cityController.uniqueStates.map((e) => e ?? '').toSet().toList() ??
          [];
      controller.propertyTypeList.value =
          projectController?.items
              ?.map((e) => e.propertyTypes ?? '')
              .toSet()
              .toList() ??
          [];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /*  Map<String, dynamic> _buildFilterResult() {
    log('Price Range ${jsonEncode(controller.priceRangeSeller)}');
    log('Min Price → ${controller.priceRangeSeller['min']}');
    log('Max Price → ${controller.priceRangeSeller['max']}');

    return {
      // Date Range
      if (controller.txtStartDate.text.isNotEmpty &&
          controller.startDate != null)
        'createdAtFrom': controller.txtStartDate.text,
      if (controller.txtEndDate.text.isNotEmpty && controller.endDate != null)
        'createdAtTo': controller.txtEndDate.text,

      // Location
      if (controller.resellerSelectedState.value.isNotEmpty)
        'state': controller.resellerSelectedState.value,
      if (controller.resellerSelectedCity.value.isNotEmpty)
        'city': controller.resellerSelectedCity.value,
      if (controller.resellerPossessionStatus.value.isNotEmpty)
        'possessionStatus': controller.resellerSelectedCity.value,

      // Property Category
      if (controller.resellerPropertyCategory.value.isNotEmpty)
        'type': controller.resellerPropertyCategory.value.toLowerCase(),

      // Listing Type
      if (controller.resellerListingType.value.isNotEmpty)
        'listingType': controller.resellerListingType.value,

      // Approval Status
      if (controller.resellerApprovalStatus.value.isNotEmpty)
        'approval_status':
            controller.resellerApprovalStatus.value.toLowerCase(),

      // Property Type
      if (controller.resellerPropertyType.value.isNotEmpty)
        'propertyType': controller.resellerPropertyType.value,

      // BHK
      if (controller.resellerBHKType.value.isNotEmpty)
        ...() {
          final bhkValue = controller.resellerBHKType.value.split(' ')[0];
          if (bhkValue == '5+') {
            return {'bhk': 5, 'bhkPlus': true};
          } else {
            return {'bhk': int.tryParse(bhkValue)};
          }
        }(),

      // Price Range
      // if (!UserHelper.isSellerBuilder) ...{
        if ((controller.resellerMinPrice.value != 0.0) ||
            (controller.resellerMaxPrice.value != 0.0)) ...{
          'priceRange': jsonEncode(controller.priceRangeSeller),
        },
      // },
      // Price Range

        'priceRange': jsonEncode({
          'min':
              controller.resellerMinPrice.value == 0.0 &&
                      controller.resellerMaxPrice.value == 0.0
                  ? DEFAULT_MIN_PRICE
                  : controller.resellerMinPrice.value,
          'max':
              controller.resellerMinPrice.value == 0.0 &&
                      controller.resellerMaxPrice.value == 0.0
                  ? DEFAULT_MAX_PRICE
                  : controller.resellerMaxPrice.value,
        }),

      // Verification Status
      if (controller.resellerVerified.value.isNotEmpty)
        'isVerified': controller.resellerVerified.value == 'Verified',

      // Possession Status
      if (controller.resellerPossessionStatus.value.isNotEmpty)
        'possessionStatus': controller.resellerPossessionStatus.value,

      // Furnishing Type
      if (controller.resellerFurnishingType.value.isNotEmpty)
        'furnish_type': controller.matchFurnishType(
          controller.resellerFurnishingType.value,
        ),
    };
  }*/
  Map<String, dynamic> _buildFilterResult() {
    final bool hasPriceFilter =
        controller.resellerMinPrice.value != 0.0 ||
        controller.resellerMaxPrice.value != 0.0;

    return {
      // Date Range
      if (controller.txtStartDate.text.isNotEmpty &&
          controller.startDate != null)
        'createdAtFrom': controller.txtStartDate.text,
      if (controller.txtEndDate.text.isNotEmpty && controller.endDate != null)
        'createdAtTo': controller.txtEndDate.text,

      // Location
      if (controller.resellerSelectedState.value.isNotEmpty)
        'state': controller.resellerSelectedState.value,
      if (controller.resellerSelectedCity.value.isNotEmpty)
        'city': controller.resellerSelectedCity.value,
      if (controller.txtBuilderProjectName.text.isNotEmpty)
        'projectName': controller.txtBuilderProjectName.text,
      if (controller.txtBuilderRERAID.text.isNotEmpty)
        'reraId': controller.txtBuilderRERAID.text,

      // Property Category
      if (controller.resellerPropertyCategory.value.isNotEmpty)
        'type': controller.resellerPropertyCategory.value.toLowerCase(),

      // Listing Type
      if (controller.resellerListingType.value.isNotEmpty)
        'listingType': controller.resellerListingType.value,

      // Approval Status
      if (controller.resellerApprovalStatus.value.isNotEmpty)
        'approval_status':
            controller.resellerApprovalStatus.value.toLowerCase(),

      // Property Type
      if (controller.resellerPropertyType.value.isNotEmpty)
        'propertyType': controller.resellerPropertyType.value,
      if (controller.builderProjectStatus.value.isNotEmpty)
        'status': controller.builderProjectStatus.value,

      // BHK
      if (controller.resellerBHKType.value.isNotEmpty)
        ...() {
          final bhkValue = controller.resellerBHKType.value.split(' ')[0];
          if (bhkValue == '5+') {
            return {'bhk': 5, 'bhkPlus': true};
          } else {
            return {'bhk': int.tryParse(bhkValue)};
          }
        }(),

      // ✅ Price Range - ONLY when user actually selected something
      if (hasPriceFilter)
        'priceRange': jsonEncode({
          'min': controller.resellerMinPrice.value,
          'max': controller.resellerMaxPrice.value,
        }),

      // Verification Status
      if (controller.resellerVerified.value.isNotEmpty)
        'isVerified': controller.resellerVerified.value == 'Verified',

      // Possession Status
      if (controller.resellerPossessionStatus.value.isNotEmpty)
        'possessionStatus': controller.resellerPossessionStatus.value,

      // Furnishing Type
      if (controller.resellerFurnishingType.value.isNotEmpty)
        'furnish_type': controller.matchFurnishType(
          controller.resellerFurnishingType.value,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
            controller.txtStartDate.clear();
            controller.txtEndDate.clear();
            controller.txtStateSearch.clear();
            controller.txtCitySearch.clear();
            controller.txtBuilderRERAID.clear();
            controller.txtSearchPropertyByID.clear();
            controller.txtBuilderProjectName.clear();

            controller.resellerApprovalStatus.value = '';
            controller.resellerBHKType.value = '';
            controller.resellerFurnishingType.value = '';
            controller.resellerListingType.value = '';
            controller.resellerPossessionStatus.value = '';
            controller.resellerPropertyCategory.value = '';
            controller.resellerPropertyType.value = '';
            controller.resellerVerified.value = '';
            controllerForFilter.availableStates.clear();
            controllerForFilter.availableCities.clear();
            controllerForFilter.selectedState.value = '';
            controllerForFilter.selectedCity.value = '';
            controllerForFilter.selectedCity.value = '';
            // ✅ Clear the dropdown lists

            controller.resellerStatePropertyList.value =
                projectController?.items.value
                    .map((e) => e.state ?? '')
                    .toSet()
                    .toList() ??
                [];

            // ✅ Repopulate the property type list
            controller.propertyTypeList.value =
                projectController?.items.value
                    .map((e) => e.propertyTypes ?? '')
                    .toSet()
                    .toList() ??
                [];

            // ✅ Clear the selected values
            controller.resellerSelectedState.value = '';
            controller.resellerSelectedCity.value = '';
            controller.builderProjectStatus.value = '';

            setState(() {
              startDate = null;
              endDate = null;
              tempMinPrice = controller.resellerMinPrice.value;
              tempMaxPrice = controller.resellerMaxPrice.value;
            });
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "${"Project Filter"}",
          style: TextStyle(
            color: ColorRes.textColor,
            fontWeight: AppFontWeights.bold,
            fontSize: getResponsiveFontSize(
              context,
              AppFontSizes.large,
              AppFontSizes.body,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              buildSectionTitle('Created Date Range'),
              SizedBox(height: 8),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: buildTextField(
                      'Start Date',
                      Icons.calendar_month_outlined,
                      controller.txtStartDate,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid date';
                        }
                        return null;
                      },
                      isEnable: false,
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: startDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: ColorRes.primary,
                                  onPrimary: ColorRes.white,
                                  onSurface: ColorRes.black,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: ColorRes.primary,
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            startDate = picked;
                            controller.startDate = picked;
                            // Clear end date if it's before start date
                            if (endDate != null &&
                                endDate!.isBefore(startDate!)) {
                              endDate = null;
                              controller.txtEndDate.clear();
                            }
                          });
                          controller.txtStartDate.text =
                              "${picked.year}-${picked.month}-${picked.day}-";
                          // controller.getPropertyType(propertyController.items);
                        }
                      },
                      isPhoneKey: true,
                    ),
                  ),
                  Expanded(
                    child: buildTextField(
                      'End Date',
                      Icons.calendar_month_outlined,
                      controller.txtEndDate,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter valid date';
                        }
                        if (startDate != null &&
                            endDate != null &&
                            endDate!.isBefore(startDate!)) {
                          return 'End date must be after start date';
                        }
                        return null;
                      },
                      isEnable: false,
                      onTap: () async {
                        if (startDate == null) {
                          NesticoPeSnackBar.showAwesomeSnackbar(
                            title: 'Date Required',
                            message: 'Please select start date first',
                            contentType: ContentType.failure,
                          );
                          return;
                        }

                        FocusScope.of(context).unfocus();
                        DateTime? picked = await showDatePicker(
                          context: context,

                          initialDate:
                              endDate ??
                              (startDate!.isAfter(DateTime.now())
                                  ? startDate!
                                  : DateTime.now()),
                          firstDate: startDate!,
                          // End date cannot be before start date
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: ColorRes.primary,
                                  onPrimary: ColorRes.white,
                                  onSurface: ColorRes.black,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: ColorRes.primary,
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            endDate = picked;
                            controller.endDate = picked;
                          });
                          controller.txtEndDate.text =
                              "${picked.year}-${picked.month}-${picked.day}";
                          // controller.getPropertyType(propertyController.items);
                        }
                      },
                      isPhoneKey: true,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              /*  Obx(() {
                return _dropdown(
                  title: "State",
                  value:
                  controller.resellerSelectedState.value.isEmpty
                      ? null
                      : controller.resellerSelectedState.value,
                  items: controller.resellerStatePropertyList,
                  hint: "Select State",
                  onChanged: (value) async {
                    controller.resellerSelectedState.value = value ?? '';

                    // Clear city when state changes
                    controller.resellerSelectedCity.value = '';

                    // Update city list based on selected state
                    controllerForFilter.updateState(value);
                  },
                );
              }),
              SizedBox(height: 16),

              Obx(() {
                final isStateSelected =
                    controller.resellerSelectedState.value.isNotEmpty;

                return _dropdown(
                  title: "City",
                  value:
                  isStateSelected
                      ? null
                      : controller.resellerSelectedCity.value,
                  items: controllerForFilter.availableCities,
                  hint: isStateSelected ? "Select City" : "Select State First",
                  onChanged:
                  isStateSelected
                      ? (value) {
                    controller.resellerSelectedCity.value = value ?? '';
                  }
                      : (value) {},
                );
              }),*/
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: SearchableDropdownWidget(
                  label: 'State',
                  hint: 'Select your state',
                  items: controllerForFilter.availableStates,
                  // now RxList
                  selectedValue: controllerForFilter.selectedState,
                  prefixIcon: Icons.location_city,
                  onChanged: (value) {
                    controller.resellerSelectedState.value = value ?? '';
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
                              controller.resellerSelectedCity.value =
                                  value ?? '';
                            },
                  ),
                ),
              ),

              SizedBox(height: 16),
              buildSectionTitle('Approval Status'),
              SizedBox(height: 8),
              Obx(() {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 12,
                    children:
                        ['Approved', 'Pending', 'Rejected']
                            .map(
                              (option) => buildChoice(
                                width: 110,
                                title: option.toString(),
                                selected:
                                    controller.resellerApprovalStatus.value ==
                                    option,
                                onTap: () {
                                  controller.setValue(
                                    controller.resellerApprovalStatus,
                                    option,
                                  );
                                  log(
                                    "resellerListingType Type Reseller PropertyFilter ${controller.resellerApprovalStatus}",
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                );
              }),
              SizedBox(height: 16),
              buildSectionTitle('Price'),
              SizedBox(height: 8),
              Obx(
                () => BudgetFilterChange(
                  minSelected: controller.resellerMinPrice.value,
                  maxSelected: controller.resellerMaxPrice.value,
                  budgetList: controller.budgetValues.value,
                  onMinChanged: (val) {
                    if (val != null) {
                      controller.resellerMinPrice.value = val;

                      print("Main ${controller.resellerMinPrice.value}");
                    }
                  },
                  onMaxChanged: (val) {
                    if (val != null) {
                      controller.resellerMaxPrice.value = val;
                      controller.buyerPriceRange(
                        RangeValues(controller.resellerMinPrice.value, val),
                      );

                      print("mxa ${controller.resellerMaxPrice.value}");
                    }
                  },
                  minLabel: "Min Budget",
                  maxLabel: "Max Budget",
                ),
              ),

              /*    SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorRes.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      '${Formatter.formatPrice(tempMinPrice)}',
                      style: TextStyle(
                        color: ColorRes.primary,
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorRes.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      '${Formatter.formatPrice(tempMaxPrice)}',
                      style: TextStyle(
                        color: ColorRes.primary,
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                ],
              ),*/
              SizedBox(height: 16),
              buildSectionTitle('Project Status'),
              SizedBox(height: 8),
              Obx(() {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 12,
                    children:
                        ['UpComing', 'Ongoing', 'Completed']
                            .map(
                              (option) => buildChoice(
                                width: 110,
                                title: option.toString(),
                                selected:
                                    controller.builderProjectStatus.value ==
                                    option,
                                onTap: () {
                                  controller.setValue(
                                    controller.builderProjectStatus,
                                    option,
                                  );
                                  log(
                                    "resellerListingType Type Reseller PropertyFilter ${controller.builderProjectStatus}",
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                );
              }),
              SizedBox(height: 16),
              NesticoPeTextField(
                title: "Project Name",
                isRequired: false,
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textSecondary,
                ),
                prefixIcon: Icons.apartment_outlined,
                hintText: "Enter Project Name ",
                autovalidateMode: AutovalidateMode.onUserInteraction,

                onChanged: (value) {
                  if (value.isNotEmpty) {
                    log(
                      "Property  search: $value → ${controller.txtBuilderProjectName.value}",
                    );
                  }
                },
                controller: controller.txtBuilderProjectName,
              ),
              SizedBox(height: 16),
              NesticoPeTextField(
                title: "RERA ID",
                isRequired: false,
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textSecondary,
                ),
                prefixIcon: Icons.apartment_outlined,
                hintText: "Enter ID",
                autovalidateMode: AutovalidateMode.onUserInteraction,

                onChanged: (value) {
                  if (value.isNotEmpty) {
                    log(
                      "Property  search: $value → ${controller.txtBuilderRERAID.value}",
                    );
                  }
                },
                controller: controller.txtBuilderRERAID,
              ),

              SizedBox(height: 16),
              buildSectionTitle('Property Type'),
              SizedBox(height: 8),
              Obx(() {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 12,
                    children:
                        controller.propertyTypeList.value.map((option) {
                          // Safely capitalize the first letter
                          final formattedOption =
                              option.isNotEmpty
                                  ? option[0].toUpperCase() +
                                      option.substring(1).toLowerCase()
                                  : option;

                          return buildChoice(
                            title: formattedOption,
                            selected:
                                controller.resellerPropertyType.value == option,
                            onTap: () {
                              controller.setValue(
                                controller.resellerPropertyType,
                                option,
                              );
                              log(
                                "resellerListingType Type Reseller PropertyFilter ${controller.resellerPropertyType}",
                              );
                            },
                          );
                        }).toList(),
                  ),
                );
              }),

              SizedBox(height: 16),
              buildSectionTitle('Verification Status'),
              SizedBox(height: 8),
              Obx(() {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 12,
                    children:
                        ['Verified', 'Unverified']
                            .map(
                              (option) => buildChoice(
                                title: option.toString(),
                                selected:
                                    controller.resellerVerified.value == option,
                                onTap: () {
                                  controller.setValue(
                                    controller.resellerVerified,
                                    option,
                                  );
                                  log(
                                    "resellerListingType Type Reseller PropertyFilter ${controller.resellerVerified}",
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                );
              }),
              SizedBox(height: 40),
              SafeArea(
                child: Row(
                  children: [
                    // Clear Filter Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // 🔄 Clear all filters
                          controller.txtStartDate.clear();
                          controller.txtEndDate.clear();
                          controller.txtStateSearch.clear();
                          controller.txtCitySearch.clear();
                          controller.txtSearchPropertyByID.clear();
                          controller.txtBuilderProjectName.clear();
                          controller.txtBuilderRERAID.clear();
                          controller.resellerApprovalStatus.value = '';
                          controller.resellerBHKType.value = '';
                          controller.resellerFurnishingType.value = '';
                          controller.resellerListingType.value = '';
                          controller.resellerPossessionStatus.value = '';
                          controller.resellerPropertyCategory.value = '';
                          controller.resellerPropertyType.value = '';
                          controller.resellerVerified.value = '';
                          controllerForFilter.availableStates.clear();
                          controller.txtBuilderRERAID.clear();
                          controllerForFilter.availableCities.clear();
                          controllerForFilter.selectedState.value = '';
                          controllerForFilter.selectedCity.value = '';
                          // ✅ Clear the dropdown lists

                          controller.resellerStatePropertyList.value =
                              projectController?.items.value
                                  .map((e) => e.state ?? '')
                                  .toSet()
                                  .toList() ??
                              [];

                          // ✅ Repopulate the property type list
                          controller.propertyTypeList.value =
                              projectController?.items.value
                                  .map((e) => e.propertyTypes ?? '')
                                  .toSet()
                                  .toList() ??
                              [];

                          // ✅ Clear the selected values
                          controller.resellerSelectedState.value = '';
                          controller.resellerSelectedCity.value = '';
                          controller.builderProjectStatus.value = '';

                          setState(() {
                            startDate = null;
                            endDate = null;
                            tempMinPrice = controller.resellerMinPrice.value;
                            tempMaxPrice = controller.resellerMaxPrice.value;
                          });

                          // controller.getPropertyType(propertyController.items);

                          NesticoPeSnackBar.showAwesomeSnackbar(
                            title: 'Filters Cleared',
                            message: 'All filters have been reset successfully',
                            contentType: ContentType.help,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorRes.error.withOpacity(0.1),
                          foregroundColor: ColorRes.error,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Clear Filters',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Apply Filter Button
                    // Apply Filter Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.getPropertyType();

                          // Build filter result and return it
                          Map<String, dynamic> filterResult =
                              _buildFilterResult();

                          Get.back(
                            result: filterResult,
                          ); // ✅ Return the filter result
                          controller.txtStartDate.clear();
                          controller.txtEndDate.clear();
                          controller.txtStateSearch.clear();
                          controller.txtCitySearch.clear();
                          controller.txtSearchPropertyByID.clear();

                          controller.resellerApprovalStatus.value = '';
                          controller.resellerBHKType.value = '';
                          controller.resellerFurnishingType.value = '';
                          controller.resellerListingType.value = '';
                          controller.resellerPossessionStatus.value = '';
                          controller.resellerPropertyCategory.value = '';
                          controller.resellerPropertyType.value = '';
                          controller.txtBuilderProjectName.clear();
                          controller.resellerVerified.value = '';
                          controllerForFilter.availableStates.clear();
                          controllerForFilter.availableCities.clear();
                          controllerForFilter.selectedState.value = '';
                          controllerForFilter.selectedCity.value = '';
                          // ✅ Clear the dropdown lists

                          controller.resellerStatePropertyList.value =
                              projectController?.items.value
                                  .map((e) => e.state ?? '')
                                  .toSet()
                                  .toList() ??
                              [];

                          // ✅ Repopulate the property type list
                          controller.propertyTypeList.value =
                              projectController?.items.value
                                  .map((e) => e.propertyTypes ?? '')
                                  .toSet()
                                  .toList() ??
                              [];

                          // ✅ Clear the selected values
                          controller.resellerSelectedState.value = '';
                          controller.resellerSelectedCity.value = '';
                          controller.builderProjectStatus.value = '';

                          setState(() {
                            startDate = null;
                            endDate = null;
                            tempMinPrice = controller.resellerMinPrice.value;
                            tempMaxPrice = controller.resellerMaxPrice.value;
                          });
                          // Get.snackbar(
                          //   'Filters Applied',
                          //   'Your filters have been applied successfully',
                          //   snackPosition: SnackPosition.BOTTOM,
                          //   backgroundColor: ColorRes.primary,
                          //   colorText: ColorRes.white,
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorRes.primary,
                          foregroundColor: ColorRes.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
