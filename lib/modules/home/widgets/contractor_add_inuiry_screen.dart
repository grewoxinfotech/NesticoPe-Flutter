import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/validation.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/text_field.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/widgets/button/button.dart';

import '../controllers/contractor_profile_service_controller/contractor_profile_service_controller.dart';

class ContractorInquiryScreen extends StatelessWidget {
  const ContractorInquiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contractorServiceController = Get.find<ContractorServiceController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Property Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: contractorServiceController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property Type
                NesticoPeDropdownField<String>(
                  title: "Property Type*",
                  value: contractorServiceController.selectedPropertyType.value,
                  hintText: "Select property type",
                  items:
                      contractorServiceController.propertyTypes
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.toLowerCase().replaceAll(' ', '_'),
                              child: Text("e"),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    contractorServiceController.selectedPropertyType.value =
                        value!;
                  },
                  isRequired: true,
                  validator: (value) => requiredField(value, 'PropertyType'),
                ),

                const SizedBox(height: 12),
                NesticoPeTextField(
                  title: "City",
                  controller: contractorServiceController.cityController,
                  hintText: "Enter city",
                  isRequired: true,
                  validator: (value) => requiredField(value, 'City'),
                ),

                const SizedBox(height: 12),
                NesticoPeTextField(
                  title: "Location",
                  controller: contractorServiceController.locationController,
                  hintText: "Enter location",
                  isRequired: true,
                  validator: (value) => requiredField(value, 'Location'),
                ),

                const SizedBox(height: 12),

                // BHK
                NesticoPeTextField(
                  title: "BHK",
                  keyboardType: TextInputType.number,
                  controller: contractorServiceController.bhkController,
                  hintText: "Enter BHK",
                  isRequired: true,
                  formatter: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => requiredField(value, 'BHK'),
                ),

                const SizedBox(height: 12),

                // Carpet Area
                NesticoPeTextField(
                  title: "Carpet Area",
                  keyboardType: TextInputType.number,
                  controller: contractorServiceController.carpetAreaController,
                  hintText: "Enter carpet area",
                  isRequired: true,
                  formatter: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => requiredField(value, 'Carpet Area'),
                ),

                const SizedBox(height: 12),

                // Service Description
                NesticoPeTextField(
                  title: "Service Description",
                  controller: contractorServiceController.descriptionController,
                  hintText: "Enter service description",
                  maxLines: 5,
                  isRequired: true,
                  validator:
                      (value) => requiredField(value, 'Service Description'),
                ),

                const SizedBox(height: 20),

                NesticoPeButton(
                  width: double.infinity,
                  backgroundColor: contractorServiceController.isLoading.value
                      ? ColorRes.leadGreyColor.shade300
                      : ColorRes.primary,
                  title:
                      contractorServiceController.isLoading.value
                          ? "Submitting..."
                          : "Submit",
                  onTap:
                      contractorServiceController.isLoading.value
                          ? null
                          : () {
                    contractorServiceController.createInquiry();
                      },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration() {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.blue, width: 1.3),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );
}
