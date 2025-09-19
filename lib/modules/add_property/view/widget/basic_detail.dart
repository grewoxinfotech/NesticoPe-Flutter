import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';

class BasicDetail extends StatelessWidget {
  final CreatePropertyController controller;
  const BasicDetail({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
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
                onTap: () => controller.setValue(controller.propertyType,'Residential'),
              ),
              const SizedBox(width: 12),
              buildChoice(
                title: 'Commercial',
                selected: controller.propertyType.value == 'Commercial',
                onTap: () => controller.setValue(controller.propertyType,'Commercial'),
              ),
            ],
          ),

          const SizedBox(height: 24),
          buildSectionTitle("You're looking to..."),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              if (controller.propertyType.value == 'Residential') ...[
                buildChoice(
                  title: 'Rent',
                  selected: controller.lookingTo.value == 'Rent',
                  onTap: () => controller.setValue(controller.lookingTo,'Rent'),
                ),
                buildChoice(
                  title: 'Sell',
                  selected: controller.lookingTo.value == 'Sell',
                  onTap: () => controller.setValue(controller.lookingTo,'Sell'),
                ),
                buildChoice(
                  title: 'PG/Co-Living',
                  selected: controller.lookingTo.value == 'PG/Co-Living',
                  onTap: () => controller.setValue(controller.lookingTo,'PG/Co-Living'),
                ),
              ] else ...[
                buildChoice(
                  title: 'Rent',
                  selected: controller.lookingTo.value == 'Rent',
                  onTap: () => controller.setValue(controller.lookingTo,'Rent'),
                ),
                buildChoice(
                  title: 'Sell',
                  selected: controller.lookingTo.value == 'Sell',
                  onTap: () => controller.setValue(controller.lookingTo,'Sell'),
                ),
              ],
            ],
          ),

          const SizedBox(height: 24),
          Text('City'),
          const SizedBox(height: 8),

          buildTextField(
            "Search City",
            Icons.search,
            controller.cityController,
            
          ),
          if (controller.propertyType.value == "Commercial") ...[
            const SizedBox(height: 24),
            subPropertyType(controller),
          ],

          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
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
                "Next, add address & price",
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
    });
  }
}
