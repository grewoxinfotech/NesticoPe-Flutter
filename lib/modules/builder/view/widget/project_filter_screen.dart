import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/builder/controller/project_filter_controller.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/text_field.dart';

import '../../../search_property/model/search_model.dart';
import '../../../search_property/view/search_screen.dart';

class ProjectFilterScreen extends StatelessWidget {
  final Function(Map<String, dynamic>) onApply;
  final Map<String, dynamic>? initialFilters;

  ProjectFilterScreen({super.key, required this.onApply, this.initialFilters});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectFilterController());

    // -----------------------------
    // 🔥 SET INITIAL FILTER VALUES
    // -----------------------------
    if (initialFilters != null) {
      // PROPERTY TYPE
      if (initialFilters!["propertyTypes"] != null &&
          initialFilters!["propertyTypes"].toString().isNotEmpty) {
        controller.selectedPropertyType.value =
            initialFilters!["propertyTypes"];
      }

      // CITY
      if (initialFilters!["city"] != null &&
          initialFilters!["city"].toString().isNotEmpty) {
        controller.selectedCity.value = initialFilters!["city"];

        // Auto-load locality list
      }

      // LOCALITY
      if (initialFilters!["location"] != null &&
          initialFilters!["location"].toString().isNotEmpty) {
        controller.selectedLocality.value = initialFilters!["location"];
      }
    }
    // ------------------------------

    return Scaffold(
      appBar: AppBar(title: const Text("Filters"), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
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

              // LOCALITY
              // Obx(() {
              //   bool enabled = controller.selectedCity.value != "All Cities";
              //
              //   return AbsorbPointer(
              //     absorbing: !enabled,
              //     child: Opacity(
              //       opacity: enabled ? 1 : 0.4,
              //       child: _dropdown(
              //         title: 'Locality',
              //         value:
              //             controller.selectedLocality.value.isEmpty
              //                 ? null
              //                 : controller.selectedLocality.value,
              //         items: controller.localityList,
              //         hint: "Select city first",
              //         onChanged: (val) {
              //           controller.selectedLocality.value = val!;
              //         },
              //       ),
              //     ),
              //   );
              // }),
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
                      child: const Text("Reset"),
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

                        // Remove empty entries
                        final nonNullFilters = Map.fromEntries(
                          filterData.entries.where(
                            (e) =>
                                e.value != null &&
                                e.value.toString().trim().isNotEmpty,
                          ),
                        );

                        onApply(nonNullFilters);
                      },
                      child: const Text("Apply"),
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

  // DROPDOWN WIDGET
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
      title: title,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
