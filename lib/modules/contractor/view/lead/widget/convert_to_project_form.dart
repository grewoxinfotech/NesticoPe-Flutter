import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_lead_model/contractor_lead_model.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_lead_controller.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_my_service_controller.dart';

import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/constants/color_res.dart';
import '../../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../../add_property/view/create_property.dart';

class AddProjectScreen extends StatefulWidget {
  ContractorLeadItem item;
  AddProjectScreen({super.key, required this.item});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final formKey = GlobalKey<FormState>();
  final controller = Get.find<ContractorLeadController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log(
      "Category datra ${controller.items.value.map((e) => e.customFields?.serviceName ?? '').toSet().toList()}",
    );
  }

  @override
  Widget build(BuildContext context) {
    final controllerCategory = Get.find<ContractorMyServiceController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.populateFormFromItem(widget.item);
    });

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            controller.resetForm();
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text(
          "Convert To Project",
          style: TextStyle(
            color: ColorRes.textPrimary,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: ColorRes.textPrimary),
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSectionTitle("Title *"),
                const SizedBox(height: 8),
                buildTextField(
                  "Enter project title",
                  Icons.title,
                  controller.txtTitle,
                  validator: (v) => v!.isEmpty ? "Please enter title" : null,
                ),
                const SizedBox(height: 16),

                // Dates
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        "Start Date *",
                        Icons.calendar_today,
                        controller.startDate.value,
                        () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            controller.startDate.value = picked;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDateField(
                        "Deadline",
                        Icons.date_range,
                        controller.deadline.value,
                        () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: controller.startDate.value,
                            firstDate:
                                controller.startDate.value ?? DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            controller.deadline.value = picked;
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                buildSectionTitle("Service"),
                const SizedBox(height: 8),
                NesticoPeDropdownField<String>(
                  isRequired: true,
                  enabled: false,
                  value: controller.selectedService.value,
                  hintText: "Select service",
                  prefixIcon: Icons.work,
                  items:
                      controller.items.value
                          ?.map((e) => e.customFields?.serviceName)
                          .where((name) => name != null && name!.isNotEmpty)
                          .toSet() // ✅ removes duplicate names
                          .map(
                            (name) => DropdownMenuItem(
                              value: name,
                              child: Text(name ?? ''),
                            ),
                          )
                          .toList() ??
                      [],

                  onChanged:
                      (val) => controller.selectedService.value = val ?? '',
                  darkText: true,
                ),

                const SizedBox(height: 16),
                buildSectionTitle("Client Name"),
                const SizedBox(height: 8),
                buildTextField(
                  "Enter client name",
                  Icons.person,
                  controller.txtClientName,
                ),

                const SizedBox(height: 16),

                buildSectionTitle("Client Email"),
                const SizedBox(height: 8),
                buildTextField(
                  "Enter client email",
                  Icons.email,
                  controller.txtClientEmail,
                ),
                const SizedBox(height: 16),
                buildSectionTitle("Client Phone"),
                const SizedBox(height: 8),
                buildTextField(
                  "Enter client phone",
                  Icons.phone,
                  controller.txtClientPhone,
                  isPhoneKey: true,
                ),

                const SizedBox(height: 16),
                buildSectionTitle("Project Price"),
                const SizedBox(height: 8),
                buildTextField(
                  "Enter project price",
                  Icons.currency_rupee_outlined,
                  controller.txtProjectPrice,
                  validator:
                      (v) => v!.isEmpty ? "Please enter project price" : null,
                  inputType: TextInputType.number,
                  formatter: [FilteringTextInputFormatter.digitsOnly],
                ),

                const SizedBox(height: 16),
                buildSectionTitle("Notes"),
                const SizedBox(height: 8),
                buildTextField(
                  "Enter notes (optional)",
                  Icons.note,
                  controller.txtNotes,
                  maxLines: 3,
                  minLines: 3,
                ),

                const SizedBox(height: 24),
                SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.resetForm,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ColorRes.textSecondary,
                            side: const BorderSide(color: ColorRes.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              controller.convertIntoProject(
                                widget.item.id ?? '',
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRes.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Convert",
                            style: TextStyle(
                              color: ColorRes.white,
                              fontWeight: AppFontWeights.semiBold,
                              fontSize: AppFontSizes.body,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 📅 Date Picker UI (uses buildTextField style)
  Widget _buildDateField(
    String label,
    IconData icon,
    DateTime? date,
    VoidCallback onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(label),
        const SizedBox(height: 8),
        buildTextField(
          date == null
              ? "Select date"
              : "${date.day}/${date.month}/${date.year}",
          icon,
          TextEditingController(),
          isEnable: false,
          onTap: onTap,
        ),
      ],
    );
  }
}
