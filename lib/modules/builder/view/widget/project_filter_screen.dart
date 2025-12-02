// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/modules/builder/controller/project_filter_controller.dart';
// import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
// import 'package:housing_flutter_app/widgets/New%20folder/inputs/text_field.dart';
//
// import '../../../search_property/model/search_model.dart';
// import '../../../search_property/view/search_screen.dart';
//
// class ProjectFilterScreen extends StatelessWidget {
//   final Function(Map<String, dynamic>) onApply;
//   final Map<String, dynamic>? initialFilters;
//
//   ProjectFilterScreen({super.key, required this.onApply, this.initialFilters});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ProjectFilterController());
//
//     // -----------------------------
//     // 🔥 SET INITIAL FILTER VALUES
//     // -----------------------------
//     if (initialFilters != null) {
//       // PROPERTY TYPE
//       if (initialFilters!["propertyTypes"] != null &&
//           initialFilters!["propertyTypes"].toString().isNotEmpty) {
//         controller.selectedPropertyType.value =
//             initialFilters!["propertyTypes"];
//       }
//
//       // CITY
//       if (initialFilters!["city"] != null &&
//           initialFilters!["city"].toString().isNotEmpty) {
//         controller.selectedCity.value = initialFilters!["city"];
//
//         // Auto-load locality list
//       }
//
//       // LOCALITY
//       if (initialFilters!["location"] != null &&
//           initialFilters!["location"].toString().isNotEmpty) {
//         controller.selectedLocality.value = initialFilters!["location"];
//       }
//     }
//     // ------------------------------
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Filters"), elevation: 0),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // PROPERTY TYPE
//               Obx(
//                 () => _dropdown(
//                   title: "Property Type",
//                   value: controller.selectedPropertyType.value,
//                   items: controller.propertyTypes,
//                   onChanged: (val) {
//                     controller.selectedPropertyType.value = val!;
//                   },
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // CITY
//               Obx(
//                 () => _dropdown(
//                   title: 'City',
//                   hint: 'Select city',
//                   value: controller.selectedCity.value,
//                   items: controller.cityList.value,
//                   onChanged: (val) {
//                     controller.selectedCity.value = val!;
//                     controller.selectedLocality.value = "";
//                   },
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               // LOCALITY
//               // Obx(() {
//               //   bool enabled = controller.selectedCity.value != "All Cities";
//               //
//               //   return AbsorbPointer(
//               //     absorbing: !enabled,
//               //     child: Opacity(
//               //       opacity: enabled ? 1 : 0.4,
//               //       child: _dropdown(
//               //         title: 'Locality',
//               //         value:
//               //             controller.selectedLocality.value.isEmpty
//               //                 ? null
//               //                 : controller.selectedLocality.value,
//               //         items: controller.localityList,
//               //         hint: "Select city first",
//               //         onChanged: (val) {
//               //           controller.selectedLocality.value = val!;
//               //         },
//               //       ),
//               //     ),
//               //   );
//               // }),
//               Obx(() {
//                 bool enabled = controller.selectedCity.value != "All Cities";
//
//                 return GestureDetector(
//                   onTap: () async {
//                     Prediction selectedCity = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder:
//                             (context) => CommonSearchField(
//                               selectedCity: controller.selectedCity.value,
//                               isLocality: true,
//                               onCitySelected: (city) {
//                                 Navigator.pop(context, city);
//                               },
//                               isFromAddProperty: true,
//                               initialSearchText:
//                                   controller.selectedLocality.value,
//                               hintText: 'Locality',
//                             ),
//                       ),
//                     );
//
//                     controller.selectedLocality.value =
//                         selectedCity.description!.split(",").first ?? '';
//                   },
//                   child: AbsorbPointer(
//                     absorbing: !enabled,
//                     child: Opacity(
//                       opacity: enabled ? 1 : 0.4,
//                       child: NesticoPeTextField(
//                         enabled: false,
//                         controller: TextEditingController(
//                           text: controller.selectedLocality.value,
//                         ),
//                         title: 'Locality',
//                         hintText: 'Select city first',
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//
//               const SizedBox(height: 30),
//
//               // BUTTONS
//               Row(
//                 children: [
//                   // RESET
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: controller.resetFilters,
//                       child: const Text("Reset"),
//                     ),
//                   ),
//
//                   const SizedBox(width: 12),
//
//                   // APPLY
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         final filterData = {
//                           "propertyTypes":
//                               controller.selectedPropertyType.value,
//                           "city": controller.selectedCity.value,
//                           "location": controller.selectedLocality.value,
//                         };
//
//                         // Remove empty entries
//                         final nonNullFilters = Map.fromEntries(
//                           filterData.entries.where(
//                             (e) =>
//                                 e.value != null &&
//                                 e.value.toString().trim().isNotEmpty,
//                           ),
//                         );
//
//                         onApply(nonNullFilters);
//                       },
//                       child: const Text("Apply"),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // DROPDOWN WIDGET
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
//       title: title,
//       items:
//           items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
//       onChanged: onChanged,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/builder/controller/project_filter_controller.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/text_field.dart';

import '../../../search_property/model/search_model.dart';
import '../../../search_property/view/search_screen.dart';

class ProjectFilterSheet extends StatelessWidget {
  final Function(Map<String, dynamic>) onApply;
  final Map<String, dynamic>? initialFilters;

  const ProjectFilterSheet({
    super.key,
    required this.onApply,
    this.initialFilters,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectFilterController());

    // -----------------------------
    // 🔥 SET INITIAL FILTER VALUES
    // -----------------------------
    if (initialFilters != null) {
      if (initialFilters!["propertyTypes"] != null &&
          initialFilters!["propertyTypes"].toString().isNotEmpty) {
        controller.selectedPropertyType.value = initialFilters!["propertyTypes"];
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

    // --------------------------------------------
    // 🔽 Bottom Sheet Container
    // --------------------------------------------
    return DraggableScrollableSheet(
      initialChildSize: 0.7, // starts at ~70% of screen height
      minChildSize: 0.6,      // can collapse slightly
      maxChildSize: 0.70,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      "Filters",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textColor
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                 Divider(
                  color: ColorRes.leadGreyColor.shade200,

                ),
                const SizedBox(height: 12),

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

                // LOCALITY
                Obx(() {
                  bool enabled = controller.selectedCity.value != "All Cities";
                  return GestureDetector(
                    onTap: () async {
                      Prediction selectedCity = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommonSearchField(
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
                            controller.selectedPropertyType.value,
                            "city": controller.selectedCity.value,
                            "location": controller.selectedLocality.value,
                          };

                          final nonNullFilters = Map.fromEntries(
                            filterData.entries.where(
                                  (e) =>
                              e.value != null &&
                                  e.value.toString().trim().isNotEmpty,
                            ),
                          );

                          onApply(nonNullFilters);
                          // Get.back();
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
        );
      },
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
