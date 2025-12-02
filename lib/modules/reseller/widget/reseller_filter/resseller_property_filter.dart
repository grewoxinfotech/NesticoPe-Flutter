// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/modules/insights/views/insights_screen.dart';
// import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
// import 'package:housing_flutter_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
//
// import '../../../../app/constants/app_font_sizes.dart';
// import '../../../../app/constants/color_res.dart';
// import '../../../../app/utils/formater/formater.dart';
// import '../../../../app/utils/validation.dart';
// import '../../../../widgets/New folder/inputs/text_field.dart';
// import '../../../add_property/view/create_property.dart';
// import '../../../seller/module/lead_screen/views/lead_screen_enhanced.dart';
//
// class ResellerPropertyFilter extends StatefulWidget {
//   const ResellerPropertyFilter({super.key});
//
//   @override
//   State<ResellerPropertyFilter> createState() => _ResellerPropertyFilterState();
// }
//
// class _ResellerPropertyFilterState extends State<ResellerPropertyFilter> {
//   final DashboardController controller = Get.find();
//   final PropertyController propertyController = Get.find();
//   double tempMinPrice = 0.0;
//   double tempMaxPrice = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//
//     if (tempMinPrice < controller.resellerMinPrice.value ||
//         tempMaxPrice > controller.resellerMaxPrice.value ||
//         tempMinPrice > tempMaxPrice) {
//       tempMinPrice = controller.resellerMinPrice.value;
//       tempMaxPrice = controller.resellerMaxPrice.value;
//     }
//     controller.resellerStatePropertyList.value = propertyController.items.value
//         .map((e) => e.state ?? '')
//         .toSet()
//         .toList();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//         title: Text(
//           "Property Filter",
//           style: TextStyle(
//             color: ColorRes.textColor,
//             fontWeight: AppFontWeights.bold,
//             fontSize: getResponsiveFontSize(
//               context,
//               AppFontSizes.large,
//               AppFontSizes.body,
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 16),
//               buildSectionTitle('Created Date Range'),
//               SizedBox(height: 8),
//               Row(
//                 spacing: 12,
//                 children: [
//                   Expanded(
//                     child: buildTextField(
//                       'Start Date',
//                       Icons.calendar_month_outlined,
//                       controller.txtStartDate,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter valid date';
//                         }
//                         return null;
//                       },
//                       isEnable: false,
//                       onTap: () async {
//                         FocusScope.of(context).unfocus();
//                         DateTime? picked = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime.now(),
//                           lastDate: DateTime(2100),
//                           builder: (context, child) {
//                             return Theme(
//                               data: Theme.of(context).copyWith(
//                                 colorScheme: ColorScheme.light(
//                                   primary: ColorRes.primary,
//                                   // header background color
//                                   onPrimary: ColorRes.white,
//                                   // header text color
//                                   onSurface: ColorRes.black, // body text color
//                                 ),
//                                 textButtonTheme: TextButtonThemeData(
//                                   style: TextButton.styleFrom(
//                                     foregroundColor: ColorRes.primary,
//                                   ),
//                                 ),
//                               ),
//
//                               child: child!,
//                             );
//                           },
//                         );
//                         if (picked != null) {
//                           controller.txtStartDate.text =
//                               "${picked.day}/${picked.month}/${picked.year}";
//                         }
//                       },
//                       isPhoneKey: true,
//                     ),
//                   ),
//                   Expanded(
//                     child: buildTextField(
//                       'End Date',
//                       Icons.calendar_month_outlined,
//                       controller.txtEndDate,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter valid date';
//                         }
//                         return null;
//                       },
//                       isEnable: false,
//                       onTap: () async {
//                         FocusScope.of(context).unfocus();
//                         DateTime? picked = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime.now(),
//                           lastDate: DateTime(2100),
//                           builder: (context, child) {
//                             return Theme(
//                               data: Theme.of(context).copyWith(
//                                 colorScheme: ColorScheme.light(
//                                   primary: ColorRes.primary,
//                                   // header background color
//                                   onPrimary: ColorRes.white,
//                                   // header text color
//                                   onSurface: ColorRes.black, // body text color
//                                 ),
//                                 textButtonTheme: TextButtonThemeData(
//                                   style: TextButton.styleFrom(
//                                     foregroundColor: ColorRes.primary,
//                                   ),
//                                 ),
//                               ),
//
//                               child: child!,
//                             );
//                           },
//                         );
//                         if (picked != null) {
//                           controller.txtEndDate.text =
//                               "${picked.day}/${picked.month}/${picked.year}";
//                         }
//                       },
//                       isPhoneKey: true,
//                     ),
//                   ),
//                 ],
//               ),
//               // SizedBox(height: 16),
//               // buildSectionTitle('City'),
//               SizedBox(height: 8),
//               SizedBox(
//                 height: 100, // give enough height for text field + dropdown
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     NesticoPeTextField(
//                       title: "State",
//                       prefixIcon: Icons.location_city_outlined,
//                       hintText: "Select State",
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       isRequired: false,
//                       onChanged: (value) {
//                         if (value.isNotEmpty) {
//                           controller.resellerStatePropertyList.value = propertyController.items.value
//                               .map((e) => e.state ?? '')
//                               .where((state) => state
//                               .toLowerCase()
//                               .contains(controller.txtStateSearch.text.toLowerCase()))
//                               .toSet()
//                               .toList();
//
//                           log("State input Reseller: $value → ${controller.resellerStatePropertyList.value}");
//                         } else {
//                           controller.resellerStatePropertyList.clear();
//                         }
//                       },
//                       controller: controller.txtStateSearch,
//                     ),
//
//                     Obx(() {
//                       final list = controller.resellerStatePropertyList;
//                       if (list.isEmpty) return const SizedBox();
//
//                       return Positioned(
//                         top: 70, // position dropdown below textfield
//                         left: 0,
//                         right: 0,
//                         child: Material(
//                           elevation: 6,
//                           borderRadius: BorderRadius.circular(12),
//                           child: Container(
//                             constraints: const BoxConstraints(maxHeight: 200),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: ColorRes.primary.withOpacity(0.2),
//                               ),
//                             ),
//                             child: ListView.separated(
//                               shrinkWrap: true,
//                               padding: const EdgeInsets.symmetric(vertical: 4),
//                               itemCount: list.length,
//                               separatorBuilder: (_, __) => Divider(
//                                 height: 1,
//                                 thickness: 0.5,
//                                 color: ColorRes.grey.withOpacity(0.2),
//                               ),
//                               itemBuilder: (context, index) {
//                                 final city = list[index];
//                                 return InkWell(
//                                   onTap: () {
//                                     controller.txtStateSearch.text = city;
//                                     controller.resellerCityPropertyList.value = propertyController.items.value
//                                         .where((e) => (e.state ?? '').toLowerCase() == controller.txtStateSearch.text.toLowerCase())
//                                         .map((e) => e.city ?? '') // extract city name safely
//                                         .toSet() // remove duplicates
//                                         .toList();
//
//                                     log("jshdus ${ controller.resellerCityPropertyList.value}");
//                                     controller.resellerStatePropertyList.clear();
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 12,
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         const Icon(Icons.location_on,
//                                             color: ColorRes.primary, size: 20),
//                                         const SizedBox(width: 12),
//                                         Expanded(
//                                           child: Text(
//                                             city,
//                                             style: TextStyle(
//                                               fontSize: AppFontSizes.medium,
//                                               color: ColorRes.textPrimary,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 8),
//               SizedBox(
//                 height: 100, // give enough height for text field + dropdown
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     NesticoPeTextField(
//                       title: "City",
//                       isRequired: false,
//                       enabled: controller.txtStateSearch.text.isEmpty?true:false,
//                       prefixIcon: Icons.location_city_outlined,
//                       hintText: "Select City",
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       onChanged: (value) {
//                         if (value.isNotEmpty) {
//                           controller.resellerCityPropertyList.value = propertyController.items.value // ✅ only Gujarat
//                               .map((e) => e.city ?? '')
//                               .where((state) => state
//                               .toLowerCase()
//                               .contains(controller.txtCitySearch.text.toLowerCase()))
//                               .toSet()
//                               .toList();
//
//
//                           log("State input Reseller: $value → ${controller.resellerCityPropertyList.value}");
//                         } else {
//                           controller.resellerCityPropertyList.clear();
//                         }
//                       },
//                       controller: controller.txtCitySearch,
//                     ),
//
//                     Obx(() {
//                       final list = controller.resellerCityPropertyList;
//                       if (list.isEmpty) return const SizedBox();
//
//                       return Positioned(
//                         top: 70, // position dropdown below textfield
//                         left: 0,
//                         right: 0,
//                         child: Material(
//                           elevation: 6,
//                           borderRadius: BorderRadius.circular(12),
//                           child: Container(
//                             constraints: const BoxConstraints(maxHeight: 200),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: ColorRes.primary.withOpacity(0.2),
//                               ),
//                             ),
//                             child: ListView.separated(
//                               shrinkWrap: true,
//                               padding: const EdgeInsets.symmetric(vertical: 4),
//                               itemCount: list.length,
//                               separatorBuilder: (_, __) => Divider(
//                                 height: 1,
//                                 thickness: 0.5,
//                                 color: ColorRes.grey.withOpacity(0.2),
//                               ),
//                               itemBuilder: (context, index) {
//                                 final city = list[index];
//                                 return InkWell(
//                                   onTap: () {
//                                     controller.txtCitySearch.text = city;
//                                     controller.resellerCityPropertyList.clear();
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 12,
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         const Icon(Icons.location_on,
//                                             color: ColorRes.primary, size: 20),
//                                         const SizedBox(width: 12),
//                                         Expanded(
//                                           child: Text(
//                                             city,
//                                             style: TextStyle(
//                                               fontSize: AppFontSizes.medium,
//                                               color: ColorRes.textPrimary,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               buildSectionTitle('Approval Status'),
//               SizedBox(height: 8),
//               Obx(() {
//                 return SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     spacing: 12,
//                     children:
//                         ['Approved', 'Pending', 'Rejected']
//                             .map(
//                               (option) => buildChoice(
//                                 width: 110,
//                                 title: option.toString(),
//                                 selected:
//                                     controller.resellerApprovalStatus.value ==
//                                     option,
//                                 onTap: () {
//                                   controller.setValue(
//                                     controller.resellerApprovalStatus,
//                                     option,
//                                   );
//                                   log(
//                                     "resellerListingType Type Reseller PropertyFilter ${controller.resellerApprovalStatus}",
//                                   );
//                                 },
//                               ),
//                             )
//                             .toList(),
//                   ),
//                 );
//               }),
//               SizedBox(height: 16),
//               buildSectionTitle('BHK'),
//               SizedBox(height: 8),
//               Obx(() {
//                 return SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     spacing: 12,
//                     children:
//                         ['1 BHK', '2 BHK', '3 BHK', '4 BHK', '5+ BHK']
//                             .map(
//                               (option) => buildChoice(
//                                 width: 80,
//                                 title: option.toString(),
//                                 selected:
//                                     controller.resellerBHKType.value == option,
//                                 onTap: () {
//                                   controller.setValue(
//                                     controller.resellerBHKType,
//                                     option,
//                                   );
//                                   log(
//                                     "BHK Type Reseller PropertyFilter ${controller.resellerBHKType}",
//                                   );
//                                 },
//                               ),
//                             )
//                             .toList(),
//                   ),
//                 );
//               }),
//               SizedBox(height: 16),
//               buildSectionTitle('Price'),
//               SizedBox(height: 8),
//               Obx(() {
//                 final minVal = controller.resellerMinPrice.value;
//                 final maxVal = controller.resellerMaxPrice.value;
//
//                 if (tempMinPrice < minVal) tempMinPrice = minVal;
//                 if (tempMaxPrice > maxVal) tempMaxPrice = maxVal;
//                 if (tempMinPrice > tempMaxPrice) tempMinPrice = minVal;
//
//                 return SliderTheme(
//                   data: SliderThemeData(
//                     activeTrackColor: ColorRes.primary,
//                     inactiveTrackColor: ColorRes.white,
//                     thumbColor: ColorRes.primary,
//                     valueIndicatorTextStyle: TextStyle(
//                       fontSize: AppFontSizes.small,
//                       color: ColorRes.textColor,
//                     ),
//                     overlayColor: ColorRes.primary.withOpacity(0.2),
//                     rangeThumbShape: RoundRangeSliderThumbShape(
//                       enabledThumbRadius: 10,
//                       elevation: 3,
//                     ),
//                     rangeTrackShape: RoundedRectRangeSliderTrackShape(),
//                   ),
//                   child: RangeSlider(
//                     values: RangeValues(tempMinPrice, tempMaxPrice),
//                     min: minVal,
//                     max: maxVal,
//                     divisions: 20,
//                     labels: RangeLabels(
//                       '${Formatter.formatPrice(tempMinPrice)}',
//                       '${Formatter.formatPrice(tempMaxPrice)}',
//                     ),
//                     onChanged: (RangeValues values) {
//                       setState(() {
//                         tempMinPrice = values.start;
//                         tempMaxPrice = values.end;
//                       });
//                     },
//                   ),
//                 );
//               }),
//               SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: ColorRes.primary.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: ColorRes.primary.withOpacity(0.3),
//                       ),
//                     ),
//                     child: Text(
//                       '${Formatter.formatPrice(tempMinPrice)}',
//                       style: TextStyle(
//                         color: ColorRes.primary,
//                         fontSize: AppFontSizes.bodySmall,
//                         fontWeight: AppFontWeights.semiBold,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: ColorRes.primary.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: ColorRes.primary.withOpacity(0.3),
//                       ),
//                     ),
//                     child: Text(
//                       '${Formatter.formatPrice(tempMaxPrice)}',
//                       style: TextStyle(
//                         color: ColorRes.primary,
//                         fontSize: AppFontSizes.bodySmall,
//                         fontWeight: AppFontWeights.semiBold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               buildSectionTitle('Furnishing Type'),
//               SizedBox(height: 8),
//               Obx(() {
//                 return SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     spacing: 12,
//                     children:
//                         ['Unfurnished', 'Semi', 'Fully']
//                             .map(
//                               (option) => buildChoice(
//                                 title: option.toString(),
//                                 selected:
//                                     controller.resellerFurnishingType.value ==
//                                     option,
//                                 onTap: () {
//                                   controller.setValue(
//                                     controller.resellerFurnishingType,
//                                     option,
//                                   );
//                                   log(
//                                     "resellerListingType Type Reseller PropertyFilter ${controller.resellerFurnishingType}",
//                                   );
//                                 },
//                               ),
//                             )
//                             .toList(),
//                   ),
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/insights/views/insights_screen.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:housing_flutter_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/utils/formater/formater.dart';
import '../../../../app/utils/validation.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';
import '../../../add_property/view/create_property.dart';
import '../../../seller/module/lead_screen/views/lead_screen_enhanced.dart';

class ResellerPropertyFilter extends StatefulWidget {
  const ResellerPropertyFilter({super.key});

  @override
  State<ResellerPropertyFilter> createState() => _ResellerPropertyFilterState();
}

class _ResellerPropertyFilterState extends State<ResellerPropertyFilter> {
  final DashboardController controller = Get.put(DashboardController());
  final PropertyController propertyController = Get.find();
  double tempMinPrice = 0.0;
  double tempMaxPrice = 0.0;

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

    if (tempMinPrice < controller.resellerMinPrice.value ||
        tempMaxPrice > controller.resellerMaxPrice.value ||
        tempMinPrice > tempMaxPrice) {
      tempMinPrice = controller.resellerMinPrice.value;
      tempMaxPrice = controller.resellerMaxPrice.value;
    }
    controller.resellerStatePropertyList.value = propertyController.items.value
        .map((e) => e.state ?? '')
        .toSet()
        .toList();
    controller.propertyTypeList.value = propertyController.items.value
        .map((e) => e.propertyType ?? '')
        .toSet()
        .toList();

    // Add listeners to focus nodes
    stateFocusNode.addListener(() {
      showStateDropdown.value = stateFocusNode.hasFocus &&
          controller.resellerStatePropertyList.isNotEmpty;
    });

    cityFocusNode.addListener(() {
      showCityDropdown.value = cityFocusNode.hasFocus &&
          controller.resellerCityPropertyList.isNotEmpty;
    });
  }

  @override
  void dispose() {
    stateFocusNode.dispose();
    cityFocusNode.dispose();
    super.dispose();
  }
  Map<String, dynamic> _buildFilterResult() {
    return {
      // Date Range
      if (controller.txtStartDate.text.isNotEmpty && controller.startDate != null)
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
        'approval_status': controller.resellerApprovalStatus.value.toLowerCase(),

      // Property Type
      if (controller.resellerPropertyType.value.isNotEmpty)
        'propertyType': controller.resellerPropertyType.value,

      // BHK
      if (controller.resellerBHKType.value.isNotEmpty)
        ...() {
          final bhkValue = controller.resellerBHKType.value.split(' ')[0];
          if (bhkValue == '5+') {
            return {
              'bhk': 5,
              'bhkPlus': true,
            };
          } else {
            return {
              'bhk': int.tryParse(bhkValue),
            };
          }
        }(),

      // Price Range
      if (tempMinPrice != controller.resellerMinPrice.value ||
          tempMaxPrice != controller.resellerMaxPrice.value)
        'priceRange': controller.priceRangeSeller,

      // Verification Status
      if (controller.resellerVerified.value.isNotEmpty)
        'isVerified': controller.resellerVerified.value == 'Verified',

      // Possession Status
      if (controller.resellerPossessionStatus.value.isNotEmpty)
        'possessionStatus': controller.resellerPossessionStatus.value,

      // Furnishing Type
      if (controller.resellerFurnishingType.value.isNotEmpty)
        'furnish_type': controller.matchFurnishType(controller.resellerFurnishingType.value),
    };
  }

  // Method to build filter result map
  // Map<String, dynamic> _buildFilterResult() {
  //   final filterResult = <String, dynamic>{};
  //
  //   // Start date
  //   if (controller.txtStartDate.text.isNotEmpty) {
  //     filterResult['createdAt'] = controller.startDate?.toIso8601String();
  //   }
  //
  //   // End date
  //   if (controller.txtEndDate.text.isNotEmpty) {
  //     filterResult['endDate'] = controller.endDate?.toIso8601String();
  //   }
  //
  //   // State & City
  //   if (controller.resellerSelectedState.value.isNotEmpty) {
  //     filterResult['state'] = controller.resellerSelectedState.value;
  //   }
  //   if (controller.resellerSelectedCity.value.isNotEmpty) {
  //     filterResult['city'] = controller.resellerSelectedCity.value;
  //   }
  //
  //   // Property Category
  //   if (controller.resellerPropertyCategory.value.isNotEmpty) {
  //     filterResult['type'] = controller.resellerPropertyCategory.value.toLowerCase();
  //   }
  //
  //   // Listing Type
  //   if (controller.resellerListingType.value.isNotEmpty) {
  //     filterResult['listingType'] = controller.resellerListingType.value;
  //   }
  //
  //   // Approval Status
  //   if (controller.resellerApprovalStatus.value.isNotEmpty) {
  //     filterResult['approval_status'] = controller.resellerApprovalStatus.value.toLowerCase();
  //   }
  //
  //   // Property Type
  //   if (controller.resellerPropertyType.value.isNotEmpty) {
  //     filterResult['propertyType'] = controller.resellerPropertyType.value;
  //   }
  //
  //   // BHK
  //   if (controller.resellerBHKType.value.isNotEmpty) {
  //     final bhkValue = controller.resellerBHKType.value.split(' ')[0];
  //     if (bhkValue == '5+') {
  //       filterResult['bhk'] = 5;
  //       filterResult['bhkPlus'] = true;
  //     } else {
  //       filterResult['bhk'] = int.tryParse(bhkValue);
  //     }
  //   }
  //
  //   // Price Range — only if changed from defaults
  //   if (tempMinPrice != controller.resellerMinPrice.value ||
  //       tempMaxPrice != controller.resellerMaxPrice.value) {
  //     filterResult['priceRange'] = controller.priceRangeSeller;
  //   }
  //
  //   // Verified
  //   if (controller.resellerVerified.value.isNotEmpty) {
  //     filterResult['isVerified'] =
  //         controller.resellerVerified.value == 'Verified';
  //   }
  //
  //   // Possession Status
  //   if (controller.resellerPossessionStatus.value.isNotEmpty) {
  //     filterResult['possessionStatus'] =
  //         controller.resellerPossessionStatus.value;
  //   }
  //
  //   // Furnishing Type
  //   if (controller.resellerFurnishingType.value.isNotEmpty) {
  //     filterResult['furnish_type'] =
  //         controller.matchFurnishType(controller.resellerFurnishingType.value);
  //   }
  //
  //   return filterResult;
  // }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Property Filter",
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
                            controller.startDate=picked;
                            // Clear end date if it's before start date
                            if (endDate != null && endDate!.isBefore(startDate!)) {
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
                        if (startDate != null && endDate != null && endDate!.isBefore(startDate!)) {
                          return 'End date must be after start date';
                        }
                        return null;
                      },
                      isEnable: false,
                      onTap: () async {
                        if (startDate == null) {
                          Get.snackbar(
                            'Date Required',
                            'Please select start date first',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: ColorRes.primary.withOpacity(0.8),
                            colorText: ColorRes.white,
                          );
                          return;
                        }

                        FocusScope.of(context).unfocus();
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: endDate ?? (startDate!.isAfter(DateTime.now()) ? startDate! : DateTime.now()),
                          firstDate: startDate!, // End date cannot be before start date
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
                            controller.endDate=picked;

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
              // SizedBox(height: 16),
              // SizedBox(height: 16),
              // buildSectionTitle('Search By PropertyID'),
              // SizedBox(height: 8),
              // buildTextField(
              //   "Search City",
              //   Icons.search,
              //   controller.txtSearchPropertyByID,
              //   isEnable: true,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please select a city';
              //     }
              //     return null;
              //   },
              //
              // ),
              // SizedBox(height: 16),
              SizedBox(height: 16),
              // // State Field with Dropdown
              // SizedBox(
              //
              //   height: 85, // Base height for text field
              //   child: NesticoPeTextField(
              //     title: "State",
              //     prefixIcon: Icons.location_city_outlined,
              //     hintText: "Select State",
              //     autovalidateMode: AutovalidateMode.onUserInteraction,
              //     isRequired: false,
              //     focusNode: stateFocusNode,
              //     onChanged: (value) {
              //       if (value.isNotEmpty) {
              //         controller.resellerStatePropertyList.value = propertyController.items.value
              //             .map((e) => e.state ?? '')
              //             .where((state) => state
              //             .toLowerCase()
              //             .contains(value.toLowerCase()))
              //             .toSet()
              //             .toList();
              //         showStateDropdown.value = controller.resellerStatePropertyList.isNotEmpty;
              //         log("State input Reseller: $value → ${controller.resellerStatePropertyList.value}");
              //       } else {
              //         controller.resellerStatePropertyList.clear();
              //         showStateDropdown.value = false;
              //       }
              //     },
              //     controller: controller.txtStateSearch,
              //   ),
              // ),
              //
              // // State Dropdown (positioned below the field)
              // Obx(() {
              //   if (!showStateDropdown.value || controller.resellerStatePropertyList.isEmpty) {
              //     return const SizedBox();
              //   }
              //
              //   return Material(
              //     elevation: 6,
              //     borderRadius: BorderRadius.circular(12),
              //     child: Container(
              //       constraints: const BoxConstraints(maxHeight: 200),
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(12),
              //         border: Border.all(
              //           color: ColorRes.primary.withOpacity(0.2),
              //         ),
              //       ),
              //       child: ListView.separated(
              //         shrinkWrap: true,
              //         padding: const EdgeInsets.symmetric(vertical: 4),
              //         itemCount: controller.resellerStatePropertyList.length,
              //         separatorBuilder: (_, __) => Divider(
              //           height: 1,
              //           thickness: 0.5,
              //           color: ColorRes.grey.withOpacity(0.2),
              //         ),
              //         itemBuilder: (context, index) {
              //           final state = controller.resellerStatePropertyList[index];
              //           return InkWell(
              //             onTap: () {
              //               controller.txtStateSearch.text = state;
              //               controller.resellerSelectedState.value =state;
              //               showStateDropdown.value = false;
              //               stateFocusNode.unfocus();
              //
              //               // Update city list based on selected state
              //               controller.resellerCityPropertyList.value = propertyController.items.value
              //                   .where((e) => (e.state ?? '').toLowerCase() == state.toLowerCase())
              //                   .map((e) => e.city ?? '')
              //                   .toSet()
              //                   .toList();
              //               controller.getPropertyType();
              //               log("Selected state cities: ${controller.resellerCityPropertyList.value}");
              //               controller.resellerStatePropertyList.clear();
              //             },
              //             child: Padding(
              //               padding: const EdgeInsets.symmetric(
              //                 horizontal: 12,
              //                 vertical: 12,
              //               ),
              //               child: Row(
              //                 children: [
              //                   const Icon(Icons.location_on,
              //                       color: ColorRes.primary, size: 20),
              //                   const SizedBox(width: 12),
              //                   Expanded(
              //                     child: Text(
              //                       state,
              //                       style: TextStyle(
              //                         fontSize: AppFontSizes.medium,
              //                         color: ColorRes.textPrimary,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           );
              //         },
              //       ),
              //     ),
              //   );
              // }),
              // State Field with Dropdown
              SizedBox(
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
                    if (value.isNotEmpty) {
                      // ✅ Update the dropdown list
                      controller.resellerStatePropertyList.value = propertyController.items.value
                          .map((e) => e.state ?? '')
                          .where((state) => state
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                          .toSet()
                          .toList();

                      showStateDropdown.value = controller.resellerStatePropertyList.isNotEmpty;
                      log("State search: $value → ${controller.resellerStatePropertyList.value}");
                    } else {

                      // ✅ Clear selected state when text is cleared
                      controller.resellerSelectedState.value = '';
                      showStateDropdown.value = false;
                      // controller.getPropertyType(propertyController.items); // ✅ Refresh property types
                    }
                  },
                  controller: controller.txtStateSearch,
                ),
              ),

// State Dropdown
              Obx(() {
                if (!showStateDropdown.value || controller.resellerStatePropertyList.isEmpty) {
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
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        thickness: 0.5,
                        color: ColorRes.grey.withOpacity(0.2),
                      ),
                      itemBuilder: (context, index) {
                        final state = controller.resellerStatePropertyList[index];
                        return InkWell(
                          onTap: () {
                            // ✅ Set the text field value
                            controller.txtStateSearch.text = state;

                            // ✅ Store the selected state for filtering
                            controller.resellerSelectedState.value = state;

                            // ✅ Hide dropdown
                            showStateDropdown.value = false;
                            stateFocusNode.unfocus();

                            // ✅ Update city list based on selected state
                            controller.resellerCityPropertyList.value = propertyController.items.value
                                .where((e) => (e.state ?? '').toLowerCase() == state.toLowerCase())
                                .map((e) => e.city ?? '')
                                .toSet()
                                .toList();

                            // ✅ Clear city selection when state changes

                            controller.resellerSelectedCity.value = '';

                            // ✅ Refresh property types based on new filter
                            // controller.getPropertyType(propertyController.items);

                            log("Selected state: $state");
                            log("Available cities: ${controller.resellerCityPropertyList.value}");


                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: ColorRes.primary, size: 20),
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

// City Field with Dropdown
              SizedBox(
                height: 85,
                child: NesticoPeTextField(
                  title: "City",
                  isRequired: false,
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textSecondary,
                  ),
                  enabled: controller.txtStateSearch.text.isNotEmpty,
                  prefixIcon: Icons.location_city_outlined,
                  hintText: "Select City",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  focusNode: cityFocusNode,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      // ✅ Update city dropdown list - filter by selected state
                      controller.resellerCityPropertyList.value = propertyController.items.value
                          .where((e) => (e.state ?? '').toLowerCase() ==
                          controller.resellerSelectedState.value.toLowerCase())
                          .map((e) => e.city ?? '')
                          .where((city) => city
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                          .toSet()
                          .toList();

                      showCityDropdown.value = controller.resellerCityPropertyList.isNotEmpty;
                      log("City search: $value → ${controller.resellerCityPropertyList.value}");
                    } else {

                      // ✅ Clear selected city when text is cleared
                      controller.resellerSelectedCity.value = '';
                      showCityDropdown.value = false;
                      // controller.getPropertyType(propertyController.items); // ✅ Refresh property types
                    }
                  },
                  controller: controller.txtCitySearch,
                ),
              ),

// City Dropdown
              Obx(() {
                if (!showCityDropdown.value || controller.resellerCityPropertyList.isEmpty) {
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
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        thickness: 0.5,
                        color: ColorRes.grey.withOpacity(0.2),
                      ),
                      itemBuilder: (context, index) {
                        final city = controller.resellerCityPropertyList[index];
                        return InkWell(
                          onTap: () {
                            // ✅ Set the text field value
                            controller.txtCitySearch.text = city;

                            // ✅ Store the selected city for filtering
                            controller.resellerSelectedCity.value = city;

                            // ✅ Hide dropdown
                            showCityDropdown.value = false;
                            cityFocusNode.unfocus();

                            // ✅ Refresh property types based on new filter
                            // controller.getPropertyType(propertyController.items);

                            log("Selected city: $city");

                            // ✅ Clear the city dropdown list

                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: ColorRes.primary, size: 20),
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
              }),

              // SizedBox(height: 8),
              //
              // // City Field with Dropdown
              // SizedBox(
              //   height: 85, // Base height for text field
              //   child: NesticoPeTextField(
              //     title: "City",
              //     isRequired: false,
              //     enabled: controller.txtStateSearch.text.isNotEmpty,
              //     prefixIcon: Icons.location_city_outlined,
              //     hintText: "Select City",
              //     autovalidateMode: AutovalidateMode.onUserInteraction,
              //     focusNode: cityFocusNode,
              //     onChanged: (value) {
              //       if (value.isNotEmpty) {
              //         controller.resellerCityPropertyList.value = propertyController.items.value
              //             .where((e) => (e.state ?? '').toLowerCase() ==
              //             controller.txtStateSearch.text.toLowerCase())
              //             .map((e) => e.city ?? '')
              //             .where((city) => city
              //             .toLowerCase()
              //             .contains(value.toLowerCase()))
              //             .toSet()
              //             .toList();
              //
              //         showCityDropdown.value = controller.resellerCityPropertyList.isNotEmpty;
              //         log("City input Reseller: $value → ${controller.resellerCityPropertyList.value}");
              //       } else {
              //         controller.resellerCityPropertyList.clear();
              //         showCityDropdown.value = false;
              //       }
              //     },
              //     controller: controller.txtCitySearch,
              //   ),
              // ),
              //
              // // City Dropdown (positioned below the field)
              // Obx(() {
              //   if (!showCityDropdown.value || controller.resellerCityPropertyList.isEmpty) {
              //     return const SizedBox();
              //   }
              //
              //   return Material(
              //     elevation: 6,
              //     borderRadius: BorderRadius.circular(12),
              //     child: Container(
              //       constraints: const BoxConstraints(maxHeight: 200),
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(12),
              //         border: Border.all(
              //           color: ColorRes.primary.withOpacity(0.2),
              //         ),
              //       ),
              //       child: ListView.separated(
              //         shrinkWrap: true,
              //         padding: const EdgeInsets.symmetric(vertical: 4),
              //         itemCount: controller.resellerCityPropertyList.length,
              //         separatorBuilder: (_, __) => Divider(
              //           height: 1,
              //           thickness: 0.5,
              //           color: ColorRes.grey.withOpacity(0.2),
              //         ),
              //         itemBuilder: (context, index) {
              //           final city = controller.resellerCityPropertyList[index];
              //           return InkWell(
              //             onTap: () {
              //               controller.txtCitySearch.text = city;
              //               controller.resellerSelectedCity.value =city;
              //               showCityDropdown.value = false;
              //               controller.getPropertyType();
              //               cityFocusNode.unfocus();
              //               controller.resellerCityPropertyList.clear();
              //             },
              //             child: Padding(
              //               padding: const EdgeInsets.symmetric(
              //                 horizontal: 12,
              //                 vertical: 12,
              //               ),
              //               child: Row(
              //                 children: [
              //                   const Icon(Icons.location_on,
              //                       color: ColorRes.primary, size: 20),
              //                   const SizedBox(width: 12),
              //                   Expanded(
              //                     child: Text(
              //                       city,
              //                       style: TextStyle(
              //                         fontSize: AppFontSizes.medium,
              //                         color: ColorRes.textPrimary,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           );
              //         },
              //       ),
              //     ),
              //   );
              // }),
              SizedBox(height: 16),
              buildSectionTitle('Property Category'),
              SizedBox(height: 8),
              Obx(() {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 12,
                    children:
                   ['Residential','Commercial']
                        .map(
                          (option) => buildChoice(
                        title: option.toString(),
                        selected:
                        controller.resellerPropertyCategory.value ==
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
                    ['Rent','Sell','PG']
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
                    children: controller.propertyTypeList.value
                        .map(
                          (option) {
                        // Safely capitalize the first letter
                        final formattedOption = option.isNotEmpty
                            ? option[0].toUpperCase() + option.substring(1).toLowerCase()
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
                      },
                    ).toList(),
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
              Obx(() {
                final minVal = controller.resellerMinPrice.value;
                final maxVal = controller.resellerMaxPrice.value;

                if (tempMinPrice < minVal) tempMinPrice = minVal;
                if (tempMaxPrice > maxVal) tempMaxPrice = maxVal;
                if (tempMinPrice > tempMaxPrice) tempMinPrice = minVal;

                return SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: ColorRes.primary,
                    inactiveTrackColor: ColorRes.white,
                    thumbColor: ColorRes.primary,
                    valueIndicatorTextStyle: TextStyle(
                      fontSize: AppFontSizes.small,
                      color: ColorRes.textColor,
                    ),
                    overlayColor: ColorRes.primary.withOpacity(0.2),
                    rangeThumbShape: RoundRangeSliderThumbShape(
                      enabledThumbRadius: 10,
                      elevation: 3,
                    ),
                    rangeTrackShape: RoundedRectRangeSliderTrackShape(),
                  ),
                  child: RangeSlider(
                    values: RangeValues(tempMinPrice, tempMaxPrice),
                    min: minVal,
                    max: maxVal,
                    divisions: 20,
                    labels: RangeLabels(
                      '${Formatter.formatPrice(tempMinPrice)}',
                      '${Formatter.formatPrice(tempMaxPrice)}',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        tempMinPrice = values.start;
                        tempMaxPrice = values.end;
                        controller.buyerPriceRange(values);
                        // controller.getPropertyType(propertyController.items);
                      });
                    },
                  ),
                );
              }),
              SizedBox(height: 8),
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
              ),
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
                        controller.resellerVerified.value ==
                            option,
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
              // SizedBox(height: 16),
              // buildSectionTitle('Possession Status'),
              // SizedBox(height: 8),
              // Obx(() {
              //   return SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     child: Row(
              //       spacing: 12,
              //       children:
              //       ['Ready to Move', 'Under Construction']
              //           .map(
              //             (option) => buildChoice(
              //           title: option.toString(),
              //           selected:
              //           controller.resellerPossessionStatus.value ==
              //               option,
              //           onTap: () {
              //             controller.setValue(
              //               controller.resellerPossessionStatus,
              //               option,
              //             );
              //             log(
              //               "resellerListingType Type Reseller PropertyFilter ${controller.resellerPossessionStatus}",
              //             );
              //           },
              //         ),
              //       )
              //           .toList(),
              //     ),
              //   );
              // }),
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
              SizedBox(height: 16),
              Row(
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

                        controller.resellerApprovalStatus.value = '';
                        controller.resellerBHKType.value = '';
                        controller.resellerFurnishingType.value = '';
                        controller.resellerListingType.value = '';
                        controller.resellerPossessionStatus.value = '';
                        controller.resellerPropertyCategory.value = '';
                        controller.resellerPropertyType.value = '';
                        controller.resellerVerified.value = '';

                        // ✅ Clear the dropdown lists

                        controller.resellerStatePropertyList.value = propertyController.items.value
                            .map((e) => e.state ?? '')
                            .toSet()
                            .toList();

                        // ✅ Repopulate the property type list
                        controller.propertyTypeList.value = propertyController.items.value
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

                        // controller.getPropertyType(propertyController.items);

                        Get.snackbar(
                          'Filters Cleared',
                          'All filters have been reset successfully',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: ColorRes.primary.withOpacity(0.8),
                          colorText: ColorRes.white,
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

                        Get.snackbar(
                          'Filters Applied',
                          'Your filters have been applied successfully',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: ColorRes.primary,
                          colorText: ColorRes.white,
                        );
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
              SizedBox(height: 40),

            ],
          ),
        ),
      ),
    );
  }
}
