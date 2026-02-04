import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart'
    hide Obx;
import 'package:housing_flutter_app/modules/add_property/view/widget/stepper_property.dart';
import 'package:housing_flutter_app/modules/search_property/model/search_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../utils/common_widget/validator/area_validator.dart';
import '../../../search_property/view/search_screen.dart';
import 'package:flutter/material.dart';

class PostProperty extends StatelessWidget {
  final CreatePropertyController controller;
  final GlobalKey<FormState>? formKey;

  const PostProperty({super.key, required this.controller, this.formKey});

  @override
  Widget build(BuildContext context) {
    final List<String> pgFor = ["Boys", "Girls", "Co-ed"];
    final List<String> bestSuitedFor = [
      "Students",
      "Working Professionals",
      "Family",
      "Other",
    ];
    final List<String> mealList = ['breakfast', 'lunch', 'dinner'];
    final List<String> furnishingList = [
      'Fully Furnished',
      'Semi Furnished',
      'Unfurnished',
    ];
    final commercial_ownerShipList = [
      'Freehold',
      'Leaser hold',
      'Cooperative',
      'Power of attorney',
    ];

    final List<String> propertyType = [
      'Apartment',
      'Independent House',
      'Villa',
      'Duplex',
      'Studio',
      'Penthouse',
      'Farmhouse',
      'Independent Floor',
    ];
    final List<String> sellPropertyType = [
      'Apartment',
      'Independent House',
      'Villa',
      'Duplex',
      'Studio',
      'Penthouse',
      'Farmhouse',
      'Independent Floor',
      'Plot',
      'Agricultural Land',
    ];
    final commercial_construction_status = [
      'No wall',
      "Brick walls",
      "Cemented walls",
      "Plastered walls",
    ];
    final List<String> commercial_propertyComditon = [
      'Ready to use',
      'Bare Shell',
    ];

    /// dgfhydf23E
    final posession_Status = ["Ready to move", "Under Construction"];

    final List<String> commonArea = [
      'Living Rooms',
      'Kitchens',
      'Dining Hall',
      'Study Room',
      'Breakout Room',
    ];
    final List<String> propertyManagedBy = [
      'Landlord',
      'Caretaker',
      'Professional',
    ];
    final List<String> tenantType = ['Student', 'Company', 'Family', 'Any'];
    final List<String> bhkTypes = [
      "1 BHK",
      "2 BHK",
      "3 BHK",
      "4 BHK",
      "5 BHK",
      "6 BHK",
      "7 BHK",
      "8 BHK",
      "9 BHK",
      "10 BHK",
    ];

    return Obx(() {
      print(
        "Chrvloefjeri ${controller.lookingTo.value == 'Sell'} ${controller.propertyType.value == "Commercial"} ${(controller.lookingTo.value == 'Rent' && controller.propertyType.value == "Commercial")}",
      );
      if (controller.lookingTo.value == 'PG/Co-Living') {
        return Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
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
                      onTap: () {
                        controller.previousStep();
                        controller.setValue(
                          controller.propertyType,
                          'Commercial',
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Looking To
              buildSectionTitle("You're looking to..."),
              const SizedBox(height: 12),
              Obx(() {
                final isResidential =
                    controller.propertyType.value == 'Residential';
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
                            (option) => GestureDetector(
                              onTap: () {
                                controller.setValue(
                                  controller.lookingTo,
                                  option,
                                );
                                if (option != 'PG/Co-Living') {
                                  controller.previousStep();
                                }
                              },
                              child: buildChoice(
                                title: option,
                                selected: controller.lookingTo.value == option,
                                onTap: () {
                                  controller.setValue(
                                    controller.lookingTo,
                                    option,
                                  );
                                  if (option != 'PG/Co-Living') {
                                    controller.previousStep();
                                  }
                                },
                              ),
                            ),
                          )
                          .toList(),
                );
              }),
              const SizedBox(height: 24),

              // City
              const Text('City'),
              const SizedBox(height: 8),
              buildTextField(
                "Search City",
                Icons.search,
                controller.cityController,
                isEnable: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a city';
                  }
                  return null;
                },
                onTap: () async {
                  Prediction selectedCity = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CommonSearchField(
                            onlySearchCity: true,
                            onCitySelected: (city) {
                              Navigator.pop(context, city);
                            },
                            isFromAddProperty: true,
                            initialSearchText: controller.cityController.text,
                          ),
                    ),
                  );

                  controller.cityController.text =
                      selectedCity.structuredFormatting?.secondaryText?.split(
                        ',',
                      )[0] ??
                      '';

                  print("city ${controller.cityController.text}");
                },
              ),
              const SizedBox(height: 16),

              // PG-specific fields
              Obx(() {
                final showPGFields =
                    controller.lookingTo.value == "PG/Co-Living" &&
                    controller.propertyType.value == "Residential";

                if (showPGFields) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Locality
                      const Text('Locality'),
                      const SizedBox(height: 8),
                      buildTextField(
                        "Enter Locality",
                        Icons.location_on_outlined,
                        controller.localityController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please add locality';
                          }
                          return null;
                        },
                        onTap: () async {
                          Prediction selectedCity = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => CommonSearchField(
                                    selectedCity:
                                        controller.cityController.text,
                                    isLocality: true,
                                    onCitySelected: (city) {
                                      Navigator.pop(context, city);
                                    },
                                    isFromAddProperty: true,
                                    initialSearchText:
                                        controller
                                                .localityController
                                                .text
                                                .isEmpty
                                            ? ''
                                            : controller
                                                .localityController
                                                .text,
                                    hintText: 'Locality',
                                  ),
                            ),
                          );

                          controller.localityController.text =
                              selectedCity.description ?? '';

                          print(
                            "city ${controller.localityController.text}  $selectedCity",
                          );
                        },
                        isEnable: false,
                      ),
                      const SizedBox(height: 16),

                      // PG Details
                      buildSectionTitle("PG Details"),
                      const SizedBox(height: 8),
                      buildTextField(
                        "PG Name",
                        Icons.home_work_outlined,
                        controller.pgNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter PG Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      buildSectionTitle("Total Bed"),
                      const SizedBox(height: 8),
                      buildTextField(
                        'Enter total bed',
                        Icons.bed_outlined,
                        controller.totalRoomsController,
                        isPhoneKey: true,
                        // isEnable: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter total bed';
                          }
                          final onlyDigits = RegExp(r'^\d+$');
                          if (!onlyDigits.hasMatch(value)) {
                            return 'Enter digits only';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),
                      buildSectionTitle("PG for"),
                      const SizedBox(height: 8),
                      // MultiSelectChip(
                      //   options: pgFor,
                      //   selectedItems: controller.selectedItems,
                      //   onTap:
                      //       (option) => controller.toggleItemInList(
                      //         controller.selectedItems,
                      //         option,
                      //       ),
                      // ),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children:
                            pgFor.map((option) {
                              return buildChoice(
                                title: option,
                                selected: controller.pgFor.value == option,
                                onTap: () {
                                  controller.setValue(controller.pgFor, option);
                                },
                              );
                            }).toList(),
                      ),

                      const SizedBox(height: 16),

                      // Best Suited for
                      buildSectionTitle("Best Suited for"),
                      const SizedBox(height: 8),
                      MultiSelectChip(
                        options: bestSuitedFor,
                        selectedItems: controller.bestSuitedList,
                        onTap:
                            (option) => controller.toggleItemInList(
                              controller.bestSuitedList,
                              option,
                            ),
                      ),
                      const SizedBox(height: 16),
                      buildSectionTitle('Furnishing'),
                      SizedBox(height: 8),
                      Obx(
                        () => Wrap(
                          runSpacing: 12,
                          spacing: 12,

                          children:
                              furnishingList
                                  .map(
                                    (type) => buildChoice(
                                      title: type,
                                      selected:
                                          controller.furnishingType.value ==
                                          type,
                                      onTap:
                                          () => controller.setValue(
                                            controller.furnishingType,
                                            type,
                                          ),
                                    ),
                                  )
                                  .toList(),
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
                                selectedItems: controller.mealAvailableList,
                                onTap: (option) {
                                  controller.toggleItemInList(
                                    controller.mealAvailableList,
                                    option,
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              buildSectionTitle("Meal Charges"),
                              const SizedBox(height: 8),
                              Obx(
                                () => Row(
                                  children: [
                                    buildChoice(
                                      title: 'Included in Rent',
                                      selected:
                                          controller.mealCharges.value ==
                                          'Included in Rent',
                                      onTap:
                                          () => controller.setValue(
                                            controller.mealCharges,
                                            'Included in Rent',
                                          ),
                                    ),
                                    const SizedBox(width: 10),
                                    buildChoice(
                                      title: 'Separate',
                                      selected:
                                          controller.mealCharges.value ==
                                          'Separate',
                                      onTap:
                                          () => controller.setValue(
                                            controller.mealCharges,
                                            'Separate',
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              if (controller.mealCharges.value ==
                                  "Separate") ...[
                                const SizedBox(height: 16),
                                buildSectionTitle("Meal Charges per Month"),
                                const SizedBox(height: 12),
                                buildTextField(
                                  "Enter meal Charges",
                                  isPhoneKey: true,
                                  Icons.currency_rupee_outlined,
                                  controller.mealChargesTextFiled,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter meal charges';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      }),

                      Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            buildSectionTitle("Electricity Charges"),
                            const SizedBox(height: 8),
                            Obx(
                              () => Row(
                                children: [
                                  buildChoice(
                                    title: 'Included in Rent',
                                    selected:
                                        controller.electricityCharges.value ==
                                        'Included in Rent',
                                    onTap:
                                        () => controller.setValue(
                                          controller.electricityCharges,
                                          'Included in Rent',
                                        ),
                                  ),
                                  const SizedBox(width: 10),
                                  buildChoice(
                                    title: 'Separate',
                                    selected:
                                        controller.electricityCharges.value ==
                                        'Separate',
                                    onTap:
                                        () => controller.setValue(
                                          controller.electricityCharges,
                                          'Separate',
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            if (controller.electricityCharges.value ==
                                "Separate") ...[
                              const SizedBox(height: 16),
                              buildSectionTitle(
                                "Electricity Charges per Month",
                              ),
                              const SizedBox(height: 12),
                              buildTextField(
                                "Enter electricity Charges",
                                isPhoneKey: true,
                                Icons.currency_rupee_outlined,
                                controller.electricityChargesTextFiled,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter electricity charges';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ],
                        );
                      }),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          buildSectionTitle("PG Rules Available"),
                          const SizedBox(height: 8),
                          Obx(
                            () => Row(
                              children: [
                                buildChoice(
                                  title: 'Yes',
                                  selected:
                                      controller.pgRulesAvailable.value ==
                                      'Yes',
                                  onTap:
                                      () => controller.setValue(
                                        controller.pgRulesAvailable,
                                        'Yes',
                                      ),
                                ),
                                const SizedBox(width: 10),
                                buildChoice(
                                  title: 'No',
                                  selected:
                                      controller.pgRulesAvailable.value == 'No',
                                  onTap:
                                      () => controller.setValue(
                                        controller.pgRulesAvailable,
                                        'No',
                                      ),
                                ),
                              ],
                            ),
                          ),
                          if (controller.pgRulesAvailable.value == "Yes") ...[
                            const SizedBox(height: 16),
                            buildSectionTitle("Non-Veg Allowed"),
                            const SizedBox(height: 12),
                            Obx(
                              () => Row(
                                children: [
                                  buildChoice(
                                    title: 'Yes',
                                    selected:
                                        controller.nonVegAllowed.value == 'Yes',
                                    onTap:
                                        () => controller.setValue(
                                          controller.nonVegAllowed,
                                          'Yes',
                                        ),
                                  ),
                                  const SizedBox(width: 10),
                                  buildChoice(
                                    title: 'No',
                                    selected:
                                        controller.nonVegAllowed.value == 'No',
                                    onTap:
                                        () => controller.setValue(
                                          controller.nonVegAllowed,
                                          'No',
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            buildSectionTitle("Smoking Allowed"),
                            const SizedBox(height: 12),
                            Obx(
                              () => Row(
                                children: [
                                  buildChoice(
                                    title: 'Yes',
                                    selected:
                                        controller.smokingAllowed.value ==
                                        'Yes',
                                    onTap:
                                        () => controller.setValue(
                                          controller.smokingAllowed,
                                          'Yes',
                                        ),
                                  ),
                                  const SizedBox(width: 10),
                                  buildChoice(
                                    title: 'No',
                                    selected:
                                        controller.smokingAllowed.value == 'No',
                                    onTap:
                                        () => controller.setValue(
                                          controller.smokingAllowed,
                                          'No',
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            buildSectionTitle("Drinking Allowed"),
                            const SizedBox(height: 12),
                            Obx(
                              () => Row(
                                children: [
                                  buildChoice(
                                    title: 'Yes',
                                    selected:
                                        controller.drinkingAllowed.value ==
                                        'Yes',
                                    onTap:
                                        () => controller.setValue(
                                          controller.drinkingAllowed,
                                          'Yes',
                                        ),
                                  ),
                                  const SizedBox(width: 10),
                                  buildChoice(
                                    title: 'No',
                                    selected:
                                        controller.drinkingAllowed.value ==
                                        'No',
                                    onTap:
                                        () => controller.setValue(
                                          controller.drinkingAllowed,
                                          'No',
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            buildSectionTitle("Pets Allowed"),
                            const SizedBox(height: 12),
                            Obx(
                              () => Row(
                                children: [
                                  buildChoice(
                                    title: 'Yes',
                                    selected:
                                        controller.petAllowed.value == 'Yes',
                                    onTap:
                                        () => controller.setValue(
                                          controller.petAllowed,
                                          'Yes',
                                        ),
                                  ),
                                  const SizedBox(width: 10),
                                  buildChoice(
                                    title: 'No',
                                    selected:
                                        controller.petAllowed.value == 'No',
                                    onTap:
                                        () => controller.setValue(
                                          controller.petAllowed,
                                          'No',
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            buildSectionTitle("Late Entry Allowed"),
                            const SizedBox(height: 12),
                            Obx(
                              () => Row(
                                children: [
                                  buildChoice(
                                    title: 'Yes',
                                    selected:
                                        controller.letEntryAllowed.value ==
                                        'Yes',
                                    onTap:
                                        () => controller.setValue(
                                          controller.letEntryAllowed,
                                          'Yes',
                                        ),
                                  ),
                                  const SizedBox(width: 10),
                                  buildChoice(
                                    title: 'No',
                                    selected:
                                        controller.letEntryAllowed.value ==
                                        'No',
                                    onTap:
                                        () => controller.setValue(
                                          controller.letEntryAllowed,
                                          'No',
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            buildSectionTitle("Visitors Allowed"),
                            const SizedBox(height: 12),
                            Obx(
                              () => Row(
                                children: [
                                  buildChoice(
                                    title: 'Yes',
                                    selected:
                                        controller.visitorsAllowed.value ==
                                        'Yes',
                                    onTap:
                                        () => controller.setValue(
                                          controller.visitorsAllowed,
                                          'Yes',
                                        ),
                                  ),
                                  const SizedBox(width: 10),
                                  buildChoice(
                                    title: 'No',
                                    selected:
                                        controller.visitorsAllowed.value ==
                                        'No',
                                    onTap:
                                        () => controller.setValue(
                                          controller.visitorsAllowed,
                                          'No',
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 16),
                      buildSectionTitle("Property Managed By"),
                      SizedBox(height: 8),
                      Obx(
                        () => Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children:
                              propertyManagedBy.map((option) {
                                return buildChoice(
                                  title: option,
                                  selected:
                                      controller.propertyManagedBy.value ==
                                      option,
                                  onTap: () {
                                    controller.setValue(
                                      controller.propertyManagedBy,
                                      option,
                                    );
                                  },
                                );
                              }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildSectionTitle("Property Manager stays at Property"),
                      const SizedBox(height: 12),
                      Obx(
                        () => Row(
                          children: [
                            buildChoice(
                              title: 'Yes',
                              selected:
                                  controller.managerStaysAtProperty.value ==
                                  'Yes',
                              onTap:
                                  () => controller.setValue(
                                    controller.managerStaysAtProperty,
                                    'Yes',
                                  ),
                            ),
                            const SizedBox(width: 10),
                            buildChoice(
                              title: 'No',
                              selected:
                                  controller.managerStaysAtProperty.value ==
                                  'No',
                              onTap:
                                  () => controller.setValue(
                                    controller.managerStaysAtProperty,
                                    'No',
                                  ),
                            ),
                          ],
                        ),
                      ),

                      // const SizedBox(height: 16),
                      const SizedBox(height: 16),

                      // PG Details
                      buildSectionTitle("Notice Period"),
                      const SizedBox(height: 8),
                      buildTextField(
                        'Enter notice period (Days)',
                        Icons.calendar_month_outlined,

                        controller.noticPeriodController,
                        isPhoneKey: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter notice period';
                          }
                          final onlyDigits = RegExp(r'^\d+$');
                          if (!onlyDigits.hasMatch(value)) {
                            return 'Enter digits only';
                          }
                          return null;
                        },

                        // isEnable: false,
                        // isEnable:      ,
                      ),
                      const SizedBox(height: 16),

                      // PG Details
                      buildSectionTitle("Lock in Period"),
                      const SizedBox(height: 8),
                      buildTextField(
                        'Enter lock in period (Days)',
                        Icons.calendar_month_outlined,
                        controller.lockPeriodController,
                        isPhoneKey: true,
                        // isEnable: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter lock in period';
                          }
                          final onlyDigits = RegExp(r'^\d+$');
                          if (!onlyDigits.hasMatch(value)) {
                            return 'Enter digits only';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      buildSectionTitle("Common Areas"),
                      const SizedBox(height: 8),
                      MultiSelectChip(
                        options: commonArea,
                        selectedItems: controller.commonAreasList,
                        onTap:
                            (option) => controller.toggleItemInList(
                              controller.commonAreasList,
                              option,
                            ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              }),

              // Commercial-specific fields
              Obx(() {
                if (controller.propertyType.value != "Commercial") {
                  return const SizedBox();
                }
                return Column(
                  children: [
                    const SizedBox(height: 24),
                    subPropertyType(controller),
                  ],
                );
              }),

              const SizedBox(height: 28),
            ],
          ),
        );
      } else if ((controller.lookingTo.value == 'Rent' ||
              controller.lookingTo.value == 'Sell') &&
          controller.propertyType.value == 'Residential') {
        return Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              buildSectionTitle("Property Type"),
              SizedBox(height: 12),
              Obx(
                () =>
                    (controller.lookingTo.value == "Rent")
                        ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            spacing: 12,
                            children:
                                propertyType
                                    .map(
                                      (type) => buildChoice(
                                        title: type,
                                        selected:
                                            controller
                                                .rent_propertyType
                                                .value ==
                                            type,
                                        onTap: () {
                                          controller.setValue(
                                            controller.rent_propertyType,
                                            type,
                                          );
                                          controller
                                                  .showPropertyTypeError
                                                  .value =
                                              false; // Hide error on selection
                                        },
                                      ),
                                    )
                                    .toList(),
                          ),
                        )
                        : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            spacing: 12,
                            children:
                                sellPropertyType
                                    .map(
                                      (type) => buildChoice(
                                        title: type,
                                        selected:
                                            controller
                                                .rent_propertyType
                                                .value ==
                                            type,
                                        onTap: () {
                                          controller.setValue(
                                            controller.rent_propertyType,
                                            type,
                                          );
                                          controller
                                                  .showPropertyTypeError
                                                  .value =
                                              false; // Hide error on selection
                                        },
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
              ),

              if ((controller.rent_propertyType.value == "Plot") ||
                  (controller.rent_propertyType.value ==
                      "Agricultural Land")) ...[
                SizedBox(height: 16),
                Text("Plot Area"),
                SizedBox(height: 6),
                TextFieldWithDropdown(
                  hintText: "Plot Area",
                  icon: Icons.square_foot,
                  controller: controller.commercial_plot,

                  selectedValue: controller.commercial_plotArea,
                  // RxString
                  dropdownItems: ['sq.ft.', 'sq.yd.', 'sq.mt.'],
                  isPhoneKey: true,
                ),
                const Text('Locality'),
                SizedBox(height: 8),
                buildTextField(
                  'Locality',
                  Icons.location_on,
                  controller.localityController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter locality';
                    }
                    return null;
                  },
                  onTap:
                      (controller.localityController.text.trim().isEmpty)
                          ? () async {
                            Prediction selectedCity = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => CommonSearchField(
                                      selectedCity:
                                          controller.cityController.text,
                                      isLocality: true,
                                      onCitySelected: (city) {
                                        Navigator.pop(context, city);
                                      },
                                      isFromAddProperty: true,
                                      initialSearchText:
                                          controller.localityController.text,
                                      hintText: 'Locality',
                                    ),
                              ),
                            );

                            controller.localityController.text =
                                selectedCity.description ?? '';
                            controller.sell_rent_Address.text =
                                selectedCity.description ?? '';
                            print("city ${controller.localityController.text}");
                          }
                          : null,
                  isEnable: false,
                ),
                SizedBox(height: 16),
                const Text('Full Address'),
                SizedBox(height: 8),
                buildTextField(
                  'exact Address',
                  Icons.apartment_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter complete address';
                    }
                    return null;
                  },
                  controller.sell_rent_Address,
                  maxLines: 2,
                  minLines: 1,
                ),

                SizedBox(height: 16),
                Text("Length"),
                SizedBox(height: 6),
                buildTextField(
                  "Enter Plot Length",
                  isPhoneKey: true,
                  Icons.photo_size_select_large_rounded,
                  controller.plotLength,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter length';
                    }
                    return null;
                  },
                ),
                SizedBox(width: 16),
                SizedBox(height: 16),
                Text("Width"),
                SizedBox(height: 6),
                buildTextField(
                  "Enter Width Length",
                  Icons.photo_size_select_large_rounded,
                  controller.plotWidth,

                  isPhoneKey: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter width';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                buildSectionTitle("Ownership"),
                SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        commercial_ownerShipList
                            .map(
                              (e) => buildChoice(
                                title: e,
                                selected:
                                    controller.commercial_ownerShipList.value ==
                                    e,
                                onTap: () {
                                  controller.setValue(
                                    controller.commercial_ownerShipList,
                                    e,
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
                Obx(
                  () =>
                      controller.seletedOwnerShipInCommercial.value
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'Please select OwnerShip type',
                              style: TextStyle(
                                color: ColorRes.error.shade700,
                                fontSize: AppFontSizes.small,
                                // fontSize: 12,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
                SizedBox(height: 16),
                buildSectionTitle("Zone Type"),
                SizedBox(height: 8),

                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        controller.zoneType
                            .map(
                              (e) => buildChoice(
                                title: e.replaceAll("_"," ").capitalize.toString(),
                                selected:
                                    controller.commercial_ZoneType.value == e,
                                onTap: () {
                                  controller.setValue(
                                    controller.commercial_ZoneType,
                                    e,
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
                Obx(
                  () =>
                      controller.selectedZoneTypeInCommercial.value
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'Please select Zone type',
                              style: TextStyle(
                                color: ColorRes.error.shade700,
                                fontSize: AppFontSizes.bodySmall,
                                // fontSize: 12,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ] else ...[
                Obx(
                  () =>
                      controller.showPropertyTypeError.value
                          ? Padding(
                            padding: const EdgeInsets.only(top: 6, left: 4),
                            child: Text(
                              'Please select a property type',
                              style: TextStyle(
                                color: ColorRes.error,
                                fontSize: AppFontSizes.bodySmall,
                              ),
                            ),
                          )
                          : SizedBox.shrink(),
                ),
                SizedBox(height: 16),

                const Text('Locality'),
                SizedBox(height: 8),
                buildTextField(
                  'Locality',
                  Icons.location_on,
                  controller.localityController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter locality';
                    }
                    return null;
                  },
                  onTap:
                      (controller.localityController.text.trim().isEmpty)
                          ? () async {
                            Prediction selectedCity = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => CommonSearchField(
                                      selectedCity:
                                          controller.cityController.text,
                                      isLocality: true,
                                      onCitySelected: (city) {
                                        Navigator.pop(context, city);
                                      },
                                      isFromAddProperty: true,
                                      initialSearchText:
                                          controller.localityController.text,
                                      hintText: 'Locality',
                                    ),
                              ),
                            );

                            controller.localityController.text =
                                selectedCity.description ?? '';
                            controller.sell_rent_Address.text =
                                selectedCity.description ?? '';
                            print("city ${controller.localityController.text}");
                          }
                          : null,
                  isEnable: false,
                ),
                SizedBox(height: 16),
                const Text('Full Address'),
                SizedBox(height: 8),
                buildTextField(
                  'exact Address',
                  Icons.apartment_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter complete address';
                    }
                    return null;
                  },
                  controller.sell_rent_Address,
                  maxLines: 1,
                  minLines: 1,
                ),
                SizedBox(height: 16),
                buildSectionTitle('BHK'),
                SizedBox(height: 8),
                Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      children:
                          bhkTypes
                              .map(
                                (type) => buildChoice(
                                  title: type,
                                  selected: controller.bhkType.value == type,
                                  width: 80,
                                  onTap:
                                      () => controller.setValue(
                                        controller.bhkType,
                                        type,
                                      ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
                Obx(
                  () =>
                      controller.showBHKChooseToError.value
                          ? Padding(
                            padding: const EdgeInsets.only(top: 6, left: 4),
                            child: Text(
                              'Please select a BHK type',
                              style: TextStyle(
                                color: ColorRes.error,
                                fontSize: AppFontSizes.bodySmall,
                              ),
                            ),
                          )
                          : SizedBox.shrink(),
                ),

                if (controller.lookingTo.value == "Rent") ...[
                  SizedBox(height: 16),
                  buildSectionTitle('Tenant type'),
                  SizedBox(height: 8),
                  Obx(
                    () => Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          tenantType.map((option) {
                            return buildChoice(
                              title: option,
                              selected: controller.tenantType.value == option,
                              onTap: () {
                                controller.setValue(
                                  controller.tenantType,
                                  option,
                                );
                              },
                            );
                          }).toList(),
                    ),
                  ),
                ] else ...[
                  SizedBox(height: 16),
                  buildSectionTitle('Transaction Type'),
                  SizedBox(height: 8),
                  Obx(
                    () => Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          ['New Booking', 'Resale'].map((option) {
                            return buildChoice(
                              title: option,
                              selected:
                                  controller.transactionType.value == option,
                              onTap: () {
                                controller.setValue(
                                  controller.transactionType,
                                  option,
                                );
                              },
                            );
                          }).toList(),
                    ),
                  ),
                ],

                SizedBox(height: 16),
                const Text('Build Up Area'),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: buildTextField(
                        'Build Up Area',
                        Icons.square_foot,
                        controller.areaController,
                        isPhoneKey: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid area';
                          }

                          if (controller.bhkType.value.isEmpty) {
                            return 'Please select BHK type first';
                          }

                          final entered = int.tryParse(value);
                          if (entered == null) {
                            return 'Please enter a valid number';
                          }

                          // final range = AreaRangeHelper.getAreaRange(
                          //   controller.bhkType.value,
                          //   controller.areaUnit.value,
                          // );
                          //
                          // if (range[0] == 0 && range[1] == 0) {
                          //   return 'Please select BHK type first';
                          // }
                          //
                          // if (entered < range[0] || entered > range[1]) {
                          //   return 'Area must be between ${range[0]} - ${range[1]} ${controller.areaUnit.value}';
                          // }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: ColorRes.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ColorRes.leadGreyColor.shade400,
                        ),
                      ),
                      child: DropdownButton<String>(
                        value: controller.areaUnit.value,
                        items:
                            ['sq.ft.', 'sq.yd.', 'sq.mt.']
                                .map(
                                  (unit) => DropdownMenuItem(
                                    value: unit,
                                    child: Text(unit),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.areaUnit.value = value;
                            // Trigger revalidation when unit changes
                            if (formKey?.currentState != null) {
                              formKey!.currentState!.validate();
                            }
                          }
                        },
                        underline: Container(),
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          color: ColorRes.black,
                        ),
                        dropdownColor: ColorRes.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                const Text('Carpet Area'),
                // buildSectionTitle("Carpet Area"),
                SizedBox(height: 8),

                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          'Carpet Area',
                          Icons.square_foot_outlined,
                          controller.carpetAreaController,
                          isPhoneKey: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: ColorRes.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ColorRes.leadGreyColor.shade400,
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: controller.carpetAreaUnit.value,
                          items:
                              ['sq.ft.', 'sq.yd.', 'sq.mt.', 'sq.cm.', 'sq.in.']
                                  .map(
                                    (unit) => DropdownMenuItem(
                                      value: unit,
                                      child: Text(unit),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.carpetAreaUnit.value = value;
                            }
                          },
                          underline: Container(),
                          style: const TextStyle(
                            // fontSize: 12,
                            color: ColorRes.black,
                            fontSize: AppFontSizes.small,
                          ),
                          dropdownColor: ColorRes.white,
                        ),
                      ),
                    ],
                  ),
                ),
                if (controller.lookingTo.value == "Rent") ...[
                  const SizedBox(height: 16),

                  // PG Details
                  buildSectionTitle("Notice Period"),
                  const SizedBox(height: 8),
                  buildTextField(
                    'Enter notice period (Days)',
                    Icons.calendar_month_outlined,

                    controller.noticPeriodController,
                    isPhoneKey: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter notice period';
                      }
                      final onlyDigits = RegExp(r'^\d+$');
                      if (!onlyDigits.hasMatch(value)) {
                        return 'Enter digits only';
                      }
                      return null;
                    },

                    // isEnable: false,
                    // isEnable:      ,
                  ),
                  const SizedBox(height: 16),

                  // PG Details
                  buildSectionTitle("Lock in Period"),
                  const SizedBox(height: 8),
                  buildTextField(
                    'Enter lock in period (Days)',
                    Icons.calendar_month_outlined,
                    controller.lockPeriodController,
                    isPhoneKey: true,
                    // isEnable: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter lock in period';
                      }
                      final onlyDigits = RegExp(r'^\d+$');
                      if (!onlyDigits.hasMatch(value)) {
                        return 'Enter digits only';
                      }
                      return null;
                    },
                  ),
                ],

                SizedBox(height: 16),
                buildSectionTitle('Furnishing'),
                SizedBox(height: 8),
                Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      children:
                          furnishingList
                              .map(
                                (type) => buildChoice(
                                  title: type,
                                  selected:
                                      controller.furnishingType.value == type,
                                  onTap:
                                      () => controller.setValue(
                                        controller.furnishingType,
                                        type,
                                      ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      } else if (controller.propertyType.value == "Commercial" &&
          controller.lookingTo.value == "Rent" &&
          controller.selectedIndex.value.isNotEmpty) {
        return Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),

              const Text('Building'),
              SizedBox(height: 8),
              buildTextField(
                'Building / Project / Society',
                Icons.apartment_outlined,
                controller.commercial_rent_building_Name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter building name';
                  }
                  return null;
                },
                onTap: () async {
                  Prediction selectedCity = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CommonSearchField(
                            onCitySelected: (city) {
                              Navigator.pop(context, city);
                            },

                            isSearchForBuilding: true,
                            isFromAddProperty: true,
                            initialSearchText:
                                controller.commercial_rent_Loaclity_Name.text,
                            hintText: 'Building / Project / Society',
                          ),
                    ),
                  );

                  controller.commercial_rent_building_Name.text =
                      selectedCity.structuredFormatting?.mainText ?? '';
                  if (controller
                      .commercial_rent_building_Name
                      .text
                      .isNotEmpty) {
                    controller.commercial_rent_Loaclity_Name.text =
                        selectedCity.structuredFormatting?.secondaryText ?? '';
                    controller.sell_rent_Address.text =
                        selectedCity.structuredFormatting?.secondaryText ?? '';
                  }
                  print(
                    "city ${controller.commercial_rent_Loaclity_Name.text}",
                  );
                },
                isEnable: false,
              ),
              SizedBox(height: 16),

              const Text('Locality'),
              SizedBox(height: 8),
              buildTextField(
                'Locality',
                Icons.location_on_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter locality';
                  }
                  return null;
                },
                controller.commercial_rent_Loaclity_Name,
                onTap:
                    (controller.commercial_rent_Loaclity_Name.text
                            .trim()
                            .isEmpty)
                        ? () async {
                          Prediction selectedCity = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => CommonSearchField(
                                    selectedCity:
                                        controller.cityController.text,
                                    isLocality: true,
                                    onCitySelected: (city) {
                                      Navigator.pop(context, city);
                                    },
                                    isFromAddProperty: true,
                                    initialSearchText:
                                        controller
                                            .commercial_rent_Loaclity_Name
                                            .text,
                                    hintText: 'Locality',
                                  ),
                            ),
                          );

                          controller.commercial_rent_Loaclity_Name.text =
                              selectedCity.description ?? '';
                          controller.sell_rent_Address.text =
                              selectedCity.description ?? '';

                          print(
                            "city ${controller.commercial_rent_Loaclity_Name.text}",
                          );
                        }
                        : null,
                isEnable: false,
              ),
              SizedBox(height: 16),
              const Text('Full Address'),
              SizedBox(height: 8),
              buildTextField(
                'exact Address',
                Icons.apartment_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter complete address';
                  }
                  return null;
                },
                controller.sell_rent_Address,
                maxLines: 2,
                minLines: 1,
              ),

              if (controller.selectedIndex.value == 'Other') ...[
                SizedBox(height: 16),
                const Text('Property Name'),
                SizedBox(height: 8),
                buildTextField(
                  'Enter Property Name',
                  Icons.apartment_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Property name';
                    }
                    return null;
                  },
                  controller.commercial_Property_Name,
                ),
                SizedBox(height: 16),
              ],
              if ((controller.selectedIndex.value == 'Office') ||
                  (controller.selectedIndex.value == 'Shop') ||
                  (controller.selectedIndex.value == 'Showroom') ||
                  (controller.selectedIndex.value == 'Warehouse') ||
                  (controller.selectedIndex.value == 'Other')) ...[
                SizedBox(height: 16),
                Text(
                  'POSSESSTION INFO',
                  style: TextStyle(
                    color: ColorRes.black,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
                SizedBox(height: 16),
                buildSectionTitle('Posession status'),
                SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    children:
                        posession_Status.map((e) {
                          return buildChoice(
                            title: e,
                            selected:
                                controller
                                    .commercial_rent_posessionStatus
                                    .value ==
                                e,
                            onTap: () {
                              controller.setValue(
                                controller.commercial_rent_posessionStatus,
                                e,
                              );
                            },
                          );
                        }).toList(),
                  ),
                ),
                Obx(
                  () =>
                      controller.selectedPossessionStatus.value
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'Please select possession type',
                              style: TextStyle(
                                color: ColorRes.error.shade700,
                                // fontSize: 12,
                                fontSize: AppFontSizes.bodySmall,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
                if (controller.commercial_rent_posessionStatus.value ==
                    "Under Construction") ...[
                  SizedBox(height: 16),
                  Text('Available From'),
                  SizedBox(height: 8),
                  buildTextField(
                    'Enter Available From',
                    Icons.calendar_month_outlined,
                    controller.commercial_rent_AvailableFrom,
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
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: ColorRes.primary,
                                // header background color
                                onPrimary: ColorRes.white,
                                // header text color
                                onSurface: ColorRes.black, // body text color
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
                        controller.commercial_rent_AvailableFrom.text =
                            "${picked.day}/${picked.month}/${picked.year}";
                      }
                    },
                    isPhoneKey: true,
                  ),
                ],
              ],
              if ((controller.selectedIndex.value == 'Plot')) ...[
                SizedBox(height: 16),
                Text(
                  'POSSESSTION INFO',
                  style: TextStyle(
                    color: ColorRes.black,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
                SizedBox(height: 16),
                buildSectionTitle('Posession status'),
                SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    children:
                        ['Immediate', 'In Future'].map((e) {
                          return buildChoice(
                            title: e,
                            selected:
                                controller
                                    .commercial_rent_posessionStatus
                                    .value ==
                                e,
                            onTap: () {
                              controller.setValue(
                                controller.commercial_rent_posessionStatus,
                                e,
                              );
                            },
                          );
                        }).toList(),
                  ),
                ),
                Obx(
                  () =>
                      controller.selectedPossessionStatus.value
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'Please select possession type',
                              style: TextStyle(
                                color: ColorRes.error.shade700,
                                // fontSize: 12,
                                fontSize: AppFontSizes.bodySmall,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
                if (controller.commercial_rent_posessionStatus.value ==
                        "Under Construction" ||
                    controller.commercial_rent_posessionStatus.value ==
                        "In Future") ...[
                  SizedBox(height: 16),
                  Text('Available From'),
                  SizedBox(height: 8),
                  buildTextField(
                    'Enter Available From',
                    Icons.calendar_month_outlined,
                    controller.commercial_rent_AvailableFrom,
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
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: ColorRes.primary,
                                // header background color
                                onPrimary: ColorRes.white,
                                // header text color
                                onSurface: ColorRes.black, // body text color
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
                        controller.commercial_rent_AvailableFrom.text =
                            "${picked.day}/${picked.month}/${picked.year}";
                      }
                    },
                    isPhoneKey: true,
                  ),
                ],
              ],

              SizedBox(height: 16),
              if (controller.commercial_rent_posessionStatus.value ==
                      "Ready to move" &&
                  controller.selectedIndex.value != "Plot") ...[
                Text('Age of Property'),
                SizedBox(height: 8),
                buildTextField(
                  'Enter Age of property in years',
                  Icons.apartment_outlined,
                  controller.commercial_rent_AgeOfPropertInYear,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter property age';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
              ],

              Text(
                'ABOUT THE PROPERTY',
                style: TextStyle(
                  color: ColorRes.black,
                  fontWeight: AppFontWeights.medium,
                  // fontWeight: AppFontWeights.medium,
                ),
              ),
              if (controller.selectedIndex.value == 'Plot') ...[
                SizedBox(height: 16),
                buildSectionTitle("Zone Type"),
                SizedBox(height: 8),

                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        controller.zoneType
                            .map(
                              (e) => buildChoice(
                                title: e.replaceAll("_"," ").capitalize.toString(),
                                selected:
                                    controller.commercial_ZoneType.value == e,
                                onTap: () {
                                  controller.setValue(
                                    controller.commercial_ZoneType,
                                    e,
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
                Obx(
                  () =>
                      controller.selectedZoneTypeInCommercial.value
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'Please select Zone type',
                              style: TextStyle(
                                color: ColorRes.error.shade700,
                                fontSize: AppFontSizes.bodySmall,
                                // fontSize: 12,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
                SizedBox(height: 16),
              ],
              if (controller.selectedIndex.value != 'Plot' &&
                  controller.selectedIndex.value != "Office" &&
                  controller.selectedIndex.value != "Shop" &&
                  controller.selectedIndex.value != "Showroom" &&
                  controller.selectedIndex.value != "Warehouse" &&
                  controller.selectedIndex.value != 'Other') ...[
                SizedBox(height: 16),
                buildSectionTitle('Location Hub'),
                SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        controller.locationHub
                            .map(
                              (e) => buildChoice(
                                title: e,
                                selected:
                                    controller.commercial_LocationHub.value ==
                                    e,
                                onTap: () {
                                  controller.setValue(
                                    controller.commercial_LocationHub,
                                    e,
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],

              if (controller.commercial_LocationHub.value == "Other") ...[
                Text('Other Location '),
                SizedBox(height: 8),
                buildTextField(
                  'Enter the Location',
                  Icons.location_on_outlined,
                  controller.commercial_other_Location,
                ),
                SizedBox(height: 16),
              ],
              if (controller.selectedIndex.value != "Shop" &&
                  controller.selectedIndex.value != "Showroom" &&
                  controller.selectedIndex.value != "Warehouse" &&
                  controller.selectedIndex.value != "Plot" &&
                  controller.selectedIndex.value != "Other") ...[
                SizedBox(height: 16),
                buildSectionTitle("Property Condition"),
                SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    children:
                        commercial_propertyComditon
                            .map(
                              (e) => buildChoice(
                                title: e,
                                selected:
                                    controller
                                        .commercial_property_condition
                                        .value ==
                                    e,
                                onTap: () {
                                  controller.setValue(
                                    controller.commercial_property_condition,
                                    e,
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),

                // if (controller.commercial_property_condition.value ==
                //     'Ready to use') ...[
                //   SizedBox(height: 16),
                //   Text("Carpet Area"),
                //   SizedBox(height: 8),
                //   TextFieldWithDropdown(
                //     hintText: "Carpet Area",
                //     icon: Icons.square_foot,
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Please enter building name';
                //       }
                //       final rent = int.parse(value);
                //       final buildArea =
                //           int.tryParse(
                //             controller.commercial_Square_BuildArea.text,
                //           ) ??
                //           0;
                //       if (rent > buildArea) {
                //         return 'Carpet area should not be greater than Build up area';
                //       }
                //       return null;
                //     },
                //     controller: controller.commercial_Square_CarpetArea,
                //     selectedValue: controller.commercial_Square_AreaUnti_Carpet,
                //     // RxString
                //     dropdownItems: ['sq.ft.', 'sq.yd.', 'sq.mt.'],
                //     isPhoneKey: true,
                //   ),
                // ],
              ],
              if (controller.selectedIndex.value == "Plot") ...[
                Text("Plot Area"),
                SizedBox(height: 8),
                TextFieldWithDropdown(
                  hintText: "Plot Area",
                  icon: Icons.square_foot,
                  controller: controller.commercial_plot,

                  selectedValue: controller.commercial_plotArea,
                  // RxString
                  dropdownItems: ['sq.ft.', 'sq.yd.', 'sq.mt.'],
                  isPhoneKey: true,
                ),
                SizedBox(height: 16),
                Text("Length"),
                SizedBox(height: 6),
                buildTextField(
                  "Enter Plot Length",
                  isPhoneKey: true,
                  Icons.photo_size_select_large_rounded,
                  controller.plotLength,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter length';
                    }
                    return null;
                  },
                ),
                SizedBox(width: 16),
                SizedBox(height: 16),
                Text("Width"),
                SizedBox(height: 6),
                buildTextField(
                  "Enter Width Length",
                  Icons.photo_size_select_large_rounded,
                  controller.plotWidth,

                  isPhoneKey: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter width';
                    }
                    return null;
                  },
                ),
              ],
              if (controller.selectedIndex.value == 'Shop' ||
                  controller.selectedIndex.value == 'Showroom' ||
                  controller.selectedIndex.value == "Warehouse" ||
                  controller.selectedIndex.value == "Office" ||
                  controller.selectedIndex.value == 'Other') ...[
                SizedBox(height: 16),
                Text("Carpet Area"),
                SizedBox(height: 8),
                TextFieldWithDropdown(
                  hintText: "Carpet Area",
                  icon: Icons.square_foot,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter building name';
                    }
                    final rent = int.parse(value);
                    final buildArea =
                        int.tryParse(
                          controller.commercial_Square_BuildArea.text,
                        ) ??
                        0;
                    if (rent > buildArea) {
                      return 'Carpet area should not be greater than Build up area';
                    }
                    return null;
                  },
                  controller: controller.commercial_Square_CarpetArea,
                  selectedValue: controller.commercial_Square_AreaUnti_Carpet,
                  // RxString
                  dropdownItems: ['sq.ft.', 'sq.yd.', 'sq.mt.'],
                  isPhoneKey: true,
                ),
              ],
              if (controller.selectedIndex.value != "Plot") ...[
                SizedBox(height: 8),
                Text("Build Up Area"),
                SizedBox(height: 8),
                TextFieldWithDropdown(
                  hintText: "Build Up Area",
                  icon: Icons.square_foot,
                  controller: controller.commercial_Square_BuildArea,
                  selectedValue: controller.commercial_Square_AreaUnti_Build,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter building area';
                    }

                    final rent = int.tryParse(value);
                    if (rent == null) {
                      return 'Please enter a valid number';
                    }

                    if (rent < 50 || rent > 3000000) {
                      return 'Area should be between 50 to 3000000';
                    }

                    return null;
                  },

                  // RxString
                  dropdownItems: ['sq.ft.', 'sq.yd.', 'sq.mt.'],
                  isPhoneKey: true,
                ),
              ],

              if (controller.selectedIndex.value != "Office" &&
                  controller.selectedIndex.value != "Shop" &&
                  controller.selectedIndex.value != "Showroom" &&
                  controller.selectedIndex.value != "Warehouse" &&
                  controller.selectedIndex.value != 'Other') ...[
                SizedBox(height: 16),
                buildSectionTitle("Ownership"),
                SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        commercial_ownerShipList
                            .map(
                              (e) => buildChoice(
                                title: e,
                                selected:
                                    controller.commercial_ownerShipList.value ==
                                    e,
                                onTap: () {
                                  controller.setValue(
                                    controller.commercial_ownerShipList,
                                    e,
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
                Obx(
                  () =>
                      controller.seletedOwnerShipInCommercial.value
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'Please select OwnerShip type',
                              style: TextStyle(
                                color: ColorRes.error.shade700,
                                fontSize: AppFontSizes.small,
                                // fontSize: 12,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ],

              if (controller.commercial_property_condition.value ==
                  "Bare shell") ...[
                SizedBox(height: 16),
                buildSectionTitle("Construction status"),
                SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        commercial_construction_status
                            .map(
                              (e) => buildChoice(
                                title: e,
                                selected:
                                    controller
                                        .commercial_construction_status_value
                                        .value ==
                                    e,
                                onTap: () {
                                  controller.setValue(
                                    controller
                                        .commercial_construction_status_value,
                                    e,
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
                Obx(
                  () =>
                      controller.seletedOwnerShipInCommercial.value
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'Please select OwnerShip type',
                              style: TextStyle(
                                color: ColorRes.error.shade700,
                                fontSize: AppFontSizes.small,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ],
              if (controller.commercial_property_condition.value ==
                      "Ready to use" &&
                  controller.selectedIndex.value == 'Office') ...[
                SizedBox(height: 16),
                Text("Seats"),
                SizedBox(height: 8),
                buildTextField(
                  'Min Number of seats',
                  Icons.chair_alt_outlined,
                  controller.commercial_seats,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter minimum area';
                    }

                    return null;
                  },
                  isPhoneKey: true,
                ),
                SizedBox(height: 16),
                Text("Cabins"),
                SizedBox(height: 8),
                buildTextField(
                  'Min Number of cabins',
                  Icons.cabin_outlined,
                  controller.commercial_cabins,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cabins';
                    }
                    final rent = int.parse(value);
                    if (rent < 0 || rent > 1000) {
                      return 'Cabins should be between 0 to 1000';
                    }

                    return null;
                  },
                  // controller.commercial_cabins,
                  isPhoneKey: true,
                ),
                SizedBox(height: 16),
                Text("Meeting Room"),
                SizedBox(height: 8),
                buildTextField(
                  'Number of Meeting Rooms',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cabins';
                    }
                    final rent = int.parse(value);
                    if (rent < 0 || rent > 100) {
                      return 'Meeting should be between 0 to 100';
                    }

                    return null;
                  },
                  Icons.meeting_room_outlined,
                  controller.commercial_meeting_room,
                  isPhoneKey: true,
                ),
              ],

              if (controller.selectedIndex.value != "Plot") ...[
                SizedBox(height: 16),
                Text('Floor Available'),
                SizedBox(height: 8),
                buildTextField(
                  'Total Floor',
                  Icons.elevator_outlined,
                  controller.commercial_total_floor,
                  isPhoneKey: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total floor';
                    }

                    final totalFloor = int.tryParse(value);
                    if (totalFloor == null) {
                      return 'Please enter a valid number';
                    }

                    if (totalFloor < 1 || totalFloor > 200) {
                      // you can decide your valid range
                      return 'Total floor should be between 1 and 200';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 16),
                Text('Your Floor'),
                SizedBox(height: 8),

                GestureDetector(
                  onTap: () {
                    int totalFloor =
                        int.tryParse(controller.commercial_total_floor.text) ??
                        0;
                    List<String> floorOptions = ['-2', '-1', 'Ground'];
                    for (int i = 1; i <= totalFloor; i++) {
                      floorOptions.add(i.toString());
                    }
                    _showFloorSelectionBottomSheet(
                      context,
                      controller,
                      floorOptions,
                    );
                  },
                  child: AbsorbPointer(
                    child: buildTextField(
                      'Select Your Floor',
                      Icons.elevator_outlined,
                      controller.commercial_your_floor,
                      isEnable: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your floor';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Property Description'),
                SizedBox(height: 8),
                buildTextField(
                  'Enter Property Description',
                  maxLines: 3,
                  minLines: 1,
                  Icons.elevator_outlined,
                  controller.commercial_rent_description,
                  // isPhoneKey: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Property description';
                    }
                    return null;
                  },
                ),
              ],
            ],
          ),
        );
      } else if (controller.propertyType.value == "Commercial" &&
          controller.lookingTo.value == "Sell" &&
          controller.selectedIndex.value.isNotEmpty) {
        return Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              const Text('Building'),
              SizedBox(height: 8),
              buildTextField(
                'Building / Project / Society',
                Icons.apartment_outlined,
                controller.commercial_rent_building_Name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter building name';
                  }
                  return null;
                },
                onTap: () async {
                  Prediction selectedCity = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CommonSearchField(
                            onCitySelected: (city) {
                              Navigator.pop(context, city);
                            },
                            isFromAddProperty: true,
                            isSearchForBuilding:
                                true, // 👈 enable building search mode
                            selectedCity:
                                controller
                                    .cityController
                                    .text, // current city filter
                            initialSearchText:
                                controller.commercial_rent_building_Name.text,
                            hintText: 'Building / Project / Society',
                          ),
                    ),
                  );

                  // controller.commercial_rent_building_Name.text =
                  //     selectedCity.structuredFormatting?.mainText ?? '';
                  // if (controller
                  //     .commercial_rent_building_Name
                  //     .text
                  //     .isNotEmpty) {
                  //   controller.commercial_rent_Loaclity_Name.text =
                  //       selectedCity.structuredFormatting?.secondaryText ?? '';
                  //   controller.sell_rent_Address.text =
                  //       selectedCity.structuredFormatting?.secondaryText ?? '';
                  // }
                  controller.commercial_rent_building_Name.text =
                      selectedCity.structuredFormatting?.mainText ??
                      selectedCity.description ??
                      '';

                  // ✅ Fill Locality & Address (secondary text)
                  if (controller
                      .commercial_rent_building_Name
                      .text
                      .isNotEmpty) {
                    controller.commercial_rent_Loaclity_Name.text =
                        selectedCity.structuredFormatting?.secondaryText ?? '';
                    controller.sell_rent_Address.text =
                        selectedCity.structuredFormatting?.secondaryText ?? '';
                  }

                  print(
                    "city ${controller.commercial_rent_building_Name.text}",
                  );
                },
                isEnable: false,
              ),

              SizedBox(height: 16),
              const Text('Locality'),
              SizedBox(height: 8),
              buildTextField(
                'Locality',
                Icons.location_on_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter locality';
                  }
                  return null;
                },
                controller.commercial_rent_Loaclity_Name,
                onTap:
                    (controller.commercial_rent_Loaclity_Name.text
                            .trim()
                            .isEmpty)
                        ? () async {
                          Prediction selectedCity = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => CommonSearchField(
                                    selectedCity:
                                        controller.cityController.text,
                                    isLocality: true,
                                    onCitySelected: (city) {
                                      Navigator.pop(context, city);
                                    },
                                    isFromAddProperty: true,
                                    initialSearchText:
                                        controller
                                            .commercial_rent_Loaclity_Name
                                            .text,
                                    hintText: 'Locality',
                                  ),
                            ),
                          );

                          controller.commercial_rent_Loaclity_Name.text =
                              selectedCity.description ?? '';
                          controller.sell_rent_Address.text =
                              selectedCity.description ?? '';
                          print(
                            "city ${controller.commercial_rent_Loaclity_Name.text}",
                          );
                        }
                        : null,
                isEnable: false,
              ),
              SizedBox(height: 16),
              const Text('Full Address'),
              SizedBox(height: 8),
              buildTextField(
                'exact Address',
                Icons.apartment_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter complete address';
                  }
                  return null;
                },
                controller.sell_rent_Address,
                maxLines: 2,
                minLines: 1,
              ),

              // SizedBox(height: 16),
              // Text(
              //   'POSSESSTION INFO',
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontWeight: AppFontWeights.medium,
              //   ),
              // ),
              if (controller.selectedIndex.value == 'Other') ...[
                SizedBox(height: 16),
                const Text('Property Name'),
                SizedBox(height: 8),
                buildTextField(
                  'Enter Property Name',
                  Icons.apartment_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter property name';
                    }

                    return null;
                  },

                  controller.commercial_Property_Name,
                ),
                SizedBox(height: 16),
              ],
              if ((controller.selectedIndex.value == 'Office') ||
                  (controller.selectedIndex.value == 'Shop') ||
                  (controller.selectedIndex.value == 'Showroom') ||
                  (controller.selectedIndex.value == 'Warehouse') ||
                  (controller.selectedIndex.value == 'Other')) ...[
                SizedBox(height: 16),
                Text(
                  'POSSESSTION INFO',
                  style: TextStyle(
                    color: ColorRes.black,
                    fontWeight: AppFontWeights.medium,
                    // fontWeight: AppFontWeights.medium,
                  ),
                ),
                SizedBox(height: 16),
                buildSectionTitle('Posession status'),
                SizedBox(height: 8),
                ////////////////////
                Obx(
                  () => Wrap(
                    spacing: 12,
                    children:
                        posession_Status.map((e) {
                          return buildChoice(
                            title: e,
                            selected:
                                controller
                                    .commercial_rent_posessionStatus
                                    .value ==
                                e,
                            onTap: () {
                              controller.setValue(
                                controller.commercial_rent_posessionStatus,
                                e,
                              );
                            },
                          );
                        }).toList(),
                  ),
                ),
                Obx(
                  () =>
                      controller.selectedPossessionStatus.value
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'Please select possession type',
                              style: TextStyle(
                                color: ColorRes.error.shade700,
                                fontSize: 12,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ],
              if (controller.commercial_rent_posessionStatus.value ==
                  "Under Construction") ...[
                SizedBox(height: 16),
                Text('Possession Date'),
                SizedBox(height: 8),
                buildTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please valid date';
                    }

                    return null;
                  },
                  'Enter possession Date',
                  Icons.calendar_month_outlined,
                  controller.commercial_rent_AvailableFrom,
                  isEnable: false,
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: ColorRes.primary,
                              // header background color
                              onPrimary: ColorRes.white,
                              // header text color
                              onSurface: ColorRes.black, // body text color
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
                      controller.commercial_rent_AvailableFrom.text =
                          "${picked.day}/${picked.month}/${picked.year}";
                    }
                  },

                  isPhoneKey: true,
                ),
              ],
              if ((controller.selectedIndex.value == 'Plot')) ...[
                SizedBox(height: 16),
                Text(
                  'POSSESSTION INFO',
                  style: TextStyle(
                    color: ColorRes.black,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
                SizedBox(height: 16),
                buildSectionTitle('Posession status'),
                SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    children:
                        ['Immediate', 'In Future'].map((e) {
                          return buildChoice(
                            title: e,
                            selected:
                                controller
                                    .commercial_rent_posessionStatus
                                    .value ==
                                e,
                            onTap: () {
                              controller.setValue(
                                controller.commercial_rent_posessionStatus,
                                e,
                              );
                            },
                          );
                        }).toList(),
                  ),
                ),
                Obx(
                  () =>
                      controller.selectedPossessionStatus.value
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'Please select possession type',
                              style: TextStyle(
                                color: ColorRes.error.shade700,
                                // fontSize: 12,
                                fontSize: AppFontSizes.bodySmall,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
                if (controller.commercial_rent_posessionStatus.value ==
                        "Under Construction" ||
                    controller.commercial_rent_posessionStatus.value ==
                        "In Future") ...[
                  SizedBox(height: 16),
                  Text('Available From'),
                  SizedBox(height: 8),
                  buildTextField(
                    'Enter Available From',
                    Icons.calendar_month_outlined,
                    controller.commercial_rent_AvailableFrom,
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
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: ColorRes.primary,
                                // header background color
                                onPrimary: ColorRes.white,
                                // header text color
                                onSurface: ColorRes.black, // body text color
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
                        controller.commercial_rent_AvailableFrom.text =
                            "${picked.day}/${picked.month}/${picked.year}";
                      }
                    },
                    isPhoneKey: true,
                  ),
                ],
              ],

              SizedBox(height: 16),
              if (controller.commercial_rent_posessionStatus.value ==
                      "Ready to move" &&
                  controller.selectedIndex.value != "Plot") ...[
                Text('Age of Property'),
                SizedBox(height: 8),
                buildTextField(
                  'Enter Age of property in years',
                  Icons.apartment_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter property age';
                    }

                    return null;
                  },
                  controller.commercial_rent_AgeOfPropertInYear,
                ),
                SizedBox(height: 16),
              ],

              Text(
                'ABOUT THE PROPERTY',
                style: TextStyle(
                  color: ColorRes.black,
                  fontWeight: AppFontWeights.medium,
                ),
              ),

              if (controller.selectedIndex.value == 'Plot') ...[
                SizedBox(height: 16),

                buildSectionTitle("Zone Type"),
                SizedBox(height: 8),

                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        controller.zoneType
                            .map(
                              (e) => buildChoice(
                                title: e.replaceAll("_", " ").capitalize.toString(),
                                selected:
                                    controller.commercial_ZoneType.value == e,
                                onTap: () {
                                  controller.setValue(
                                    controller.commercial_ZoneType,
                                    e,
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
                Obx(
                  () =>
                      controller.selectedZoneTypeInCommercial.value
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'Please select Zone type',
                              style: TextStyle(
                                color: ColorRes.error.shade700,
                                fontSize: AppFontSizes.small,
                                // fontSize: 12,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
                SizedBox(height: 16),
              ],
              if (controller.selectedIndex.value != 'Plot' &&
                  controller.selectedIndex.value != "Office" &&
                  controller.selectedIndex.value != "Shop" &&
                  controller.selectedIndex.value != "Showroom" &&
                  controller.selectedIndex.value != "Warehouse" &&
                  controller.selectedIndex.value != "Other") ...[
                SizedBox(height: 16),
                buildSectionTitle('Location Hub'),
                SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        controller.locationHub
                            .map(
                              (e) => buildChoice(
                                title: e,
                                selected:
                                    controller.commercial_LocationHub.value ==
                                    e,
                                onTap: () {
                                  controller.setValue(
                                    controller.commercial_LocationHub,
                                    e,
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
                SizedBox(height: 16),
              ],

              if (controller.commercial_LocationHub.value == "Other") ...[
                Text('Other Location '),
                SizedBox(height: 8),
                buildTextField(
                  'Enter the Location',
                  Icons.location_on_outlined,
                  controller.commercial_other_Location,
                ),
                SizedBox(height: 16),
              ],
              if (controller.selectedIndex.value != "Shop" &&
                  controller.selectedIndex.value != "Showroom" &&
                  controller.selectedIndex.value != "Warehouse" &&
                  controller.selectedIndex.value != "Plot" &&
                  controller.selectedIndex.value != "Other") ...[
                SizedBox(height: 16),
                buildSectionTitle("Property Condition"),
                SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    children:
                        commercial_propertyComditon
                            .map(
                              (e) => buildChoice(
                                title: e,
                                selected:
                                    controller
                                        .commercial_property_condition
                                        .value ==
                                    e,
                                onTap: () {
                                  controller.setValue(
                                    controller.commercial_property_condition,
                                    e,
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),

                // if (controller.commercial_property_condition.value ==
                //     'Ready to use') ...[
                //   SizedBox(height: 16),
                //   Text("Carpet Area"),
                //   SizedBox(height: 8),
                //   TextFieldWithDropdown(
                //     hintText: "Carpet Area",
                //     icon: Icons.square_foot,
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Please enter building name';
                //       }
                //       final rent = int.parse(value);
                //       final buildArea =
                //           int.tryParse(
                //             controller.commercial_Square_BuildArea.text,
                //           ) ??
                //           0;
                //       if (rent > buildArea) {
                //         return 'Carpet area should not be greater than Build up area';
                //       }
                //       return null;
                //     },
                //     controller: controller.commercial_Square_CarpetArea,
                //     selectedValue: controller.commercial_Square_AreaUnti_Carpet,
                //     // RxString
                //     dropdownItems: ['sq.ft.', 'sq.yd.', 'sq.mt.'],
                //     isPhoneKey: true,
                //   ),
                // ],
              ],
              if (controller.selectedIndex.value == "Plot") ...[
                Text("Plot Area"),
                SizedBox(height: 8),
                TextFieldWithDropdown(
                  hintText: "Plot Area",
                  icon: Icons.square_foot,
                  controller: controller.commercial_plot,

                  selectedValue: controller.commercial_plotArea,
                  // RxString
                  dropdownItems: ['sq.ft.', 'sq.yd.', 'sq.mt.'],
                  isPhoneKey: true,
                ),
                SizedBox(height: 16),
                Text("Length"),
                SizedBox(height: 6),
                buildTextField(
                  "Enter Plot Length",
                  isPhoneKey: true,
                  Icons.photo_size_select_large_rounded,
                  controller.plotLength,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter length';
                    }
                    return null;
                  },
                ),
                SizedBox(width: 16),
                SizedBox(height: 16),
                Text("Width"),
                SizedBox(height: 6),
                buildTextField(
                  "Enter Width Length",
                  Icons.photo_size_select_large_rounded,
                  controller.plotWidth,

                  isPhoneKey: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter width';
                    }
                    return null;
                  },
                ),
              ],
              if (controller.selectedIndex.value == 'Shop' ||
                  controller.selectedIndex.value == 'Showroom' ||
                  controller.selectedIndex.value == "Warehouse" ||
                  controller.selectedIndex.value == "Office" ||
                  controller.selectedIndex.value == "Other") ...[
                SizedBox(height: 16),
                Text("Carpet Area"),
                SizedBox(height: 8),
                TextFieldWithDropdown(
                  hintText: "Carpet Area",
                  icon: Icons.square_foot,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter building name';
                    }
                    final rent = int.parse(value);
                    final buildArea =
                        int.tryParse(
                          controller.commercial_Square_BuildArea.text,
                        ) ??
                        0;
                    if (rent > buildArea) {
                      return 'Carpet area should not be greater than Build up area';
                    }
                    return null;
                  },
                  controller: controller.commercial_Square_CarpetArea,
                  selectedValue: controller.commercial_Square_AreaUnti_Carpet,
                  // RxString
                  dropdownItems: ['sq.ft.', 'sq.yd.', 'sq.mt.'],
                  isPhoneKey: true,
                ),
              ],
              if (controller.selectedIndex.value != "Plot") ...[
                SizedBox(height: 8),
                Text("Build Up Area"),
                SizedBox(height: 8),
                TextFieldWithDropdown(
                  hintText: "Build Up Area",
                  icon: Icons.square_foot,
                  controller: controller.commercial_Square_BuildArea,
                  selectedValue: controller.commercial_Square_AreaUnti_Build,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter building name';
                    }
                    final rent = int.tryParse(value);
                    if (rent != null) {
                      if (rent < 50 || rent > 3000000) {
                        return 'Area should be between 50 to 3000000';
                      }
                    }
                    return null;
                  },
                  // RxString
                  dropdownItems: ['sq.ft.', 'sq.yd.', 'sq.mt.'],
                  isPhoneKey: true,
                ),
              ],

              if (controller.selectedIndex.value != "Office" &&
                  controller.selectedIndex.value != "Shop" &&
                  controller.selectedIndex.value != "Showroom" &&
                  controller.selectedIndex.value != "Warehouse" &&
                  controller.selectedIndex.value != "Other") ...[
                SizedBox(height: 16),
                buildSectionTitle("Ownership"),
                SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        commercial_ownerShipList
                            .map(
                              (e) => buildChoice(
                                title: e,
                                selected:
                                    controller.commercial_ownerShipList.value ==
                                    e,
                                onTap: () {
                                  controller.setValue(
                                    controller.commercial_ownerShipList,
                                    e,
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
                Obx(
                  () =>
                      controller.seletedOwnerShipInCommercial.value
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'Please select OwnerShip type',
                              style: TextStyle(
                                color: ColorRes.error.shade700,
                                fontSize: AppFontSizes.small,
                                // fontSize: 12,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ],
              if (controller.commercial_property_condition.value ==
                  "Bare shell") ...[
                SizedBox(height: 16),
                buildSectionTitle("Construction status"),
                SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        commercial_construction_status
                            .map(
                              (e) => buildChoice(
                                title: e,
                                selected:
                                    controller
                                        .commercial_construction_status_value
                                        .value ==
                                    e,
                                onTap: () {
                                  controller.setValue(
                                    controller
                                        .commercial_construction_status_value,
                                    e,
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
                Obx(
                  () =>
                      controller.selectedConstructionStatusRent_Commercial.value
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'Please select Construction Status',
                              style: TextStyle(
                                color: ColorRes.error.shade700,
                                fontSize: AppFontSizes.small,
                                // fontSize: 12,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ],
              if (controller.commercial_property_condition.value ==
                      "Ready to use" &&
                  controller.selectedIndex.value == 'Office') ...[
                SizedBox(height: 16),
                Text("Seats"),
                SizedBox(height: 8),
                buildTextField(
                  'Min Number of seats',
                  Icons.chair_alt_outlined,
                  controller.commercial_seats,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter minimum area';
                    }
                    if (int.parse(value) < 0) {
                      return 'Seats should be greater than 0';
                    }

                    return null;
                  },

                  isPhoneKey: true,
                ),
                SizedBox(height: 16),
                Text("Cabins"),
                SizedBox(height: 8),
                buildTextField(
                  'Min Number of cabins',
                  Icons.cabin_outlined,
                  controller.commercial_cabins,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter minimum area';
                    }
                    if (int.parse(value) < 0) {
                      return 'Cabins should be greater than 0';
                    }

                    return null;
                  },

                  isPhoneKey: true,
                ),
                SizedBox(height: 16),
                Text("Meeting Room"),
                SizedBox(height: 8),
                buildTextField(
                  'Number of Meeting Rooms',
                  Icons.meeting_room_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter minimum area';
                    }
                    if (int.parse(value) < 0) {
                      return 'Meeting should be greater than 0';
                    }

                    return null;
                  },
                  controller.commercial_meeting_room,
                  isPhoneKey: true,
                ),
              ],

              if (controller.selectedIndex.value != "Plot") ...[
                SizedBox(height: 16),
                Text('Floor Available'),
                SizedBox(height: 8),
                buildTextField(
                  'Total Floor',
                  Icons.elevator_outlined,
                  controller.commercial_total_floor,
                  isPhoneKey: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total floor';
                    }

                    final totalFloor = int.tryParse(value);
                    if (totalFloor == null) {
                      return 'Please enter a valid number';
                    }

                    if (totalFloor < 1 || totalFloor > 200) {
                      // you can decide your valid range
                      return 'Total floor should be between 1 and 200';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 16),
                Text('Your Floor'),
                SizedBox(height: 8),

                GestureDetector(
                  onTap: () {
                    int totalFloor =
                        int.tryParse(controller.commercial_total_floor.text) ??
                        0;
                    List<String> floorOptions = ['-2', '-1', 'Ground'];
                    for (int i = 1; i <= totalFloor; i++) {
                      floorOptions.add(i.toString());
                    }
                    _showFloorSelectionBottomSheet(
                      context,
                      controller,
                      floorOptions,
                    );
                  },
                  child: AbsorbPointer(
                    child: buildTextField(
                      'Select Your Floor',
                      Icons.elevator_outlined,
                      controller.commercial_your_floor,
                      isEnable: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your floor';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Property Description'),
                SizedBox(height: 8),
                buildTextField(
                  'Enter Property Description',
                  maxLines: 3,
                  minLines: 1,
                  Icons.elevator_outlined,
                  controller.commercial_rent_description,
                  // isPhoneKey: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Property description';
                    }
                    return null;
                  },
                ),
              ],
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}

class TextFieldWithDropdown extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final RxString selectedValue;
  final List<String> dropdownItems;
  final bool isPhoneKey;
  final String? Function(String?)? validator;

  const TextFieldWithDropdown({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.selectedValue,
    required this.dropdownItems,
    this.isPhoneKey = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Text Field
        Expanded(
          child: buildTextField(
            hintText,
            icon,
            controller,
            isPhoneKey: isPhoneKey,
            validator: validator,
          ),
        ),
        const SizedBox(width: 12),

        /// Dropdown
        Obx(
          () => Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: ColorRes.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorRes.leadGreyColor.shade400),
            ),
            child: DropdownButton<String>(
              value: selectedValue.value,
              items:
                  dropdownItems
                      .map(
                        (unit) =>
                            DropdownMenuItem(value: unit, child: Text(unit)),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedValue.value = value;
                }
              },
              underline: Container(),
              style: TextStyle(
                fontSize: AppFontSizes.small,
                color: ColorRes.black,
              ),
              // style: const TextStyle(fontSize: 12, color: ColorRes.black),
              dropdownColor: ColorRes.white,
            ),
          ),
        ),
      ],
    );
  }
}

// void _showFloorSelectionBottomSheet(
//   BuildContext context,
//   CreatePropertyController controller,
//   List<String> floorOptions,
// ) {
//   // Parse total floor from controller (assume it's a TextEditingController)
//   int totalFloor = int.tryParse(controller.commercial_total_floor.text) ?? 0;
//
//   // Build dynamic floor list
//   List<String> availableFloors = [
//     '-2',
//     '-1',
//     'Ground',
//     ...List.generate(totalFloor, (i) => '${i + 1}'),
//   ];
//
//   List<String> tempSelectedFloors = List.from(controller.selectedFloors);
//
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     isDismissible: true,
//     enableDrag: true,
//     backgroundColor: Colors.transparent,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setModalState) {
//           return Container(
//             // Add maximum height constraint
//             constraints: BoxConstraints(
//               maxHeight: MediaQuery.of(context).size.height * 0.5,
//             ),
//             decoration: BoxDecoration(
//               color: ColorRes.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Drag handle
//                 Container(
//                   margin: EdgeInsets.only(top: 6),
//                   width: 32,
//                   height: 3,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[400],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 // Header section
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(16, 12, 12, 8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Select Your Floor',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: AppFontWeights.semiBold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () => Navigator.pop(context),
//                         icon: Icon(Icons.close, size: 20),
//                         padding: EdgeInsets.all(4),
//                         constraints: BoxConstraints(),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(height: 1, color: Colors.grey[300]),
//                 // Floor list - Wrap in Flexible to allow it to take available space
//                 Flexible(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     padding: EdgeInsets.symmetric(vertical: 8),
//                     itemCount: availableFloors.length,
//                     itemBuilder: (context, index) {
//                       String floor = availableFloors[index];
//                       bool isSelected = tempSelectedFloors.contains(floor);
//
//                       return Container(
//                         margin: EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 2,
//                         ),
//                         child: CheckboxListTile(
//                           title: Text(
//                             floor,
//                             style: TextStyle(
//                               fontSize: 15,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           value: isSelected,
//                           onChanged: (bool? value) {
//                             setModalState(() {
//                               if (value == true) {
//                                 tempSelectedFloors.add(floor);
//                               } else {
//                                 tempSelectedFloors.remove(floor);
//                               }
//                             });
//                           },
//                           controlAffinity: ListTileControlAffinity.leading,
//                           activeColor: Theme.of(context).primaryColor,
//                           contentPadding: EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 0,
//                           ),
//                           dense: true,
//                           visualDensity: VisualDensity.compact,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 // Bottom action section - Keep this fixed at bottom
//                 SafeArea(
//                   child: Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         if (tempSelectedFloors.isNotEmpty)
//                           Container(
//                             width: double.infinity,
//                             margin: EdgeInsets.only(bottom: 8),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.grey.shade200,
//                             ),
//                             child: TextButton(
//                               onPressed: () {
//                                 setModalState(() {
//                                   tempSelectedFloors.clear();
//                                 });
//                               },
//                               style: TextButton.styleFrom(
//                                 padding: EdgeInsets.symmetric(vertical: 8),
//                               ),
//                               child: Text(
//                                 'Clear All',
//                                 style: TextStyle(
//                                   color: Colors.red,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               controller.updateSelectedFloors(
//                                 tempSelectedFloors,
//                               );
//                               Navigator.pop(context);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Theme.of(context).primaryColor,
//                               foregroundColor: ColorRes.white,
//                               padding: EdgeInsets.symmetric(vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: Text(
//                               'Done',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: AppFontWeights.medium,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }

void _showFloorSelectionBottomSheet(
  BuildContext context,
  CreatePropertyController controller,
  List<String> floorOptions,
) {
  // Parse total floor from controller (assume it's a TextEditingController)
  int totalFloor = int.tryParse(controller.commercial_total_floor.text) ?? 0;

  // Build dynamic floor list
  List<String> availableFloors = [
    // '-2',
    // '-1',
    // 'Ground',
    ...List.generate(totalFloor, (i) => '${i + 1}'),
  ];

  // Keep only one selected floor
  String? tempSelectedFloor =
      controller.selectedFloors.isNotEmpty
          ? controller.selectedFloors.first
          : null;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: ColorRes.transparentColor,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            decoration: BoxDecoration(
              color: ColorRes.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  margin: EdgeInsets.only(top: 6),
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 12, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Your Floor',
                        style: TextStyle(
                          fontSize: AppFontSizes.large,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, size: 20),
                        padding: EdgeInsets.all(4),
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: ColorRes.leadGreyColor.shade300),
                // Floor list (single selection)
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: availableFloors.length,
                    itemBuilder: (context, index) {
                      String floor = availableFloors[index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        child: RadioListTile<String>(
                          title: Text(
                            floor,
                            style: TextStyle(
                              fontSize: AppFontSizes.bodyMedium,
                              color: ColorRes.textPrimary,
                            ),
                          ),
                          value: floor,
                          groupValue: tempSelectedFloor,
                          onChanged: (value) {
                            setModalState(() {
                              tempSelectedFloor = value;
                            });
                          },
                          activeColor: Theme.of(context).primaryColor,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          dense: true,
                          visualDensity: VisualDensity.compact,
                        ),
                      );
                    },
                  ),
                ),
                // Bottom action
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (tempSelectedFloor != null)
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: ColorRes.leadGreyColor.shade200,
                            ),
                            child: TextButton(
                              onPressed: () {
                                setModalState(() {
                                  tempSelectedFloor = null;
                                });
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: Text(
                                'Clear Selection',
                                style: TextStyle(
                                  color: ColorRes.error,
                                  fontSize: AppFontSizes.medium,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.updateSelectedFloors(
                                tempSelectedFloor != null
                                    ? [tempSelectedFloor!]
                                    : [],
                              );
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: ColorRes.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Done',
                              style: TextStyle(
                                fontSize: AppFontSizes.bodyMedium,
                                fontWeight: AppFontWeights.medium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

//Tejas6542
