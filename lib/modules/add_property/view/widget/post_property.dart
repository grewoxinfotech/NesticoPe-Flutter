import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart'
    hide Obx;
import 'package:housing_flutter_app/modules/add_property/view/widget/stepper_property.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostProperty extends StatelessWidget {
  final CreatePropertyController controller;

  const PostProperty({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final List<String> pgFor = ['Girl', 'Boy'];
    final List<String> bestSuitedFor = ["Students", "Professionals"];
    final List<String> mealList = ['Breakfast', 'Lunch', "Dinner"];
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
    final List<String> bhkTypes = [
      "1 RK",
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
                              controller.setValue(controller.lookingTo, option);
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
                      controller.totalRoomsController,
                      isPhoneKey: true,
                    ),
                    const SizedBox(height: 16),

                    // PG for
                    buildSectionTitle("PG for"),
                    const SizedBox(height: 8),
                    MultiSelectChip(
                      options: pgFor,
                      selectedItems: controller.selectedItems,
                      onTap:
                          (option) => controller.toggleItemInList(
                            controller.selectedItems,
                            option,
                          ),
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
                          ],
                        );
                      }
                      return const SizedBox.shrink();
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
        );
      } else if ((controller.lookingTo.value == 'Rent' ||
              controller.lookingTo.value == 'Sell') &&
          controller.propertyType.value == 'Residential') {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            buildSectionTitle("Property Type"),
            SizedBox(height: 12),
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 12,

                  children:
                      propertyType
                          .map(
                            (type) => buildChoice(
                              title: type,
                              selected:
                                  controller.rent_propertyType.value == type,
                              onTap:
                                  () => controller.setValue(
                                    controller.rent_propertyType,
                                    type,
                                  ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
            SizedBox(height: 24),
            const Text('Building'),
            SizedBox(height: 8),
            buildTextField(
              'Building / Project / Society',
              Icons.apartment_outlined,
              controller.rentBuildingController,
            ),
            SizedBox(height: 16),
            const Text('Locality'),
            SizedBox(height: 8),
            buildTextField(
              'Locality',
              Icons.location_on,
              controller.localityController,
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
            SizedBox(height: 16),
            const Text('Build Up Area'),
            // SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: buildTextField(
                    'Build Up Area',
                    Icons.square_foot,
                    controller.areaController,
                    isPhoneKey: true,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
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
                      }
                    },
                    underline: Container(),
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                    dropdownColor: Colors.white,
                  ),
                ),
              ],
            ),
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
                              selected: controller.furnishingType.value == type,
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
            SizedBox(height: 12),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: controller.isShareWithAgents.value,
                    onChanged: (val) {
                      controller.isShareWithAgents.value = val ?? false;
                    },
                  ),
                  Text(
                    'Share listing information with agents',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            // SizedBox(height: 28),
          ],
        );
      } else if (controller.propertyType.value == "Commercial" &&
          controller.lookingTo.value == "Rent") {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            const Text('Building'),
            SizedBox(height: 8),
            buildTextField(
              'Building / Project / Society',
              Icons.apartment_outlined,
              controller.commercial_rent_building_Name,
            ),
            SizedBox(height: 16),
            const Text('Locality'),
            SizedBox(height: 8),
            buildTextField(
              'Locality',
              Icons.location_on_outlined,
              controller.commercial_rent_Loaclity_Name,
            ),

            if (controller.selectedIndex.value == 'Other') ...[
              SizedBox(height: 16),
              const Text('Property Name'),
              SizedBox(height: 8),
              buildTextField(
                'Enter Property Name',
                Icons.apartment_outlined,
                controller.commercial_Property_Name,
              ),
              SizedBox(height: 16),
              Text(
                'POSSESSTION INFO',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            if (controller.selectedIndex.value != 'Plot') ...[
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
            ],
            SizedBox(height: 16),
            Text('Available From'),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                FocusScope.of(context).unfocus(); // hide keyboard if open

                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  final formattedDate = DateFormat(
                    'dd/MM/yyyy',
                  ).format(pickedDate);
                  controller.commercial_rent_AvailableFrom.text = formattedDate;
                  controller.setDate(
                    pickedDate,
                  ); // optional: save in observable
                }
              },
              child: buildTextField(
                'Enter Available From',
                Icons.calendar_month_outlined,
                controller.commercial_rent_AvailableFrom,
                isEnable: false,
                isPhoneKey: true
              ),
            ),

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
              ),
              SizedBox(height: 16),
            ],

            Text(
              'ABOUT THE PROPERTY',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            if (controller.selectedIndex.value == 'Office' ||
                controller.selectedIndex.value == 'Warehouse' ||
                controller.selectedIndex.value == 'Plot' ||
                controller.selectedIndex.value == 'Other') ...[
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
                              title: e,
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
              SizedBox(height: 16),
            ],
            if (controller.selectedIndex.value != 'Plot') ...[
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
                                  controller.commercial_LocationHub.value == e,
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

              if (controller.commercial_property_condition.value ==
                  'Ready to use') ...[
                SizedBox(height: 16),
                Text("Carpet Area"),
                SizedBox(height: 8),
                TextFieldWithDropdown(
                  hintText: "Carpet Area",
                  icon: Icons.square_foot,
                  controller: controller.commercial_Square_CarpetArea,
                  selectedValue: controller.commercial_Square_AreaUnti_Carpet,
                  // RxString
                  dropdownItems: ['sq.ft.', 'sq.yd.', 'sq.mt.'],
                  isPhoneKey: true,
                ),
              ],
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
            ],
            if (controller.selectedIndex.value == 'Shop' ||
                controller.selectedIndex.value == 'Showroom' ||
                controller.selectedIndex.value == "Warehouse" ||
                controller.selectedIndex.value == "Other") ...[
              Text("Carpet Area"),
              SizedBox(height: 8),
              TextFieldWithDropdown(
                hintText: "Carpet Area",
                icon: Icons.square_foot,
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
                // RxString
                dropdownItems: ['sq.ft.', 'sq.yd.', 'sq.mt.'],
                isPhoneKey: true,
              ),
            ],

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
                                controller.commercial_ownerShipList.value == e,
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
                isPhoneKey: true
              ),
              SizedBox(height: 16),
              Text("Cabins"),
              SizedBox(height: 8),
              buildTextField(
                'Min Number of cabins',
                Icons.cabin_outlined,
                controller.commercial_cabins,
                isPhoneKey: true
              ),
              SizedBox(height: 16),
              Text("Meeting Room"),
              SizedBox(height: 8),
              buildTextField(
                'Number of Meeting Rooms',
                Icons.meeting_room_outlined,
                controller.commercial_meeting_room,
                isPhoneKey: true
              ),
            ],

            SizedBox(height: 16),
            Text('Floor Available'),
            SizedBox(height: 8),
            buildTextField(
              'Total Floor',
              Icons.elevator_outlined,
              controller.commercial_total_floor,
              isPhoneKey: true,
            ),
            SizedBox(height: 16),
            Text('Your Floor'),
            SizedBox(height: 8),

            GestureDetector(
              onTap: () {
                int totalFloor = int.tryParse(controller.commercial_total_floor.text) ?? 0;
                List<String> floorOptions = ['-2', '-1', 'Ground'];
                for (int i = 1; i <= totalFloor; i++) {
                  floorOptions.add(i.toString());
                }
                _showFloorSelectionBottomSheet(context, controller, floorOptions);
              },
              child: AbsorbPointer(
                child: buildTextField(
                  'Select Your Floor',
                  Icons.elevator_outlined,
                  controller.commercial_your_floor,
                  isEnable: false,
                ),
              ),
            ),
          ],
        );
      }else if (controller.propertyType.value == "Commercial" &&
          controller.lookingTo.value == "Sell") {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            const Text('Building'),
            SizedBox(height: 8),
            buildTextField(
              'Building / Project / Society',
              Icons.apartment_outlined,
              controller.commercial_rent_building_Name,
            ),
            SizedBox(height: 16),
            const Text('Locality'),
            SizedBox(height: 8),
            buildTextField(
              'Locality',
              Icons.location_on_outlined,
              controller.commercial_rent_Loaclity_Name,
            ),
            SizedBox(height: 16),
            Text(
              'POSSESSTION INFO',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),

            if (controller.selectedIndex.value == 'Other') ...[
              SizedBox(height: 16),
              const Text('Property Name'),
              SizedBox(height: 8),
              buildTextField(
                'Enter Property Name',
                Icons.apartment_outlined,
                controller.commercial_Property_Name,
              ),
              SizedBox(height: 16),
              Text(
                'POSSESSTION INFO',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            if (controller.selectedIndex.value != 'Plot') ...[
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
            ],
           if(controller.commercial_rent_posessionStatus.value=="Under Construction")...[
             SizedBox(height: 16),
             Text('Possession Date'),
             SizedBox(height: 8),
             GestureDetector(
               onTap: () async {
                 FocusScope.of(context).unfocus();

                 final DateTime? pickedDate = await showDatePicker(
                   context: context,
                   initialDate: DateTime.now(),
                   firstDate: DateTime(2000),
                   lastDate: DateTime(2100),
                 );

                 if (pickedDate != null) {
                   final formattedDate = DateFormat(
                     'dd/MM/yyyy',
                   ).format(pickedDate);
                   controller.commercial_rent_AvailableFrom.text = formattedDate;
                   controller.setDate(
                     pickedDate,
                   ); // optional: save in observable
                 }
               },
               child: buildTextField(
                   'Enter possession Date',
                   Icons.calendar_month_outlined,
                   controller.commercial_rent_AvailableFrom,
                   isEnable: false,
                   isPhoneKey: true
               ),
             ),

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
              ),
              SizedBox(height: 16),
            ],

            Text(
              'ABOUT THE PROPERTY',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            if (controller.selectedIndex.value == 'Office' ||
                controller.selectedIndex.value == 'Warehouse' ||
                controller.selectedIndex.value == 'Plot' ||
                controller.selectedIndex.value == 'Other') ...[
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
                      title: e,
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
              SizedBox(height: 16),
            ],
            if (controller.selectedIndex.value != 'Plot') ...[
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
                      controller.commercial_LocationHub.value == e,
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

              if (controller.commercial_property_condition.value ==
                  'Ready to use') ...[
                SizedBox(height: 16),
                Text("Carpet Area"),
                SizedBox(height: 8),
                TextFieldWithDropdown(
                  hintText: "Carpet Area",
                  icon: Icons.square_foot,
                  controller: controller.commercial_Square_CarpetArea,
                  selectedValue: controller.commercial_Square_AreaUnti_Carpet,
                  // RxString
                  dropdownItems: ['sq.ft.', 'sq.yd.', 'sq.mt.'],
                  isPhoneKey: true,
                ),
              ],
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
            ],
            if (controller.selectedIndex.value == 'Shop' ||
                controller.selectedIndex.value == 'Showroom' ||
                controller.selectedIndex.value == "Warehouse" ||
                controller.selectedIndex.value == "Other") ...[
              Text("Carpet Area"),
              SizedBox(height: 8),
              TextFieldWithDropdown(
                hintText: "Carpet Area",
                icon: Icons.square_foot,
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
                // RxString
                dropdownItems: ['sq.ft.', 'sq.yd.', 'sq.mt.'],
                isPhoneKey: true,
              ),
            ],

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
                    controller.commercial_ownerShipList.value == e,
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
                  isPhoneKey: true
              ),
              SizedBox(height: 16),
              Text("Cabins"),
              SizedBox(height: 8),
              buildTextField(
                  'Min Number of cabins',
                  Icons.cabin_outlined,
                  controller.commercial_cabins,
                  isPhoneKey: true
              ),
              SizedBox(height: 16),
              Text("Meeting Room"),
              SizedBox(height: 8),
              buildTextField(
                  'Number of Meeting Rooms',
                  Icons.meeting_room_outlined,
                  controller.commercial_meeting_room,
                  isPhoneKey: true
              ),
            ],

            SizedBox(height: 16),
            Text('Floor Available'),
            SizedBox(height: 8),
            buildTextField(
              'Total Floor',
              Icons.elevator_outlined,
              controller.commercial_total_floor,
              isPhoneKey: true,
            ),
            SizedBox(height: 16),
            Text('Your Floor'),
            SizedBox(height: 8),

            GestureDetector(
              onTap: () {
                int totalFloor = int.tryParse(controller.commercial_total_floor.text) ?? 0;
                List<String> floorOptions = ['-2', '-1', 'Ground'];
                for (int i = 1; i <= totalFloor; i++) {
                  floorOptions.add(i.toString());
                }
                _showFloorSelectionBottomSheet(context, controller, floorOptions);
              },
              child: AbsorbPointer(
                child: buildTextField(
                  'Select Your Floor',
                  Icons.elevator_outlined,
                  controller.commercial_your_floor,
                  isEnable: false,
                ),
              ),
            ),
          ],
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

  const TextFieldWithDropdown({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.selectedValue,
    required this.dropdownItems,
    this.isPhoneKey = false,
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
          ),
        ),
        const SizedBox(width: 12),

        /// Dropdown
        Obx(
          () => Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
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
              style: const TextStyle(fontSize: 12, color: Colors.black),
              dropdownColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
void _showFloorSelectionBottomSheet(
    BuildContext context,
    CreatePropertyController controller,
    List<String> floorOptions,
    ) {
  // Parse total floor from controller (assume it's a TextEditingController)
  int totalFloor = int.tryParse(controller.commercial_total_floor.text) ?? 0;

  // Build dynamic floor list
  List<String> availableFloors = [
    '-2',
    '-1',
    'Ground',
    ...List.generate(totalFloor, (i) => '${i + 1}')
  ];

  List<String> tempSelectedFloors = List.from(controller.selectedFloors);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            // Add maximum height constraint
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
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
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header section
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 12, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Your Floor',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
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
                Divider(height: 1, color: Colors.grey[300]),
                // Floor list - Wrap in Flexible to allow it to take available space
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: availableFloors.length,
                    itemBuilder: (context, index) {
                      String floor = availableFloors[index];
                      bool isSelected = tempSelectedFloors.contains(floor);

                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        child: CheckboxListTile(
                          title: Text(
                            floor,
                            style: TextStyle(fontSize: 15, color: Colors.black87),
                          ),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value == true) {
                                tempSelectedFloors.add(floor);
                              } else {
                                tempSelectedFloors.remove(floor);
                              }
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Theme.of(context).primaryColor,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 0,
                          ),
                          dense: true,
                          visualDensity: VisualDensity.compact,
                        ),
                      );
                    },
                  ),
                ),
                // Bottom action section - Keep this fixed at bottom
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (tempSelectedFloors.isNotEmpty)
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade200,
                            ),
                            child: TextButton(
                              onPressed: () {
                                setModalState(() {
                                  tempSelectedFloors.clear();
                                });
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: Text(
                                'Clear All',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.updateSelectedFloors(
                                tempSelectedFloors,
                              );
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Done',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
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
