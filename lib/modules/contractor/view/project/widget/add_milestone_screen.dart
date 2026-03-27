// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/modules/contractor/controller/contractor_project_milestone_controller.dart';
//
// import '../../../../../app/constants/app_font_sizes.dart';
// import '../../../../../app/constants/color_res.dart';
// import '../../../../../data/network/contractor/model/contractor_project_model/contractor_project_milestone_model.dart';
// import '../../../../../widgets/New folder/inputs/dropdown_field.dart';
// import '../../../../add_property/view/create_property.dart';
//
// class AddMilestoneScreen extends StatelessWidget {
//   final String tag;
//   const AddMilestoneScreen({super.key, required this.tag});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<ContractorProjectMilestoneController>(tag: tag);
//
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             controller.resetForm();
//             Get.back();
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//         title: const Text(
//           "Add Milestone",
//           style: TextStyle(
//             color: ColorRes.textPrimary,
//             fontWeight: AppFontWeights.semiBold,
//           ),
//         ),
//         backgroundColor: ColorRes.white,
//         elevation: 0.5,
//         iconTheme: const IconThemeData(color: ColorRes.textPrimary),
//       ),
//       body: Obx(
//         () => Singleiew(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: Form(
//             key: controller.formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildSectionTitle("Title *"),
//                 const SizedBox(height: 8),
//                 buildTextField(
//                   "Enter project title",
//                   Icons.title,
//                   controller.titleController,
//                   validator: (v) => v!.isEmpty ? "Please enter title" : null,
//                 ),
//                 const SizedBox(height: 16),
//
//                 buildSectionTitle("Description"),
//                 const SizedBox(height: 8),
//                 buildTextField(
//                   "Enter project description (optional)",
//                   Icons.description_outlined,
//                   controller.descriptionController,
//                   maxLines: 3,
//                   minLines: 3,
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Dates
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildDateField(
//                         "Start Date *",
//                         Icons.calendar_today,
//                         controller.startDate.value,
//                         () async {
//                           final picked = await showDatePicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate: DateTime.now(),
//                             lastDate: DateTime(2100),
//                           );
//                           if (picked != null) {
//                             controller.startDate.value = picked;
//                           }
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _buildDateField(
//                         "End Date",
//                         Icons.date_range,
//                         controller.endDate.value,
//                         () async {
//                           final picked = await showDatePicker(
//                             context: context,
//                             initialDate: controller.startDate.value,
//                             firstDate:
//                                 controller.startDate.value ?? DateTime.now(),
//                             lastDate: DateTime(2100),
//                           );
//                           if (picked != null) {
//                             controller.endDate.value = picked;
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 16),
//                 buildSectionTitle("Milestone Type"),
//                 const SizedBox(height: 8),
//                 Obx(
//                   () => NesticoPeDropdownField<String>(
//                     isRequired: true,
//                     enabled: false,
//                     value: controller.selectedMileStoneType.value,
//                     hintText: "Select milestone type",
//                     prefixIcon: Icons.work,
//                     items:
//                         controller.milestoneType
//                             .map(
//                               (e) => DropdownMenuItem(child: Text(e), value: e),
//                             )
//                             .toList() ??
//                         [],
//
//                     onChanged:
//                         (val) =>
//                             controller.selectedMileStoneType.value = val ?? '',
//                     darkText: true,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 if (controller.selectedMileStoneType.value == 'Percentage') ...[
//                   buildSectionTitle("Percentage"),
//                   const SizedBox(height: 8),
//                   buildTextField(
//                     "Enter percentage",
//                     Icons.percent,
//                     controller.percentageController,
//                     validator: (v) {
//                       if (v!.isEmpty) {
//                         return "Please enter percentage";
//                       }
//
//                       if (double.parse(v) > 100) {
//                         return "Percentage cannot be greater than 100";
//                       }
//
//                       return null;
//                     },
//                     inputType: TextInputType.number,
//                     formatter: [FilteringTextInputFormatter.digitsOnly],
//                   ),
//                 ] else ...[
//                   buildSectionTitle("Milestone Amount"),
//                   const SizedBox(height: 8),
//                   buildTextField(
//                     "Enter milestone amount",
//                     Icons.money,
//                     controller.fixedController,
//                     validator:
//                         (v) =>
//                             v!.isEmpty ? "Please enter milestone amount" : null,
//                     inputType: TextInputType.number,
//                     formatter: [FilteringTextInputFormatter.digitsOnly],
//                   ),
//                 ],
//
//                 const SizedBox(height: 16),
//
//                 buildSectionTitle("Work Status"),
//                 const SizedBox(height: 8),
//                 Obx(
//                   () => NesticoPeDropdownField<String>(
//                     isRequired: true,
//                     value: controller.selectedWorkStatus.value,
//                     hintText: "Select work status",
//                     prefixIcon: Icons.work,
//                     items:
//                         controller.workStatus
//                             .map(
//                               (e) => DropdownMenuItem(child: Text(e), value: e),
//                             )
//                             .toList() ??
//                         [],
//
//                     onChanged:
//                         (val) =>
//                             controller.selectedWorkStatus.value = val ?? '',
//                     darkText: true,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 Obx(
//                   () => buildBudgetSummary(
//                     controller.items,
//                     controller.currentMilestone.value,
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//                 SafeArea(
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // if (formKey.currentState?.validate() ?? false) {
//                         //   controller.convertIntoProject(
//                         //     widget.item.id ?? '',
//                         //   );
//                         // }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: ColorRes.primary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                       ),
//                       child: const Text(
//                         "Add Milestone",
//                         style: TextStyle(
//                           color: ColorRes.white,
//                           fontWeight: AppFontWeights.semiBold,
//                           fontSize: AppFontSizes.body,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateField(
//     String label,
//     IconData icon,
//     DateTime? date,
//     VoidCallback onTap,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buildSectionTitle(label),
//         const SizedBox(height: 8),
//         buildTextField(
//           date == null
//               ? "Select date"
//               : "${date.day}/${date.month}/${date.year}",
//           icon,
//           TextEditingController(),
//           isEnable: false,
//           onTap: onTap,
//         ),
//       ],
//     );
//   }
//
//   Widget buildBudgetSummary(
//     List<ProjectMilestone> milestones,
//     ProjectMilestone? currentMilestone,
//   ) {
//     final double projectPrice = milestones.fold(
//       0.0,
//       (sum, m) => sum + _toAmount(m.milestoneAmount!),
//     );
//
//     final double totalPaid = milestones.fold(
//       0.0,
//       (sum, m) => sum + _toAmount(m.paidAmount!),
//     );
//
//     final double remainingBudget = projectPrice - totalPaid;
//
//     ProjectMilestone? currentMilestone;
//
//     // if (milestones.isNotEmpty) {
//     //   for (final m in milestones) {
//     //     if (m.paymentStatus == 'pending') {
//     //       currentMilestone = m;
//     //       break;
//     //     }
//     //   }
//     // }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buildSectionTitle("Budget Summary"),
//         const SizedBox(height: 8),
//
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: ColorRes.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: ColorRes.border),
//           ),
//           child: Column(
//             children: [
//               /// Project Price
//               _row(
//                 label: "Project Price:",
//                 value: _formatAmount(projectPrice),
//                 valueColor: Colors.black,
//                 isBold: true,
//               ),
//
//               const SizedBox(height: 12),
//
//               /// Milestone deductions
//               ...milestones.map(
//                 (m) => Padding(
//                   padding: const EdgeInsets.only(bottom: 6),
//                   child: _row(
//                     label: m.title!,
//                     value: "- ${_formatAmount(_toAmount(m.milestoneAmount!))}",
//                     valueColor: Colors.red,
//                   ),
//                 ),
//               ),
//
//               const Divider(height: 24),
//
//               /// Current milestone
//               _row(
//                 label: "Current Milestone:",
//                 value:
//                     currentMilestone != null
//                         ? "- ${_formatAmount(_toAmount(currentMilestone.milestoneAmount!))}"
//                         : "- ₹0",
//                 labelColor: Colors.blue,
//                 valueColor: Colors.blue,
//               ),
//
//               const Divider(height: 24),
//
//               /// Remaining budget
//               _row(
//                 label: "Remaining Budget:",
//                 value: _formatAmount(remainingBudget),
//                 valueColor: Colors.green,
//                 isBold: true,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _row({
//     required String label,
//     required String value,
//     Color labelColor = Colors.black87,
//     Color valueColor = Colors.black,
//     bool isBold = false,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             color: labelColor,
//             fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 14,
//             color: valueColor,
//             fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
//
//   double _toAmount(String value) {
//     return double.tryParse(value) ?? 0.0;
//   }
//
//   String _formatAmount(double value) {
//     return "₹${value.toStringAsFixed(0)}";
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/modules/contractor/controller/contractor_project_milestone_controller.dart';

import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/constants/color_res.dart';
import '../../../../../data/network/contractor/model/contractor_project_model/contractor_project_milestone_model.dart';
import '../../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../../add_property/view/create_property.dart';

class AddMilestoneScreen extends StatelessWidget {
  final String tag;
  final ProjectMilestone? milestone;
  final double projectPrice;

  const AddMilestoneScreen({
    super.key,
    required this.tag,
    this.milestone,
    required this.projectPrice,
  });

  @override
  Widget build(BuildContext context) {
    log("AddMilestoneScreen build called with milestone: $projectPrice");

    final controller = Get.find<ContractorProjectMilestoneController>(tag: tag);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (milestone != null) {
        controller.initializeForEdit(milestone!);
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
            controller.isEditMode.value ? "Edit Milestone" : "Add Milestone",
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
              buildSectionTitle("Title *"),
              const SizedBox(height: 8),
              buildTextField(
                "Enter milestone title",
                Icons.title,
                controller.titleController,
                validator:
                    (v) =>
                        v == null || v.trim().isEmpty
                            ? "Please enter title"
                            : null,
              ),

              const SizedBox(height: 16),
              buildSectionTitle("Description"),
              const SizedBox(height: 8),
              buildTextField(
                "Enter milestone description (optional)",
                Icons.description_outlined,
                controller.descriptionController,
                maxLines: 3,
                minLines: 3,
              ),

              const SizedBox(height: 16),

              /// Dates
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => _buildDateField(
                        "Start Date *",
                        Icons.calendar_today,
                        controller.startDate.value,
                        () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate:
                                controller.startDate.value ?? DateTime.now(),
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            controller.startDate.value = picked;
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => _buildDateField(
                        "End Date",
                        Icons.date_range,
                        controller.endDate.value,
                        () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate:
                                controller.endDate.value ??
                                controller.startDate.value ??
                                DateTime.now(),
                            firstDate:
                                controller.startDate.value ?? DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            controller.endDate.value = picked;
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              buildSectionTitle("Milestone Type *"),
              const SizedBox(height: 8),

              Obx(
                () => NesticoPeDropdownField<String>(
                  isRequired: true,
                  enabled: !controller.isEditMode.value,
                  value: controller.selectedMileStoneType.value,
                  hintText: "Select milestone type",
                  prefixIcon: Icons.work,
                  items:
                      controller.milestoneType
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) {
                    if (val == null) return;
                    controller.selectedMileStoneType.value = val;
                    val == 'Percentage'
                        ? controller.fixedController.clear()
                        : controller.percentageController.clear();
                  },
                  darkText: true,
                ),
              ),

              const SizedBox(height: 16),

              /// Conditional Fields
              Obx(() {
                return controller.selectedMileStoneType.value == 'Percentage'
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSectionTitle("Percentage *"),
                        const SizedBox(height: 8),
                        buildTextField(
                          "Enter percentage (0-100)",
                          Icons.percent,
                          controller.percentageController,
                          inputType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          formatter: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'),
                            ),
                          ],
                          validator: (v) {
                            final value = double.tryParse(v ?? '');
                            if (value == null) return "Invalid number";
                            if (value < 0 || value > 100) {
                              return "Must be between 0-100";
                            }
                            return null;
                          },

                          // onChanged: (val) {
                          //   final percent = double.tryParse(val) ?? 0.0;
                          //   if (percent <= 0) {
                          //     controller.milestoneAmount.value = 0.0;
                          //     return;
                          //   }
                          //
                          //   // Calculate total of previous milestones
                          //   final existingTotal = controller.items.fold<double>(
                          //     0.0,
                          //         (sum, m) => sum + (double.tryParse(m.milestoneAmount ?? '0') ?? 0.0),
                          //   );
                          //
                          //   // Remaining before adding current milestone
                          //   final remainingBefore = projectPrice - existingTotal;
                          //
                          //   // Calculate milestone amount
                          //   final currentAmount = (existingTotal == 0)
                          //       ? projectPrice * (percent / 100) // Case 1: no previous
                          //       : remainingBefore * (percent / 100); // Case 2: has previous
                          //
                          //   controller.milestoneAmount.value = currentAmount;
                          // },
                          onChanged: (val) {
                            if (val.isEmpty) {
                              controller.milestoneAmount.value = 0.0;
                            }
                            final remainingAmount = controller
                                .calculateRemainingAmount(projectPrice);
                            controller.milestoneAmount.value =
                                remainingAmount *
                                ((double.tryParse(val) ?? 0.0) / 100);
                          },
                        ),
                      ],
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSectionTitle("Milestone Amount *"),
                        const SizedBox(height: 8),
                        buildTextField(
                          "Enter milestone amount",
                          Icons.currency_rupee,
                          controller.fixedController,
                          inputType: TextInputType.number,
                          formatter: [FilteringTextInputFormatter.digitsOnly],
                          validator:
                              (v) =>
                                  double.tryParse(v ?? '') == null
                                      ? "Invalid amount"
                                      : null,
                          onChanged: (val) {
                            if (val.isEmpty) {
                              controller.milestoneAmount.value = 0.0;
                            }
                            // final remainingAmount =  controller.calculateRemainingAmount(projectPrice);
                            controller.milestoneAmount.value =
                                double.tryParse(val) ?? 0.0;
                          },
                        ),
                      ],
                    );
              }),

              const SizedBox(height: 16),
              buildSectionTitle("Work Status *"),
              const SizedBox(height: 8),

              Obx(
                () => NesticoPeDropdownField<String>(
                  isRequired: true,
                  value: controller.selectedWorkStatus.value,
                  hintText: "Select work status",
                  prefixIcon: Icons.work_outline,
                  items:
                      controller.workStatus
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged:
                      (val) => controller.selectedWorkStatus.value = val ?? '',
                  darkText: true,
                ),
              ),

              const SizedBox(height: 16),

              /// ✅ FIXED BUDGET SUMMARY
              Obx(() {
                final milestones = controller.items.toList();
                final current = controller.currentMilestone.value;

                return buildBudgetSummary(milestones, current, projectPrice);
              }),

              const SizedBox(height: 24),

              /// Button
              Obx(
                () => SafeArea(

                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          controller.isLoading.value
                              ? null
                              : () {
                                if (controller.formKey.currentState?.validate() ??
                                    false) {
                                  controller.saveMilestone(projectPrice);
                                }
                              },
                      child:
                          controller.isLoading.value
                              ? const CircularProgressIndicator()
                              : Text(
                                controller.isEditMode.value
                                    ? "Update Milestone"
                                    : "Add Milestone",
                              ),
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
              : "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}",
          icon,
          TextEditingController(),
          isEnable: false,
          onTap: onTap,
        ),
      ],
    );
  }

  Widget buildBudgetSummary(
    List<ProjectMilestone> milestones,
    ProjectMilestone? currentMilestone,
    double totalProjectPrice,
  ) {
    // final controller = Get.find<ContractorProjectMilestoneController>(tag: tag);
    //
    // final double totalMilestones = totalProjectPrice;
    //
    // final double totalPaid = milestones.fold(
    //   0.0,
    //   (sum, m) => sum + _toAmount(m.paidAmount ?? '0'),
    // );
    //
    // final double remainingBudget = totalMilestones - totalPaid;

    final controller = Get.find<ContractorProjectMilestoneController>(tag: tag);
    final editingId = controller.editingMilestoneId.value;

    final double totalMilestones = totalProjectPrice;

    // ✅ If there’s an edited milestone, skip updating for that one

    final filteredMilestones =
        milestones.where((m) => m.id != editingId).toList();

    controller.currentMilestoneAmount.value = filteredMilestones.fold(0.0, (
      sum,
      m,
    ) {
      final val = _toAmount(m.milestoneAmount ?? '0');
      log(
        "Milestone ID: ${m.id} | Amount: ${m.milestoneAmount} | Current Sum: $sum | New Sum: ${sum + val}",
      );
      return sum + val;
    });

    // final double totalPaid = milestones.where((element) => element.id==controller.,)

    log("Allocated Total: ${controller.currentMilestoneAmount.value}");

    // Current milestone (typed in but not saved yet)
    final double currentAmount = controller.milestoneAmount.value;

    log(
      "Data From ${totalMilestones - (controller.currentMilestoneAmount.value + currentAmount)}       $currentAmount  ${controller.currentMilestoneAmount.value} ",
    );

    // Remaining unallocated budget
    final double remainingBudget =
        totalMilestones -
        (controller.currentMilestoneAmount.value + currentAmount);

    log("Remaining Budget: $remainingBudget");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle("Budget Summary"),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ColorRes.leadGreyColor.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              /// Total Allocated
              _row(
                label: "Total Allocated:",
                value: _formatAmount(totalMilestones),
                valueColor: Colors.black,
                isBold: true,
              ),

              const SizedBox(height: 8),

              /// Total Paid
              // _row(
              //   label: "Total Paid:",
              //   value: _formatAmount(totalPaid),
              //   valueColor: Colors.green,
              // ),
              Divider(
                height: 24,
                color: ColorRes.leadGreyColor.withOpacity(0.3),
              ),

              /// Milestone deductions
              if (milestones.isNotEmpty) ...[
                Text(
                  "Existing Milestones:",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                // ...milestones.map(
                //   (m) => Padding(
                //     padding: const EdgeInsets.only(bottom: 6),
                //     child: _row(
                //       label: m.title ?? 'Untitled',
                //       value:
                //           "₹${_toAmount(m.milestoneAmount ?? '0').toStringAsFixed(0)}",
                //       valueColor: Colors.black87,
                //       labelColor: Colors.grey[700]!,
                //     ),
                //   ),
                // ),
                ...milestones
                    // ✅ Skip the milestone being edited
                    .where((m) => m.id != controller.editingMilestoneId.value)
                    .map((m) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: _row(
                          label: m.title ?? 'Untitled',
                          value:
                              "- ₹${_toAmount(m.milestoneAmount ?? '0').toStringAsFixed(0)}",
                          valueColor: ColorRes.error,
                          labelColor: Colors.grey[700]!,
                        ),
                      );
                    }),

                const SizedBox(height: 8),
              ],

              /// Current milestone (if editing)
              // if (currentMilestone != null) ...[
              Divider(
                height: 16,
                color: ColorRes.leadGreyColor.withOpacity(0.3),
              ),
              Obx(
                () => _row(
                  label: "Current Milestone:",
                  labelColor: ColorRes.primary,
                  valueColor: ColorRes.primary,
                  value:
                      '- ${_formatAmount(_toAmount(controller.milestoneAmount.value.toStringAsFixed(0)))}',
                ),
              ),

              // ],
              Divider(
                height: 24,
                color: ColorRes.leadGreyColor.withOpacity(0.3),
              ),

              /// Remaining budget
              _row(
                label: "Remaining to Allocate:",
                value: _formatAmount(remainingBudget),
                valueColor: remainingBudget >= 0 ? Colors.green : Colors.red,
                isBold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _row({
    required String label,
    required String value,
    Color labelColor = Colors.black87,
    Color valueColor = Colors.black,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: labelColor,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: valueColor,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  double _toAmount(String value) {
    return double.tryParse(value) ?? 0.0;
  }

  String _formatAmount(double value) {
    return "₹${value.toStringAsFixed(0)}";
  }
}
