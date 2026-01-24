import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_inquiry_controller.dart';
import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../../../widgets/messages/snack_bar.dart';
import '../../../../add_property/view/create_property.dart';
import '../../../controller/contractor_lead_controller.dart';

class ContractorLeadFilter extends StatefulWidget {
  const ContractorLeadFilter({super.key});

  @override
  State<ContractorLeadFilter> createState() => _ContractorLeadFilterState();
}

class _ContractorLeadFilterState extends State<ContractorLeadFilter> {
  final ContractorLeadController controller =
      Get.find<ContractorLeadController>();

  final _formKey = GlobalKey<FormState>();
  DateTime? startDate;
  DateTime? endDate;

  Map<String, String> _buildFilterResult() {
    return {
      if (controller.txtStartDate.text.isNotEmpty &&
          controller.startCreate != null)
        'startDate': controller.txtStartDate.text,
      if (controller.txtEndDate.text.isNotEmpty && controller.endCreate != null)
        'endDate': controller.txtEndDate.text,
      if (controller.leadStatus.value.isNotEmpty)
        'status': controller.leadStatus.value.toLowerCase().replaceAll(
          " ",
          "_",
        ),
      if (controller.leadStage.value.isNotEmpty)
        'stage': controller.leadStage.value.toLowerCase().replaceAll(" ", "_"),
      if (controller.leadSource.value.isNotEmpty)
        'source': controller.leadSource.value.toLowerCase().replaceAll(
          " ",
          "_",
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorRes.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: ColorRes.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Lead Filters",
                        style: TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                        controller.resetFilters();
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: const Icon(
                        Icons.close_rounded,
                        color: ColorRes.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 Scrollable Form
              Flexible(
                flex: 1,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSectionTitle('Created Date Range'),
                      const SizedBox(height: 8),
                      Row(
                        spacing: 12,
                        children: [
                          Expanded(
                            child: buildTextField(
                              'Start Date',
                              Icons.calendar_month_outlined,
                              controller.txtStartDate,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter valid date';
                                }
                                return null;
                              },
                              isEnable: false,
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      controller.startCreate ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
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
                                  setState(() {
                                    startDate = picked;
                                    controller.startCreate = picked;
                                    // Clear end date if it's before start date
                                    if (endDate != null &&
                                        endDate!.isBefore(startDate!)) {
                                      endDate = null;
                                      controller.txtEndDate.clear();
                                    }
                                  });
                                  controller.txtStartDate.text =
                                      "${picked.year}-${picked.month}-${picked.day}";
                                  // controller.getPropertyType(propertyController.items);
                                }
                              },
                              isPhoneKey: true,
                            ),
                          ),
                          Expanded(
                            child: buildTextField(
                              'End Date',
                              Icons.calendar_month_outlined,
                              controller.txtEndDate,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter valid date';
                                }
                                if (startDate != null &&
                                    endDate != null &&
                                    endDate!.isBefore(startDate!)) {
                                  return 'End date must be after start date';
                                }
                                return null;
                              },
                              isEnable: false,
                              onTap: () async {
                                if (startDate == null) {
                                  NesticoPeSnackBar.showAwesomeSnackbar(
                                    title: 'Date Required',
                                    message: 'Please select start date first',
                                    contentType: ContentType.failure,
                                  );
                                  return;
                                }

                                FocusScope.of(context).unfocus();
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      endDate ??
                                      (startDate!.isAfter(DateTime.now())
                                          ? startDate!
                                          : DateTime.now()),
                                  firstDate: startDate!,
                                  // End date cannot be before start date
                                  lastDate: DateTime(2100),
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
                                  setState(() {
                                    endDate = picked;
                                    controller.endCreate = picked;
                                  });
                                  controller.txtEndDate.text =
                                      "${picked.year}-${picked.month}-${picked.day}";
                                  // controller.getPropertyType(propertyController.items);
                                }
                              },
                              isPhoneKey: true,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      buildSectionTitle('Status'),
                      const SizedBox(height: 8),
                      Obx(() {
                        return NesticoPeDropdownField<String>(
                          isRequired: true,
                          value: controller.leadStatus.value,
                          hintText: "Select availability",
                          prefixIcon: Icons.auto_graph,
                          items:
                              [
                                    'New',
                                    'Contacted',
                                    'Qualified',
                                    'Negotiation',
                                    'Lost',
                                    'Converted',
                                  ]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) {
                            controller.setValue(controller.leadStatus, val);
                            log(
                              "Contractor_status ${controller.leadStatus.value}",
                            );
                          },
                          darkText: true,
                        );
                      }),
                      const SizedBox(height: 20),
                      buildSectionTitle('Stage'),
                      const SizedBox(height: 8),
                      Obx(() {
                        return NesticoPeDropdownField<String>(
                          isRequired: true,
                          value: controller.leadStage.value,
                          hintText: "Select availability",
                          prefixIcon: Icons.polyline_sharp,
                          items:
                              [
                                    'New Lead',
                                    'Contacted',
                                    'Interested',
                                    'Site Visit',
                                    'Sell',
                                  ]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) {
                            controller.setValue(controller.leadStage, val);
                            log(
                              "Contractor_status ${controller.leadStage.value}",
                            );
                          },
                          darkText: true,
                        );
                      }),
                      const SizedBox(height: 20),
                      buildSectionTitle('Source'),
                      const SizedBox(height: 8),
                      Obx(() {
                        return NesticoPeDropdownField<String>(
                          isRequired: true,
                          value: controller.leadSource.value,
                          hintText: "Select availability",
                          prefixIcon: Icons.source,
                          items:
                              controller.sourceList.value
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) {
                            controller.setValue(controller.leadSource, val);
                            log(
                              "Contractor_status ${controller.leadSource.value}",
                            );
                          },
                          darkText: true,
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // 🔹 Footer Buttons
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: ColorRes.white,
                  border: Border(
                    top: BorderSide(
                      color: ColorRes.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back(result: <String, String>{});
                          controller.resetFilters();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: ColorRes.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: AppFontSizes.medium,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          final filters = _buildFilterResult();

                          log("Applied Filters: $filters");
                          Get.back(result: filters);
                          // controller.resetFilters();   // controller.resetFilters();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorRes.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.filter_alt, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Apply Filters',
                              style: TextStyle(
                                fontSize: AppFontSizes.medium,
                                fontWeight: AppFontWeights.semiBold,
                              ),
                            ),
                          ],
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
    );
  }
}
