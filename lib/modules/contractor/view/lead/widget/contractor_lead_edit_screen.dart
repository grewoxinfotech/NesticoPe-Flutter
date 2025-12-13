import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_lead_controller.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_my_service_controller.dart';
import '../../../../../data/network/contractor/model/contractor_lead_model/contractor_lead_model.dart';
import '../../../../../widgets/New folder/inputs/dropdown_field.dart';

/// 🟦 Full Screen Lead Edit Screen
class ContractorLeadEditScreen extends StatefulWidget {
  final ContractorLeadItem lead;
  const ContractorLeadEditScreen({super.key, required this.lead});

  @override
  State<ContractorLeadEditScreen> createState() =>
      _ContractorLeadEditScreenState();
}

class _ContractorLeadEditScreenState extends State<ContractorLeadEditScreen> {
  final controller = Get.find<ContractorLeadController>();
  final controllerMyService = Get.find<ContractorMyServiceController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.populateLeadData(widget.lead);
  }

  /// 🧩 UDF: Reusable text field
  Widget buildTextFieldSection({
    required String label,
    required TextEditingController controller,
    bool requiredField = false,
    bool isPhone=false,
    IconData icon=Icons.person,
    bool enabled = true,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: ColorRes.textColor,
              fontWeight: FontWeight.w500,
              fontSize: AppFontSizes.medium,
            ),
            children: [
              if (requiredField)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        buildTextField(label,icon , controller,  isEnable: enabled,maxLines: maxLines,isPhoneKey: isPhone,  validator: (value) {
          if (requiredField && (value == null || value.isEmpty)) {
            return 'Required field';
          }
          return null;

        },)

      ],
    );
  }

  /// 🧩 UDF: Reusable dropdown
  Widget buildDropdown({
    required String label,
    required List<String> items,
    required RxString value,
    bool requiredField = false,
  }) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                color: ColorRes.textColor,
                fontWeight: FontWeight.w500,
                fontSize: AppFontSizes.medium,
              ),
              children: [
                if (requiredField)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          NesticoPeDropdownField<String>(
            isRequired: requiredField,
            value: value.value.isEmpty ? null : value.value,
            hintText: 'Select $label',
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => value.value = val ?? '',
          ),
        ],
      );
    });
  }

  void _onUpdatePressed() {
    if (_formKey.currentState?.validate() ?? false) {
      log("Updating lead...");
      controller.updateLeadDetails(
         widget.lead.id ?? '',
      );
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(

        title: const Text(
          'Edit Lead',
          style: TextStyle(
            color: ColorRes.textPrimary,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: ColorRes.white),
          onPressed: () {Get.back();controller.resetForm();},
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- First Row: Full name + Phone ---
                Row(
                  children: [
                    Expanded(
                      child: buildTextFieldSection(
                        label: 'Full Name',
                        controller: controller.txtName,
                        requiredField: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: buildTextFieldSection(
                        label: 'Phone',
                        controller: controller.txtPhone,
                        requiredField: true,
                          isPhone: true,
                          icon: Icons.phone
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- Email + Contractor ---
                buildTextFieldSection(
                    label: 'Email',
                    controller: controller.txtEmail,
                    requiredField: true,
                    isPhone: false,
                    icon: Icons.mail_outline
                ),
                const SizedBox(height: 12),
                // buildDropdown(
                //   label: 'Contractor',
                //
                //   items: controller.items.value
                //       .map((e) => e.id ?? '')
                //       .where((id) => id.isNotEmpty)
                //       .toList(),
                //   value: controller.selectedContractor,
                //   requiredField: true,
                // ),
          Obx(() {
            // Use a Set to track unique contractor IDs
            final uniqueContractors = <String>{};

            // Filter duplicates before creating dropdown items
            final contractorItems = controller.items.value
                .where((e) {
              final id = e.customFields?.contractorId;
              if (id == null || id.isEmpty) return false;
              return uniqueContractors.add(id); // only adds if not already present
            })
                .toList();

            return NesticoPeDropdownField<String>(
              isRequired: false,
              title: 'Contractor',
              enabled: false,
              value: controller.selectedContractor.isEmpty
                  ? null
                  : controller.selectedContractor.value,
              items: contractorItems
                  .map((e) => DropdownMenuItem(
                value: e.customFields?.contractorId,
                child: Text(e.customFields?.contractorUsername ?? ''),
              ))
                  .toList(),
              onChanged: (val) {
                if (val != null && val.isNotEmpty) {
                  controller.selectedContractor.value = val;

                  final selectedItem = controller.items.firstWhereOrNull(
                        (element) => element.customFields?.contractorId == val,
                  );

                  controller.selectedContractorName.value =
                      selectedItem?.customFields?.contractorUsername ?? '';
                } else {
                  controller.selectedContractor.value = '';
                  controller.selectedContractorName.value = '';
                }

                log("Selected Contractor: ${controller.selectedContractorName.value} "
                    "(${controller.selectedContractor.value})");
              },
            );
          }),
                const SizedBox(height: 16),

                // --- Service + Source ---
                Obx(
                  () =>  NesticoPeDropdownField<String>(
                    isRequired: false,
                    title: 'Service',
                    value: controller.selectedServiceId.value.isEmpty
                        ? null
                        : controller.selectedServiceId.value,
                    items: controllerMyService.items.value
                        .map((e) => DropdownMenuItem(
                      value: e.id ?? '',
                      child: Text(e.serviceName ?? ''),
                    ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null && val.isNotEmpty) {
                        controller.selectedServiceId.value = val;

                        // safely find matching service name
                        final selectedItem = controllerMyService.items.firstWhereOrNull(
                              (element) => element.id == val,
                        );
                        print("Json Service Name not Chnage ${selectedItem?.toMap()}  $val");
                        controller.selectedServiceName.value =
                            selectedItem?.serviceName ?? '';

                      } else {
                        controller.selectedServiceId.value = '';
                        controller.selectedServiceName.value = '';
                      }

                      // Optional: log or trigger any dependent updates
                      log("Selected Service: ${controller.selectedServiceName.value} "
                          "(${controller.selectedServiceId.value})");
                    },
                  ),
                ),

                const SizedBox(height: 12),
                buildDropdown(
                  label: 'Source',
                  items: ['App','Website','Direct','Social Media','Referral','Other'],
                  value: controller.selectedSource,
                ),
                const SizedBox(height: 16),

                // --- Status + Stage ---
                Row(
                  children: [
                    Expanded(
                      child: buildDropdown(
                        label: 'Status',
                        items: const [
                          'New',
                          'Contacted',
                          'Qualified',
                          'Negotiation',
                          'Lost',
                          'Converted'
                        ],
                        value: controller.selectedStatus,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: buildDropdown(
                        label: 'Stage',
                        items: const [
                          'New Lead',
                          'Contacted',
                          'Interested',
                          'Site Visit',
                          'Sell'
                        ],
                        value: controller.selectedStage,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- Notes ---
                buildTextFieldSection(
                  label: 'Notes',
                  controller: controller.txtNotes,
                  maxLines: 3,
                ),

                const SizedBox(height: 30),

                // --- Buttons ---
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: ()  {Get.back();controller.resetForm();},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: ColorRes.primary),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: ColorRes.primary,
                            fontWeight: AppFontWeights.semiBold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _onUpdatePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorRes.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Update Lead',
                          style: TextStyle(
                            color: ColorRes.white,
                            fontWeight: AppFontWeights.semiBold,
                            fontSize: AppFontSizes.medium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
