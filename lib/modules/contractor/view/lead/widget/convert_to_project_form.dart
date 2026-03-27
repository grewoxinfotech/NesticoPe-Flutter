// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/data/network/contractor/model/contractor_lead_model/contractor_lead_model.dart';
// import 'package:nesticope_app/modules/contractor/controller/contractor_lead_controller.dart';
// import 'package:nesticope_app/modules/contractor/controller/contractor_my_service_controller.dart';
// import 'package:nesticope_app/modules/contractor/controller/contractor_project_controller.dart';
// import 'package:nesticope_app/modules/contractor/controller/contractot_employee_controller.dart';
//
// import '../../../../../app/constants/app_font_sizes.dart';
// import '../../../../../app/constants/color_res.dart';
// import '../../../../../data/network/contractor/model/employee/contractor_employee_model.dart';
// import '../../../../../widgets/New folder/inputs/dropdown_field.dart';
// import '../../../../add_property/view/create_property.dart';
//
// class AddProjectScreen extends StatefulWidget {
//   ContractorLeadItem item;
//
//   AddProjectScreen({super.key, required this.item});
//
//   @override
//   State<AddProjectScreen> createState() => _AddProjectScreenState();
// }
//
// class _AddProjectScreenState extends State<AddProjectScreen> {
//   final formKey = GlobalKey<FormState>();
//   final controller = Get.find<ContractorLeadController>();
//   final controllerEmployee = Get.put(ContractorEmployeeController());
//   final controllerProject = Get.put(ContractorProjectController());
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     log(
//       "Category datra ${controller.items.value.map((e) => e.customFields?.serviceName ?? '').toSet().toList()}",
//     );log(
//       "Category datra ${controller.items.value.map((e) => e.toMap()).toList()}",
//     );
//     // log("Selected Project: ${controllerEmployee.items.firstWhere((e) => controllerProject.items.any((proj) => proj.meta.employees.any((element) => element.id== e.id)),orElse: ()=>ContractorEmployeeItem()).toJson()}");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controllerCategory = Get.find<ContractorMyServiceController>();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.populateFormFromItem(widget.item);
//     });
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
//           "Convert To Project",
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
//         () => SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: Form(
//             key: formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildSectionTitle("Title *"),
//                 const SizedBox(height: 8),
//                 buildTextField(
//                   "Enter project title",
//                   Icons.title,
//                   controller.txtTitle,
//                   validator: (v) => v!.isEmpty ? "Please enter title" : null,
//                 ),
//                 const SizedBox(height: 16),
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
//                         "Deadline",
//                         Icons.date_range,
//                         controller.deadline.value,
//                         () async {
//                           final picked = await showDatePicker(
//                             context: context,
//                             initialDate: controller.startDate.value,
//                             firstDate:
//                                 controller.startDate.value ?? DateTime.now(),
//                             lastDate: DateTime(2100),
//                           );
//                           if (picked != null) {
//                             controller.deadline.value = picked;
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 16),
//                 buildSectionTitle("Service"),
//                 const SizedBox(height: 8),
//                 NesticoPeDropdownField<String>(
//                   isRequired: true,
//                   enabled: false,
//                   value: controller.selectedService.value,
//                   hintText: "Select service",
//                   prefixIcon: Icons.work,
//                   items:
//                       controller.items.value
//                           ?.map((e) => e.customFields?.serviceName)
//                           .where((name) => name != null && name!.isNotEmpty)
//                           .toSet() // ✅ removes duplicate names
//                           .map(
//                             (name) => DropdownMenuItem(
//                               value: name,
//                               child: Text(name ?? ''),
//                             ),
//                           )
//                           .toList() ??
//                       [],
//
//                   onChanged:
//                       (val) => controller.selectedService.value = val ?? '',
//                   darkText: true,
//                 ),
//
//                 const SizedBox(height: 16),
//                 buildSectionTitle("Client Name"),
//                 const SizedBox(height: 8),
//                 buildTextField(
//                   "Enter client name",
//                   Icons.person,
//                   controller.txtClientName,
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 buildSectionTitle("Client Email"),
//                 const SizedBox(height: 8),
//                 buildTextField(
//                   "Enter client email",
//                   Icons.email,
//                   controller.txtClientEmail,
//                 ),
//                 const SizedBox(height: 16),
//                 buildSectionTitle("Client Phone"),
//                 const SizedBox(height: 8),
//                 buildTextField(
//                   "Enter client phone",
//                   Icons.phone,
//                   controller.txtClientPhone,
//                   isPhoneKey: true,
//                 ),
//
//                 const SizedBox(height: 16),
//                 buildSectionTitle("Project Price"),
//                 const SizedBox(height: 8),
//                 buildTextField(
//                   "Enter project price",
//                   Icons.currency_rupee_outlined,
//                   controller.txtProjectPrice,
//                   validator:
//                       (v) => v!.isEmpty ? "Please enter project price" : null,
//                   inputType: TextInputType.number,
//                   formatter: [FilteringTextInputFormatter.digitsOnly],
//                 ),
//                 const SizedBox(height: 16),
//                 buildSectionTitle('Assign Employees'),
//                 const SizedBox(height: 8),
//
//                 Obx(() {
//                   final employees = controllerEmployee.items;
//
//                   return SingleChildScrollView(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade50,
//                         border: Border.all(
//                           color: ColorRes.leadGreyColor.shade300,
//                           width: 1,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 4,
//                             children:
//                                 controller.selectedEmployees
//                                     .toSet()
//                                     .map(
//                                       (e) => Chip(
//                                         side: BorderSide(
//                                           color: ColorRes.secondary,
//                                           width: 1,
//                                         ),
//                                         label: Text(
//                                           e.name ?? 'Unnamed',
//                                           style: TextStyle(
//                                             fontSize: AppFontSizes.bodySmall,
//                                             color: ColorRes.textColor,
//                                             fontWeight: AppFontWeights.regular,
//                                           ),
//                                         ),
//                                         onDeleted:
//                                             () => controller.selectedEmployees
//                                                 .remove(e),
//                                         deleteIconColor: Colors.redAccent,
//                                       ),
//                                     )
//                                     .toList(),
//                           ),
//                           const SizedBox(height: 8),
//                           DropdownButtonFormField<ContractorEmployeeItem>(
//                             decoration: const InputDecoration.collapsed(
//                               hintText: "",
//                             ),
//                             hint: const Text(
//                               "Select employees",
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.medium,
//                                 fontWeight: AppFontWeights.regular,
//                               ),
//                             ),
//                             icon: const Icon(Icons.arrow_drop_down),
//                             items:
//                                 employees.map((emp) {
//                                   final assignedProject = controllerProject
//                                       .items
//                                       .firstWhereOrNull(
//                                         (proj) => proj.meta.employees.any(
//                                           (e) => e.id == emp.id,
//                                         ),
//                                       );
//
//                                   final isAssigned = assignedProject != null;
//                                   final clientName =
//                                       assignedProject?.client.name ?? '';
//
//                                   return DropdownMenuItem<
//                                     ContractorEmployeeItem
//                                   >(
//                                     enabled: !isAssigned,
//                                     value: emp,
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           emp.name ?? 'Unnamed',
//                                           style: TextStyle(
//                                             fontSize: AppFontSizes.small,
//                                             color:
//                                                 isAssigned
//                                                     ? Colors.grey
//                                                     : ColorRes.textColor,
//                                             fontWeight: AppFontWeights.medium,
//                                           ),
//                                         ),
//                                         if (isAssigned)
//                                           Text(
//                                             "Assigned to: ${clientName.isNotEmpty ? clientName : 'Assigned'}",
//                                             style: const TextStyle(
//                                               fontSize: AppFontSizes.caption,
//                                               color: Colors.redAccent,
//                                               fontWeight: AppFontWeights.medium,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//                             onChanged: (val) {
//                               if (val != null &&
//                                   !controller.selectedEmployees.any(
//                                     (existing) => existing.id == val.id,
//                                   )) {
//                                 controller.selectedEmployees.add(val);
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//
//                 // Obx(() {
//                 //   final employees =
//                 //       controllerEmployee
//                 //           .items;
//                 //
//                 //   return Container(
//                 //     padding: const EdgeInsets.symmetric(
//                 //       horizontal: 12,
//                 //       vertical: 8,
//                 //     ),
//                 //     decoration: BoxDecoration(
//                 //       color: Colors.grey.shade50,
//                 //       border: Border.all(color: ColorRes.leadGreyColor.shade300,width: 1),
//                 //       borderRadius: BorderRadius.circular(8),
//                 //     ),
//                 //     child: Column(
//                 //       crossAxisAlignment: CrossAxisAlignment.start,
//                 //       children: [
//                 //         Wrap(
//                 //           spacing: 8,
//                 //           runSpacing: 4,
//                 //           children:
//                 //               controller.selectedEmployees
//                 //                   .toSet()
//                 //                   .map(
//                 //                     (e) => Chip(
//                 //                       side: BorderSide(color: ColorRes.secondary,width: 1),
//                 //                       label: Text(e.name ?? 'Unnamed',style: TextStyle(
//                 //                         fontSize: AppFontSizes.bodySmall,
//                 //                         color:ColorRes.textColor,
//                 //                         fontWeight: AppFontWeights.regular,
//                 //                       ),),
//                 //                       onDeleted:
//                 //                           () => controller.selectedEmployees
//                 //                               .remove(e),
//                 //                       deleteIconColor: Colors.redAccent,
//                 //                     ),
//                 //                   )
//                 //                   .toList(),
//                 //         ),
//                 //         const SizedBox(height: 8),
//                 //         DropdownButtonFormField<ContractorEmployeeItem>(
//                 //           decoration: const InputDecoration.collapsed(hintText: ""),
//                 //           hint: const Text(
//                 //             "Select employees",
//                 //             style: TextStyle(
//                 //               fontSize: AppFontSizes.medium,
//                 //               fontWeight: AppFontWeights.regular,
//                 //             ),
//                 //           ),
//                 //           icon: const Icon(Icons.arrow_drop_down),
//                 //           items: employees.map((emp) {
//                 //
//                 //             final assignedProject = controllerProject.items.firstWhereOrNull(
//                 //                   (proj) => proj.meta.employees.any((e) => e.id == emp.id),
//                 //             );
//                 //             log("Employee ${emp.name} assigned to project: ${assignedProject?.meta.employees.map((e) => e.toJson(),)}");
//                 //
//                 //
//                 //
//                 //             final isAssigned = assignedProject != null;
//                 //             final clientName = assignedProject?.client.name ?? '';
//                 //
//                 //             return DropdownMenuItem<ContractorEmployeeItem>(
//                 //               enabled: !isAssigned, // disable if already assigned
//                 //               value: emp,
//                 //               child: Column(
//                 //                 crossAxisAlignment: CrossAxisAlignment.start,
//                 //                 children: [
//                 //                   Text(
//                 //                     '${(isAssigned)?'${emp.name} (Already assigned)' :emp.name}' ?? 'Unnamed',
//                 //                     style: TextStyle(
//                 //                       fontSize: AppFontSizes.small,
//                 //                       color: isAssigned ? Colors.grey : ColorRes.textColor,
//                 //                       fontWeight: AppFontWeights.medium,
//                 //                     ),
//                 //                   ),
//                 //                   if (isAssigned)
//                 //                     Text(
//                 //                       "Assigned to : ${clientName.isNotEmpty ? clientName : 'Assigned'}",
//                 //                       style: const TextStyle(
//                 //                         fontSize: AppFontSizes.caption,
//                 //                         color: Colors.redAccent,
//                 //                         fontWeight: AppFontWeights.medium,
//                 //                         overflow: TextOverflow.ellipsis,
//                 //                       ),
//                 //                     ),
//                 //                 ],
//                 //               ),
//                 //             );
//                 //           }).toList(),
//                 //           onChanged: (val) {
//                 //             if (val != null &&
//                 //                 !controller.selectedEmployees.any(
//                 //                       (existing) => existing.id == val.id,
//                 //                 )) {
//                 //               controller.selectedEmployees.add(val);
//                 //             }
//                 //           },
//                 //         )
//                 //
//                 //
//                 //         // DropdownButtonFormField<ContractorEmployeeItem>(
//                 //         //   decoration: const InputDecoration.collapsed(
//                 //         //     hintText: "",
//                 //         //   ),
//                 //         //   hint: const Text("Select employee to add"),
//                 //         //   icon: const Icon(Icons.arrow_drop_down),
//                 //         //
//                 //         //   items:
//                 //         //       employees.toSet().map((emp) {
//                 //         //         return DropdownMenuItem(
//                 //         //           value: emp,
//                 //         //           child: Text(emp.name ?? 'Unnamed',style: TextStyle(
//                 //         //             fontSize: AppFontSizes.medium,
//                 //         //             color:ColorRes.textColor,
//                 //         //             fontWeight: AppFontWeights.medium,
//                 //         //           ),),
//                 //         //         );
//                 //         //       }).toList(),
//                 //         //   onChanged: (val) {
//                 //         //     if (val != null &&
//                 //         //         !controller.selectedEmployees.any(
//                 //         //           (existing) => existing.id == val.id,
//                 //         //         )) {
//                 //         //       controller.selectedEmployees.add(val);
//                 //         //     }
//                 //         //   },
//                 //         // ),
//                 //       ],
//                 //     ),
//                 //   );
//                 // }),
//                 const SizedBox(height: 16),
//                 buildSectionTitle("Notes"),
//                 const SizedBox(height: 8),
//                 buildTextField(
//                   "Enter notes (optional)",
//                   Icons.note,
//                   controller.txtNotes,
//                   maxLines: 3,
//                   minLines: 3,
//                 ),
//
//                 const SizedBox(height: 24),
//                 SafeArea(
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: controller.resetForm,
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: ColorRes.textSecondary,
//                             side: const BorderSide(color: ColorRes.border),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                           ),
//                           child: const Text("Cancel"),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             if (formKey.currentState?.validate() ?? false) {
//                               controller.convertIntoProject(
//                                 widget.item.id ?? '',
//                               );
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: ColorRes.primary,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                           ),
//                           child: const Text(
//                             "Convert",
//                             style: TextStyle(
//                               color: ColorRes.white,
//                               fontWeight: AppFontWeights.semiBold,
//                               fontSize: AppFontSizes.body,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
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
//   // 📅 Date Picker UI (uses buildTextField style)
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
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/constants/color_res.dart';
import '../../../../../data/network/contractor/model/contractor_lead_model/contractor_lead_model.dart';
import '../../../../../data/network/contractor/model/contractor_project_model/contracto_project_model.dart';
import '../../../../../data/network/contractor/model/employee/contractor_employee_model.dart';
import '../../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../../add_property/view/create_property.dart';
import '../../../controller/contractor_lead_controller.dart';
import '../../../controller/contractor_my_service_controller.dart';
import '../../../controller/contractor_project_controller.dart';
import '../../../controller/contractot_employee_controller.dart';

class AddOrEditProjectScreen extends StatefulWidget {
  final ContractorLeadItem? leadItem;
  final ContractorProjectItem? projectItem;

  AddOrEditProjectScreen({super.key, this.leadItem, this.projectItem})
    : assert(
        leadItem != null || projectItem != null,
        "Either leadItem or projectItem must be provided",
      );

  @override
  State<AddOrEditProjectScreen> createState() => _AddOrEditProjectScreenState();
}

class _AddOrEditProjectScreenState extends State<AddOrEditProjectScreen> {
  final formKey = GlobalKey<FormState>();
  final controller = Get.find<ContractorLeadController>();
  final controllerEmployee = Get.find<ContractorEmployeeController>();

  final controllerProject = Get.put(ContractorProjectController());

  bool get isEdit => widget.projectItem != null;

  @override
  void initState() {
    super.initState();
    log("Check for project item: ${widget.projectItem?.toJson()}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isEdit) {
        controller.populateProjectForm(widget.projectItem!);
      } else {
        controller.populateFormFromItem(widget.leadItem!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controllerCategory = Get.find<ContractorMyServiceController>();

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
        title: Text(
          isEdit ? "Edit Project" : "Convert To Project",
          style: const TextStyle(
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
                            initialDate:
                                controller.startDate.value ?? DateTime.now(),
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
                          final startDate =
                              controller.startDate.value ?? DateTime.now();
                          final currentDeadline =
                              controller.deadline.value ?? startDate;

                          final initialDate =
                              currentDeadline.isBefore(startDate)
                                  ? startDate
                                  : currentDeadline;

                          final picked = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: startDate,
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
                  enabled: !isEdit,
                  value: controller.selectedService.value,
                  hintText: "Select service",
                  prefixIcon: Icons.work,
                  items:
                      controller.items.value
                          ?.map((e) => e.customFields?.serviceName)
                          .where((name) => name != null && name!.isNotEmpty)
                          .toSet()
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
                buildSectionTitle('Assign Employees'),
                const SizedBox(height: 8),
                _buildEmployeesDropdown(),
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

                      /*hshdsubbhdb*/
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              if (isEdit) {
                                controller.updateProject(
                                  widget.projectItem!.id ?? '',
                                );
                              } else {
                                controller.convertIntoProject(
                                  widget.leadItem!.id ?? '',
                                );
                              }
                            }
                            /*
                              *avesh kumar prajapati ndwjdwnn hdhb bshkjjjjnbsbm  */
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorRes.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            isEdit ? "Update" : "Convert",
                            style: const TextStyle(
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

  Widget _buildEmployeesDropdown() {
    return Obx(() {
      final employees = controllerEmployee.items;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  controller.selectedEmployees
                      .toSet()
                      .map(
                        (e) => Chip(
                          side: BorderSide(color: ColorRes.secondary, width: 1),
                          label: Text(
                            e.name ?? 'Unnamed',
                            style: TextStyle(
                              fontSize: AppFontSizes.bodySmall,
                              color: ColorRes.textColor,
                              fontWeight: AppFontWeights.regular,
                            ),
                          ),
                          onDeleted: () async {
                            // Remove employee from selected list
                            controller.selectedEmployees.remove(e);

                            // Also remove employee from each project where they exist
                            for (var project in controllerProject.items) {
                              final employeesInProject =
                                  project.meta?.employees ?? [];
                              employeesInProject.removeWhere(
                                (emp) => emp.id == e.id,
                              );
                            }

                            // Optionally, refresh UI or save changes if needed
                            controllerProject.items.refresh();
                          },

                          deleteIconColor: Colors.redAccent,
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 8),
            /*  DropdownButtonFormField<ContractorEmployeeItem>(
              decoration: const InputDecoration.collapsed(hintText: ""),
              hint: const Text(
                "Select employees",
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.regular,
                ),
              ),
              icon: const Icon(Icons.arrow_drop_down),
              items:
                  employees.map((emp) {
                    final assignedProject = controllerProject.items
                        .firstWhereOrNull(
                          (proj) =>
                              proj.meta.employees.any((e) => e.id == emp.id),
                        );
                    log("Message the ${assignedProject?.toJson()}");
                    final isAssigned = assignedProject != null;
                    final clientName = assignedProject?.client.name ?? '';

                    return DropdownMenuItem<ContractorEmployeeItem>(
                      enabled: !isAssigned,
                      value: emp,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            emp.name ?? 'Unnamed',
                            style: TextStyle(
                              fontSize: AppFontSizes.small,
                              color:
                                  isAssigned ? Colors.grey : ColorRes.textColor,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                          if (isAssigned)
                            Text(
                              "Assigned to: ${clientName.isNotEmpty ? clientName : 'Assigned'}",
                              style: const TextStyle(
                                fontSize: AppFontSizes.caption,
                                color: Colors.redAccent,
                                fontWeight: AppFontWeights.medium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (val) {
                if (val != null &&
                    !controller.selectedEmployees.any(
                      (existing) => existing.id == val.id,
                    )) {
                  controller.selectedEmployees.add(val);
                }
              },
            ),*/
            DropdownButtonFormField<ContractorEmployeeItem>(
              decoration: const InputDecoration.collapsed(hintText: ""),
              hint: const Text(
                "Select employees",
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.regular,
                ),
              ),
              icon: const Icon(Icons.arrow_drop_down),
              items:
                  employees.map((emp) {
                    final assignedProject = controllerProject.items
                        .firstWhereOrNull(
                          (proj) =>
                              proj.meta.employees.any((e) => e.id == emp.id),
                        );

                    final isAssigned = assignedProject != null;
                    final clientName = assignedProject?.client.name ?? '';

                    return DropdownMenuItem<ContractorEmployeeItem>(
                      enabled: !isAssigned,
                      value: emp,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // ✅ prevents overflow
                        children: [
                          Text(
                            emp.name ?? 'Unnamed',
                            style: TextStyle(
                              fontSize: AppFontSizes.small,
                              color:
                                  isAssigned ? Colors.grey : ColorRes.textColor,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                          if (isAssigned)
                            Text(
                              "Assigned to: ${clientName.isNotEmpty ? clientName : 'Assigned'}",
                              style: const TextStyle(
                                fontSize: AppFontSizes.caption,
                                color: Colors.redAccent,
                                fontWeight: AppFontWeights.medium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (val) {
                if (val != null &&
                    !controller.selectedEmployees.any(
                      (existing) => existing.id == val.id,
                    )) {
                  controller.selectedEmployees.add(val);
                }
              },
            ),
          ],
        ),
      );
    });
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
