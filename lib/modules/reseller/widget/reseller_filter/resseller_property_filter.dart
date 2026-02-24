import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:housing_flutter_app/modules/filter_property/controller/city_insigths_controller.dart';
import 'package:housing_flutter_app/modules/insights/views/insights_screen.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:housing_flutter_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
import 'package:housing_flutter_app/utils/logger/app_logger.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/utils/formater/formater.dart';
import '../../../../app/utils/validation.dart';
import '../../../../data/database/secure_storage_service.dart';
import '../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';
import '../../../../widgets/messages/snack_bar.dart';
import '../../../add_property/view/create_property.dart';
import '../../../builder/controller/builder_form_controller.dart';
import '../../../filter_property/controller/property_filter_controller.dart';
import '../../../filter_property/view/widget/common_component/budget_filter.dart';
import '../../../filter_property/view/widget/location_dropdown.dart';
import '../../../seller/module/lead_screen/views/lead_screen_enhanced.dart';
import '../../controller/project/reseller_project_controller.dart';
import '../../controller/reseller_property_controller/reseller_property_controller.dart';

class ResellerPropertyFilter extends StatefulWidget {
  final bool isProjectItemFilter;

  const ResellerPropertyFilter({super.key, this.isProjectItemFilter = true});

  @override
  State<ResellerPropertyFilter> createState() => _ResellerPropertyFilterState();
}

class _ResellerPropertyFilterState extends State<ResellerPropertyFilter> {
  final DashboardController controller = Get.put(DashboardController());
  final PropertyController propertyController = Get.find();
  late final ProjectWizardController controllerProject;
  PropertyFilterControllerForFilter controllerForFilter = Get.put(
    PropertyFilterControllerForFilter(),
  );
  CityController cityController = Get.put(CityController());

  double tempMinPrice = 0.0;
  double tempMaxPrice = 100000000;

  double DEFAULT_MIN_PRICE = 0;
  double DEFAULT_MAX_PRICE = 100000000; // 10 Cr

  // Focus nodes for state and city fields
  final FocusNode stateFocusNode = FocusNode();
  final FocusNode cityFocusNode = FocusNode();

  // Track if dropdowns should be visible
  final RxBool showStateDropdown = false.obs;
  final RxBool showCityDropdown = false.obs;

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        Get.lazyPut(
          () => ProjectWizardController(isBuilderView: true),
          tag: "builder",
        );
        controllerProject = Get.find<ProjectWizardController>(tag: "builder");
      });
      _initializeUserData();
    });

    if (tempMinPrice < controller.resellerMinPrice.value ||
        tempMaxPrice > controller.resellerMaxPrice.value ||
        tempMinPrice > tempMaxPrice) {
      tempMinPrice = controller.resellerMinPrice.value;
      tempMaxPrice = controller.resellerMaxPrice.value;
    }
    // log("Check all Method ${controllerProject.items.map((element) => element.toJson(),)} ${!UserHelper.isSellerBuilder}");
    // if (!UserHelper.isSellerBuilder) {
    //   controller.resellerStatePropertyList.value =
    //       propertyController.items.value
    //           .map((e) => e.state ?? '')
    //           .toSet()
    //           .toList();
    // } else {
    //   controller.resellerStatePropertyList.value =
    //       controllerProject.items.value
    //           .map((e) => e.state ?? '')
    //           .toSet()
    //           .toList();
    //   print("dfydgfydgfydgf Builder State ${controller.resellerStatePropertyList}");
    //
    // }
    // if (!UserHelper.isSellerBuilder) {
    //   print("dfydgfydgfydgf Seller");
    //   controller.propertyTypeList.value =
    //       propertyController.items.value
    //           .map((e) => e.propertyType ?? '')
    //           .toSet()
    //           .toList();
    // } else {
    //   print("dfydgfydgfydgf Builder");
    //   controller.propertyTypeList.value =
    //       controllerProject.items.value
    //           .map((e) => e.propertyTypes ?? '')
    //           .toSet()
    //           .toList();
    //   print("dfydgfydgfydgf Builder ${controller.propertyTypeList}");
    // }
    //
    // // Add listeners to focus nodes
  }

  Future<void> _initializeUserData() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id;

    if (userId == null) return;

    setState(() {
      if (!UserHelper.isSellerBuilder) {
        // ✅ Filter property list based on user ID
        log("USer ID ${userId}");

        AppLogger.structured(
          "Check any Reseller",
          propertyController.items.map((element) => element.state),
        );

        final userProperties =
            (UserHelper.isReseller)
                ? propertyController.items.value
                    .where((e) => e.assignedTo?.contains(userId) ?? false)
                    .toList()
                : propertyController.items.value
                    .where(
                      (e) => e.createdBy == userId,
                    ) // adjust field name as per your model
                    .toList();

        controller.resellerStatePropertyList.value =
            cityController.allCities.map((e) => e.state ?? '').toSet().toList();

        controller.propertyTypeList.value =
            userProperties.map((e) => e.propertyType ?? '').toSet().toList();
        print(
          " Filtered States:propertyuy shdgs  ${controller.propertyTypeList}",
        );
      } else {
        log("USer ID ${userId}");
        AppLogger.structured(
          "Check any Builder and State",
          controllerProject.items.map((element) => element.toJson()),
        );

        log(
          "USer IDdkjgfdi dhfjdfhsdj${controllerProject.items.value.map((e) => e.state)}",
        );

        final userProjects =
            controllerProject.items.value
                .where((e) => e.createdBy == userId)
                .toList();
        print("fdjdfgh ${userProjects.map((e) => e.toJson())}");

        controller.resellerStatePropertyList.value =
            cityController.allCities.map((e) => e.state ?? '').toSet().toList();

        log(
          "USer IDdkjgfdi ${controllerProject.items.map((e) => e.state ?? '').toSet()}",
        );

        controller.propertyTypeList.value =
            userProjects.map((e) => e.propertyTypes ?? '').toSet().toList();

        print("Builder Filtered States: ${controller.propertyTypeList}");
      }
    });
  }

  @override
  void dispose() {
    stateFocusNode.dispose();
    cityFocusNode.dispose();
    super.dispose();
  }

  Future<void> _updateCitiesForSelectedState(String state) async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id;

    if (userId == null) return;

    setState(() {
      if (!UserHelper.isSellerBuilder) {
        controller.resellerCityPropertyList.value =
            cityController.allCities
                .where(
                  (e) => (e.state ?? '').toLowerCase() == state.toLowerCase(),
                )
                .map((e) => e.city ?? '')
                .toSet()
                .toList();
      } else {
        controller.resellerCityPropertyList.value =
            cityController.allCities
                .where(
                  (e) => (e.state ?? '').toLowerCase() == state.toLowerCase(),
                )
                .map((e) => e.city ?? '')
                .toSet()
                .toList();
      }
    });
  }

  /*
  Map<String, dynamic> _buildFilterResult() {
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
      //   if ((controller.resellerMinPrice.value != 0.0) ||
      //       (controller.resellerMaxPrice.value != 0.0)) ...{
      //     'priceRange': jsonEncode(controller.priceRangeSeller),
      //   },
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
    // ✅ Only include price if user actually selected something
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
      if (controller.txtBuilderProjectName.text.isNotEmpty)
        'projectName': controller.txtBuilderProjectName.text,
      if (controller.txtBuilderRERAID.text.isNotEmpty)
        'reraId': controller.txtBuilderRERAID.text,
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

      // ✅ Price Range - ONLY when user actually changed values
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
            controller.txtSearchPropertyByID.clear();
            controllerForFilter.availableStates.clear();
            controllerForFilter.availableCities.clear();
            controllerForFilter.selectedState.value = '';
            controllerForFilter.selectedCity.value = '';
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
            controller.builderProjectStatus.value = '';

            // ✅ Clear the dropdown lists
            controllerForFilter.availableStates.clear();
            controllerForFilter.availableCities.clear();
            controllerForFilter.selectedState.value = '';
            controllerForFilter.selectedCity.value = '';

            controller.resellerStatePropertyList.value =
                propertyController.items.value
                    .map((e) => e.state ?? '')
                    .toSet()
                    .toList();

            // ✅ Repopulate the property type list
            controller.propertyTypeList.value =
                propertyController.items.value
                    .map((e) => e.propertyType ?? '')
                    .toSet()
                    .toList();
            // ✅ Clear the selected values
            controller.resellerSelectedState.value = '';
            controller.resellerSelectedCity.value = '';

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
          "${UserHelper.isSellerBuilder ? "Project Filter" : "Property Filter"}",
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

              /*              SizedBox(
                height: 85,
                child: NesticoPeTextField(
                  title: "State",
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textSecondary,
                  ),
                  prefixIcon: Icons.location_city_outlined,
                  hintText: "Select State",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  isRequired: false,
                  focusNode: stateFocusNode,
                  onChanged: (value) {
                    // ✅ Make this synchronous - move async logic outside
                    if (value.isNotEmpty) {
                      _updateStateList(value); // Call separate async method
                      log("State search: $value");
                    } else {
                      controller.resellerSelectedState.value = '';
                      controller.resellerStatePropertyList.clear();
                      showStateDropdown.value = false;
                    }
                  },
                  controller: controller.txtStateSearch,
                ),
              ),

              // SizedBox(
              //   height: 85,
              //   child: NesticoPeTextField(
              //     title: "State",
              //     style: TextStyle(
              //       fontSize: AppFontSizes.small,
              //       fontWeight: AppFontWeights.semiBold,
              //       color: ColorRes.textSecondary,
              //     ),
              //     prefixIcon: Icons.location_city_outlined,
              //     hintText: "Select State",
              //     autovalidateMode: AutovalidateMode.onUserInteraction,
              //     isRequired: false,
              //     focusNode: stateFocusNode,
              //     onChanged: (value) async {
              //       if (value.isNotEmpty) {
              //         // ✅ Update the dropdown list
              //         final user = await SecureStorage.getUserData();
              //         final userId = user?.user?.id;
              //
              //         if (userId == null) return;
              //         if (!UserHelper.isSellerBuilder) {
              //           controller.resellerStatePropertyList.value =
              //               propertyController.items.value.where((element) => element.id==userId,)
              //                   .map((e) => e.state ?? '')
              //                   .where(
              //                     (state) => state.toLowerCase().contains(
              //                       value.toLowerCase(),
              //                     ),
              //                   )
              //                   .toSet()
              //                   .toList();
              //           print("dfydgfydgfydgf Builder State ${controller.resellerStatePropertyList}");
              //         } else {
              //
              //           controller.resellerStatePropertyList.value =
              //               controllerProject.items.value.where((element) => element.id==userId,)
              //
              //                   .map((e) => e.state ?? '')
              //                   .where(
              //                     (state) => state.toLowerCase().contains(
              //                       value.toLowerCase(),
              //                     ),
              //                   )
              //                   .toSet()
              //                   .toList();
              //           print("dfydgfydgfydgf Builder State ${controller.resellerStatePropertyList}");
              //         }
              //
              //         showStateDropdown.value =
              //             controller.resellerStatePropertyList.isNotEmpty;
              //         log(
              //           "State search: $value → ${controller.resellerStatePropertyList.value}",
              //         );
              //       } else {
              //         // ✅ Clear selected state when text is cleared
              //         controller.resellerSelectedState.value = '';
              //         showStateDropdown.value = false;
              //         // controller.getPropertyType(propertyController.items); // ✅ Refresh property types
              //       }
              //     },
              //     controller: controller.txtStateSearch,
              //   ),
              // ),

              // State Dropdown
              Obx(() {
                if (!showStateDropdown.value ||
                    controller.resellerStatePropertyList.isEmpty) {
                  return const SizedBox();
                }

                return Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorRes.primary.withOpacity(0.2),
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: controller.resellerStatePropertyList.length,
                      separatorBuilder:
                          (_, __) => Divider(
                            height: 1,
                            thickness: 0.5,
                            color: ColorRes.grey.withOpacity(0.2),
                          ),
                      itemBuilder: (context, index) {
                        final state =
                            controller.resellerStatePropertyList[index];
                        return InkWell(
                          onTap: () async {
                            controller.txtStateSearch.text = state;
                            controller.resellerSelectedState.value = state;

                            showStateDropdown.value = false;
                            stateFocusNode.unfocus();

                            // ✅ Update cities based on selected state
                            await _updateCitiesForSelectedState(state);

                            controller.resellerSelectedCity.value = '';
                            controller.txtCitySearch.clear();

                            log("Selected state: $state");
                            log(
                              "Available cities: ${controller.resellerCityPropertyList.value}",
                            );
                          },

                          // onTap: () async {
                          //   // ✅ Set the text field value
                          //   controller.txtStateSearch.text = state;
                          //
                          //   // ✅ Store the selected state for filtering
                          //   controller.resellerSelectedState.value = state;
                          //
                          //   // ✅ Hide dropdown
                          //   showStateDropdown.value = false;
                          //   stateFocusNode.unfocus();
                          //
                          //   // ✅ Update city list based on selected state
                          //   final user = await SecureStorage.getUserData();
                          //   final userId = user?.user?.id;
                          //
                          //   if (userId == null) return;
                          //   if (!UserHelper.isSellerBuilder) {
                          //     controller.resellerCityPropertyList.value =
                          //         propertyController.items.value.where((element) => element.id==userId,)
                          //
                          //             .where(
                          //               (e) =>
                          //                   (e.state ?? '').toLowerCase() ==
                          //                   state.toLowerCase(),
                          //             )
                          //             .map((e) => e.city ?? '')
                          //             .toSet()
                          //             .toList();
                          //   } else {
                          //
                          //     controller.resellerCityPropertyList.value =
                          //         controllerProject.items.value.where((element) => element.id==userId,)
                          //             .where(
                          //               (e) =>
                          //                   (e.state ?? '').toLowerCase() ==
                          //                   state.toLowerCase(),
                          //             )
                          //             .map((e) => e.city ?? '')
                          //             .toSet()
                          //             .toList();
                          //     print("dfydgfydgfydgf Builder City ${controller.resellerCityPropertyList}");
                          //   }
                          //
                          //   // ✅ Clear city selection when state changes
                          //
                          //   controller.resellerSelectedCity.value = '';
                          //
                          //   // ✅ Refresh property types based on new filter
                          //   // controller.getPropertyType(propertyController.items);
                          //
                          //   log("Selected state: $state");
                          //   log(
                          //     "Available cities: ${controller.resellerCityPropertyList.value}",
                          //   );
                          // },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: ColorRes.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    state,
                                    style: TextStyle(
                                      fontSize: AppFontSizes.medium,
                                      color: ColorRes.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
              Obx(() {
                final isStateSelected =
                    controller.resellerSelectedState.value.isNotEmpty;

                return SizedBox(
                  height: 85,
                  child: NesticoPeTextField(
                    title: "City",
                    isRequired: false,
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                      color:
                          isStateSelected
                              ? ColorRes.textSecondary
                              : ColorRes.grey,
                    ),
                    enabled: isStateSelected,
                    // ✅ Only enable when state is selected
                    prefixIcon: Icons.location_city_outlined,
                    hintText:
                        isStateSelected ? "Select City" : "Select State First",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: cityFocusNode,
                    onChanged: (value) {
                      // ✅ Make this synchronous
                      if (value.isNotEmpty && isStateSelected) {
                        _updateCityList(value); // Call separate method
                        log("City search: $value");
                      } else {
                        controller.resellerSelectedCity.value = '';
                        controller.resellerCityPropertyList.clear();
                        showCityDropdown.value = false;
                      }
                    },
                    controller: controller.txtCitySearch,
                  ),
                );
              }),

              // City Field with Dropdown
              // SizedBox(
              //   height: 85,
              //   child: NesticoPeTextField(
              //     title: "City",
              //     isRequired: false,
              //     style: TextStyle(
              //       fontSize: AppFontSizes.small,
              //       fontWeight: AppFontWeights.semiBold,
              //       color: ColorRes.textSecondary,
              //     ),
              //     enabled: controller.txtStateSearch.text.isNotEmpty,
              //     prefixIcon: Icons.location_city_outlined,
              //     hintText: "Select City",
              //     autovalidateMode: AutovalidateMode.onUserInteraction,
              //     focusNode: cityFocusNode,
              //     onChanged: (value) async {
              //       if (value.isNotEmpty) {
              //         final user = await SecureStorage.getUserData();
              //         final userId = user?.user?.id;
              //
              //         if (userId == null) return;
              //         // ✅ Update city dropdown list - filter by selected state
              //         if (!UserHelper.isSellerBuilder) {
              //           controller.resellerCityPropertyList.value =
              //               propertyController.items.value.where((element) => element.id==userId,)
              //                   .where(
              //                     (e) =>
              //                         (e.state ?? '').toLowerCase() ==
              //                         controller.resellerSelectedState.value
              //                             .toLowerCase(),
              //                   )
              //                   .map((e) => e.city ?? '')
              //                   .where(
              //                     (city) => city.toLowerCase().contains(
              //                       value.toLowerCase(),
              //                     ),
              //                   )
              //                   .toSet()
              //                   .toList();
              //           log(
              //             "City search: $value → ${controller.resellerCityPropertyList.value}",
              //           );
              //         } else {
              //           controller.resellerCityPropertyList.value =
              //               controllerProject.items.value.where((element) => element.id==userId,)
              //                   .where(
              //                     (e) =>
              //                         (e.state ?? '').toLowerCase() ==
              //                         controller.resellerSelectedState.value
              //                             .toLowerCase(),
              //                   )
              //                   .map((e) => e.city ?? '')
              //                   .where(
              //                     (city) => city.toLowerCase().contains(
              //                       value.toLowerCase(),
              //                     ),
              //                   )
              //                   .toSet()
              //                   .toList();
              //         }
              //
              //         showCityDropdown.value =
              //             controller.resellerCityPropertyList.isNotEmpty;
              //         log(
              //           "City search: $value → ${controller.resellerCityPropertyList.value}",
              //         );
              //       } else {
              //         // ✅ Clear selected city when text is cleared
              //         controller.resellerSelectedCity.value = '';
              //         showCityDropdown.value = false;
              //         // controller.getPropertyType(propertyController.items); // ✅ Refresh property types
              //       }
              //     },
              //     controller: controller.txtCitySearch,
              //   ),
              // ),

              // City Dropdown
              Obx(() {
                if (!showCityDropdown.value ||
                    controller.resellerCityPropertyList.isEmpty) {
                  return const SizedBox();
                }

                return Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorRes.primary.withOpacity(0.2),
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: controller.resellerCityPropertyList.length,
                      separatorBuilder:
                          (_, __) => Divider(
                            height: 1,
                            thickness: 0.5,
                            color: ColorRes.grey.withOpacity(0.2),
                          ),
                      itemBuilder: (context, index) {
                        final city = controller.resellerCityPropertyList[index];
                        return InkWell(
                          onTap: () {
                            controller.txtCitySearch.text = city;
                            controller.resellerSelectedCity.value = city;

                            showCityDropdown.value = false;
                            cityFocusNode.unfocus();

                            log("Selected city: $city");
                          },
                          // onTap: () {
                          //   // ✅ Set the text field value
                          //   controller.txtCitySearch.text = city;
                          //
                          //   // ✅ Store the selected city for filtering
                          //   controller.resellerSelectedCity.value = city;
                          //
                          //   // ✅ Hide dropdown
                          //   showCityDropdown.value = false;
                          //   cityFocusNode.unfocus();
                          //
                          //   // ✅ Refresh property types based on new filter
                          //   // controller.getPropertyType(propertyController.items);
                          //
                          //   log("Selected city: $city");
                          //
                          //   // ✅ Clear the city dropdown list
                          // },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: ColorRes.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    city,
                                    style: TextStyle(
                                      fontSize: AppFontSizes.medium,
                                      color: ColorRes.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),*/
              if (!UserHelper.isSellerBuilder) ...[
                SizedBox(height: 16),
                buildSectionTitle('Property Category'),
                SizedBox(height: 8),
                Obx(() {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      children:
                          ['Residential', 'Commercial']
                              .map(
                                (option) => buildChoice(
                                  title: option.toString(),
                                  selected:
                                      controller
                                          .resellerPropertyCategory
                                          .value ==
                                      option,
                                  onTap: () {
                                    controller.setValue(
                                      controller.resellerPropertyCategory,
                                      option,
                                    );
                                    log(
                                      "resellerListingType Type Reseller PropertyFilter ${controller.resellerPropertyCategory}",
                                    );
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  );
                }),
                SizedBox(height: 16),
                buildSectionTitle('Service/Listing Type'),
                SizedBox(height: 8),
                Obx(() {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      children:
                          ['Rent', 'Sell', 'PG']
                              .map(
                                (option) => buildChoice(
                                  title: option.toString(),
                                  selected:
                                      controller.resellerListingType.value ==
                                      option,
                                  onTap: () {
                                    controller.setValue(
                                      controller.resellerListingType,
                                      option,
                                    );
                                    log(
                                      "resellerListingType Type Reseller PropertyFilter ${controller.resellerListingType}",
                                    );
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  );
                }),
              ],
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
              if (UserHelper.isSellerBuilder) ...[
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
              ],

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

              if (!UserHelper.isSellerBuilder) ...[
                SizedBox(height: 16),
                buildSectionTitle('BHK'),
                SizedBox(height: 8),
                Obx(() {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      children:
                          ['1 BHK', '2 BHK', '3 BHK', '4 BHK', '5+ BHK']
                              .map(
                                (option) => buildChoice(
                                  width: 80,
                                  title: option.toString(),
                                  selected:
                                      controller.resellerBHKType.value ==
                                      option,
                                  onTap: () {
                                    controller.setValue(
                                      controller.resellerBHKType,
                                      option,
                                    );
                                    log(
                                      "BHK Type Reseller PropertyFilter ${controller.resellerBHKType}",
                                    );
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  );
                }),
              ],
              SizedBox(height: 16),
              buildSectionTitle('Price'),
              SizedBox(height: 8),
              // Obx(() {
              //   final minVal = controller.resellerMinPrice.value;
              //   final maxVal = controller.resellerMaxPrice.value;
              //
              //   if (tempMinPrice < minVal) tempMinPrice = minVal;
              //   if (tempMaxPrice > maxVal) tempMaxPrice = maxVal;
              //   if (tempMinPrice > tempMaxPrice) tempMinPrice = minVal;
              //
              //   return SliderTheme(
              //     data: SliderThemeData(
              //       activeTrackColor: ColorRes.primary,
              //       inactiveTrackColor: ColorRes.white,
              //       thumbColor: ColorRes.primary,
              //       valueIndicatorTextStyle: TextStyle(
              //         fontSize: AppFontSizes.small,
              //         color: ColorRes.textColor,
              //       ),
              //       overlayColor: ColorRes.primary.withOpacity(0.2),
              //       rangeThumbShape: RoundRangeSliderThumbShape(
              //         enabledThumbRadius: 10,
              //         elevation: 3,
              //       ),
              //       rangeTrackShape: RoundedRectRangeSliderTrackShape(),
              //     ),
              //     child: RangeSlider(
              //       values: RangeValues(tempMinPrice, tempMaxPrice),
              //       min: minVal,
              //       max: maxVal,
              //       //divisions: 20,
              //       labels: RangeLabels(
              //         '${Formatter.formatPrice(tempMinPrice)}',
              //         '${Formatter.formatPrice(tempMaxPrice)}',
              //       ),
              //       onChanged: (RangeValues values) {
              //         setState(() {
              //           tempMinPrice = values.start;
              //           tempMaxPrice = values.end;
              //           controller.buyerPriceRange(values);
              //           // controller.getPropertyType(propertyController.items);
              //         });
              //       },
              //     ),
              //   );
              // }),
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

              // buildSectionTitle('Price Range'),
              // SizedBox(height: 8),
              // Row(
              //   spacing: 12,
              //   children: [
              //     Expanded(
              //       child: NesticoPeTextField(
              //         title: 'Min Price',
              //         style: TextStyle(
              //           fontSize: AppFontSizes.small,
              //           fontWeight: AppFontWeights.semiBold,
              //           color: ColorRes.textSecondary,
              //         ),
              //         hintText: 'Enter minimum price',
              //         keyboardType: TextInputType.number,
              //         controller: TextEditingController(
              //           text: tempMinPrice > 0 ? tempMinPrice.toStringAsFixed(0) : '',
              //         ),
              //         onChanged: (value) {
              //           tempMinPrice = double.tryParse(value) ?? 0.0;
              //           controller.resellerMinPrice.value = tempMinPrice;
              //
              //           // 🔥 Now call your price update method
              //           controller.buyerPriceRange(
              //             RangeValues(tempMinPrice, tempMaxPrice),
              //           );
              //
              //           log("💰 Min Price Updated → ${controller.resellerMinPrice.value}");
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: NesticoPeTextField(
              //         title: 'Max Price',
              //         style: TextStyle(
              //           fontSize: AppFontSizes.small,
              //           fontWeight: AppFontWeights.semiBold,
              //           color: ColorRes.textSecondary,
              //         ),
              //         hintText: 'Enter maximum price',
              //         keyboardType: TextInputType.number,
              //         controller: TextEditingController(
              //           text: tempMaxPrice > 0 ? tempMaxPrice.toStringAsFixed(0) : '',
              //         ),
              //         onChanged: (value) {
              //           tempMaxPrice = double.tryParse(value) ?? 0.0;
              //           controller.resellerMaxPrice.value = tempMaxPrice;
              //
              //           // 🔥 Call price update method again
              //           controller.buyerPriceRange(
              //             RangeValues(tempMinPrice, tempMaxPrice),
              //           );
              //
              //           log("💰 Max Price Updated → ${controller.resellerMaxPrice.value}");
              //         },
              //       ),
              //     ),
              //   ],
              // ),
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
              if (!UserHelper.isSellerBuilder) ...[
                SizedBox(height: 16),
                buildSectionTitle('Possession Status'),
                SizedBox(height: 8),
                Obx(() {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      children:
                          ['Ready to Move', 'Under Construction']
                              .map(
                                (option) => buildChoice(
                                  title: option.toString(),
                                  selected:
                                      controller
                                          .resellerPossessionStatus
                                          .value ==
                                      option,
                                  onTap: () {
                                    controller.setValue(
                                      controller.resellerPossessionStatus,
                                      option,
                                    );
                                    log(
                                      "resellerListingType Type Reseller PropertyFilter ${controller.resellerPossessionStatus}",
                                    );
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  );
                }),
                SizedBox(height: 16),
                buildSectionTitle('Furnishing Type'),
                SizedBox(height: 8),
                Obx(() {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      children:
                          ['Unfurnished', 'Semi', 'Fully']
                              .map(
                                (option) => buildChoice(
                                  title: option.toString(),
                                  selected:
                                      controller.resellerFurnishingType.value ==
                                      option,
                                  onTap: () {
                                    controller.setValue(
                                      controller.resellerFurnishingType,
                                      option,
                                    );
                                    log(
                                      "resellerListingType Type Reseller PropertyFilter ${controller.resellerFurnishingType}",
                                    );
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  );
                }),
              ],
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

                          // ✅ Clear the dropdown lists

                          controller.resellerStatePropertyList.value =
                              propertyController.items.value
                                  .map((e) => e.state ?? '')
                                  .toSet()
                                  .toList();
                          controllerForFilter.availableStates.clear();
                          controllerForFilter.availableCities.clear();
                          controllerForFilter.selectedState.value = '';
                          controllerForFilter.selectedCity.value = '';

                          // ✅ Repopulate the property type list
                          controller.propertyTypeList.value =
                              propertyController.items.value
                                  .map((e) => e.propertyType ?? '')
                                  .toSet()
                                  .toList();
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
                          controllerForFilter.availableStates.clear();
                          controllerForFilter.availableCities.clear();
                          controllerForFilter.selectedState.value = '';
                          controllerForFilter.selectedCity.value = '';
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
                          controller.resellerVerified.value = '';
                          controller.txtBuilderProjectName.clear();
                          controller.txtBuilderRERAID.clear();
                          // ✅ Clear the dropdown lists

                          controller.resellerStatePropertyList.value =
                              propertyController.items.value
                                  .map((e) => e.state ?? '')
                                  .toSet()
                                  .toList();
                          controllerForFilter.availableStates.clear();
                          controllerForFilter.availableCities.clear();
                          controllerForFilter.selectedState.value = '';
                          controllerForFilter.selectedCity.value = '';

                          // ✅ Repopulate the property type list
                          controller.propertyTypeList.value =
                              propertyController.items.value
                                  .map((e) => e.propertyType ?? '')
                                  .toSet()
                                  .toList();
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

class ResellerPropertyFilterScreen extends StatefulWidget {
  final bool isProjectItemFilter;

  const ResellerPropertyFilterScreen({
    super.key,
    this.isProjectItemFilter = true,
  });

  @override
  State<ResellerPropertyFilterScreen> createState() =>
      _ResellerPropertyFilterScreenState();
}

class _ResellerPropertyFilterScreenState
    extends State<ResellerPropertyFilterScreen> {
  final DashboardController controller = Get.put(DashboardController());
  PropertyFilterControllerForFilter controllerForFilter = Get.put(
    PropertyFilterControllerForFilter(),
  );
  CityController cityController = Get.put(CityController());

  ResellerPropertyController? propertyController;
  final RxBool isInitialized = false.obs;
  String? resellerId;
  double tempMinPrice = 0.0;
  double tempMaxPrice = 100000000;

  double DEFAULT_MIN_PRICE = 0;
  double DEFAULT_MAX_PRICE = 100000000; // 10 Cr

  // Focus nodes for state and city fields
  final FocusNode stateFocusNode = FocusNode();
  final FocusNode cityFocusNode = FocusNode();

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

    _initializeUserData();
  }

  Future<void> _loadData() async {
    final user = await SecureStorage.getUserData();
    if (user != null) {
      resellerId = user.user?.id;
    }
    propertyController = Get.put(
      ResellerPropertyController(resellerId: resellerId ?? ''),
    );
    _initializeUserData();
    isInitialized.value = true; // Mark as initialized
  }

  Future<void> _initializeUserData() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id;

    if (userId == null) return;

    setState(() {
      AppLogger.structured(
        "Check any Reseller",
        propertyController?.items.map((element) => element.state),
      );

      final userProperties = propertyController?.items.value.toList();

      controller.resellerStatePropertyList.value =
          propertyController?.items
              .map((e) => e.state ?? '')
              .toSet()
              .toList() ??
          [];

      controller.propertyTypeList.value =
          propertyController?.items
              .map((e) => e.propertyType ?? '')
              .toSet()
              .toList() ??
          [];
      print(
        " Filtered States:propertyuy shdgs  ${controller.propertyTypeList}",
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _updateStateList(String searchValue) async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id;

    if (userId == null) return;

    setState(() {
      controller.resellerStatePropertyList.value =
          propertyController?.items.value
              .map((e) => e.state ?? '')
              .where(
                (state) =>
                    state.toLowerCase().contains(searchValue.toLowerCase()),
              )
              .toSet()
              .toList() ??
          [];
      showStateDropdown.value = controller.resellerStatePropertyList.isNotEmpty;
    });
  }

  Future<void> _updateCitiesForSelectedState(String state) async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id;

    if (userId == null) return;
    setState(() {
      controller.resellerCityPropertyList.value =
          propertyController?.items.value
              .where(
                (e) => (e.state ?? '').toLowerCase() == state.toLowerCase(),
              )
              .map((e) => e.city ?? '')
              .toSet()
              .toList() ??
          [];
    });
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
      //   if ((controller.resellerMinPrice.value != 0.0) ||
      //       (controller.resellerMaxPrice.value != 0.0)) ...{
      //     'priceRange': jsonEncode(controller.priceRangeSeller),
      //   },
      // },
      // Price Range
      if (!UserHelper.isSellerBuilder) ...{
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
      },

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
    // ✅ Only include price if user actually selected something
    final bool hasPriceFilter =
        controller.resellerMinPrice.value != 0.0 ||
            controller.resellerMaxPrice.value != 0.0;

    return {
      // Date Range
      if (controller.txtStartDate.text.isNotEmpty &&
          controller.startDate != null)
        'createdAtFrom': controller.txtStartDate.text,
      if (controller.txtEndDate.text.isNotEmpty &&
          controller.endDate != null)
        'createdAtTo': controller.txtEndDate.text,

      // Location
      if (controller.resellerSelectedState.value.isNotEmpty)
        'state': controller.resellerSelectedState.value,
      if (controller.resellerSelectedCity.value.isNotEmpty)
        'city': controller.resellerSelectedCity.value,

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

      // ✅ Price Range - only when user actually changed values
      if (!UserHelper.isSellerBuilder && hasPriceFilter)
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
            controller.txtSearchPropertyByID.clear();

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
            // ✅ Clear the dropdown lists

            controller.resellerStatePropertyList.value =
                propertyController?.items.value
                    .map((e) => e.state ?? '')
                    .toSet()
                    .toList() ??
                [];

            // ✅ Repopulate the property type list
            controller.propertyTypeList.value =
                propertyController?.items.value
                    .map((e) => e.propertyType ?? '')
                    .toSet()
                    .toList() ??
                [];

            // ✅ Clear the selected values
            controller.resellerSelectedState.value = '';
            controller.resellerSelectedCity.value = '';

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
          "${"Property Filter"}",
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

              if (!UserHelper.isSellerBuilder) ...[
                SizedBox(height: 16),
                buildSectionTitle('Property Category'),
                SizedBox(height: 8),
                Obx(() {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      children:
                          ['Residential', 'Commercial']
                              .map(
                                (option) => buildChoice(
                                  title: option.toString(),
                                  selected:
                                      controller
                                          .resellerPropertyCategory
                                          .value ==
                                      option,
                                  onTap: () {
                                    controller.setValue(
                                      controller.resellerPropertyCategory,
                                      option,
                                    );
                                    log(
                                      "resellerListingType Type Reseller PropertyFilter ${controller.resellerPropertyCategory}",
                                    );
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  );
                }),
                SizedBox(height: 16),
                buildSectionTitle('Service/Listing Type'),
                SizedBox(height: 8),
                Obx(() {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      children:
                          ['Rent', 'Sell', 'PG']
                              .map(
                                (option) => buildChoice(
                                  title: option.toString(),
                                  selected:
                                      controller.resellerListingType.value ==
                                      option,
                                  onTap: () {
                                    controller.setValue(
                                      controller.resellerListingType,
                                      option,
                                    );
                                    log(
                                      "resellerListingType Type Reseller PropertyFilter ${controller.resellerListingType}",
                                    );
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  );
                }),
              ],
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
              buildSectionTitle('BHK'),
              SizedBox(height: 8),
              Obx(() {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 12,
                    children:
                        ['1 BHK', '2 BHK', '3 BHK', '4 BHK', '5+ BHK']
                            .map(
                              (option) => buildChoice(
                                width: 80,
                                title: option.toString(),
                                selected:
                                    controller.resellerBHKType.value == option,
                                onTap: () {
                                  controller.setValue(
                                    controller.resellerBHKType,
                                    option,
                                  );
                                  log(
                                    "BHK Type Reseller PropertyFilter ${controller.resellerBHKType}",
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
              // Obx(() {
              //   final minVal = controller.resellerMinPrice.value;
              //   final maxVal = controller.resellerMaxPrice.value;
              //
              //   if (tempMinPrice < minVal) tempMinPrice = minVal;
              //   if (tempMaxPrice > maxVal) tempMaxPrice = maxVal;
              //   if (tempMinPrice > tempMaxPrice) tempMinPrice = minVal;
              //
              //   return SliderTheme(
              //     data: SliderThemeData(
              //       activeTrackColor: ColorRes.primary,
              //       inactiveTrackColor: ColorRes.white,
              //       thumbColor: ColorRes.primary,
              //       valueIndicatorTextStyle: TextStyle(
              //         fontSize: AppFontSizes.small,
              //         color: ColorRes.textColor,
              //       ),
              //       overlayColor: ColorRes.primary.withOpacity(0.2),
              //       rangeThumbShape: RoundRangeSliderThumbShape(
              //         enabledThumbRadius: 10,
              //         elevation: 3,
              //       ),
              //       rangeTrackShape: RoundedRectRangeSliderTrackShape(),
              //     ),
              //     child: RangeSlider(
              //       values: RangeValues(tempMinPrice, tempMaxPrice),
              //       min: minVal,
              //       max: maxVal,
              //       //divisions: 20,
              //       labels: RangeLabels(
              //         '${Formatter.formatPrice(tempMinPrice)}',
              //         '${Formatter.formatPrice(tempMaxPrice)}',
              //       ),
              //       onChanged: (RangeValues values) {
              //         setState(() {
              //           tempMinPrice = values.start;
              //           tempMaxPrice = values.end;
              //           controller.buyerPriceRange(values);
              //           // controller.getPropertyType(propertyController.items);
              //         });
              //       },
              //     ),
              //   );
              // }),
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

              // buildSectionTitle('Price Range'),
              // SizedBox(height: 8),
              // Row(
              //   spacing: 12,
              //   children: [
              //     Expanded(
              //       child: NesticoPeTextField(
              //         title: 'Min Price',
              //         style: TextStyle(
              //           fontSize: AppFontSizes.small,
              //           fontWeight: AppFontWeights.semiBold,
              //           color: ColorRes.textSecondary,
              //         ),
              //         hintText: 'Enter minimum price',
              //         keyboardType: TextInputType.number,
              //         controller: TextEditingController(
              //           text: tempMinPrice > 0 ? tempMinPrice.toStringAsFixed(0) : '',
              //         ),
              //         onChanged: (value) {
              //           tempMinPrice = double.tryParse(value) ?? 0.0;
              //           controller.resellerMinPrice.value = tempMinPrice;
              //
              //           // 🔥 Now call your price update method
              //           controller.buyerPriceRange(
              //             RangeValues(tempMinPrice, tempMaxPrice),
              //           );
              //
              //           log("💰 Min Price Updated → ${controller.resellerMinPrice.value}");
              //         },
              //       ),
              //     ),
              //     Expanded(
              //       child: NesticoPeTextField(
              //         title: 'Max Price',
              //         style: TextStyle(
              //           fontSize: AppFontSizes.small,
              //           fontWeight: AppFontWeights.semiBold,
              //           color: ColorRes.textSecondary,
              //         ),
              //         hintText: 'Enter maximum price',
              //         keyboardType: TextInputType.number,
              //         controller: TextEditingController(
              //           text: tempMaxPrice > 0 ? tempMaxPrice.toStringAsFixed(0) : '',
              //         ),
              //         onChanged: (value) {
              //           tempMaxPrice = double.tryParse(value) ?? 0.0;
              //           controller.resellerMaxPrice.value = tempMaxPrice;
              //
              //           // 🔥 Call price update method again
              //           controller.buyerPriceRange(
              //             RangeValues(tempMinPrice, tempMaxPrice),
              //           );
              //
              //           log("💰 Max Price Updated → ${controller.resellerMaxPrice.value}");
              //         },
              //       ),
              //     ),
              //   ],
              // ),
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

              SizedBox(height: 16),
              buildSectionTitle('Possession Status'),
              SizedBox(height: 8),
              Obx(() {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 12,
                    children:
                        ['Ready to Move', 'Under Construction']
                            .map(
                              (option) => buildChoice(
                                title: option.toString(),
                                selected:
                                    controller.resellerPossessionStatus.value ==
                                    option,
                                onTap: () {
                                  controller.setValue(
                                    controller.resellerPossessionStatus,
                                    option,
                                  );
                                  log(
                                    "resellerListingType Type Reseller PropertyFilter ${controller.resellerPossessionStatus}",
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                );
              }),
              SizedBox(height: 16),
              buildSectionTitle('Furnishing Type'),
              SizedBox(height: 8),
              Obx(() {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 12,
                    children:
                        ['Unfurnished', 'Semi', 'Fully']
                            .map(
                              (option) => buildChoice(
                                title: option.toString(),
                                selected:
                                    controller.resellerFurnishingType.value ==
                                    option,
                                onTap: () {
                                  controller.setValue(
                                    controller.resellerFurnishingType,
                                    option,
                                  );
                                  log(
                                    "resellerListingType Type Reseller PropertyFilter ${controller.resellerFurnishingType}",
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
                          controllerForFilter.availableStates.clear();
                          controllerForFilter.availableCities.clear();
                          controllerForFilter.selectedState.value = '';
                          controllerForFilter.selectedCity.value = '';
                          controller.resellerApprovalStatus.value = '';
                          controller.resellerBHKType.value = '';
                          controller.resellerFurnishingType.value = '';
                          controller.resellerListingType.value = '';
                          controller.resellerPossessionStatus.value = '';
                          controller.resellerPropertyCategory.value = '';
                          controller.resellerPropertyType.value = '';
                          controller.resellerVerified.value = '';

                          // ✅ Clear the dropdown lists

                          controller.resellerStatePropertyList.value =
                              propertyController?.items.value
                                  .map((e) => e.state ?? '')
                                  .toSet()
                                  .toList() ??
                              [];

                          // ✅ Repopulate the property type list
                          controller.propertyTypeList.value =
                              propertyController?.items.value
                                  .map((e) => e.propertyType ?? '')
                                  .toSet()
                                  .toList() ??
                              [];
                          // ✅ Clear the selected values
                          controller.resellerSelectedState.value = '';
                          controller.resellerSelectedCity.value = '';

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
                          controllerForFilter.availableStates.clear();
                          controllerForFilter.availableCities.clear();
                          controllerForFilter.selectedState.value = '';
                          controllerForFilter.selectedCity.value = '';
                          controller.resellerApprovalStatus.value = '';
                          controller.resellerBHKType.value = '';
                          controller.resellerFurnishingType.value = '';
                          controller.resellerListingType.value = '';
                          controller.resellerPossessionStatus.value = '';
                          controller.resellerPropertyCategory.value = '';
                          controller.resellerPropertyType.value = '';
                          controller.resellerVerified.value = '';

                          // ✅ Clear the dropdown lists

                          controller.resellerStatePropertyList.value =
                              propertyController?.items.value
                                  .map((e) => e.state ?? '')
                                  .toSet()
                                  .toList() ??
                                  [];

                          // ✅ Repopulate the property type list
                          controller.propertyTypeList.value =
                              propertyController?.items.value
                                  .map((e) => e.propertyType ?? '')
                                  .toSet()
                                  .toList() ??
                                  [];
                          // ✅ Clear the selected values
                          controller.resellerSelectedState.value = '';
                          controller.resellerSelectedCity.value = '';

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
