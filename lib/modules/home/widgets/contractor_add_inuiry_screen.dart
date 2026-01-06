// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/utils/validation.dart';
// import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
// import 'package:housing_flutter_app/widgets/New%20folder/inputs/text_field.dart'
//     hide tile;
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/widgets/button/button.dart';
//
// import '../../../app/constants/app_font_sizes.dart';
// import '../../../app/constants/size_manager.dart';
// import '../../../data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
// import '../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
// import '../../../widgets/input/city_selection_widget.dart';
// import '../controllers/contractor_profile_service_controller/contractor_profile_service_controller.dart';
//
// class ContractorAddInquiryScreen extends StatelessWidget {
//   final Contractor contractor;
//   final List<ContractorServiceItem> services;
//
//   const ContractorAddInquiryScreen({
//     super.key,
//     required this.contractor,
//     required this.services,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final contractorServiceController = Get.find<ContractorServiceController>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Property Details",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Form(
//             key: contractorServiceController.formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// ------------------ PROPERTY TYPE ------------------
//                 NesticoPeDropdownField<String>(
//                   prefixIcon: Icons.home_work_outlined,
//                   title: "Property Type",
//                   value: contractorServiceController.selectedPropertyType.value,
//                   hintText: "Select property type",
//                   items:
//                       contractorServiceController.propertyTypes
//                           .map(
//                             (e) => DropdownMenuItem(
//                               value: e.toLowerCase().replaceAll(' ', '_'),
//                               child: Text(e),
//                             ),
//                           )
//                           .toList(),
//                   onChanged: (value) {
//                     contractorServiceController.selectedPropertyType.value =
//                         value!;
//                   },
//                   isRequired: true,
//                   validator: (value) => requiredField(value, 'Property Type'),
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 /// ------------------ CITY ------------------
//                 Row(
//                   children: [
//                     Text(
//                       'City',
//                       style: TextStyle(
//                         fontSize: AppFontSizes.medium,
//                         color: ColorRes.textSecondary,
//                         fontWeight: AppFontWeights.bold,
//                       ),
//                     ),
//                     Text(
//                       ' *',
//                       style: TextStyle(
//                         color: Get.theme.colorScheme.error,
//                         fontSize: AppFontSizes.medium,
//                         fontWeight: AppFontWeights.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8),
//                 CitySelectionWidget(
//                   isEditing: true,
//                   controller: contractorServiceController.cityController,
//                   onCitySelected: (selectedCity) {
//                     print("✅ Selected city: ${selectedCity.description}");
//                     contractorServiceController.cityController.text =
//                         selectedCity.description ?? '';
//                     contractorServiceController.statController.text =
//                         selectedCity.reference ?? '';
//                     // You can also store city details in your controller here
//                   },
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.all(AppPadding.small),
//                     filled: true,
//                     fillColor: Get.theme.colorScheme.surface,
//                     hintText: 'Select City',
//                     hintStyle: TextStyle(
//                       color: Get.theme.colorScheme.onSurface.withAlpha(128),
//                       fontSize: AppFontSizes.bodyMedium,
//                       fontWeight: AppFontWeights.regular,
//                     ),
//                     prefixIcon: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Icon(
//                         Icons.gps_fixed,
//                         size: 20,
//                         color: Get.theme.colorScheme.primary,
//                       ),
//                     ),
//                     prefixIconConstraints: const BoxConstraints(minWidth: 40),
//                     enabledBorder: tile(Get.theme.dividerColor),
//                     focusedBorder: tile(Get.theme.colorScheme.primary),
//                     errorBorder: tile(Get.theme.colorScheme.error),
//                     focusedErrorBorder: tile(Get.theme.colorScheme.error),
//                     disabledBorder: tile(Get.theme.dividerColor),
//                     errorStyle: TextStyle(
//                       color: Get.theme.colorScheme.error,
//                       fontSize: AppFontSizes.small,
//                       fontWeight: AppFontWeights.semiBold,
//                     ),
//                   ),
//                 ),
//
//                 /// ------------------ LOCATION ------------------
//                 LocationSelectionWidget(
//                   controller: contractorServiceController.locationController,
//                   onLocationSelected: (data) {
//                     print("✅ Selected location: ${data.description}");
//                     contractorServiceController.locationController.text =
//                         data.description ?? '';
//                   },
//                   cityFilter: contractorServiceController.cityController.text,
//                 ),
//
//                 // NesticoPeTextField(
//                 //   prefixIcon: Icons.place_outlined,
//                 //   title: "Location",
//                 //   controller: contractorServiceController.locationController,
//                 //   hintText: "Enter location",
//                 //   isRequired: true,
//                 //   validator: (value) => requiredField(value, 'Location'),
//                 // ),
//                 const SizedBox(height: 12),
//
//                 /// ------------------ BHK (Only if Residential types) ------------------
//                 Obx(() {
//                   final type =
//                       contractorServiceController.selectedPropertyType.value;
//
//                   final residentialTypes = [
//                     'apartment',
//                     'house',
//                     'villa',
//                     'other',
//                   ];
//
//                   if (residentialTypes.contains(type)) {
//                     return Column(
//                       children: [
//                         NesticoPeTextField(
//                           prefixIcon: Icons.king_bed_outlined,
//                           title: "BHK",
//                           keyboardType: TextInputType.number,
//                           controller: contractorServiceController.bhkController,
//                           hintText: "Enter BHK",
//                           isRequired: true,
//                           formatter: [FilteringTextInputFormatter.digitsOnly],
//                           validator: (value) => requiredField(value, 'BHK'),
//                         ),
//                         const SizedBox(height: 12),
//                       ],
//                     );
//                   }
//                   return const SizedBox.shrink();
//                 }),
//
//                 /// ------------------ CARPET AREA ------------------
//                 NesticoPeTextField(
//                   prefixIcon: Icons.square_foot,
//                   title: "Carpet Area",
//                   keyboardType: TextInputType.number,
//                   controller: contractorServiceController.carpetAreaController,
//                   hintText: "Enter carpet area",
//                   isRequired: true,
//                   formatter: [FilteringTextInputFormatter.digitsOnly],
//                   validator: (value) => requiredField(value, 'Carpet Area'),
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 /// ------------------ DESCRIPTION ------------------
//                 NesticoPeTextField(
//                   prefixIcon: Icons.description_outlined,
//                   title: "Service Description",
//                   controller: contractorServiceController.descriptionController,
//                   hintText: "Enter service description",
//                   maxLines: 5,
//                   isRequired: true,
//                   validator:
//                       (value) => requiredField(value, 'Service Description'),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 /// ------------------ SUBMIT BUTTON ------------------
//                 Obx(
//                   () => NesticoPeButton(
//                     width: double.infinity,
//                     backgroundColor:
//                         contractorServiceController.isLoading.value
//                             ? ColorRes.leadGreyColor.shade300
//                             : ColorRes.primary,
//                     title:
//                         contractorServiceController.isLoading.value
//                             ? "Submitting..."
//                             : "Submit",
//                     onTap:
//                         contractorServiceController.isLoading.value
//                             ? null
//                             : () {
//                               /// Validate form
//                               contractorServiceController.createInquiry(
//                                 contractor.userId,
//                                 services,
//                               );
//                             },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/validation.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/text_field.dart'
    hide tile;
import 'package:get/get.dart';
import 'package:housing_flutter_app/widgets/button/button.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/size_manager.dart';
import '../../../data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import '../../../widgets/input/city_selection_widget.dart';
import '../controllers/contractor_profile_service_controller/contractor_profile_service_controller.dart';

class ContractorAddInquiryScreen extends StatelessWidget {
  final Contractor contractor;
  final List<ContractorServiceItem> services;

  const ContractorAddInquiryScreen({
    super.key,
    required this.contractor,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    final contractorServiceController = Get.find<ContractorServiceController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Property Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: contractorServiceController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ------------------ PROPERTY TYPE ------------------
                NesticoPeDropdownField<String>(
                  prefixIcon: Icons.home_work_outlined,
                  title: "Property Type",
                  value: contractorServiceController.selectedPropertyType.value,
                  hintText: "Select property type",
                  items:
                      contractorServiceController.propertyTypes
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.toLowerCase().replaceAll(' ', '_'),
                              child: Text(e),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    contractorServiceController.selectedPropertyType.value =
                        value!;
                  },
                  isRequired: true,
                  validator: (value) => requiredField(value, 'Property Type'),
                ),

                const SizedBox(height: 12),

                /// ------------------ CITY ------------------
                Row(
                  children: [
                    Text(
                      'City',
                      style: TextStyle(
                        fontSize: AppFontSizes.medium,
                        color: ColorRes.textSecondary,
                        fontWeight: AppFontWeights.bold,
                      ),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(
                        color: Get.theme.colorScheme.error,
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CitySelectionWidget(
                  isEditing: true,
                  controller: contractorServiceController.cityController,
                  onCitySelected: (selectedCity) {
                    print("✅ Selected city: ${selectedCity.description}");

                    // Update text controller
                    contractorServiceController.cityController.text =
                        selectedCity.description ?? '';
                    contractorServiceController.statController.text =
                        selectedCity.reference ?? '';

                    // ✅ UPDATE THE REACTIVE SELECTED CITY
                    contractorServiceController.selectedCity.value =
                        selectedCity.description ?? '';
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(AppPadding.small),
                    filled: true,
                    fillColor: Get.theme.colorScheme.surface,
                    hintText: 'Select City',
                    hintStyle: TextStyle(
                      color: Get.theme.colorScheme.onSurface.withAlpha(128),
                      fontSize: AppFontSizes.bodyMedium,
                      fontWeight: AppFontWeights.regular,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(
                        Icons.gps_fixed,
                        size: 20,
                        color: Get.theme.colorScheme.primary,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 40),
                    enabledBorder: tile(Get.theme.dividerColor),
                    focusedBorder: tile(Get.theme.colorScheme.primary),
                    errorBorder: tile(Get.theme.colorScheme.error),
                    focusedErrorBorder: tile(Get.theme.colorScheme.error),
                    disabledBorder: tile(Get.theme.dividerColor),
                    errorStyle: TextStyle(
                      color: Get.theme.colorScheme.error,
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// ------------------ LOCATION ------------------
                LocationSelectionWidget(
                  controller: contractorServiceController.locationController,
                  onLocationSelected: (data) {
                    print("✅ Selected location: ${data.description}");
                    contractorServiceController.locationController.text =
                        data.description ?? '';
                  },
                  // ✅ PASS THE REACTIVE SELECTED CITY
                  cityFilter: contractorServiceController.selectedCity,
                ),

                const SizedBox(height: 12),

                /// ------------------ BHK (Only if Residential types) ------------------
                Obx(() {
                  final type =
                      contractorServiceController.selectedPropertyType.value;

                  final residentialTypes = [
                    'apartment',
                    'house',
                    'villa',
                    'other',
                  ];

                  if (residentialTypes.contains(type)) {
                    return Column(
                      children: [
                        NesticoPeTextField(
                          prefixIcon: Icons.king_bed_outlined,
                          title: "BHK",
                          keyboardType: TextInputType.number,
                          controller: contractorServiceController.bhkController,
                          hintText: "Enter BHK",
                          isRequired: true,
                          formatter: [FilteringTextInputFormatter.digitsOnly],
                          validator: (value) => requiredField(value, 'BHK'),
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),

                /// ------------------ CARPET AREA ------------------
                NesticoPeTextField(
                  prefixIcon: Icons.square_foot,
                  title: "Carpet Area",
                  keyboardType: TextInputType.number,
                  controller: contractorServiceController.carpetAreaController,
                  hintText: "Enter carpet area",
                  isRequired: true,
                  formatter: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => requiredField(value, 'Carpet Area'),
                ),

                const SizedBox(height: 12),

                /// ------------------ DESCRIPTION ------------------
                NesticoPeTextField(
                  prefixIcon: Icons.description_outlined,
                  title: "Service Description",
                  controller: contractorServiceController.descriptionController,
                  hintText: "Enter service description",
                  maxLines: 5,
                  isRequired: true,
                  validator:
                      (value) => requiredField(value, 'Service Description'),
                ),

                const SizedBox(height: 20),

                /// ------------------ SUBMIT BUTTON ------------------
                Obx(
                  () => NesticoPeButton(
                    width: double.infinity,
                    backgroundColor:
                        contractorServiceController.isLoading.value
                            ? ColorRes.leadGreyColor.shade300
                            : ColorRes.primary,
                    title:
                        contractorServiceController.isLoading.value
                            ? "Submitting..."
                            : "Submit",
                    onTap:
                        contractorServiceController.isLoading.value
                            ? null
                            : () {
                              /// Validate form
                              contractorServiceController.createInquiry(
                                contractor.userId,
                                services,
                              );
                            },
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
