import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';

class RentPriceDetail extends StatelessWidget {
  final CreatePropertyController controller;

  const RentPriceDetail({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final rentDepositType = ["None", "1 month", "2 month", "Custom"];
    return Obx(() {
      if (controller.lookingTo.value == "Rent" &&
          controller.propertyType.value == "Residential") {
        return Column(
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
            ),
            SizedBox(height: 16),
            Text("Available From"),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: ColorRes.primary, // header background color
                          onPrimary: Colors.white, // header text color
                          onSurface: Colors.black, // body text color
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
              child: buildTextField(
                "Enter Available From",
                Icons.calendar_month_outlined,
                controller.rent_AvailableFrom,
                isEnable: false,
              ),
            ),
            SizedBox(height: 16),
            Text("Deposit"),
            SizedBox(height: 8),
            Obx(
              () => Wrap(
                spacing: 12,

                runSpacing: 12,
                children:
                    rentDepositType
                        .map(
                          (type) => buildChoice(
                            title: type,
                            selected: controller.rent_depositType.value == type,

                            onTap: () {
                              controller.setValue(
                                controller.rent_depositType,
                                type,
                              );
                            },
                          ),
                        )
                        .toList(),
              ),
            ),
            if (controller.rent_depositType.value == "Custom") ...[
              SizedBox(height: 16),
              Text("Security Deposit"),
              SizedBox(height: 8),
              buildTextField(
                "Enter Security Deposit Amount",
                Icons.currency_rupee_outlined,
                controller.rent_SecurityDeposit,
                isPhoneKey: true,
              ),
            ],
          ],
        );
      } else if (controller.lookingTo.value == "Sell" &&
          controller.propertyType.value == "Residential") {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text("Expected Price"),
            SizedBox(height: 8),
            buildTextField(
              "Enter Expected Price",
              Icons.currency_rupee_outlined,
              controller.sell_ExpectedPrice,
              isPhoneKey: true,
            ),
            SizedBox(height: 16),
            buildSectionTitle("Construction Status"),
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
                              controller.sell_constructionStatus.value == type,
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
            if (controller.sell_constructionStatus.value ==
                "Under Construction") ...[
              SizedBox(height: 16),
              Text("Available From"),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: ColorRes.primary,
                            // header background color
                            onPrimary: Colors.white,
                            // header text color
                            onSurface: Colors.black, // body text color
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
                child: buildTextField(
                  "Enter Available From",
                  Icons.calendar_month_outlined,
                  controller.sell_AvailableFrom,
                  isEnable: false,
                ),
              ),
            ],
          ],
        );
      } else if (controller.lookingTo.value == 'Rent' &&
          controller.propertyType.value == "Commercial") {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Text("Financial"),
            SizedBox(height: 8),
            buildSectionTitle('Excepted Rent'),
            SizedBox(height: 8),
            buildTextField(
              'Enter Cost',
              Icons.currency_rupee_outlined,
              controller.commercial_rent_cost,
              isPhoneKey: true,
            ),
          ],
        );
      } else if (controller.lookingTo.value == 'Sell' &&
          controller.propertyType.value == "Commercial") {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Text("Financial"),
            SizedBox(height: 8),
            buildSectionTitle('Excepted Rent'),
            SizedBox(height: 8),
            buildTextField(
              'Enter Cost',
              Icons.currency_rupee_outlined,
              controller.commercial_rent_cost,
              isPhoneKey: true,
            ),

            SizedBox(height: 16),
            Text('Other Details'),
            SizedBox(height: 8),
            buildSectionTitle("Is it pre-leased?/pre-rented? "),
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
                              controller.commercial_isPreLeased.value == type,
                          onTap: () {
                            controller.setValue(
                              controller.commercial_isPreLeased,
                              type,
                            );
                          },
                        ),
                      )
                      .toList(),
            ),
            if(controller.commercial_isPreLeased.value=="Yes")...[
              SizedBox(height: 16),
              Text("Current Rent per month"),
              SizedBox(height: 8),
              buildTextField(
                'Enter Rent per month',
                Icons.currency_rupee_outlined,
                controller.commercial_current_rent_preLeasedTill,
                isPhoneKey: true
              ),
              SizedBox(height: 16),
              Text("Lease years"),
              SizedBox(height: 8),
              buildTextField(
                'Enter year',
                Icons.timelapse_outlined,
                controller.commercial_lease_years,
                isPhoneKey: true
              ),
            ]else if(controller.commercial_isPreLeased.value=="No")...[
              SizedBox(height: 16),
              Text("Expected R.O.I %"),
              SizedBox(height: 8),
              buildTextField(
                  'Enter R.O.I %',
                  Icons.timelapse_outlined,
                  controller.commercial_returned_RIO,
                  isPhoneKey: true
              ),
            ]
          ],
        );
      } else {
        return SizedBox();
      }
    });
  }
}
