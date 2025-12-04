import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import 'package:housing_flutter_app/modules/search_property/model/search_model.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

import '../../../../app/constants/color_res.dart';

class BasicDetail extends StatelessWidget {
  final CreatePropertyController controller;
  final GlobalKey<FormState>? formKey;

  const BasicDetail({super.key, required this.controller, this.formKey});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            buildSectionTitle("Property Type"),
            const SizedBox(height: 12),

            Row(
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

            Obx(
              () =>
                  controller.showBasicPropertyType.value
                      ? Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Text(
                          'Please select property type',
                          style: TextStyle(
                            color: ColorRes.error.shade700,
                            fontSize: AppFontSizes.small,
                            // fontSize: 12,
                          ),
                        ),
                      )
                      : const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),
            buildSectionTitle("You're looking to..."),
            const SizedBox(height: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    if (controller.propertyType.value == 'Residential') ...[
                      buildChoice(
                        title: 'Rent',
                        selected: controller.lookingTo.value == 'Rent',
                        onTap:
                            () => controller.setValue(
                              controller.lookingTo,
                              'Rent',
                            ),
                      ),
                      buildChoice(
                        title: 'Sell',
                        selected: controller.lookingTo.value == 'Sell',
                        onTap:
                            () => controller.setValue(
                              controller.lookingTo,
                              'Sell',
                            ),
                      ),
                      buildChoice(
                        title: 'PG/Co-Living',
                        selected: controller.lookingTo.value == 'PG/Co-Living',
                        onTap:
                            () => controller.setValue(
                              controller.lookingTo,
                              'PG/Co-Living',
                            ),
                      ),
                    ] else ...[
                      buildChoice(
                        title: 'Rent',
                        selected: controller.lookingTo.value == 'Rent',
                        onTap:
                            () => controller.setValue(
                              controller.lookingTo,
                              'Rent',
                            ),
                      ),
                      buildChoice(
                        title: 'Sell',
                        selected: controller.lookingTo.value == 'Sell',
                        onTap:
                            () => controller.setValue(
                              controller.lookingTo,
                              'Sell',
                            ),
                      ),
                    ],
                  ],
                ),
                // Add error message
                Obx(
                  () =>
                      controller.showBasicLookingTo.value
                          ? Padding(
                            padding: const EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'Please select what you are looking to do',
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
            ),

            const SizedBox(height: 24),
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
                    selectedCity.description?.split(',')[0] ?? '';
                // controller.cityController.text = selectedCity.split(',')[0];

                print("city ${controller.cityController.text}");
              },
            ),
            if (controller.propertyType.value == "Commercial") ...[
              const SizedBox(height: 24),
              subPropertyType(controller),
              Obx(
                () =>
                    controller.hasShownCommercialCategory.value
                        ? Padding(
                          padding: const EdgeInsets.only(top: 8, left: 4),
                          child: Text(
                            'Please select any one category',
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

            const SizedBox(height: 28),
            // SizedBox(
            //   width: double.infinity,
            //   height: 45,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       if (controller.stepIndex.value < controller.stepsList.value.length) {
            //         controller.nextStep(); // move to next step
            //       } else {
            //         controller.submitForm(); // final submit
            //       }
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: ColorRes.primary,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(14),
            //       ),
            //       elevation: 2,
            //     ),
            //     child: const Text(
            //       "Next, add address & price",
            //       style: TextStyle(
            //         fontSize: 14,
            //         color: ColorRes.white,
            //         fontWeight: AppFontWeights.medium,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    });
  }
}
