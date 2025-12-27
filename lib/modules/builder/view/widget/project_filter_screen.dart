// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:housing_flutter_app/modules/builder/controller/project_filter_controller.dart';
// // import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
// // import 'package:housing_flutter_app/widgets/New%20folder/inputs/text_field.dart';
// //
// // import '../../../search_property/model/search_model.dart';
// // import '../../../search_property/view/search_screen.dart';
// //
// // class ProjectFilterScreen extends StatelessWidget {
// //   final Function(Map<String, dynamic>) onApply;
// //   final Map<String, dynamic>? initialFilters;
// //
// //   ProjectFilterScreen({super.key, required this.onApply, this.initialFilters});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final controller = Get.put(ProjectFilterController());
// //
// //     // -----------------------------
// //     // 🔥 SET INITIAL FILTER VALUES
// //     // -----------------------------
// //     if (initialFilters != null) {
// //       // PROPERTY TYPE
// //       if (initialFilters!["propertyTypes"] != null &&
// //           initialFilters!["propertyTypes"].toString().isNotEmpty) {
// //         controller.selectedPropertyType.value =
// //             initialFilters!["propertyTypes"];
// //       }
// //
// //       // CITY
// //       if (initialFilters!["city"] != null &&
// //           initialFilters!["city"].toString().isNotEmpty) {
// //         controller.selectedCity.value = initialFilters!["city"];
// //
// //         // Auto-load locality list
// //       }
// //
// //       // LOCALITY
// //       if (initialFilters!["location"] != null &&
// //           initialFilters!["location"].toString().isNotEmpty) {
// //         controller.selectedLocality.value = initialFilters!["location"];
// //       }
// //     }
// //     // ------------------------------
// //
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Filters"), elevation: 0),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // PROPERTY TYPE
// //               Obx(
// //                 () => _dropdown(
// //                   title: "Property Type",
// //                   value: controller.selectedPropertyType.value,
// //                   items: controller.propertyTypes,
// //                   onChanged: (val) {
// //                     controller.selectedPropertyType.value = val!;
// //                   },
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 16),
// //
// //               // CITY
// //               Obx(
// //                 () => _dropdown(
// //                   title: 'City',
// //                   hint: 'Select city',
// //                   value: controller.selectedCity.value,
// //                   items: controller.cityList.value,
// //                   onChanged: (val) {
// //                     controller.selectedCity.value = val!;
// //                     controller.selectedLocality.value = "";
// //                   },
// //                 ),
// //               ),
// //
// //               const SizedBox(height: 16),
// //
// //               // LOCALITY
// //               // Obx(() {
// //               //   bool enabled = controller.selectedCity.value != "All Cities";
// //               //
// //               //   return AbsorbPointer(
// //               //     absorbing: !enabled,
// //               //     child: Opacity(
// //               //       opacity: enabled ? 1 : 0.4,
// //               //       child: _dropdown(
// //               //         title: 'Locality',
// //               //         value:
// //               //             controller.selectedLocality.value.isEmpty
// //               //                 ? null
// //               //                 : controller.selectedLocality.value,
// //               //         items: controller.localityList,
// //               //         hint: "Select city first",
// //               //         onChanged: (val) {
// //               //           controller.selectedLocality.value = val!;
// //               //         },
// //               //       ),
// //               //     ),
// //               //   );
// //               // }),
// //               Obx(() {
// //                 bool enabled = controller.selectedCity.value != "All Cities";
// //
// //                 return GestureDetector(
// //                   onTap: () async {
// //                     Prediction selectedCity = await Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder:
// //                             (context) => CommonSearchField(
// //                               selectedCity: controller.selectedCity.value,
// //                               isLocality: true,
// //                               onCitySelected: (city) {
// //                                 Navigator.pop(context, city);
// //                               },
// //                               isFromAddProperty: true,
// //                               initialSearchText:
// //                                   controller.selectedLocality.value,
// //                               hintText: 'Locality',
// //                             ),
// //                       ),
// //                     );
// //
// //                     controller.selectedLocality.value =
// //                         selectedCity.description!.split(",").first ?? '';
// //                   },
// //                   child: AbsorbPointer(
// //                     absorbing: !enabled,
// //                     child: Opacity(
// //                       opacity: enabled ? 1 : 0.4,
// //                       child: NesticoPeTextField(
// //                         enabled: false,
// //                         controller: TextEditingController(
// //                           text: controller.selectedLocality.value,
// //                         ),
// //                         title: 'Locality',
// //                         hintText: 'Select city first',
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               }),
// //
// //               const SizedBox(height: 30),
// //
// //               // BUTTONS
// //               Row(
// //                 children: [
// //                   // RESET
// //                   Expanded(
// //                     child: OutlinedButton(
// //                       onPressed: controller.resetFilters,
// //                       child: const Text("Reset"),
// //                     ),
// //                   ),
// //
// //                   const SizedBox(width: 12),
// //
// //                   // APPLY
// //                   Expanded(
// //                     child: ElevatedButton(
// //                       onPressed: () {
// //                         final filterData = {
// //                           "propertyTypes":
// //                               controller.selectedPropertyType.value,
// //                           "city": controller.selectedCity.value,
// //                           "location": controller.selectedLocality.value,
// //                         };
// //
// //                         // Remove empty entries
// //                         final nonNullFilters = Map.fromEntries(
// //                           filterData.entries.where(
// //                             (e) =>
// //                                 e.value != null &&
// //                                 e.value.toString().trim().isNotEmpty,
// //                           ),
// //                         );
// //
// //                         onApply(nonNullFilters);
// //                       },
// //                       child: const Text("Apply"),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // DROPDOWN WIDGET
// //   Widget _dropdown({
// //     required String title,
// //     required String? value,
// //     required List<String> items,
// //     required Function(dynamic) onChanged,
// //     String? hint,
// //   }) {
// //     return NesticoPeDropdownField<String>(
// //       value: value,
// //       hintText: hint,
// //       title: title,
// //       items:
// //           items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
// //       onChanged: onChanged,
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/modules/builder/controller/project_filter_controller.dart';
// import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
// import 'package:housing_flutter_app/widgets/New%20folder/inputs/text_field.dart';
//
// import '../../../search_property/model/search_model.dart';
// import '../../../search_property/view/search_screen.dart';
//
// class ProjectFilterSheet extends StatelessWidget {
//   final Function(Map<String, dynamic>) onApply;
//   final Map<String, dynamic>? initialFilters;
//
//   const ProjectFilterSheet({
//     super.key,
//     required this.onApply,
//     this.initialFilters,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ProjectFilterController());
//
//     // -----------------------------
//     // 🔥 SET INITIAL FILTER VALUES
//     // -----------------------------
//     if (initialFilters != null) {
//       if (initialFilters!["propertyTypes"] != null &&
//           initialFilters!["propertyTypes"].toString().isNotEmpty) {
//         controller.selectedPropertyType.value = initialFilters!["propertyTypes"];
//       }
//       if (initialFilters!["city"] != null &&
//           initialFilters!["city"].toString().isNotEmpty) {
//         controller.selectedCity.value = initialFilters!["city"];
//       }
//       if (initialFilters!["location"] != null &&
//           initialFilters!["location"].toString().isNotEmpty) {
//         controller.selectedLocality.value = initialFilters!["location"];
//       }
//     }
//
//     // --------------------------------------------
//     // 🔽 Bottom Sheet Container
//     // --------------------------------------------
//     return DraggableScrollableSheet(
//       initialChildSize: 0.7, // starts at ~70% of screen height
//       minChildSize: 0.6,      // can collapse slightly
//       maxChildSize: 0.70,
//       expand: false,
//       builder: (context, scrollController) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: SingleChildScrollView(
//             controller: scrollController,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // --- HEADER ---
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                      Text(
//                       "Filters",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: AppFontWeights.semiBold,
//                         color: ColorRes.textColor
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Get.back(),
//                     ),
//                   ],
//                 ),
//                  Divider(
//                   color: ColorRes.leadGreyColor.shade200,
//
//                 ),
//                 const SizedBox(height: 12),
//
//                 // PROPERTY TYPE
//                 Obx(
//                       () => _dropdown(
//                     title: "Property Type",
//                     value: controller.selectedPropertyType.value,
//                     items: controller.propertyTypes,
//                     onChanged: (val) {
//                       controller.selectedPropertyType.value = val!;
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 // CITY
//                 Obx(
//                       () => _dropdown(
//                     title: 'City',
//                     hint: 'Select city',
//                     value: controller.selectedCity.value,
//                     items: controller.cityList.value,
//                     onChanged: (val) {
//                       controller.selectedCity.value = val!;
//                       controller.selectedLocality.value = "";
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 // LOCALITY
//                 Obx(() {
//                   bool enabled = controller.selectedCity.value != "All Cities";
//                   return GestureDetector(
//                     onTap: () async {
//                       Prediction selectedCity = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CommonSearchField(
//                             selectedCity: controller.selectedCity.value,
//                             isLocality: true,
//                             onCitySelected: (city) {
//                               Navigator.pop(context, city);
//                             },
//                             isFromAddProperty: true,
//                             initialSearchText:
//                             controller.selectedLocality.value,
//                             hintText: 'Locality',
//                           ),
//                         ),
//                       );
//                       controller.selectedLocality.value =
//                           selectedCity.description!.split(",").first ?? '';
//                     },
//                     child: AbsorbPointer(
//                       absorbing: !enabled,
//                       child: Opacity(
//                         opacity: enabled ? 1 : 0.4,
//                         child: NesticoPeTextField(
//                           enabled: false,
//                           controller: TextEditingController(
//                             text: controller.selectedLocality.value,
//                           ),
//                           title: 'Locality',
//                           hintText: 'Select city first',
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//
//                 const SizedBox(height: 30),
//
//                 // BUTTONS
//                 Row(
//                   children: [
//                     // RESET
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: controller.resetFilters,
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           "Reset",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//
//                     // APPLY
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           final filterData = {
//                             "propertyTypes":
//                             controller.selectedPropertyType.value,
//                             "city": controller.selectedCity.value,
//                             "location": controller.selectedLocality.value,
//                           };
//
//                           final nonNullFilters = Map.fromEntries(
//                             filterData.entries.where(
//                                   (e) =>
//                               e.value != null &&
//                                   e.value.toString().trim().isNotEmpty,
//                             ),
//                           );
//
//                           onApply(nonNullFilters);
//                           // Get.back();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           "Apply",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // 🔽 DROPDOWN WIDGET
//   Widget _dropdown({
//     required String title,
//     required String? value,
//     required List<String> items,
//     required Function(dynamic) onChanged,
//     String? hint,
//   }) {
//     return NesticoPeDropdownField<String>(
//       value: value,
//       hintText: hint,
//       fontWight: AppFontWeights.semiBold,
//       darkText: true,
//       title: title,
//       items:
//       items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//       onChanged: onChanged,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import 'package:housing_flutter_app/modules/builder/controller/project_filter_controller.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/text_field.dart';
import '../../../../app/manager/icon_manager.dart';
import '../../../filter_property/view/filter_screen.dart';
import '../../../filter_property/view/widget/buy_componet/buy_component.dart';
import '../../../filter_property/view/widget/common_component/bhk_list.dart';
import '../../../filter_property/view/widget/common_component/budget_filter.dart';
import '../../../search_property/model/search_model.dart';
import '../../../search_property/view/search_screen.dart';

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
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      "Property Has Photos",
                      controller.isPropertyHaveImage,
                    ),
                    SizedBox(height: 10),
                    buildToggle(
                      "Property Has Videos",
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
                                        borderRadius: BorderRadius.circular(
                                          12,
                                        ),
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
                                            amenity.title,
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
                                              fontSize:
                                                  AppFontSizes.extraSmall,
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
              Row(
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
                              controller.selectedPropertyType.value.toString(),
                          "city": controller.selectedCity.value.toString(),
                          "location": controller.selectedLocality.value.toString(),
                          'reraId': controller.isRERAVerified.value.toString(),
                          'hasPhotos': controller.isPropertyHaveImage.value.toString(),
                          'hasVideos': controller.isPropertyHaveVideo.value.toString(),
                          'hasBrochure': controller.isPropertyHaveBroucher.value.toString(),
                          'minPrice': controller.min.value.toString(),
                          'maxPrice':controller.max.value.toString(),
                          'bhk':controller.bhkType.value.toString(),
                         if(controller.amenities.isNotEmpty)
                           'amenities': controller.amenities.value.map(
                                 (e) => e.toLowerCase().replaceAll(" ", "_"),
                           ).toString(),
                        };

                        final nonNullFilters = Map.fromEntries(
                          filterData.entries.where(
                            (e) =>
                                e.value != null &&
                                e.value.toString().trim().isNotEmpty,
                          ),
                        );

                        onApply(nonNullFilters);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
            ],
          ),
        ),
      ),
    );
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
