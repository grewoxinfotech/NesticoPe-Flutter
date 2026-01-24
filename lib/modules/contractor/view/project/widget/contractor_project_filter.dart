import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_inquiry_controller.dart';
import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../../../widgets/messages/snack_bar.dart';
import '../../../../add_property/view/create_property.dart';
import '../../../controller/contractor_project_controller.dart';

class ContractorProjectFilter extends StatefulWidget {
  const ContractorProjectFilter({super.key});

  @override
  State<ContractorProjectFilter> createState() =>
      _ContractorProjectFilterState();
}

class _ContractorProjectFilterState extends State<ContractorProjectFilter> {
  final ContractorProjectController controller =
      Get.find<ContractorProjectController>();

  final _formKey = GlobalKey<FormState>();
  DateTime? startDate;
  DateTime? endDate;

  Map<String, String> _buildFilterResult() {
    return {
      if (controller.txtStartDate.text.isNotEmpty &&
          controller.startDate != null)
        'startDate': controller.txtStartDate.text,
      if (controller.txtEndDate.text.isNotEmpty && controller.endDate != null)
        'endDate': controller.txtEndDate.text,
      if (controller.statusChange.value.isNotEmpty)
        'status': controller.statusChange.value.toLowerCase().replaceAll(
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
                        "Filter Project",
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
                                      controller.startDate ?? DateTime.now(),
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
                                    controller.startDate = picked;
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
                                    controller.endDate = picked;
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
                      buildSectionTitle('Project Status'),
                      const SizedBox(height: 8),
                      Obx(() {
                        // return Wrap(
                        //   spacing: 12,
                        //   runSpacing: 8,
                        //   children: [
                        //     'Pending',
                        //     'Contacted',
                        //     'In Progress',
                        //     'Converted',
                        //     'Rejected',
                        //     'Closed',
                        //   ].map((option) {
                        //     return buildChoice(
                        //       title: option,
                        //       selected:
                        //       controller.inquiryStatus.value == option,
                        //       onTap: () {
                        //         controller.setValue(
                        //             controller.inquiryStatus, option);
                        //       },
                        //     );
                        //   }).toList(),
                        // );
                        return NesticoPeDropdownField<String>(
                          isRequired: true,
                          value: controller.statusChange.value,
                          hintText: "Select availability",
                          prefixIcon: Icons.schedule,
                          items:
                              [
                                    'Pending',
                                    'Completed',
                                    'In Progress',
                                    'Cancelled',
                                  ]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) {
                            controller.setValue(controller.statusChange, val);
                            log(
                              "Contractor_status ${controller.statusChange.value}",
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

// class ContractorInquiryFilter extends StatefulWidget {
//   const ContractorInquiryFilter({super.key});
//
//   @override
//   State<ContractorInquiryFilter> createState() =>
//       _ContractorInquiryFilterState();
// }
//
// class _ContractorInquiryFilterState extends State<ContractorInquiryFilter> {
//   ContractorInquiryController controller =
//       Get.find<ContractorInquiryController>();
//   DateTime? startDate;
//   DateTime? endDate;
//
//   Map<String, dynamic> _buildFilterResult() {
//     // log('Price Range ${jsonEncode(controller.priceRangeSeller)}');
//     // log('Min Price → ${controller.priceRangeSeller['min']}');
//     // log('Max Price → ${controller.priceRangeSeller['max']}');
//
//     return {
//       // Date Range
//       if (controller.txtStartDate.text.isNotEmpty &&
//           controller.startDate != null)
//         'createdAtFrom': controller.txtStartDate.text,
//       if (controller.txtEndDate.text.isNotEmpty && controller.endDate != null)
//         'createdAtTo': controller.txtEndDate.text,
//     };
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorRes.background,
//       appBar: AppBar(
//         backgroundColor: ColorRes.surface,
//         elevation: 0,
//         title: const Text(
//           'Filters',
//           style: TextStyle(
//             // fontSize: AppFontSizes.title,
//             fontWeight: AppFontWeights.semiBold,
//             color: ColorRes.textPrimary,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 16),
//               buildSectionTitle('Created Date Range'),
//               SizedBox(height: 8),
//               Row(
//                 spacing: 12,
//                 children: [
//                   Expanded(
//                     child: buildTextField(
//                       'Start Date',
//                       Icons.calendar_month_outlined,
//                       controller.txtStartDate,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter valid date';
//                         }
//                         return null;
//                       },
//                       isEnable: false,
//                       onTap: () async {
//                         FocusScope.of(context).unfocus();
//                         DateTime? picked = await showDatePicker(
//                           context: context,
//                           initialDate: controller.startDate ?? DateTime.now(),
//                           firstDate: DateTime(2000),
//                           lastDate: DateTime(2100),
//                           builder: (context, child) {
//                             return Theme(
//                               data: Theme.of(context).copyWith(
//                                 colorScheme: ColorScheme.light(
//                                   primary: ColorRes.primary,
//                                   onPrimary: ColorRes.white,
//                                   onSurface: ColorRes.black,
//                                 ),
//                                 textButtonTheme: TextButtonThemeData(
//                                   style: TextButton.styleFrom(
//                                     foregroundColor: ColorRes.primary,
//                                   ),
//                                 ),
//                               ),
//                               child: child!,
//                             );
//                           },
//                         );
//                         if (picked != null) {
//                           setState(() {
//                             startDate = picked;
//                             controller.startDate = picked;
//                             // Clear end date if it's before start date
//                             if (endDate != null &&
//                                 endDate!.isBefore(startDate!)) {
//                               endDate = null;
//                               controller.txtEndDate.clear();
//                             }
//                           });
//                           controller.txtStartDate.text =
//                               "${picked.year}-${picked.month}-${picked.day}-";
//                           // controller.getPropertyType(propertyController.items);
//                         }
//                       },
//                       isPhoneKey: true,
//                     ),
//                   ),
//                   Expanded(
//                     child: buildTextField(
//                       'End Date',
//                       Icons.calendar_month_outlined,
//                       controller.txtEndDate,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter valid date';
//                         }
//                         if (startDate != null &&
//                             endDate != null &&
//                             endDate!.isBefore(startDate!)) {
//                           return 'End date must be after start date';
//                         }
//                         return null;
//                       },
//                       isEnable: false,
//                       onTap: () async {
//                         if (startDate == null) {
//                           Get.snackbar(
//                             'Date Required',
//                             'Please select start date first',
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: ColorRes.primary.withOpacity(0.8),
//                             colorText: ColorRes.white,
//                           );
//                           return;
//                         }
//
//                         FocusScope.of(context).unfocus();
//                         DateTime? picked = await showDatePicker(
//                           context: context,
//                           initialDate:
//                               endDate ??
//                               (startDate!.isAfter(DateTime.now())
//                                   ? startDate!
//                                   : DateTime.now()),
//                           firstDate: startDate!,
//                           // End date cannot be before start date
//                           lastDate: DateTime(2100),
//                           builder: (context, child) {
//                             return Theme(
//                               data: Theme.of(context).copyWith(
//                                 colorScheme: ColorScheme.light(
//                                   primary: ColorRes.primary,
//                                   onPrimary: ColorRes.white,
//                                   onSurface: ColorRes.black,
//                                 ),
//                                 textButtonTheme: TextButtonThemeData(
//                                   style: TextButton.styleFrom(
//                                     foregroundColor: ColorRes.primary,
//                                   ),
//                                 ),
//                               ),
//                               child: child!,
//                             );
//                           },
//                         );
//                         if (picked != null) {
//                           setState(() {
//                             endDate = picked;
//                             controller.endDate = picked;
//                           });
//                           controller.txtEndDate.text =
//                               "${picked.year}-${picked.month}-${picked.day}";
//                           // controller.getPropertyType(propertyController.items);
//                         }
//                       },
//                       isPhoneKey: true,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               buildSectionTitle('Inquiry Status'),
//               SizedBox(height: 8),
//               Obx(() {
//                 return Wrap(
//                   spacing: 12,
//                   runSpacing: 8,
//                   children:
//                       [
//                             'Pending',
//                             'Contacted',
//                             'In Progress',
//                             'Converted',
//                             'Rejected',
//                             'Closed',
//                           ]
//                           .map(
//                             (option) => buildChoice(
//                               title: option.toString(),
//                               selected:
//                                   controller.inquiryStatus.value == option,
//                               onTap: () {
//                                 controller.setValue(
//                                   controller.inquiryStatus,
//                                   option,
//                                 );
//                                 log("Inquiry ${controller.inquiryStatus}");
//                               },
//                             ),
//                           )
//                           .toList(),
//                 );
//               }),
//               SizedBox(height: 16),
//               buildSectionTitle('Conversion Status'),
//               SizedBox(height: 8),
//               Obx(() {
//                 return Wrap(
//                   spacing: 12,
//                   runSpacing: 8,
//                   children:
//                       ['Converted', 'Not Converted']
//                           .map(
//                             (option) => buildChoice(
//                               title: option.toString(),
//                               selected:
//                                   controller.conversionStatus.value == option,
//                               onTap: () {
//                                 controller.setValue(
//                                   controller.conversionStatus,
//                                   option,
//                                 );
//                                 log("Inquiry ${controller.conversionStatus}");
//                               },
//                             ),
//                           )
//                           .toList(),
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// page
// 1
// limit
// 10
// status
// contacted
// isConvertedToLead
// true
// startDate
// 2025-12-01
// endDate
// 2025-12-16
