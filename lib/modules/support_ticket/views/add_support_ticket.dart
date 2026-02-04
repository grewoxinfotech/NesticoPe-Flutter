import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/utils/validation.dart';
import 'package:housing_flutter_app/modules/support_ticket/controllers/support_ticket_controller.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/text_field.dart';

class CreateTicketScreen extends StatelessWidget {
  const CreateTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SupportTicketController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Create Ticket")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              NesticoPeTextField(
                title: 'Title',
                hintText: 'Enter title',
                validator: (value) => requiredField(value, 'title'),
                controller: controller.titleController,
              ),
              const SizedBox(height: 20),

              Obx(
                () => NesticoPeDropdownField<String>(
                  title: 'Ticket Category',
                  value:
                      controller.selectedCategory.value.isEmpty
                          ? null
                          : controller.selectedCategory.value,
                  hintText: "Select Category",
                  items:
                      controller.categories
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e.replaceAll("_", " ").capitalize.toString(),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (val) => controller.selectedCategory.value = val!,
                ),
              ),
              const SizedBox(height: 20),

              Obx(
                () => NesticoPeDropdownField<String>(
                  title: 'Ticket Type',
                  value:
                      controller.selectedTicketType.value.isEmpty
                          ? null
                          : controller.selectedTicketType.value,
                  hintText: "Select Ticket Type",
                  items:
                      controller.ticketTypes
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e.replaceAll("_", " ").capitalize.toString(),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (val) => controller.selectedTicketType.value = val!,
                ),
              ),
              const SizedBox(height: 20),

              NesticoPeTextField(
                title: 'Description',
                hintText: 'Enter description',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required';
                  }
                  if (value.length < 10) {
                    return 'Description must be at least 20 characters';
                  }
                  return null;
                },
                controller: controller.descriptionController,
                maxLines: 4,
              ),

              // const SizedBox(height: 20),
              //
              // Obx(
              //   () => NesticoPeDropdownField<String>(
              //     value:
              //         controller.selectedPriority.value.isEmpty
              //             ? null
              //             : controller.selectedPriority.value,
              //     title: 'Priority',
              //     hintText: "Select Priority",
              //     items:
              //         controller.priorities
              //             .map(
              //               (e) => DropdownMenuItem(
              //                 value: e,
              //                 child: Text(
              //                   e.replaceAll("_", " ").capitalize.toString(),
              //                 ),
              //               ),
              //             )
              //             .toList(),
              //     onChanged: (val) => controller.selectedPriority.value = val!,
              //   ),
              // ),
              const SizedBox(height: 30),

              // ---------------- Upload Image Section ----------------
              // ---------------- Upload Image Section ----------------
              const Text(
                "Upload Image",
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.bold,
                ),
              ),
              const SizedBox(height: 10),

              Obx(() {
                final file = controller.pickedImages.value;

                // If no image selected → show add box
                if (file.path.isEmpty) {
                  return GestureDetector(
                    onTap: controller.pickImage, // opens picker
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: const Icon(Icons.add_a_photo, size: 30),
                    ),
                  );
                }

                // If image selected → show preview
                return SizedBox(
                  height: 80,
                  child: Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(file),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Replace clickable area
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: controller.pickImage, // replace image
                          ),
                        ),
                      ),

                      // Remove badge
                      Positioned(
                        right: 4,
                        top: 4,
                        child: GestureDetector(
                          onTap: controller.clearImage,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black54,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 30),

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : controller.submitTicket,
                    child:
                        controller.isLoading.value
                            ? Text('Submitting...')
                            : Text("Submit Ticket"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.isLoading.value
                              ? Get.theme.colorScheme.primary.withOpacity(0.3)
                              : Get.theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
