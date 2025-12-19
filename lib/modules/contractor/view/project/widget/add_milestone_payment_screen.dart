import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/constants/color_res.dart';
import '../../../../../data/network/contractor/model/contractor_project_model/contractor_project_payment_model.dart';
import '../../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../../add_property/view/create_property.dart';
import '../../../controller/contractor_project_payment_controller.dart';

class AddMilestonePaymentScreen extends StatelessWidget {
  final String tag;
  final MilestonePaymentItem? payment;

  const AddMilestonePaymentScreen({
    super.key,
    required this.tag,
    this.payment,
  });

  @override
  Widget build(BuildContext context) {
    final controller =
    Get.find<ContractorProjectMilestonePaymentController>(tag: tag);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (payment != null) {
        controller.initializeForEdit(payment!);
      } else {
        controller.initializeForAdd();
      }
    });

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            controller.resetForm();
            Get.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Obx(
              () => Text(
            controller.isEditMode.value
                ? "Edit Milestone Payment"
                : "Add Milestone Payment",
            style: const TextStyle(
              color: ColorRes.textPrimary,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: ColorRes.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Milestone
              buildSectionTitle("Milestone *"),
              const SizedBox(height: 8),
              Obx(
                    () => NesticoPeDropdownField<String>(
                  isRequired: true,
                  value: controller.selectedMilestoneId.value.isEmpty
                      ? null
                      : controller.selectedMilestoneId.value,
                  hintText: "Select milestone",
                  prefixIcon: Icons.flag_outlined,
                  enabled: !controller.isEditMode.value, // Disable when editing
                  items: controller.milestones
                      .where((e) => e.paymentStatus?.toLowerCase() != 'paid')
                      .map(
                        (e) => DropdownMenuItem(
                      value: e.id,
                      child: Text(e.title ?? ''),
                    ),
                  )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      controller.selectedMilestoneId.value = val;

                      // Auto-fill amount from milestone
                      final milestone = controller.milestones.firstWhere(
                            (element) => element.id == val,
                      );

                      final amount = double.tryParse(
                        milestone.milestoneAmount ?? '0',
                      ) ??
                          0;
                      controller.amountController.text =
                          amount.toStringAsFixed(0);
                    }
                  },
                  darkText: true,
                ),
              ),

              const SizedBox(height: 16),

              /// 🔹 Amount
              buildSectionTitle("Amount *"),
              const SizedBox(height: 8),
              buildTextField(
                "Enter payment amount",
                Icons.currency_rupee,
                controller.amountController,
                inputType: const TextInputType.numberWithOptions(decimal: true),
                formatter: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+\.?\d{0,2}'),
                  ),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return "Amount is required";
                  if (double.tryParse(v) == null) return "Invalid amount";
                  if (double.parse(v) <= 0) return "Amount must be greater than 0";
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// 🔹 Payment Mode & Status
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSectionTitle("Payment Mode *"),
                        const SizedBox(height: 8),
                        Obx(
                              () => NesticoPeDropdownField<String>(
                            isRequired: true,
                            value: controller.selectedPaymentMode.value,
                            hintText: "Select mode",
                            prefixIcon: Icons.payments_outlined,
                            items: controller.paymentModes
                                .map(
                                  (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                controller.selectedPaymentMode.value = val;
                              }
                            },
                            darkText: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSectionTitle("Payment Status *"),
                        const SizedBox(height: 8),
                        Obx(
                              () => NesticoPeDropdownField<String>(
                            isRequired: true,
                            value: controller.selectedPaymentStatus.value,
                            hintText: "Select status",
                            prefixIcon: Icons.info_outline,
                            items: controller.paymentStatus
                                .map(
                                  (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                controller.selectedPaymentStatus.value = val;
                              }
                            },
                            darkText: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// 🔹 Paid On
              buildSectionTitle("Paid On *"),
              const SizedBox(height: 8),
              Obx(
                    () => _buildDateField(
                  context,
                  controller.paidOn.value,
                      () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: controller.paidOn.value ?? DateTime.now(),
                      firstDate:
                      DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      controller.paidOn.value = picked;
                    }
                  },
                ),
              ),

              const SizedBox(height: 16),

              /// 🔹 Reference Note
              buildSectionTitle("Reference Note (Optional)"),
              const SizedBox(height: 8),
              buildTextField(
                "Enter reference note",
                Icons.notes_outlined,
                controller.referenceNoteController,
                maxLines: 3,
                minLines: 3,
              ),

              const SizedBox(height: 24),

              /// 🔹 Submit Button
              SizedBox(
                width: double.infinity,
                child: Obx(
                      () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                      if (controller.formKey.currentState?.validate() ??
                          false) {
                        controller.saveMilestone();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: ColorRes.primary,
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      controller.isEditMode.value
                          ? "Update Payment"
                          : "Add Payment",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(
      BuildContext context,
      DateTime? date,
      VoidCallback onTap,
      ) {
    return buildTextField(
      date == null
          ? "Select payment date"
          : "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}",
      Icons.calendar_today,
      TextEditingController(),
      isEnable: false,
      onTap: onTap,
      validator: (_) => date == null ? "Please select payment date" : null,
    );
  }
}