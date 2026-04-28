import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/add_property/view/create_property.dart';
import 'package:nesticope_app/modules/builder/controller/project_filter_controller.dart';
import 'package:nesticope_app/modules/filter_property/controller/city_insigths_controller.dart';
import 'package:nesticope_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
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
import '../../controller/all_project_controller.dart';
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
  final List<String> _selectedAmenities = [];
  bool _showAllAmenities = false;
  static const Map<String, String> _amenityPayloadMap = {
    "Swimming Pool": "swimming_pool",
    "Gymnasium": "gymnasium",
    "Club House": "club_house",
    "Children Play Area": "children_play_area",
    "Jogging Track": "jogging_track",
    "Gardens": "gardens",
    "Meditation Area": "meditation_area",
    "Multipurpose Hall": "multipurpose_hall",
    "Amphitheatre": "amphitheatre",
    "Temple": "temple",
    "24x7 Security": "24x7_security",
    "CCTV Surveillance": "cctv_surveillance",
    "Visitor Parking": "visitor_parking",
    "Covered Parking": "covered_parking",
    "Fire Safety": "fire_safety",
    "Power Backup": "power_backup",
    "Lift": "lift",
    "Service Lift": "service_lift",
    "Waste Disposal": "waste_disposal",
    "Solar Panels": "solar_panels",
    "EV Charging": "ev_charging",
    "Wi-Fi Connectivity": "wifi_connectivity",
    "Maintenance Staff": "maintenance_staff",
    "Laundry Service": "laundry_service",
  };

  @override
  void initState() {
    super.initState();
    controller.propertyTypeList.value = List<String>.from(
      _defaultPropertyTypes,
    );
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

    controller.propertyTypeList.value = List<String>.from(
      _defaultPropertyTypes,
    );
    if (userId == null) return;

    setState(() {
      log("cityController.uniqueCities--------------------------------");
      log(
        "cityController.uniqueCities ${cityController.uniqueCities.map((e) => e ?? '').toSet().toList()}",
      );
      log("cityController.uniqueCities--------------------------------");
      controller.resellerCityPropertyList.value =
          projectController?.items.value
              .map((e) => e.city ?? '')
              .toSet()
              .toList() ??
          [];

      log(
        "controller.resellerCityPropertyList--------------------------------",
      );
      log(
        "controller.resellerCityPropertyList ${projectController?.items.value.map((e) => e.city ?? '').toSet().toList() ?? []}",
      );
      log(
        "controller.resellerCityPropertyList--------------------------------",
      );

      controller.resellerCityPropertyList.value =
          cityController.uniqueCities.map((e) => e ?? '').toSet().toList() ??
          [];
      controller.propertyTypeList.value = List<String>.from(
        _defaultPropertyTypes,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<String, dynamic> _buildFilterResult() {
    final selectedAmenityKeys =
        _selectedAmenities
            .map((amenity) => _amenityPayloadMap[amenity] ?? '')
            .where((amenity) => amenity.isNotEmpty)
            .toList();

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
      // 'hasPhotos': controllerForFilter.isPropertyHaveImage,
      // 'hasVideos': controllerForFilter.isPropertyHaveVideo,
      // 'hasBrochure': controllerForFilter.isRERAVerified,
      if (controller.locationController.text.isNotEmpty)
        'location': controller.locationController.text,
      if (controllerForFilter.isPropertyHaveImage.value) 'hasPhotos': true,
      if (controllerForFilter.isPropertyHaveVideo.value) 'hasVideos': true,
      if (controllerForFilter.isRERAVerified.value) 'hasBrochure': true,
      if (selectedAmenityKeys.isNotEmpty)
        'amenities': selectedAmenityKeys.join(', '),

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
          log("bhkValue ${bhkValue}");
          if (bhkValue == '5+') {
            return {'bhk': 5, 'bhkPlus': true};
          } else {
            return {'bhk': int.tryParse(bhkValue)};
          }
        }(),

      if (controller.resellerMinPrice.value > 0)
        'minPrice': controller.resellerMinPrice.value.toInt(),
      if (controller.resellerMaxPrice.value > 0)
        'maxPrice': controller.resellerMaxPrice.value.toInt(),

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
            controller.cityController.text = '';
            controller.locationController.clear();
            controller.txtBuilderRERAID.clear();
            controller.txtSearchPropertyByID.clear();
            controller.txtBuilderProjectName.clear();
            controller.resellerBHKType.value = '';
            controller.resellerFurnishingType.value = '';
            controller.cityController.clear();
            controller.locationController.clear();
            controller.txtBuilderRERAID.clear();
            controller.txtSearchPropertyByID.clear();
            controller.txtBuilderProjectName.clear();
            controller.resellerBHKType.value = '';
            controller.resellerFurnishingType.value = '';
            controller.cityController.clear();
            controller.locationController.clear();
            controller.txtBuilderRERAID.clear();
            controller.txtSearchPropertyByID.clear();
            controller.txtBuilderProjectName.clear();
            controllerForFilter.availableStates.clear();
            controllerForFilter.availableCities.clear();
            controllerForFilter.selectedState.value = '';
            controllerForFilter.selectedCity.value = '';
            controllerForFilter.isPropertyHaveImage.value = false;
            controllerForFilter.isPropertyHaveVideo.value = false;
            controllerForFilter.isRERAVerified.value = false;
            _selectedAmenities.clear();
            controllerForFilter.selectedCity.value = '';
            controller.resellerBHKType.value = '';
            // ✅ Clear the dropdown lists

            controller.resellerCityPropertyList.value =
                projectController?.items.value
                    .map((e) => e.city ?? '')
                    .toSet()
                    .toList() ??
                [];

            // ✅ Repopulate the property type list
            controller.propertyTypeList.value = List<String>.from(
              _defaultPropertyTypes,
            );

            // ✅ Clear the selected values
            controller.resellerSelectedState.value = '';
            controller.resellerSelectedCity.value = '';
            controller.builderProjectStatus.value = '';

            setState(() {
              startDate = null;
              endDate = null;
              tempMinPrice = controller.resellerMinPrice.value;
              tempMaxPrice = controller.resellerMaxPrice.value;
              _showAllAmenities = false;
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
              // buildSectionTitle('Created Date Range'),
              // SizedBox(height: 8),
              // Row(
              //   spacing: 12,
              //   children: [
              //     Expanded(
              //       child: buildTextField(
              //         'Start Date',
              //         Icons.calendar_month_outlined,
              //         controller.txtStartDate,
              //         validator: (value) {
              //           if (value == null || value.isEmpty) {
              //             return 'Please enter valid date';
              //           }
              //           return null;
              //         },
              //         isEnable: false,
              //         onTap: () async {
              //           FocusScope.of(context).unfocus();
              //           DateTime? picked = await showDatePicker(
              //             context: context,
              //             initialDate: startDate ?? DateTime.now(),
              //             firstDate: DateTime(2000),
              //             lastDate: DateTime(2100),
              //             builder: (context, child) {
              //               return Theme(
              //                 data: Theme.of(context).copyWith(
              //                   colorScheme: ColorScheme.light(
              //                     primary: ColorRes.primary,
              //                     onPrimary: ColorRes.white,
              //                     onSurface: ColorRes.black,
              //                   ),
              //                   textButtonTheme: TextButtonThemeData(
              //                     style: TextButton.styleFrom(
              //                       foregroundColor: ColorRes.primary,
              //                     ),
              //                   ),
              //                 ),
              //                 child: child!,
              //               );
              //             },
              //           );
              //           if (picked != null) {
              //             setState(() {
              //               startDate = picked;
              //               controller.startDate = picked;
              //               // Clear end date if it's before start date
              //               if (endDate != null &&
              //                   endDate!.isBefore(startDate!)) {
              //                 endDate = null;
              //                 controller.txtEndDate.clear();
              //               }
              //             });
              //             controller.txtStartDate.text =
              //                 "${picked.year}-${picked.month}-${picked.day}-";
              //             // controller.getPropertyType(propertyController.items);
              //           }
              //         },
              //         isPhoneKey: true,
              //       ),
              //     ),
              //     Expanded(
              //       child: buildTextField(
              //         'End Date',
              //         Icons.calendar_month_outlined,
              //         controller.txtEndDate,
              //         validator: (value) {
              //           if (value == null || value.isEmpty) {
              //             return 'Please enter valid date';
              //           }
              //           if (startDate != null &&
              //               endDate != null &&
              //               endDate!.isBefore(startDate!)) {
              //             return 'End date must be after start date';
              //           }
              //           return null;
              //         },
              //         isEnable: false,
              //         onTap: () async {
              //           if (startDate == null) {
              //             NesticoPeSnackBar.showAwesomeSnackbar(
              //               title: 'Date Required',
              //               message: 'Please select start date first',
              //               contentType: ContentType.failure,
              //             );
              //             return;
              //           }

              //           FocusScope.of(context).unfocus();
              //           DateTime? picked = await showDatePicker(
              //             context: context,

              //             initialDate:
              //                 endDate ??
              //                 (startDate!.isAfter(DateTime.now())
              //                     ? startDate!
              //                     : DateTime.now()),
              //             firstDate: startDate!,
              //             // End date cannot be before start date
              //             lastDate: DateTime(2100),
              //             builder: (context, child) {
              //               return Theme(
              //                 data: Theme.of(context).copyWith(
              //                   colorScheme: ColorScheme.light(
              //                     primary: ColorRes.primary,
              //                     onPrimary: ColorRes.white,
              //                     onSurface: ColorRes.black,
              //                   ),
              //                   textButtonTheme: TextButtonThemeData(
              //                     style: TextButton.styleFrom(
              //                       foregroundColor: ColorRes.primary,
              //                     ),
              //                   ),
              //                 ),
              //                 child: child!,
              //               );
              //             },
              //           );
              //           if (picked != null) {
              //             setState(() {
              //               endDate = picked;
              //               controller.endDate = picked;
              //             });
              //             controller.txtEndDate.text =
              //                 "${picked.year}-${picked.month}-${picked.day}";
              //             // controller.getPropertyType(propertyController.items);
              //           }
              //         },
              //         isPhoneKey: true,
              //       ),
              //     ),
              //   ],
              // ),

              // SizedBox(height: 16),

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
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 10,
              //     vertical: 8,
              //   ),
              //   child: SearchableDropdownWidget(
              //     label: 'State',
              //     hint: 'Select your state',
              //     items: controllerForFilter.availableStates,
              //     // now RxList
              //     selectedValue: controllerForFilter.selectedState,
              //     prefixIcon: Icons.location_city,
              //     onChanged: (value) {
              //       controller.resellerSelectedState.value = value ?? '';
              //       if (value != null) controllerForFilter.updateState(value);
              //     },
              //   ),
              // ),

              // City Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SearchableDropdownWidget(
                  label: 'City',
                  hint: 'Select your city',
                  items: cityController.uniqueCities,
                  selectedValue: controllerForFilter.selectedCity,
                  prefixIcon: Icons.location_on,
                  onChanged: (value) {
                    controller.cityController.text = value ?? '';
                    controller.resellerSelectedCity.value = value ?? '';
                    if (value != null) controllerForFilter.updateCity(value);
                  },
                ),
              ),
              SizedBox(height: 8),
              buildSectionTitle('Locality'),
              SizedBox(height: 4),
              buildTextField(
                "Search Locality",
                Icons.area_chart_outlined,

                controller.locationController,
                isEnable: false,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a locality';
                  }
                  return null;
                },
                onTap: () async {
                  Prediction selectedCity = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CommonSearchField(
                            isLocality: true,

                            selectedCity: controller.cityController.text,
                            onCitySelected: (city) {
                              Navigator.pop(context, city);
                            },
                            hintText: 'Locality',
                            isFromAddProperty: true,
                            initialSearchText:
                                controller.locationController.text,
                          ),
                    ),
                  );

                  controller.locationController.text =
                      selectedCity.structuredFormatting?.mainText ?? '';

                  // controller.cityController.text = selectedCity.split(',')[0];

                  print("city ${controller.locationController.text}");
                },
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
                        "Project Brochure",
                        controllerForFilter.isRERAVerified,
                      ),
                      SizedBox(height: 10),
                      buildToggle(
                        "Project Has Photos",
                        controllerForFilter.isPropertyHaveImage,
                      ),
                      SizedBox(height: 10),
                      buildToggle(
                        "Project Has Videos",
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
                    controllerForFilter.updateFilter(
                      controllerForFilter.bhkType,
                      index,
                    );
                    controller.resellerBHKType.value = index ?? '';
                    log(
                      "controller.resellerBHKType ${controller.resellerBHKType.value}",
                    );
                    log("index ${index}");
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
                        controller.propertyTypeList.map((option) {
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
              buildSectionTitle('Amenities'),
              SizedBox(height: 8),
              Builder(
                builder: (context) {
                  final amenities =
                      _showAllAmenities
                          ? IconManager.projectAmenitiesList
                          : IconManager.projectAmenitiesList.take(6).toList();

                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        amenities.map((amenity) {
                          return buildChoice(
                            title: amenity,
                            selected: _selectedAmenities.contains(amenity),
                            onTap: () {
                              setState(() {
                                if (_selectedAmenities.contains(amenity)) {
                                  _selectedAmenities.remove(amenity);
                                } else {
                                  _selectedAmenities.add(amenity);
                                }
                              });
                            },
                          );
                        }).toList(),
                  );
                },
              ),
              if (IconManager.projectAmenitiesList.length > 6) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _showAllAmenities = !_showAllAmenities;
                          });
                        },
                        icon: Icon(
                          _showAllAmenities
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                        label: Text(
                          _showAllAmenities ? 'Show less' : 'Show more',
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 40),

              // SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                      controller.resellerBHKType.value = '';
                      controller.locationController.clear();
                      controller.cityController.text = '';
                      controller.txtBuilderRERAID.clear();
                      controller.txtSearchPropertyByID.clear();
                      controller.txtBuilderProjectName.clear();
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
                      controllerForFilter.isPropertyHaveImage.value = false;
                      controllerForFilter.isPropertyHaveVideo.value = false;
                      controllerForFilter.isRERAVerified.value = false;
                      _selectedAmenities.clear();
                      controller.resellerStatePropertyList.value =
                          projectController?.items.value
                              .map((e) => e.state ?? '')
                              .toSet()
                              .toList() ??
                          [];
            
                      // ✅ Repopulate the property type list
                      controller.propertyTypeList.value = List<String>.from(
                        _defaultPropertyTypes,
                      );
            
                      // ✅ Clear the selected values
                      controller.resellerSelectedState.value = '';
                      controller.resellerSelectedCity.value = '';
                      controller.builderProjectStatus.value = '';
            
                      setState(() {
                        startDate = null;
                        endDate = null;
                        tempMinPrice = controller.resellerMinPrice.value;
                        tempMaxPrice = controller.resellerMaxPrice.value;
                        _showAllAmenities = false;
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
                      Map<String, dynamic> filterResult = _buildFilterResult();
            
                      Get.back(result: filterResult); // ✅ Return the filter result
                      controller.txtStartDate.clear();
                      controller.txtEndDate.clear();
                      controller.txtStateSearch.clear();
                      controller.txtCitySearch.clear();
            
                      controller.txtSearchPropertyByID.clear();
                      controllerForFilter.isPropertyHaveImage.value = false;
                      controllerForFilter.isPropertyHaveVideo.value = false;
                      controllerForFilter.isRERAVerified.value = false;
                      _selectedAmenities.clear();
                      controller.resellerApprovalStatus.value = '';
                      controller.resellerBHKType.value = '';
                      controller.resellerFurnishingType.value = '';
                      controller.locationController.clear();
                      controller.cityController.text = '';
                      controller.txtBuilderRERAID.clear();
                      controller.txtSearchPropertyByID.clear();
                      controller.txtBuilderProjectName.clear();
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
                      controller.propertyTypeList.value = List<String>.from(
                        _defaultPropertyTypes,
                      );
            
                      // ✅ Clear the selected values
                      controller.resellerSelectedState.value = '';
                      controller.resellerSelectedCity.value = '';
                      controller.builderProjectStatus.value = '';
            
                      setState(() {
                        startDate = null;
                        endDate = null;
                        tempMinPrice = controller.resellerMinPrice.value;
                        tempMaxPrice = controller.resellerMaxPrice.value;
                        _showAllAmenities = false;
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
        ),
      ),
    );
  }
}
