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
import '../../../reseller/controller/project/reseller_project_controller.dart';
import '../../../reseller/view/lead/lead_screen_backup.dart';
import '../../../search_property/model/search_model.dart';
import '../../../search_property/view/search_screen.dart';
import '../../controller/builder_form_controller.dart';

import 'package:flutter/material.dart';

class BuyerSideProjectFilterScreen extends StatefulWidget {
  final bool isProjectItemBuyerFilter;

  const BuyerSideProjectFilterScreen({
    super.key,
    this.isProjectItemBuyerFilter = false,
  });

  @override
  State<BuyerSideProjectFilterScreen> createState() =>
      _BuyerSideProjectFilterScreenState();
}

class _BuyerSideProjectFilterScreenState
    extends State<BuyerSideProjectFilterScreen> {
  static const List<String> _defaultPropertyTypes = [
    'apartment',
    'villa',
    'house',
  ];
  final _BuyerProjectFilterState controller = _BuyerProjectFilterState();
  final controllerFilter =
      Get.isRegistered<ProjectFilterController>()
          ? Get.find<ProjectFilterController>()
          : Get.put(ProjectFilterController());
  late final PropertyFilterControllerForFilter controllerForFilter;
  late final CityController cityController;

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
  final RxString selectedCityLocality = ''.obs;
  final RxList<String> cityLocalities = <String>[].obs;

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    controllerForFilter =
        Get.isRegistered<PropertyFilterControllerForFilter>()
            ? Get.find<PropertyFilterControllerForFilter>()
            : Get.put(PropertyFilterControllerForFilter());
    cityController =
        Get.isRegistered<CityController>()
            ? Get.find<CityController>()
            : Get.put(CityController());
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
    projectController =
        Get.isRegistered<ResellerProjectController>()
            ? Get.find<ResellerProjectController>()
            : Get.put(ResellerProjectController(resellerId: resellerId ?? ''));
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
      controller.propertyTypeList.value = _defaultPropertyTypes;
    });
    _populateAllCities();
  }

  void _populateAllCities() {
    controllerForFilter.availableCities.value =
        cityController.allCities
            .map((city) => city.city?.trim() ?? '')
            .where((city) => city.isNotEmpty)
            .toSet()
            .toList();
  }

  void _updateCityLocalities(String city) {
    final selectedCity = city.trim().toLowerCase();
    if (selectedCity.isEmpty) {
      selectedCityLocality.value = '';
      cityLocalities.clear();
      return;
    }
    final items = projectController?.items ?? <dynamic>[].obs;
    cityLocalities.value =
        items
            .where(
              (item) =>
                  (item?.city ?? '').toString().trim().toLowerCase() ==
                  selectedCity,
            )
            .map((item) => (item?.location ?? '').toString().trim())
            .where((location) => location.isNotEmpty)
            .toSet()
            .toList();
    if (!cityLocalities.contains(selectedCityLocality.value)) {
      selectedCityLocality.value = '';
    }
  }

  @override
  void dispose() {
    controller.dispose();
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
      if (controller.resellerSelectedCity.value.isNotEmpty)
        'city': controller.resellerSelectedCity.value,
      if (selectedCityLocality.value.isNotEmpty) 'locality': selectedCityLocality.value,
      if (controller.txtBuilderRERAID.text.isNotEmpty)
        'reraId': controller.txtBuilderRERAID.text,

      // Property Category
      if (controller.resellerPropertyCategory.value.isNotEmpty)
        'type': controller.resellerPropertyCategory.value.toLowerCase(),

      // Listing Type
      if (controller.resellerListingType.value.isNotEmpty)
        'listingType': controller.resellerListingType.value,

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
            controller.propertyTypeList.value = _defaultPropertyTypes;

            // ✅ Clear the selected values
            controller.resellerSelectedState.value = '';
            controller.resellerSelectedCity.value = '';
            controller.builderProjectStatus.value = '';
            selectedCityLocality.value = '';
            cityLocalities.clear();
            _populateAllCities();

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
                          //bchdbdbhsjs xbdb controller.getPropertyType(propertyController.items);
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
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: SearchableDropdownWidget(
                    label: 'City',
                    hint: 'Select your city',
                    items: controllerForFilter.availableCities,
                    selectedValue: controllerForFilter.selectedCity,
                    prefixIcon: Icons.location_on,
                    onChanged: (value) {
                      if (value != null) {
                        controllerForFilter.updateCity(value);
                      }
                      controller.resellerSelectedCity.value = value ?? '';
                      _updateCityLocalities(value ?? '');
                    },
                  ),
                ),
              ),
              Obx(
                () =>
                    controller.resellerSelectedCity.value.isNotEmpty
                        ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: SearchableDropdownWidget(
                            label: 'Locality',
                            hint:
                                cityLocalities.isEmpty
                                    ? 'No locality found for this city'
                                    : 'Search locality',
                            items: cityLocalities,
                            selectedValue: selectedCityLocality,
                            prefixIcon: Icons.place_outlined,
                            enabled: cityLocalities.isNotEmpty,
                            onChanged: (value) {
                              selectedCityLocality.value = value ?? '';
                            },
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),
              if (widget.isProjectItemBuyerFilter) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),

                  decoration: BoxDecoration(
                    color: ColorRes.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      buildToggle(
                        "Verify RERA ID",
                        controllerForFilter.isRERAVerified,
                      ),
                      SizedBox(height: 10),
                      buildToggle(
                        "Property Has Photos",
                        controllerForFilter.isPropertyHaveImage,
                      ),
                      SizedBox(height: 10),
                      buildToggle(
                        "Property Has Videos",
                        controllerForFilter.isPropertyHaveVideo,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                buildSectionTitle('BHK Type'),
                const SizedBox(height: 7),
                BHKTypes(
                  bHKList: controllerForFilter.bHkType,
                  onSelectionChanged: (index) {
                    debugPrint('BHK Type $index');
                  },
                  controllerForFilter: controllerForFilter,
                ),
                const SizedBox(height: 7),
                SizedBox(height: 16),
              ],
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
                              _defaultPropertyTypes;

                          // ✅ Clear the selected values
                          controller.resellerSelectedState.value = '';
                          controller.resellerSelectedCity.value = '';
                          controller.builderProjectStatus.value = '';
                          selectedCityLocality.value = '';
                          cityLocalities.clear();
                          _populateAllCities();

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
                              _defaultPropertyTypes;

                          // ✅ Clear the selected values
                          controller.resellerSelectedState.value = '';
                          controller.resellerSelectedCity.value = '';
                          controller.builderProjectStatus.value = '';
                          selectedCityLocality.value = '';
                          cityLocalities.clear();
                          _populateAllCities();

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

class _BuyerProjectFilterState {
  final txtStartDate = TextEditingController();
  final txtEndDate = TextEditingController();
  final txtStateSearch = TextEditingController();
  final txtCitySearch = TextEditingController();
  final txtBuilderRERAID = TextEditingController();
  final txtSearchPropertyByID = TextEditingController();
  final txtBuilderProjectName = TextEditingController();

  final RxString resellerApprovalStatus = ''.obs;
  final RxString resellerBHKType = ''.obs;
  final RxString resellerFurnishingType = ''.obs;
  final RxString resellerListingType = ''.obs;
  final RxString resellerPossessionStatus = ''.obs;
  final RxString resellerPropertyCategory = ''.obs;
  final RxString resellerPropertyType = ''.obs;
  final RxString resellerVerified = ''.obs;
  final RxString resellerSelectedState = ''.obs;
  final RxString resellerSelectedCity = ''.obs;
  final RxString builderProjectStatus = ''.obs;

  final RxDouble resellerMinPrice = 0.0.obs;
  final RxDouble resellerMaxPrice = 0.0.obs;

  final RxList<String> resellerStatePropertyList = <String>[].obs;
  final RxList<String> propertyTypeList = <String>[].obs;
  final RxList<double> budgetValues =
      <double>[
        0,
        500000,
        1000000,
        1500000,
        2000000,
        2500000,
        3000000,
        3500000,
        4000000,
        4500000,
        5000000,
        6000000,
        7000000,
        8000000,
        9000000,
        10000000,
        20000000,
        50000000,
      ].obs;

  DateTime? startDate;
  DateTime? endDate;

  void setValue<T>(Rx<T> target, T value) {
    target.value = value;
  }

  String matchFurnishType(String filterValue) {
    const furnishMap = {
      'Fully': 'fully-furnished',
      'Semi': 'semi-furnished',
      'Unfurnished': 'unfurnished',
    };
    return furnishMap[filterValue] ?? filterValue.toLowerCase();
  }

  void buyerPriceRange(RangeValues _) {}

  void getPropertyType() {}

  void dispose() {
    txtStartDate.dispose();
    txtEndDate.dispose();
    txtStateSearch.dispose();
    txtCitySearch.dispose();
    txtBuilderRERAID.dispose();
    txtSearchPropertyByID.dispose();
    txtBuilderProjectName.dispose();
  }
}
