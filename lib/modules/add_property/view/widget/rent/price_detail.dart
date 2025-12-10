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
        return Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text("Monthly Rent"),
              SizedBox(height: 8),
              buildTextField(
                "Enter Monthly Rent",
                Icons.currency_rupee_outlined,
                controller.rent_MonthilyRent,
                isPhoneKey: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter monthly rent';
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
              ),
              SizedBox(height: 16),
              buildSectionTitle('Rent Negotiable'),
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
              Text("Available From"),
              SizedBox(height: 8),
              buildTextField(
                "Enter Available From",
                Icons.calendar_month_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid month';
                  }
                  return null;
                },

                controller.rent_AvailableFrom,
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
                    controller.rent_AvailableFrom.text =
                        "${picked.day}/${picked.month}/${picked.year}";
                  }
                },
              ),

              SizedBox(height: 16),
              Text("Security Deposit"),
              SizedBox(height: 8),
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
              SizedBox(height: 16),
              Text("Past 5 years Price"),
              SizedBox(height: 8),
              buildTextField(
                "Enter Past 5 years Price",
                Icons.currency_rupee_outlined,
                controller.pastFiveYearPrice,
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
              SizedBox(height: 16),
              Text("Future 5 years Price (₹)"),
              SizedBox(height: 8),
              buildTextField(
                "Enter Future 5 years Price (₹)",
                Icons.currency_rupee_outlined,
                controller.futureFiveYearPrice,
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
                  controller.selectedIndex.value != "Showroom"&&
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
                  controller.selectedIndex.value != "Showroom"&&
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
