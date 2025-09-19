import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/stepper_property.dart';

class PostProperty extends StatelessWidget {
  final CreatePropertyController controller;
  const PostProperty({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final List<String> pgFor = ['Girl', 'Boy'];
    final List<String> bestSuitedFor = ["Students", "Professionals"];
    final List<String> mealList = ['Breakfast', 'Lunch', "Dinner"];
    final List<String> commonArea = [
      'Living Rooms',
      'Kitchens',
      'Dining Hall',
      'Study Room',
      'Breakout Room',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),

        // Property Type
        buildSectionTitle("Property Type"),
        const SizedBox(height: 12),
        Obx(
          () => Row(
            children: [
              buildChoice(
                title: 'Residential',
                selected: controller.propertyType.value == 'Residential',
                onTap:
                    () => controller.setValue(
                      controller.propertyType,
                      'Residential',
                    ),
              ),
              const SizedBox(width: 12),
              buildChoice(
                title: 'Commercial',
                selected: controller.propertyType.value == 'Commercial',
                onTap:
                    () => controller.setValue(
                      controller.propertyType,
                      'Commercial',
                    ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Looking To
        buildSectionTitle("You're looking to..."),
        const SizedBox(height: 12),
        Obx(() {
          final isResidential = controller.propertyType.value == 'Residential';
          final options =
              isResidential
                  ? ['Rent', 'Sell', 'PG/Co-Living']
                  : ['Rent', 'Sell'];
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                options
                    .map(
                      (option) => buildChoice(
                        title: option,
                        selected: controller.lookingTo.value == option,
                        onTap:
                            () => controller.setValue(
                              controller.lookingTo,
                              option,
                            ),
                      ),
                    )
                    .toList(),
          );
        }),

        const SizedBox(height: 24),

        // City
        Text('City'),
        const SizedBox(height: 8),
        buildTextField("Search City", Icons.search, controller.cityController),
        const SizedBox(height: 16),

        // PG-specific fields
        Obx(() {
          final showPGFields =
              controller.lookingTo.value == "PG/Co-Living" &&
              controller.propertyType.value == "Residential";
          if (!showPGFields) return const SizedBox();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Locality
              Text('Locality'),
              const SizedBox(height: 8),
              buildTextField(
                "Enter Locality",
                Icons.location_on_outlined,
                controller.nameController,
              ),
              const SizedBox(height: 16),

              // PG Details
              buildSectionTitle("PG Details"),
              const SizedBox(height: 8),
              buildTextField(
                "PG Name",
                Icons.home_work_outlined,
                controller.pgNameController,
              ),
              const SizedBox(height: 16),
              buildTextField(
                "Total Bed",
                Icons.bed_outlined,
                controller.pgNameController,
              ),
              const SizedBox(height: 16),

              // PG for
              buildSectionTitle("PG for"),
              const SizedBox(height: 8),
              Obx(
                () => MultiSelectChip(
                  options: pgFor,
                  selectedItems: controller.selectedItems.value,
                  onTap:
                      (option) => controller.toggleItemInList(
                        controller.selectedItems,
                        option,
                      ),
                ),
              ),
              const SizedBox(height: 16),

              // Best Suited for
              buildSectionTitle("Best Suited for"),
              const SizedBox(height: 8),
              Obx(
                () => MultiSelectChip(
                  options: bestSuitedFor,
                  selectedItems: controller.bestSuitedList.value,
                  onTap:
                      (option) => controller.toggleItemInList(
                        controller.bestSuitedList,
                        option,
                      ),
                ),
              ),
              const SizedBox(height: 16),

              // Meal Available
              buildSectionTitle("Meal Available"),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  children: [
                    buildChoice(
                      title: 'Yes',
                      selected: controller.mealAvailable.value == 'Yes',
                      onTap:
                          () => controller.setValue(
                            controller.mealAvailable,
                            'Yes',
                          ),
                    ),
                    const SizedBox(width: 10),
                    buildChoice(
                      title: 'No',
                      selected: controller.mealAvailable.value == 'No',
                      onTap:
                          () => controller.setValue(
                            controller.mealAvailable,
                            'No',
                          ),
                    ),
                  ],
                ),
              ),

              // Additional fields if meal is Yes (optional)
              Obx(() {
                if (controller.mealAvailable.value == "Yes") {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Meal Available
                      buildSectionTitle("Meal offering"),
                      const SizedBox(height: 8),
                      MultiSelectChip(
                        options: mealList,
                        selectedItems: controller.mealAvailableList.value,
                        onTap: (option) {
                          controller.toggleItemInList(
                            controller.mealAvailableList,
                            option,
                          );
                        },
                      ),
                    ],
                  );
                }
                return SizedBox.shrink();
              }),
              const SizedBox(height: 16),
              buildTextField(
                'Notice Period (Days)',
                Icons.calendar_month_outlined,
                controller.noticPeriodController,
                isPhoneKey: true,
              ),
              const SizedBox(height: 16),
              buildTextField(
                'Lock in Period (Days)',
                Icons.calendar_month_outlined,
                controller.lockPeriodController,
                isPhoneKey: true,
              ),
              const SizedBox(height: 16),
              buildSectionTitle("Common Areas"),
              const SizedBox(height: 8),
              Obx(
                () => MultiSelectChip(
                  options: commonArea,
                  selectedItems: controller.commonAreasList.value,
                  onTap:
                      (option) => controller.toggleItemInList(
                        controller.commonAreasList,
                        option,
                      ),
                ),
              ),
            ],
          );
        }),

        // Commercial-specific fields
        Obx(() {
          if (controller.propertyType.value != "Commercial")
            return const SizedBox();
          return Column(
            children: [const SizedBox(height: 24), subPropertyType(controller)],
          );
        }),

        const SizedBox(height: 28),

        // Next Button
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            onPressed: () {
              print("${controller.bestSuitedList} ${controller.selectedItems}");
              if (controller.stepIndex.value < 3) {
                controller.nextStep(); // move to next step
              } else {
                controller.submitForm(); // final submit
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorRes.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
            ),
            child: const Text(
              "Next, add Property detail",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
