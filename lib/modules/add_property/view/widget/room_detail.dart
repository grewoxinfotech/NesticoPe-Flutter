import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';

class RoomDetail extends StatelessWidget {
  final CreatePropertyController controller;
  const RoomDetail({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        buildSectionTitle('Room Details'),
        const SizedBox(height: 10),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: ColorRes.grey.withOpacity(0.3), width: 0.8),
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Room 1',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppFontSizes.body,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: ColorRes.primary,
                        fontSize: AppFontSizes.small,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                buildSectionTitle('Room Type'),
                SizedBox(height: 8),
                Obx(
                  () => Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      buildChoice(
                        width: 140,
                        title: 'Private Room',
                        selected: controller.roomType.value == 'Private Room',
                        onTap: () {
                          controller.setValue(
                            controller.roomType,
                            'Private Room',
                          );
                        },
                      ),
                      buildChoice(
                        width: 140,
                        title: 'Double Sharing',
                        selected: controller.roomType.value == 'Double Sharing',
                        onTap: () {
                          controller.setValue(
                            controller.roomType,
                            'Double Sharing',
                          );
                        },
                      ),
                      buildChoice(
                        title: 'Triple Sharing',
                        width: 140,
                        selected: controller.roomType.value == 'Triple Sharing',
                        onTap: () {
                          controller.setValue(
                            controller.roomType,
                            'Triple Sharing',
                          );
                        },
                      ),
                      buildChoice(
                        title: '3 + Sharing',
                        width: 140,
                        selected: controller.roomType.value == '3 + Sharing',
                        onTap: () {
                          controller.setValue(
                            controller.roomType,
                            '3 + Sharing',
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                buildTextField(
                  'Monthly Rent',
                  Icons.calendar_month_outlined,
                  controller.monthlyRentController,
                  isPhoneKey: true,
                ),
                SizedBox(height: 16),
                buildTextField(
                  'Deposit',
                  Icons.currency_rupee_sharp,
                  controller.depositeController,
                  isPhoneKey: true,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
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
              backgroundColor: ColorRes.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: ColorRes.primary, width: 1),
              ),
              elevation: 2,
            ),
            child: const Text(
              "Add Another Room",
              style: TextStyle(
                fontSize: 14,
                color: ColorRes.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
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
              "Post Property",
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
