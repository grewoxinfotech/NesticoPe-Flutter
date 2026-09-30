import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/add_property/controller/create_property_controller.dart';
import 'package:nesticope_app/modules/add_property/view/create_property.dart';
import 'package:nesticope_app/modules/search_property/model/search_model.dart';
import 'package:nesticope_app/modules/search_property/view/search_screen.dart';

class RentAdditionalDetail extends StatelessWidget {
  final CreatePropertyController controller;
  final GlobalKey<FormState>? formKey;

  const RentAdditionalDetail({
    super.key,
    required this.controller,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final sell_rent_facing = [
      'North',
      'South',
      'East',
      'West',
      'North-East',
      'North-West',
      'South-East',
      'South-West',
    ];

    return Obx(() {
      return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 1. Facing
            buildSectionTitle("Facing"),
            const SizedBox(height: 8),
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
                          controller.setValue(controller.rent_facing, option);
                        },
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Address
            buildSectionTitle("Address"),
            const SizedBox(height: 8),
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
                          initialSearchText: controller.sell_rent_Address.text,
                        ),
                  ),
                );

                controller.sell_rent_Address.text =
                    selectedCity.description ?? '';
              },
            ),
            const SizedBox(height: 16),

            // 3. Servent Room
            buildSectionTitle("Servent Room"),
            const SizedBox(height: 8),
            Obx(
              () => Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    ['Yes', 'No'].map((option) {
                      return buildChoice(
                        title: option,
                        selected:
                            controller.sell_rent_Servent_Room.value == option,
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
            const SizedBox(height: 16),

            // 4. Sub-Registrar Office (SRO) Name
            buildSectionTitle("Sub-Registrar Office (SRO) Name"),
            const SizedBox(height: 8),
            buildTextField(
              "Enter SRO Name",
              Icons.apartment_outlined,
              controller.subRegistrarOffice,
            ),
            const SizedBox(height: 16),

            // 5. Sale Deed Document Number
            buildSectionTitle("Sale Deed Document Number"),
            const SizedBox(height: 8),
            buildTextField(
              "Enter Sale Deed Document Number",
              Icons.edit_document,
              controller.saleDeedDocumentNumber,
            ),
            const SizedBox(height: 16),

            // 6. Year of Registration
            buildSectionTitle("Year of Registration"),
            const SizedBox(height: 8),
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
                  lastDate: now,
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
                  controller.yearOfRegistration.text = picked.year.toString();
                }
              },
            ),

            if (controller.rent_propertyType.value.toLowerCase() == "plot" ||
                controller.rent_propertyType.value.toLowerCase() ==
                    "agricultural land") ...[
              const SizedBox(height: 16),
              buildSectionTitle("Survey Number"),
              const SizedBox(height: 8),
              buildTextField(
                "Enter Survey Number",
                Icons.app_registration,
                isPhoneKey: true,
                controller.surveyNumberPlotAndLand,
              ),
              const SizedBox(height: 16),
              buildSectionTitle("Khata Number"),
              const SizedBox(height: 8),
              buildTextField(
                "Enter Khata Number",
                Icons.numbers_outlined,
                isPhoneKey: true,
                controller.khataNumberPlotAndLand,
              ),
            ],
            const SizedBox(height: 16),

            // 7. RERA ID
            buildSectionTitle('RERA ID'),
            const SizedBox(height: 8),
            buildTextField(
              "Enter RERA id",
              Icons.description_outlined,
              controller.sell_Rera_Id,
            ),
            const SizedBox(height: 16),

            // 8. Property Description
            buildSectionTitle('Property Description'),
            const SizedBox(height: 8),
            buildTextField(
              "Write about your property",
              Icons.description_outlined,
              controller.sell_rent_propertyDescriptionController,
              maxLines: 5,
              minLines: 1,
            ),
            const SizedBox(height: 4),
            Text(
              "Tell us more about the specific features of your property.",
              style: TextStyle(
                fontSize: AppFontSizes.extraSmall,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }
}
