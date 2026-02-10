import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import 'package:housing_flutter_app/modules/add_property/view/widget/stepper_property.dart';
import 'package:housing_flutter_app/modules/search_property/model/search_model.dart';

import '../../../../search_property/view/search_screen.dart';

class RentAdvanceDetail extends StatelessWidget {
  final CreatePropertyController controller;

  final GlobalKey<FormState> formKey;

  const RentAdvanceDetail({
    super.key,
    required this.controller,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final rent_legal = [
      "Free rental agreement",
      "Free Police Verification",
      "No Brokerage",
    ];
    final sell_Brokerage_and_loan = ["No Brokerage", "Interest Free Loan"];
    final sell_Registration_and_Possession = [
      "Free registration",
      "50% off on registration fees",
      "10% off on registration fees",
      "Zero stamp duty fees",
      "Zero GST charges",
    ];
    final sell_Amenities = [
      "Free car parking",
      "Free furniture",
      "Free Chimeny",
      "Free modular kitchen setup",
      "Free bed",
      "Free sofa",
      "Free AC's",
    ];
    final rent_Rentals = [
      "Zero brokerage",
      '15 days free rent',
      '1 month free rent',
    ];
    final rent_Security_DepositType = [
      "Only one month security deposit",
      "10% discount on security deposit",
      "30% discount on security deposit",
    ];
    final rent_Home_Services = ["Free Home Cleaning", "Free Painting Service "];
    final rent_Preferred_Tenants = ["Family", "Bachelors", "Company", "Any"];
    final rent_Selected_Tenants_for_Bachelors = [
      'Open to Both',
      "Men Only",
      "Women Only",
    ];
    final rent_Pet_Friendly = ["Yes", "No"];
    final lift_info = ["Yes", "No"];

    final charge_brokerage = ["Yes", "No"];
    final charge_brokerage_negotiable = ["Yes", "No"];
    final rent_maintenanceChargeType = [
      "Included in rent",
      "Separate",
      // "As per actuals",
    ];
    final rent_lockInPeriod = [
      "None",
      "1 month",
      // "2 month",
      // "3 month",
      // "4 month",
      // "5 month",
      "6 month",
      "Custom",
    ];
    final rent_Painting_Charges = [
      "None",
      "As per cost",
      "1 month",
      "Custom",
      // "As per actuals",
    ];
    final sell_rent_facing = [
      "East",
      "West",
      "North",
      "South",
      "North-East",
      "North-West",
      "South-East",
      "South-West",
    ];
    final rent_Parking_Charges = ['Included in rent', 'Separate'];
    final isEdit = controller.isEdited.value;
    log("Is Edit advanced detail $isEdit");
    return Obx(() {
      print(
        "Propwerty type${controller.rent_propertyType.value}  ${((controller.rent_propertyType.value != 'Independent House' && controller.rent_propertyType.value != 'Duplex') && controller.rent_propertyType.value != 'Farmhouse')}",
      );
      if ((controller.lookingTo.value == "Rent" ||
              controller.lookingTo.value == 'Sell') &&
          controller.propertyType.value == "Residential") {
        return Form(
          key: formKey,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.rent_propertyType.value.toLowerCase() != "plot" &&
                  controller.rent_propertyType.value.toLowerCase() !=
                      "agricultural land") ...[
                SizedBox(height: 16),
                buildSectionTitle("Bathrooms"),
                SizedBox(height: 8),
                Obx(() {
                  int bhkCount = 1;
                  if (controller.bhkType.value.isNotEmpty) {
                    bhkCount =
                        int.tryParse(controller.bhkType.value.split(' ')[0]) ??
                        1;
                  }
                  final bathroomOptions = List<int>.generate(
                    bhkCount,
                    (i) => i + 1, // Generates [1, 2, ..., bhkCount]
                  );
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      children:
                          bathroomOptions
                              .map(
                                (option) => buildChoice(
                                  title: option.toString(),
                                  selected:
                                      controller.rent_Bathroom.value == option,
                                  onTap: () {
                                    controller.setValue(
                                      controller.rent_Bathroom,
                                      option,
                                    );
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  );
                }),
                // SizedBox(height: 16),
                SizedBox(height: 16),
                buildSectionTitle("Balcony"),
                SizedBox(height: 8),
                Obx(() {
                  int bhkCount = 1;
                  if (controller.bhkType.value.isNotEmpty) {
                    bhkCount =
                        int.tryParse(controller.bhkType.value.split(' ')[0]) ??
                        1;
                  }
                  final balconyOptions = List<int>.generate(
                    bhkCount + 1,
                    (i) => i, // Generates [0, 1, ..., bhkCount]
                  );
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      children:
                          balconyOptions
                              .map(
                                (option) => buildChoice(
                                  title: option.toString(),
                                  selected:
                                      controller.rent_Balcony.value == option,
                                  onTap: () {
                                    controller.setValue(
                                      controller.rent_Balcony,
                                      option,
                                    );
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  );
                }),
                if ((controller.rent_propertyType.value !=
                            'Independent House' &&
                        controller.rent_propertyType.value != 'Duplex') &&
                    controller.rent_propertyType.value != 'Farmhouse') ...[
                  SizedBox(height: 16),
                  buildSectionTitle("Covered Parking"),
                  SizedBox(height: 8),
                  Obx(() {
                    final coverParkingOptions = ['0', '1', '2', '3', '3+'];
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 12,
                        children:
                            coverParkingOptions.map((option) {
                              return buildChoice(
                                width: 80,
                                title: option,
                                selected:
                                    controller.rent_CoveredParking.value ==
                                    option,
                                onTap: () {
                                  controller.setValue(
                                    controller.rent_CoveredParking,
                                    option,
                                  );
                                },
                              );
                            }).toList(),
                      ),
                    );
                  }),
                  SizedBox(height: 16),
                  buildSectionTitle("Open Parking"),
                  SizedBox(height: 8),
                  Obx(() {
                    final openParkingOptions = ['0', '1', '2', '3', '3+'];
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 12,
                        children:
                            openParkingOptions.map((option) {
                              return buildChoice(
                                width: 80,
                                title: option,
                                selected:
                                    controller.rent_OpenParking.value == option,
                                onTap: () {
                                  controller.setValue(
                                    controller.rent_OpenParking,
                                    option,
                                  );
                                },
                              );
                            }).toList(),
                      ),
                    );
                  }),
                ],
                if (((controller.rent_propertyType.value !=
                            'Independent House' &&
                        controller.rent_propertyType.value != 'Duplex') &&
                    controller.rent_propertyType.value != 'Villa')) ...[
                  SizedBox(height: 16),
                  buildSectionTitle("Lift info"),
                  SizedBox(height: 8),
                  Obx(
                    () => Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          lift_info.map((option) {
                            return buildChoice(
                              title: option,
                              selected: controller.lift_info.value == option,
                              onTap: () {
                                controller.setValue(
                                  controller.lift_info,
                                  option,
                                );
                              },
                            );
                          }).toList(),
                    ),
                  ),
                ],

                if (controller.lookingTo.value == 'Rent') ...[
                  SizedBox(height: 16),
                  buildSectionTitle("Pet Friendly? "),
                  SizedBox(height: 8),
                  Obx(
                    () => Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          rent_Pet_Friendly.map((option) {
                            return buildChoice(
                              title: option,
                              selected:
                                  controller.rent_Pet_Friendly.value == option,
                              onTap: () {
                                controller.setValue(
                                  controller.rent_Pet_Friendly,
                                  option,
                                );
                              },
                            );
                          }).toList(),
                    ),
                  ),
                ],

                // buildSectionTitle("Do you charge brokerage"),
                //
                // SizedBox(height: 8),
                // Obx(
                //   () => Wrap(
                //     spacing: 12,
                //     runSpacing: 12,
                //     children:
                //         charge_brokerage.map((option) {
                //           return buildChoice(
                //             title: option,
                //             selected:
                //                 controller.doYouWantBrokerage.value == option,
                //             onTap: () {
                //               controller.setValue(
                //                 controller.doYouWantBrokerage,
                //                 option,
                //               );
                //             },
                //           );
                //         }).toList(),
                //   ),
                // ),
                // if (controller.doYouWantBrokerage.value == "Yes") ...[
                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       SizedBox(height: 16),
                //       buildSectionTitle("Brokerage Negotiable"),
                //       SizedBox(height: 12),
                //
                //       Obx(
                //         () => Wrap(
                //           spacing: 12,
                //           runSpacing: 12,
                //           children:
                //               charge_brokerage_negotiable.map((option) {
                //                 return buildChoice(
                //                   title: option,
                //                   selected:
                //                       controller
                //                           .brokerageChargeNegotiable
                //                           .value ==
                //                       option,
                //                   onTap: () {
                //                     controller.setValue(
                //                       controller.brokerageChargeNegotiable,
                //                       option,
                //                     );
                //                   },
                //                 );
                //               }).toList(),
                //         ),
                //       ),
                //
                //       SizedBox(height: 12),
                //     ],
                //   ),
                // ],
                // SizedBox(height: 16),
                // buildSectionTitle("Flat No."),
                // SizedBox(height: 8),
                // buildTextField(
                //   "Flat No.",
                //   Icons.home_outlined,
                //   controller.sell_rent_Flat_No,
                //   isPhoneKey: true,
                // ),
                if (controller.rent_propertyType.value != 'Independent House' &&
                    controller.rent_propertyType.value != 'Villa') ...[
                  SizedBox(height: 16),
                  buildSectionTitle('Floor No.'),
                  SizedBox(height: 8),
                  buildTextField(
                    "Enter Floor No.",
                    Icons.apartment_outlined,
                    controller.sell_rent_Floor_No,
                    isPhoneKey: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter floor number';
                      }
                      final floorNo = int.tryParse(value);
                      final totalFloor = int.tryParse(
                        controller.sell_rent_Total_Floor.text,
                      );

                      if (floorNo == null) {
                        return 'Enter a valid number';
                      }
                      if (totalFloor != null && floorNo > totalFloor) {
                        return 'Floor number cannot be greater than total floors';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),
                  buildSectionTitle('Total Floor'),
                  SizedBox(height: 8),
                  buildTextField(
                    "Enter Total Floor",
                    Icons.apartment_outlined,
                    controller.sell_rent_Total_Floor,
                    isPhoneKey: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter total floors';
                      }
                      final totalFloor = int.tryParse(value);
                      if (totalFloor == null) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                ],

                SizedBox(height: 16),

                if (controller.lookingTo.value == 'Rent') ...[
                  buildSectionTitle("Maintenance Charges"),
                  SizedBox(height: 8),
                  Obx(
                    () => Wrap(
                      spacing: 12,

                      runSpacing: 12,
                      children:
                          rent_maintenanceChargeType.map((option) {
                            return buildChoice(
                              title: option,
                              selected:
                                  controller.rent_maintenanceChargeType.value ==
                                  option,
                              onTap: () {
                                controller.setValue(
                                  controller.rent_maintenanceChargeType,
                                  option,
                                );
                              },
                            );
                          }).toList(),
                    ),
                  ),
                  if (controller.rent_maintenanceChargeType.value ==
                      "Separate") ...[
                    SizedBox(height: 16),
                    Text("Maintenance Charges"),
                    SizedBox(height: 8),
                    buildTextField(
                      "Enter Maintenance Charges",
                      Icons.currency_rupee_outlined,
                      controller.sell_rent_Maintenance_Charges,
                      isPhoneKey: true,
                    ),
                  ],
                ]
                // else if (controller.lookingTo.value == "Sell") ...[
                //   buildSectionTitle("Maintenance Charges"),
                //   SizedBox(height: 8),
                //   Obx(
                //         () => Wrap(
                //       spacing: 12,
                //
                //       runSpacing: 12,
                //       children:
                //       rent_maintenanceChargeType.map((option) {
                //         return buildChoice(
                //           title: option,
                //           selected:
                //           controller.rent_maintenanceChargeType.value ==
                //               option,
                //           onTap: () {
                //             controller.setValue(
                //               controller.rent_maintenanceChargeType,
                //               option,
                //             );
                //           },
                //         );
                //       }).toList(),
                //     ),
                //   ),
                //   if(controller.rent_maintenanceChargeType.value ==
                //       "Separate")...[
                //     Text("Maintenance Charges"),
                //     SizedBox(height: 8),
                //     buildTextField(
                //       "Enter Maintenance Charges",
                //       Icons.currency_rupee_outlined,
                //       controller.sell_rent_Maintenance_Charges,
                //       isPhoneKey: true,
                //     ),
                //   ]
                // ],
                else if (controller.lookingTo.value == "Sell") ...[
                  buildSectionTitle("Maintenance Charges"),
                  const SizedBox(height: 8),

                  if (isEdit) ...[
                    Obx(() {
                      final hasMaintenance =
                          controller.sell_rent_Maintenance_Charges.text
                              .trim()
                              .isNotEmpty;
                      final selectedType =
                          controller.rent_maintenanceChargeType.value;

                      // Auto-default logic on edit
                      if (hasMaintenance &&
                          controller.rent_maintenanceChargeType.value.isEmpty) {
                        controller.rent_maintenanceChargeType.value =
                            "Separate";
                      } else if (!hasMaintenance &&
                          controller.rent_maintenanceChargeType.value.isEmpty) {
                        controller.rent_maintenanceChargeType.value =
                            "Included in rent";
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Choice buttons
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children:
                                rent_maintenanceChargeType.map((option) {
                                  return buildChoice(
                                    title: option,
                                    selected: selectedType == option,
                                    onTap: () {
                                      controller.setValue(
                                        controller.rent_maintenanceChargeType,
                                        option,
                                      );
                                    },
                                  );
                                }).toList(),
                          ),

                          // 🔹 Show text field only when “Separate” is selected
                          if (selectedType == "Separate") ...[
                            const SizedBox(height: 8),
                            Text("Maintenance Charges"),
                            const SizedBox(height: 8),
                            buildTextField(
                              "Enter Maintenance Charges",
                              Icons.currency_rupee_outlined,
                              controller.sell_rent_Maintenance_Charges,
                              isPhoneKey: true,
                            ),
                          ],
                        ],
                      );
                    }),
                  ] else ...[
                    Text("Maintenance Charges"),
                    const SizedBox(height: 8),
                    buildTextField(
                      "Enter Maintenance Charges",
                      Icons.currency_rupee_outlined,
                      controller.sell_rent_Maintenance_Charges,
                      isPhoneKey: true,
                    ),
                  ],
                ],

                if (controller.lookingTo.value == 'Rent') ...[
                  if (controller.rent_propertyType.value !=
                          'Independent House' ||
                      controller.rent_propertyType.value != 'Duplex' ||
                      controller.rent_propertyType.value != 'Villa' ||
                      controller.rent_propertyType.value != 'Farmhouse') ...[
                    SizedBox(height: 16),
                    buildSectionTitle("Parking Charges"),
                    SizedBox(height: 8),
                    Obx(
                      () => Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children:
                            rent_Parking_Charges.map((option) {
                              return buildChoice(
                                title: option,
                                selected:
                                    controller.rent_Parking_Charges.value ==
                                    option,
                                onTap: () {
                                  controller.setValue(
                                    controller.rent_Parking_Charges,
                                    option,
                                  );
                                },
                              );
                            }).toList(),
                      ),
                    ),
                    if (controller.rent_Parking_Charges.value ==
                        "Separate") ...[
                      SizedBox(height: 16),
                      Text("Custom Parking Charges"),
                      SizedBox(height: 8),

                      buildTextField(
                        "Enter Parking Charges",
                        Icons.currency_rupee_outlined,
                        controller.rent_Custom_Parking_Charges,
                        isPhoneKey: true,
                      ),
                      SizedBox(height: 16),
                    ],
                  ],
                ],
                SizedBox(height: 16),
                buildSectionTitle("Facing"),
                SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        sell_rent_facing.map((option) {
                          return buildChoice(
                            title: option,
                            selected: controller.rent_facing.value == option,
                            onTap: () {
                              controller.setValue(
                                controller.rent_facing,
                                option,
                              );
                            },
                          );
                        }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                buildSectionTitle("Address"),
                SizedBox(height: 8),
                buildTextField(
                  "Enter Address",
                  Icons.location_on_outlined,
                  controller.sell_rent_Address,
                  maxLines: 3,
                  minLines: 1,
                  isEnable: false,
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

                              initialSearchText:
                                  controller.sell_rent_Address.text,
                            ),
                      ),
                    );

                    controller.sell_rent_Address.text =
                        selectedCity.description ?? '';

                    print("city ${controller.sell_rent_Address.text}");
                  },
                ),
                SizedBox(height: 16),
                buildSectionTitle("Servent Room"),
                SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        ['Yes', 'No'].map((option) {
                          return buildChoice(
                            title: option,
                            selected:
                                controller.sell_rent_Servent_Room.value ==
                                option,
                            onTap: () {
                              controller.setValue(
                                controller.sell_rent_Servent_Room,
                                option,
                              );
                            },
                          );
                        }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                buildSectionTitle("Sub-Registrar Office (SRO) Name"),

                SizedBox(height: 8),
                buildTextField(
                  "Enter SRO Name",
                  Icons.apartment_outlined,
                  controller.subRegistrarOffice,
                ),
                SizedBox(height: 16),
                buildSectionTitle("Sale Deed Document Number"),

                SizedBox(height: 8),
                buildTextField(
                  "Enter Sale Deed Document Number",
                  Icons.edit_document,
                  controller.saleDeedDocumentNumber,
                ),
                SizedBox(height: 16),
                buildSectionTitle("Year of Registration"),

                SizedBox(height: 8),
                buildTextField(
                  "Enter year of registration",
                  Icons.edit_document,
                  controller.yearOfRegistration,
                  isEnable: false,
                  onTap: () async {
                    FocusScope.of(context).unfocus();

                    DateTime now = DateTime.now();

                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: DateTime(1),
                      // 👈 Year 1 (earliest possible)
                      lastDate: now,
                      // 👈 No future year
                      initialDatePickerMode: DatePickerMode.year,
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
                      controller.yearOfRegistration.text =
                          picked.year.toString();
                    }
                  },
                ),
              ],

              if (controller.rent_propertyType.value.toLowerCase() == "plot" ||
                  controller.rent_propertyType.value.toLowerCase() ==
                      "agricultural land") ...[
                SizedBox(height: 16),
                buildSectionTitle("Survey Number"),

                SizedBox(height: 8),
                buildTextField(
                  "Enter Survey Number",
                  Icons.app_registration,
                  isPhoneKey: true,
                  controller.surveyNumberPlotAndLand,
                ),
                SizedBox(height: 16),
                buildSectionTitle("Khata Number"),

                SizedBox(height: 8),
                buildTextField(
                  "Enter Khata Number",
                  Icons.numbers_outlined,
                  isPhoneKey: true,
                  controller.khataNumberPlotAndLand,
                ),
              ],
              SizedBox(height: 16),
              buildSectionTitle('RERA ID'),
              SizedBox(height: 8),
              buildTextField(
                "Enter RERA id",
                Icons.description_outlined,
                controller.sell_Rera_Id,
              ),
              SizedBox(height: 16),

              buildSectionTitle('Property Description'),
              SizedBox(height: 8),
              buildTextField(
                "Write about your property",
                Icons.description_outlined,
                controller.sell_rent_propertyDescriptionController,
                maxLines: 5,
                minLines: 1,
              ),
              SizedBox(height: 4),
              Text(
                "Tell us more about the specific features of your property.",
                style: TextStyle(
                  fontSize: AppFontSizes.extraSmall,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        );
      }
      return SizedBox.shrink();
    });
  }
}

class SelectableChipRow extends StatelessWidget {
  final List<String> options;
  final RxList<String> selectedItems;
  final void Function(String) onTap;

  final double fontSize;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;

  const SelectableChipRow({
    super.key,
    required this.options,
    required this.selectedItems,
    required this.onTap,

    this.fontSize = AppFontSizes.small,
    this.selectedColor = const Color(0xFF1976D2), // Example primary color
    this.unselectedColor = ColorRes.white,
    this.selectedTextColor = const Color(0xFF1976D2),
    this.unselectedTextColor = ColorRes.black,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 12,
          children:
              options.map((option) {
                final bool selected = selectedItems.contains(option);
                return GestureDetector(
                  onTap: () => onTap(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          selected
                              ? selectedColor.withOpacity(0.1)
                              : unselectedColor,
                      border: Border.all(
                        color:
                            selected
                                ? ColorRes.transparentColor
                                : ColorRes.leadGreyColor.shade300,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      option,
                      style: TextStyle(
                        color:
                            selected ? selectedTextColor : unselectedTextColor,
                        fontWeight: AppFontWeights.medium,
                        // fontWeight: AppFontWeights.medium,
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
