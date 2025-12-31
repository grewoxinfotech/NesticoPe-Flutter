import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';

class RentPriceDetail extends StatelessWidget {
  final CreatePropertyController controller;
  final GlobalKey<FormState>? formKey;

  const RentPriceDetail({super.key, required this.controller, this.formKey});

  @override
  Widget build(BuildContext context) {
    final rentDepositType = ["None", "1 month", "2 month", "Custom"];
    return Obx(() {
      if (controller.lookingTo.value == "Rent" &&
          controller.propertyType.value == "Residential") {
        return  Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text("Monthly Rent"),
              const SizedBox(height: 8),
              buildTextField(
                "Enter Monthly Rent",
                Icons.currency_rupee_outlined,
                controller.rent_MonthilyRent,
                isPhoneKey: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter monthly rent';
                  }

                  final rent = int.tryParse(value) ?? 0;

                  if (rent > 0) {
                    // Calculate 5% of rent as Platform Fees
                    final platformFee = rent * 0.05;
                    controller.platformFees.text = platformFee.toStringAsFixed(1);

                    // Calculate 2% of platform fees as Broker Commission
                    final brokerCommission = platformFee * 0.02;
                    controller.brokerRageCommission.text =
                        brokerCommission.toStringAsFixed(1);
                  } else {
                    controller.platformFees.text = "0";
                    controller.brokerRageCommission.text = "0";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),
              const Text("Platform Fees (5%)"),
              const SizedBox(height: 8),
              buildTextField(
                "Platform Fees",
                Icons.currency_rupee_outlined,
                controller.platformFees,
                isPhoneKey: true,
                isEnable: false,
              ),

              const SizedBox(height: 16),
              const Text("Broker Commission (2%) of Platform Fees"),
              const SizedBox(height: 8),
              buildTextField(
                "Broker Commission",
                Icons.currency_rupee_outlined,
                controller.brokerRageCommission,
                isPhoneKey: true,
                isEnable: false,
              ),

              const SizedBox(height: 16),
              buildSectionTitle('Also for Sell?'),
              const SizedBox(height: 8),
              // ---------------- CHECKBOX + CONDITIONAL FIELD ----------------
              Obx(() => Row(
                children: [
                  Checkbox(
                    value: controller.isPredefinedCostEnabled.value,
                    activeColor: ColorRes.primary,
                    onChanged: (val) {
                      controller.isPredefinedCostEnabled.value = val ?? false;
                    },
                  ),
                  const Text(
                    "You want to sell",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: ColorRes.textColor,
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 8),

              Obx(() => controller.isPredefinedCostEnabled.value
                  ? buildTextField(
                "Enter Cost",
                Icons.currency_rupee_outlined,
                controller.sell_ExpectedPrice,
                isPhoneKey: true,
                validator: (value) {
                  if (controller.isPredefinedCostEnabled.value &&
                      (value == null || value.isEmpty)) {
                    return 'Please enter cost';
                  }
                  return null;
                },
              )
                  : const SizedBox.shrink()),

              // -------------------- PAST 5 YEARS PRICES --------------------
              // -------------------- PAST 5 YEARS PRICES ------------------

              const SizedBox(height: 24),
              buildSectionTitle('Rent Negotiable'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: ["Yes", "No"]
                    .map(
                      (type) => buildChoice(
                    title: type,
                    selected: controller.negotiablePriceOrNot.value == type,
                    onTap: () {
                      controller.setValue(
                        controller.negotiablePriceOrNot,
                        type,
                      );
                    },
                  ),
                )
                    .toList(),
              ),

              const SizedBox(height: 16),
              const Text("Available From"),
              const SizedBox(height: 8),
              buildTextField(
                "Enter Available From",
                Icons.calendar_month_outlined,
                controller.rent_AvailableFrom,
                isEnable: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid month';
                  }
                  return null;
                },
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
                          colorScheme: const ColorScheme.light(
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
                    controller.rent_AvailableFrom.text =
                    "${picked.day}/${picked.month}/${picked.year}";
                  }
                },
              ),

              const SizedBox(height: 16),
              const Text("Security Deposit"),
              const SizedBox(height: 8),
              buildTextField(
                "Enter Security Deposit Amount",
                Icons.currency_rupee_outlined,
                controller.rent_SecurityDeposit,
                isPhoneKey: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter deposit';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
            ],
          ),
        );

      } else if (controller.lookingTo.value == "Sell" &&
          controller.propertyType.value == "Residential") {
        return Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text("Expected Price"),
              SizedBox(height: 8),
              buildTextField(
                "Enter Expected Price",
                Icons.currency_rupee_outlined,
                controller.sell_ExpectedPrice,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter expected price';
                  }
                  final rent = int.tryParse(value); // parse once
                  if (rent == null) {
                    return 'Please enter a valid amount';
                  }
                  if (rent > 5000000000 || rent < 2000000) {
                    return 'Please enter rent between  2000000 to 500000000';
                  }
                  return null;
                },
                isPhoneKey: true,
              ),
              // SizedBox(height: 16),
              // Text("Past 5 years Price"),
              // SizedBox(height: 8),
              // buildTextField(
              //   "Enter Past 5 years Price",
              //   Icons.currency_rupee_outlined,
              //   controller.pastFiveYearPrice,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter expected price';
              //     }
              //     final rent = int.tryParse(value); // parse once
              //     if (rent == null) {
              //       return 'Please enter a valid amount';
              //     }
              //     if (rent > 5000000000 || rent < 2000000) {
              //       return 'Please enter rent between  2000000 to 500000000';
              //     }
              //     return null;
              //   },
              //   isPhoneKey: true,
              // ),
              // SizedBox(height: 16),
              // Text("Future 5 years Price (₹)"),
              // SizedBox(height: 8),
              // buildTextField(
              //   "Enter Future 5 years Price (₹)",
              //   Icons.currency_rupee_outlined,
              //   controller.futureFiveYearPrice,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter expected price';
              //     }
              //     final rent = int.tryParse(value); // parse once
              //     if (rent == null) {
              //       return 'Please enter a valid amount';
              //     }
              //     if (rent > 5000000000 || rent < 2000000) {
              //       return 'Please enter rent between  2000000 to 500000000';
              //     }
              //     return null;
              //   },
              //   isPhoneKey: true,
              // ),
              const SizedBox(height: 16),
              buildSectionTitle('Also for Rent?'),
              const SizedBox(height: 8),
              // ---------------- CHECKBOX + CONDITIONAL FIELD ----------------
              Obx(() => Row(
                children: [
                  Checkbox(
                    value: controller.isPredefinedCostEnabled.value,
                    activeColor: ColorRes.primary,
                    onChanged: (val) {
                      controller.isPredefinedCostEnabled.value = val ?? false;
                    },
                  ),
                  const Text(
                    "You want to Rent",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: ColorRes.textColor,
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 8),

              Obx(() => controller.isPredefinedCostEnabled.value
                  ? buildTextField(
                "Enter Rent",
                Icons.currency_rupee_outlined,
                controller.rent_MonthilyRent,
                isPhoneKey: true,
                validator: (value) {
                  if (controller.isPredefinedCostEnabled.value &&
                      (value == null || value.isEmpty)) {
                    return 'Please enter Rent';
                  }
                  return null;
                },
              )
                  : const SizedBox.shrink()),

              // -------------------- PAST 5 YEARS PRICES --------------------
              // -------------------- PAST 5 YEARS PRICES --------------------
              const SizedBox(height: 24),
              buildSectionTitle("Past 5 Years Prices (Required)"),
              const SizedBox(height: 8),

// Responsive grid layout
              Column(
                children: [
                  // First 4 fields (2 per row)
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(5, (index) {
                      int year = DateTime.now().year - (index+1);
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 45) / 2, // 2 per row
                        child: buildTextField(
                          "$year",
                          Icons.currency_rupee_outlined,
                          onChanged: (value) {
                            log("Past year 5 ${controller.pastPrices.map((e) => e,)}");
                            
                          },
                          controller.pastPrices[index],
                          isPhoneKey: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter price for $year';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Enter valid number';
                            }
                            return null;
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  // // Last field (full width)
                  // Builder(builder: (context) {
                  //   int year = DateTime.now().year - 5;
                  //   return buildTextField(
                  //     "Price for $year",
                  //     Icons.currency_rupee_outlined,
                  //     controller.pastPrices[4],
                  //     isPhoneKey: true,
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return 'Enter price for $year';
                  //       }
                  //       if (int.tryParse(value) == null) {
                  //         return 'Enter valid number';
                  //       }
                  //       return null;
                  //     },
                  //   );
                  // }),
                ],
              ),


              // -------------------- FUTURE 5 YEARS PRICES --------------------
              // -------------------- FUTURE 5 YEARS PRICES --------------------
              const SizedBox(height: 24),
              buildSectionTitle("Future 5 Years Prices (Optional)"),
              const SizedBox(height: 8),

              Column(
                children: [
                  // First 4 fields → 2 in each row
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(5, (index) {
                      int year = DateTime.now().year + (index+1);
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 45) / 2,
                        child: buildTextField(

                          "$year",
                          Icons.currency_rupee_outlined,
                          controller.futurePrices[index],
                          isPhoneKey: true,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              if (int.tryParse(value) == null) {
                                return 'Enter a valid number';
                              }
                            }
                            return null;
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  //
                  // // Last field → full width
                  // Builder(builder: (context) {
                  //   int year = DateTime.now().year + 5;
                  //   return buildTextField(
                  //     "Price for $year ",
                  //     Icons.currency_rupee_outlined,
                  //     controller.futurePrices[4],
                  //     isPhoneKey: true,
                  //     validator: (value) {
                  //       if (value != null && value.isNotEmpty) {
                  //         if (int.tryParse(value) == null) {
                  //           return 'Enter a valid number';
                  //         }
                  //       }
                  //       return null;
                  //     },
                  //   );
                  // }),
                ],
              ),

              SizedBox(height: 16),
              buildSectionTitle('Price  Negotiable'),
              SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,

                children:
                    ["Yes", "No"]
                        .map(
                          (type) => buildChoice(
                            title: type,
                            selected:
                                controller.negotiablePriceOrNot.value == type,
                            onTap: () {
                              controller.setValue(
                                controller.negotiablePriceOrNot,
                                type,
                              );
                            },
                          ),
                        )
                        .toList(),
              ),
              SizedBox(height: 16),
              buildSectionTitle("Construction status"),
              SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    ["Ready to move", "Under Construction"]
                        .map(
                          (type) => buildChoice(
                            title: type,
                            selected:
                                controller.sell_constructionStatus.value ==
                                type,
                            onTap: () {
                              controller.setValue(
                                controller.sell_constructionStatus,
                                type,
                              );
                            },
                          ),
                        )
                        .toList(),
              ),
              Obx(() {
                print('${controller.sell_constructionStatus.value}');
                return controller.selectedSellFromPriceDetail.value
                    ? Padding(
                      padding: const EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        'Please select Status',
                        style: TextStyle(
                          color: ColorRes.error.shade700,
                          fontSize: AppFontSizes.small,
                          // fontSize: 12,
                        ),
                      ),
                    )
                    : const SizedBox.shrink();
              }),

              if (controller.sell_constructionStatus.value ==
                  "Under Construction") ...[
                SizedBox(height: 16),
                Text("Available From"),
                SizedBox(height: 8),
                buildTextField(
                  "Enter Available From",
                  Icons.calendar_month_outlined,
                  controller.sell_AvailableFrom,
                  isEnable: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid month';
                    }
                    return null;
                  },
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
                      controller.sell_AvailableFrom.text =
                          "${picked.day}/${picked.month}/${picked.year}";
                    }
                  },
                ),
              ],
              if (controller.sell_constructionStatus.value ==
                  "Ready to move") ...[
                SizedBox(height: 16),
                Text("Age of property"),

                SizedBox(height: 8),
                buildTextField(
                  "Enter property age in year",
                  Icons.timelapse_outlined,
                  controller.ageOfPropertyController,
                  isPhoneKey: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid age';
                    }
                    return null;
                  },
                ),
              ],
            ],
          ),
        );
      } else if (controller.lookingTo.value == 'Rent' &&
          controller.propertyType.value == "Commercial") {
        return Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Text("Financial"),
              if (controller.selectedIndex.value != "Office" &&
                  controller.selectedIndex.value != "Shop" &&
                  controller.selectedIndex.value != "Showroom" &&
                  controller.selectedIndex.value != "Warehouse") ...[
                SizedBox(height: 8),
                buildSectionTitle('Excepted Rent'),
                SizedBox(height: 8),
                buildTextField(
                  'Enter rent',

                  Icons.currency_rupee_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Excepted rent';
                    }
                    final rent = int.tryParse(value); // parse once
                    if (rent == null) {
                      return 'Please enter a valid amount';
                    }
                    if (rent > 1500000 || rent < 20000) {
                      return 'Please enter rent between  20000 to 1500000';
                    }

                    return null;
                  },

                  controller.commercial_rent_cost,

                  isPhoneKey: true,
                ),
                SizedBox(height: 16),
                buildSectionTitle('Security Deposit'),
                SizedBox(height: 8),
                buildTextField(
                  'Enter deposit',

                  Icons.currency_rupee_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Excepted deposit';
                    }
                    final rent = int.tryParse(value); // parse once
                    if (rent == null) {
                      return 'Please enter a valid amount';
                    }
                    if (rent > 1500000 || rent < 20000) {
                      return 'Please enter rent between  20000 to 1500000';
                    }

                    return null;
                  },

                  controller.commercial_rent_security_deposite,

                  isPhoneKey: true,
                ),
              ] else ...[
                SizedBox(height: 8),
                buildSectionTitle('Monthly Rent'),
                SizedBox(height: 8),
                buildTextField(
                  'Enter rent',

                  Icons.currency_rupee_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Excepted rent';
                    }
                    final rent = int.tryParse(value); // parse once
                    if (rent == null) {
                      return 'Please enter a valid amount';
                    }
                    if (rent > 1500000 || rent < 20000) {
                      return 'Please enter rent between  20000 to 1500000';
                    }

                    return null;
                  },

                  controller.commercial_rent_cost,

                  isPhoneKey: true,
                ),
                SizedBox(height: 16),
                buildSectionTitle('Price Negotiable'),
                SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children:
                      ["Yes", "No"]
                          .map(
                            (type) => buildChoice(
                              title: type,
                              selected:
                                  controller
                                      .commercial_rent_price_negotiable
                                      .value ==
                                  type,
                              onTap: () {
                                controller.setValue(
                                  controller.commercial_rent_price_negotiable,
                                  type,
                                );
                              },
                            ),
                          )
                          .toList(),
                ),
                SizedBox(height: 16),
                buildSectionTitle('Brokerage'),
                SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children:
                      ["Yes", "No"]
                          .map(
                            (type) => buildChoice(
                              title: type,
                              selected:
                                  controller.commercial_rent_brokage.value ==
                                  type,
                              onTap: () {
                                controller.setValue(
                                  controller.commercial_rent_brokage,
                                  type,
                                );
                              },
                            ),
                          )
                          .toList(),
                ),
                if (controller.commercial_rent_brokage.value == 'Yes') ...[
                  SizedBox(height: 16),
                  buildSectionTitle('Brokerage Amount'),
                  SizedBox(height: 8),
                  buildTextField(
                    'Enter brokerage amount',

                    Icons.currency_rupee_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter brokrage rent';
                      }
                      final rent = int.tryParse(value); // parse once
                      if (rent == null) {
                        return 'Please enter a valid amount';
                      }
                      if (rent > 1500000 || rent < 20000) {
                        return 'Please enter rent between  20000 to 1500000';
                      }

                      return null;
                    },

                    controller.commercial_rent_brokerage,

                    isPhoneKey: true,
                  ),
                  SizedBox(height: 16),
                  buildSectionTitle('Brokerage Negotiable'),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        ["Yes", "No"]
                            .map(
                              (type) => buildChoice(
                                title: type,
                                selected:
                                    controller
                                        .commercial_rent_brokage_negotiable
                                        .value ==
                                    type,
                                onTap: () {
                                  controller.setValue(
                                    controller
                                        .commercial_rent_brokage_negotiable,
                                    type,
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ],
                SizedBox(height: 16),
                buildSectionTitle('Maintenance Charges'),
                SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children:
                      ["Included in Rent", "Separate"]
                          .map(
                            (type) => buildChoice(
                              title: type,
                              selected:
                                  controller
                                      .commercial_rent_maintainance_charge
                                      .value ==
                                  type,
                              onTap: () {
                                controller.setValue(
                                  controller
                                      .commercial_rent_maintainance_charge,
                                  type,
                                );
                              },
                            ),
                          )
                          .toList(),
                ),

                if (controller.commercial_rent_maintainance_charge.value ==
                    "Separate") ...[
                  SizedBox(height: 16),
                  buildSectionTitle('Maintenance Amount'),
                  SizedBox(height: 8),
                  buildTextField(
                    'Enter maintenance amount',

                    Icons.currency_rupee_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Excepted rent';
                      }
                      final rent = int.tryParse(value); // parse once
                      if (rent == null) {
                        return 'Please enter a valid amount';
                      }
                      if (rent > 1500000 || rent < 20000) {
                        return 'Please enter rent between  20000 to 1500000';
                      }

                      return null;
                    },

                    controller.commercial_rent_mainatainance_charge,

                    isPhoneKey: true,
                  ),
                ],
              ],
            ],
          ),
        );
      } else if (controller.lookingTo.value == 'Sell' &&
          controller.propertyType.value == "Commercial") {
        return Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Text("Financial"),
              if (controller.selectedIndex.value != "Office" &&
                  controller.selectedIndex.value != "Shop" &&
                  controller.selectedIndex.value != "Showroom" &&
                  controller.selectedIndex.value != "Warehouse") ...[
                SizedBox(height: 8),
                buildSectionTitle('Plot Price'),
                SizedBox(height: 8),
                buildTextField(
                  'Enter rent',

                  Icons.currency_rupee_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Excepted rent';
                    }
                    final rent = int.tryParse(value); // parse once
                    if (rent == null) {
                      return 'Please enter a valid amount';
                    }
                    if (rent > 1500000 || rent < 20000) {
                      return 'Please enter rent between  20000 to 1500000';
                    }

                    return null;
                  },

                  controller.commercial_rent_cost,

                  isPhoneKey: true,
                ),
                // SizedBox(height: 16),
                // buildSectionTitle('Security Deposit'),
                // SizedBox(height: 8),
                // buildTextField(
                //   'Enter deposit',
                //
                //   Icons.currency_rupee_outlined,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter Excepted deposit';
                //     }
                //     final rent = int.tryParse(value); // parse once
                //     if (rent == null) {
                //       return 'Please enter a valid amount';
                //     }
                //     if (rent > 1500000 || rent < 20000) {
                //       return 'Please enter rent between  20000 to 1500000';
                //     }
                //
                //     return null;
                //   },
                //
                //   controller.commercial_rent_security_deposite,
                //
                //   isPhoneKey: true,
                // ),
              ] else ...[
                SizedBox(height: 8),
                buildSectionTitle('Property Price'),
                SizedBox(height: 8),
                buildTextField(
                  'Enter price',

                  Icons.currency_rupee_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Excepted price';
                    }
                    final rent = int.tryParse(value); // parse once
                    if (rent == null) {
                      return 'Please enter a valid amount';
                    }
                    if (rent > 1500000 || rent < 20000) {
                      return 'Please enter rent between  20000 to 1500000';
                    }

                    return null;
                  },

                  controller.commercial_rent_cost,

                  isPhoneKey: true,
                ),
                SizedBox(height: 16),
                buildSectionTitle('Price Negotiable'),
                SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children:
                      ["Yes", "No"]
                          .map(
                            (type) => buildChoice(
                              title: type,
                              selected:
                                  controller
                                      .commercial_rent_price_negotiable
                                      .value ==
                                  type,
                              onTap: () {
                                controller.setValue(
                                  controller.commercial_rent_price_negotiable,
                                  type,
                                );
                              },
                            ),
                          )
                          .toList(),
                ),
                SizedBox(height: 16),
                buildSectionTitle('Brokerage'),
                SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children:
                      ["Yes", "No"]
                          .map(
                            (type) => buildChoice(
                              title: type,
                              selected:
                                  controller.commercial_rent_brokage.value ==
                                  type,
                              onTap: () {
                                controller.setValue(
                                  controller.commercial_rent_brokage,
                                  type,
                                );
                              },
                            ),
                          )
                          .toList(),
                ),
                if (controller.commercial_rent_brokage.value == 'Yes') ...[
                  SizedBox(height: 16),
                  buildSectionTitle('Brokerage Amount'),
                  SizedBox(height: 8),
                  buildTextField(
                    'Enter brokerage amount',

                    Icons.currency_rupee_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter brokerage';
                      }
                      final rent = int.tryParse(value); // parse once
                      if (rent == null) {
                        return 'Please enter a valid amount';
                      }
                      if (rent > 1500000 || rent < 20000) {
                        return 'Please enter rent between  20000 to 1500000';
                      }

                      return null;
                    },

                    controller.commercial_rent_brokerage,

                    isPhoneKey: true,
                  ),
                  SizedBox(height: 16),
                  buildSectionTitle('Brokerage Negotiable'),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        ["Yes", "No"]
                            .map(
                              (type) => buildChoice(
                                title: type,
                                selected:
                                    controller
                                        .commercial_rent_brokage_negotiable
                                        .value ==
                                    type,
                                onTap: () {
                                  controller.setValue(
                                    controller
                                        .commercial_rent_brokage_negotiable,
                                    type,
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ],
                // SizedBox(height: 16),
                // buildSectionTitle('Maintenance Charges'),
                // SizedBox(height: 8),
                // Wrap(
                //   spacing: 12,
                //   runSpacing: 12,
                //   children:
                //   ["Included in Rent", "Separate"]
                //       .map(
                //         (type) => buildChoice(
                //       title: type,
                //       selected:
                //       controller
                //           .commercial_rent_maintainance_charge
                //           .value ==
                //           type,
                //       onTap: () {
                //         controller.setValue(
                //           controller
                //               .commercial_rent_maintainance_charge,
                //           type,
                //         );
                //       },
                //     ),
                //   )
                //       .toList(),
                // ),
                //
                // if (controller.commercial_rent_maintainance_charge.value ==
                //     "Separate") ...[
                //   SizedBox(height: 16),
                //   buildSectionTitle('Maintenance Amount'),
                //   SizedBox(height: 8),
                //   buildTextField(
                //     'Enter maintenance amount',
                //
                //     Icons.currency_rupee_outlined,
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Please enter Excepted rent';
                //       }
                //       final rent = int.tryParse(value); // parse once
                //       if (rent == null) {
                //         return 'Please enter a valid amount';
                //       }
                //       if (rent > 1500000 || rent < 20000) {
                //         return 'Please enter rent between  20000 to 1500000';
                //       }
                //
                //       return null;
                //     },
                //
                //     controller.commercial_rent_mainatainance_charge,
                //
                //     isPhoneKey: true,
                //   ),
                // ],
              ],
            ],
          ),
        );
      } else {
        return SizedBox();
      }
    });
  }
}
