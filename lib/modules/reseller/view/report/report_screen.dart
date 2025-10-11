// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../app/constants/app_font_sizes.dart';
// import '../../../../app/constants/color_res.dart';
// import '../../controller/report/report_controller.dart';
// import '../lead/lead_screen.dart';
//
// class ReportPropertyScreen extends StatelessWidget {
//   const ReportPropertyScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ReportPropertyController());
//
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF4A73E8),
//         elevation: 0,
//
//         title: Text(
//           'Report Property',
//           style: TextStyle(
//             color: ColorRes.white,
//             fontWeight: AppFontWeights.bold,
//             fontSize: getResponsiveFontSize(
//               context,
//               AppFontSizes.large,
//               AppFontSizes.body,
//             ),
//           ),
//         ),
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.close, color: ColorRes.white),
//             onPressed: () => controller.cancel(),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 8),
//               const Text(
//                 'apartment in Gandhinagar',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: AppFontWeights.medium,
//                 ),
//               ),
//               const SizedBox(height: 24),
//
//               // Important Note Container
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE8EAF6),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: const Color(0xFFBDBDBD)),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Icon(
//                       Icons.info,
//                       color: Color(0xFF4A73E8),
//                       size: 24,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: const [
//                           Text(
//                             'Important Note',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: AppFontWeights.semiBold,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'False reports may result in account restrictions. Please ensure your report is genuine and accurate.',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Color(0xFF424242),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//
//               // Reason for Report
//               RichText(
//                 text: const TextSpan(
//                   children: [
//                     TextSpan(
//                       text: '* ',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 16,
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'Reason for Report',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontWeight: AppFontWeights.medium,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               // Dropdown
//               Obx(() => Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: const Color(0xFFBDBDBD)),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: DropdownButtonFormField<String>(
//                   decoration: const InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     border: InputBorder.none,
//                   ),
//                   hint: const Text(
//                     'Select reason for reporting',
//                     style: TextStyle(color: Color(0xFF757575)),
//                   ),
//                   value: controller.selectedReason.value.isEmpty
//                       ? null
//                       : controller.selectedReason.value,
//                   isExpanded: true,
//                   icon: const Icon(Icons.keyboard_arrow_down),
//                   items: controller.reportReasons.map((String reason) {
//                     return DropdownMenuItem<String>(
//                       value: reason,
//                       child: Text(reason),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     if (newValue != null) {
//                       controller.setReason(newValue);
//                     }
//                   },
//                   selectedItemBuilder: (BuildContext context) {
//                     return controller.reportReasons.map((String reason) {
//                       return Text(
//                         reason,
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontSize: 16,
//                         ),
//                       );
//                     }).toList();
//                   },
//                 ),
//               )),
//
//               const SizedBox(height: 24),
//
//               // Additional Details
//               const Text(
//                 'Additional Details (Optional)',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: AppFontWeights.medium,
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               // Text Area
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: const Color(0xFFBDBDBD)),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Column(
//                   children: [
//                     TextField(
//                       maxLines: 5,
//                       maxLength: 500,
//                       decoration: const InputDecoration(
//                         hintText: 'Provide additional details about why you are reporting this property...',
//                         hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.all(16),
//                         counterText: '',
//                       ),
//                       onChanged: (value) => controller.setAdditionalDetails(value),
//                     ),
//                     Obx(() => Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       alignment: Alignment.centerRight,
//                       child: Text(
//                         '${controller.additionalDetails.value.length} / 500',
//                         style: const TextStyle(
//                           color: Color(0xFF757575),
//                           fontSize: 12,
//                         ),
//                       ),
//                     )),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 32),
//
//               // Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () => controller.cancel(),
//                     style: TextButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     ),
//                     child: const Text(
//                       'Cancel',
//                       style: TextStyle(
//                         color: Color(0xFF424242),
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   ElevatedButton(
//                     onPressed: () => controller.submitReport(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF4A73E8),
//                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                     child: const Text(
//                       'Submit Report',
//                       style: TextStyle(
//                         color: ColorRes.white,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../../controller/report/report_controller.dart';
import '../../model/reseller_lead_model/reseller_lead_overview.dart';

// Compact Report Widget
// class ReportPropertyCard extends StatelessWidget {
//   const ReportPropertyCard({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ReportPropertyController());
//     return InkWell(
//       onTap: () {
//         // Navigate to full report screen
//
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: ColorRes.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
//
//
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 // Icon Container
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFFEBEE),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(
//                     Icons.report_gmailerrorred_outlined,
//                     color: Color(0xFFD32F2F),
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 // Text Content
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text(
//                         'Report Property',
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: AppFontWeights.semiBold,
//                           color: Color(0xFF212121),
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         'Report issues or concerns about this property',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Color(0xFF757575),
//                           height: 1.3,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//
//             // Reason for Report
//             RichText(
//               text: const TextSpan(
//                 children: [
//                   TextSpan(
//                     text: '* ',
//                     style: TextStyle(
//                       color: Colors.red,
//                       fontSize: 16,
//                     ),
//                   ),
//                   TextSpan(
//                     text: 'Reason for Report',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                       fontWeight: AppFontWeights.medium,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 8),
//
//             // Dropdown
//             Obx(() => Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: const Color(0xFFBDBDBD)),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   border: InputBorder.none,
//                 ),
//                 hint: const Text(
//                   'Select reason for reporting',
//                   style: TextStyle(color: Color(0xFF757575)),
//                 ),
//                 value: controller.selectedReason.value.isEmpty
//                     ? null
//                     : controller.selectedReason.value,
//                 isExpanded: true,
//                 icon: const Icon(Icons.keyboard_arrow_down),
//                 items: controller.reportReasons.map((String reason) {
//                   return DropdownMenuItem<String>(
//                     value: reason,
//                     child: Text(reason),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   if (newValue != null) {
//                     controller.setReason(newValue);
//                   }
//                 },
//                 selectedItemBuilder: (BuildContext context) {
//                   return controller.reportReasons.map((String reason) {
//                     return Text(
//                       reason,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                       ),
//                     );
//                   }).toList();
//                 },
//               ),
//             )),
//
//             const SizedBox(height: 24),
//
//             // Additional Details
//             const Text(
//               'Additional Details (Optional)',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: AppFontWeights.medium,
//               ),
//             ),
//
//             const SizedBox(height: 8),
//
//             // Text Area
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: const Color(0xFFBDBDBD)),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Column(
//                 children: [
//                   TextField(
//                     maxLines: 5,
//                     maxLength: 500,
//                     decoration: const InputDecoration(
//                       hintText: 'Provide additional details about why you are reporting this property...',
//                       hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.all(16),
//                       counterText: '',
//                     ),
//                     onChanged: (value) => controller.setAdditionalDetails(value),
//                   ),
//                   Obx(() => Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     alignment: Alignment.centerRight,
//                     child: Text(
//                       '${controller.additionalDetails.value.length} / 500',
//                       style: const TextStyle(
//                         color: Color(0xFF757575),
//                         fontSize: 12,
//                       ),
//                     ),
//                   )),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 32),
//
//             // Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () => controller.cancel(),
//                   style: TextButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                   ),
//                   child: const Text(
//                     'Cancel',
//                     style: TextStyle(
//                       color: Color(0xFF424242),
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 ElevatedButton(
//                   onPressed: () => controller.submitReport(),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF4A73E8),
//                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                   child: const Text(
//                     'Submit Report',
//                     style: TextStyle(
//                       color: ColorRes.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ReportPropertyCard extends StatelessWidget {
//   const ReportPropertyCard({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ReportPropertyController());
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Header Section
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: const Color(0xFFFFF3F4),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(16),
//                 topRight: Radius.circular(16),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: ColorRes.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFFD32F2F).withOpacity(0.1),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.report_problem_outlined,
//                     color: Color(0xFFD32F2F),
//                     size: 28,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text(
//                         'Report Property',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: AppFontWeights.bold,
//                           color: Color(0xFF212121),
//                           letterSpacing: -0.3,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         'Help us maintain quality by reporting issues',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Color(0xFF616161),
//                           height: 1.4,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Form Content
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Reason Section
//                 RichText(
//                   text: const TextSpan(
//                     children: [
//                       TextSpan(
//                         text: 'Reason for Report ',
//                         style: TextStyle(
//                           color: Color(0xFF212121),
//                           fontSize: 15,
//                           fontWeight: AppFontWeights.semiBold,
//                         ),
//                       ),
//                       TextSpan(
//                         text: '*',
//                         style: TextStyle(
//                           color: Color(0xFFD32F2F),
//                           fontSize: 15,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 // Dropdown with better styling
//                 Obx(() => Container(
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFAFAFA),
//                     border: Border.all(
//                       color: controller.selectedReason.value.isEmpty
//                           ? const Color(0xFFE0E0E0)
//                           : const Color(0xFF4A73E8),
//                       width: controller.selectedReason.value.isEmpty ? 1 : 2,
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(
//                       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                       border: InputBorder.none,
//                       filled: false,
//                     ),
//                     hint: Row(
//                       children: const [
//                         Icon(
//                           Icons.playlist_add_check_rounded,
//                           size: 20,
//                           color: Color(0xFF9E9E9E),
//                         ),
//                         SizedBox(width: 10),
//                         Text(
//                           'Select a reason',
//                           style: TextStyle(
//                             color: Color(0xFF9E9E9E),
//                             fontSize: 15,
//                           ),
//                         ),
//                       ],
//                     ),
//                     value: controller.selectedReason.value.isEmpty
//                         ? null
//                         : controller.selectedReason.value,
//                     isExpanded: true,
//                     icon: const Icon(
//                       Icons.keyboard_arrow_down_rounded,
//                       color: Color(0xFF757575),
//                     ),
//                     dropdownColor: ColorRes.white,
//                     borderRadius: BorderRadius.circular(12),
//                     items: controller.reportReasons.map((String reason) {
//                       return DropdownMenuItem<String>(
//                         value: reason,
//                         child: Text(
//                           reason,
//                           style: const TextStyle(fontSize: 15),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       if (newValue != null) {
//                         controller.setReason(newValue);
//                       }
//                     },
//                     selectedItemBuilder: (BuildContext context) {
//                       return controller.reportReasons.map((String reason) {
//                         return Row(
//                           children: [
//                             const Icon(
//                               Icons.check_circle,
//                               size: 20,
//                               color: Color(0xFF4A73E8),
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Text(
//                                 reason,
//                                 style: const TextStyle(
//                                   color: Color(0xFF212121),
//                                   fontSize: 15,
//                                   fontWeight: AppFontWeights.medium,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       }).toList();
//                     },
//                   ),
//                 )),
//
//                 const SizedBox(height: 24),
//
//                 // Additional Details Section
//                 const Text(
//                   'Additional Details',
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: AppFontWeights.semiBold,
//                     color: Color(0xFF212121),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Optional - Provide more context to help us understand',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 // Text Area with better design
//                 Container(
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFAFAFA),
//                     border: Border.all(color: const Color(0xFFE0E0E0)),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     children: [
//                       TextField(
//                         maxLines: 5,
//                         maxLength: 500,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           height: 1.5,
//                         ),
//                         decoration: const InputDecoration(
//                           hintText: 'Describe the issue in detail to help us take appropriate action...',
//                           hintStyle: TextStyle(
//                             color: Color(0xFFBDBDBD),
//                             fontSize: 14,
//                           ),
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.all(16),
//                           counterText: '',
//                         ),
//                         onChanged: (value) => controller.setAdditionalDetails(value),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                         decoration: BoxDecoration(
//                           color: ColorRes.white,
//                           borderRadius: const BorderRadius.only(
//                             bottomLeft: Radius.circular(12),
//                             bottomRight: Radius.circular(12),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.info_outline,
//                                   size: 13,
//                                   color: Colors.grey[600],
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   'Your report will be reviewed within 24 hours',
//                                   style: TextStyle(
//                                     color: Colors.grey[600],
//                                     fontSize: 10,
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Obx(() => Text(
//                   '${controller.additionalDetails.value.length}/500',
//                   style: TextStyle(
//                     color: controller.additionalDetails.value.length > 450
//                         ? const Color(0xFFD32F2F)
//                         : Colors.grey[600],
//                     fontSize: 12,
//                     fontWeight: AppFontWeights.medium,
//                   ),
//                 )),
//
//                 const SizedBox(height: 28),
//
//                 // Action Buttons
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => controller.cancel(),
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           side: const BorderSide(
//                             color: Color(0xFFE0E0E0),
//                             width: 1.5,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: const Text(
//                           'Cancel',
//                           style: TextStyle(
//                             color: Color(0xFF616161),
//                             fontSize: 15,
//                             fontWeight: AppFontWeights.semiBold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       flex: 2,
//                       child: Obx(() => ElevatedButton(
//                         onPressed: controller.selectedReason.value.isEmpty
//                             ? null
//                             : () => controller.submitReport(),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF4A73E8),
//                           disabledBackgroundColor: const Color(0xFFE0E0E0),
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(
//                               Icons.send_rounded,
//                               size: 18,
//                               color: ColorRes.white,
//                             ),
//                             SizedBox(width: 8),
//                             Text(
//                               'Submit Report',
//                               style: TextStyle(
//                                 color: ColorRes.white,
//                                 fontSize: 15,
//                                 fontWeight: AppFontWeights.semiBold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class ReportPropertyCard extends StatelessWidget {
  final String propertyId;
  const ReportPropertyCard({Key? key, required this.propertyId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportPropertyController());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color:  ColorRes.reportCardBG, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Compact Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorRes.redAccentColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ColorRes.redAccentColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child:  Icon(
                  Icons.report_problem_outlined,
                  color: ColorRes.error,
                  size: 20,
                ),
              ),
              // const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Report Property',
                  style: TextStyle(
                    fontSize: AppFontSizes.bodyMedium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.reportCardText,
                  ),
                ),
              ),
            ],
          ),

          // Compact Form
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Reason Dropdown - Compact
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Reason ',
                        style: TextStyle(
                          color: ColorRes.reportCardText,
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: ColorRes.reportCardred,
                          fontSize: AppFontSizes.medium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: ColorRes.white,
                      border: Border.all(
                        color:
                            controller.selectedReason.value.isEmpty
                                ?  ColorRes.reportCardboarder
                                :  ColorRes.reportCardblue,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      hint: const Text(
                        'Select reason',
                        style: TextStyle(
                          color: ColorRes.reportCardhint,
                          fontSize: AppFontSizes.medium,
                        ),
                      ),
                      value:
                          controller.selectedReason.value.isEmpty
                              ? null
                              : controller.selectedReason.value,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: Color(0xFF757575),
                      ),
                      dropdownColor: ColorRes.white,
                      style:  TextStyle(
                        color: ColorRes.textColor,
                        fontSize: AppFontSizes.medium,
                      ),
                      items:
                          controller.reportReasons.map((String reason) {
                            return DropdownMenuItem<String>(
                              value: reason,
                              child: Text(reason),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.setReason(newValue);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Additional Details - Compact
                 Text(
                  'Additional Details (Optional)',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.medium,
                    color: ColorRes.reportCardText,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color:  ColorRes.white,
                    border: Border.all(color: ColorRes.reportCardboarder),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        maxLines: 3,
                        maxLength: 500,
                        style: const TextStyle(fontSize: 13, height: 1.4),
                        decoration: const InputDecoration(
                          hintText: 'Describe the issue...',
                          hintStyle: TextStyle(
                            color: ColorRes.reportCardhint,
                            fontSize: AppFontSizes.bodySmall,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                          counterText: '',
                          isDense: true,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "Additional details cannot be empty";
                          }
                          if (value != null && value.length > 500) {
                            return "Maximum 500 characters allowed";
                          }

                          if (value != null &&
                              value.length <= 10 &&
                              value.isNotEmpty) {
                            return "Please provide (min 10 characters)";
                          }
                          return null;
                        },
                        onChanged:
                            (value) => controller.setAdditionalDetails(value),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color(0xFFE0E0E0),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Obx(
                              () => Text(
                                '${controller.additionalDetails.value.length}/500',
                                style: TextStyle(
                                  color:
                                      controller
                                                  .additionalDetails
                                                  .value
                                                  .length >
                                              450
                                          ?  ColorRes.reportCardred
                                          :  ColorRes.reportCardTextFiled,
                                  fontSize: AppFontSizes.caption,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Compact Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => controller.cancel(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          side: const BorderSide(color: ColorRes.reportCardBG),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: ColorRes.textDisabled,
                            fontSize: AppFontSizes.medium,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Expanded(
                    //   flex: 2,
                    //   child: Obx(
                    //     () => ElevatedButton(
                    //       onPressed:
                    //           controller.selectedReason.value.isEmpty
                    //               ? null
                    //               : (controller
                    //                           .additionalDetails
                    //                           .value
                    //                           .length <=
                    //                       10 ||
                    //                   controller
                    //                           .additionalDetails
                    //                           .value
                    //                           .length >
                    //                       500)
                    //               ? null
                    //               : controller.isSubmitting.value
                    //               ? null
                    //               : () => controller.submitReport(propertyId),
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor:
                    //             controller.isSubmitting.value
                    //                 ? ColorRes.primary.withOpacity(0.3)
                    //                 : ColorRes.primary,
                    //         disabledBackgroundColor: const Color(0xFFE0E0E0),
                    //         padding: const EdgeInsets.symmetric(vertical: 11),
                    //         elevation: 0,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //       ),
                    //       child: Text(
                    //         controller.isSubmitting.value
                    //             ? "Submitting..."
                    //             : 'Submit Report',
                    //         style: TextStyle(
                    //           color: ColorRes.white,
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      flex: 2,
                      child: Obx(() {
                        // Determine if button should be enabled
                        bool isButtonEnabled =
                            controller.selectedReason.value.isNotEmpty &&
                            controller.additionalDetails.value.length > 10 &&
                            controller.additionalDetails.value.length <= 500 &&
                            !controller.isSubmitting.value;

                        return ElevatedButton(
                          onPressed:
                              isButtonEnabled
                                  ? () => controller.submitReport(propertyId)
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                controller.isSubmitting.value
                                    ? ColorRes.primary.withOpacity(0.3)
                                    : isButtonEnabled
                                    ? ColorRes.primary
                                    : const Color(0xFFE0E0E0), // Disabled color
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            controller.isSubmitting.value
                                ? "Submitting..."
                                : 'Submit Report',
                            style: TextStyle(
                              color:
                                  isButtonEnabled
                                      ? ColorRes.white
                                      : const Color(0xFF9E9E9E),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class PropertyOverviewCard extends StatelessWidget {
//   final ResellerLeadOverview lead;
//
//   const PropertyOverviewCard({super.key, required this.lead});
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> overviewData = [
//       {
//         "title": "Views",
//         "value": "12.4K",
//         "icon": Icons.remove_red_eye_outlined,
//         "color": Colors.blue,
//       },
//       {
//         "title": "Likes",
//         "value": "2.3K",
//         "icon": Icons.favorite_border,
//         "color": Colors.red,
//       },
//       {
//         "title": "Shares",
//         "value": "540",
//         "icon": Icons.share_outlined,
//         "color": Colors.green,
//       },
//       {
//         "title": "Visits",
//         "value": "8.9K",
//         "icon": Icons.travel_explore,
//         "color": Colors.orange,
//       },
//       {
//         "title": "Inquiries",
//         "value": "245",
//         "icon": Icons.question_answer_outlined,
//         "color": Colors.purple,
//       },
//       {
//         "title": "Saved",
//         "value": "1.1K",
//         "icon": Icons.bookmark_border,
//         "color": Colors.teal,
//       },
//     ];
//
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//
//         border: Border.all(color: Colors.grey[300]!,width: 1),
//
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: ColorRes.primary.withOpacity(0.08),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: ColorRes.primary.withOpacity(0.3),width: 1)
//                     ),
//                     child: Icon(
//                       Icons.analytics_outlined,
//                       color: ColorRes.primary,
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   const Text(
//                     "Property Insights",
//                     style: TextStyle(
//                       fontSize: AppFontSizes.body,
//                       fontWeight: AppFontWeights.semiBold,
//                       color: ColorRes.textColor,
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//
//           // Grid of metrics
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 3,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               childAspectRatio: 0.75,
//             ),
//             itemCount: overviewData.length,
//             itemBuilder: (context, index) {
//               final item = overviewData[index];
//               return Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: ColorRes.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color:Colors.grey.withOpacity(0.3),
//                     width: 1,
//                   ),
//
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: (item["color"] as Color).withOpacity(0.08),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: (item["color"] as Color).withOpacity(0.3),
//                           width: 1,
//                         ),
//                       ),
//                       child: Icon(
//                         item["icon"] as IconData,
//                         size: 20,
//                         color: item["color"] as Color,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       item["title"]!,
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Colors.grey.shade600,
//                         fontWeight: AppFontWeights.medium,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       item["value"]!,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: item["color"] as Color,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//
//           // Footer with last updated time
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.access_time,
//                 size: 12,
//                 color: Colors.grey.shade500,
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 "Updated 5 minutes ago",
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: Colors.grey.shade600,
//                   fontStyle: FontStyle.italic,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class PropertyOverviewCard extends StatelessWidget {
  final ResellerLeadOverview? lead;
  final Items? property;

  const PropertyOverviewCard({super.key, this.lead, this.property})
    : assert(
        (lead != null) != (property != null),
        'You must provide either lead OR property, not both.',
      );

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> overviewData = [
      {
        "title": "Views",
        "value": "12.4K",
        "icon": Icons.remove_red_eye_outlined,
        "color": Colors.blue,
      },
      {
        "title": "Likes",
        "value": "2.3K",
        "icon": Icons.favorite_border,
        "color": Colors.red,
      },
      {
        "title": "Shares",
        "value": "540",
        "icon": Icons.share_outlined,
        "color": Colors.green,
      },
      {
        "title": "Visits",
        "value": "8.9K",
        "icon": Icons.travel_explore,
        "color": Colors.orange,
      },
      {
        "title": "Inquiries",
        "value": "245",
        "icon": Icons.question_answer_outlined,
        "color": Colors.purple,
      },
      {
        "title": "Saved",
        "value": "1.1K",
        "icon": Icons.bookmark_border,
        "color": Colors.teal,
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: ColorRes.grey.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: ColorRes.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  color: ColorRes.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Property Insights",
                style: TextStyle(
                  fontSize: AppFontSizes.body,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textColor,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// 2-column horizontal layout grid
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // two columns
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.0, // wide horizontal cells
            ),
            itemCount: overviewData.length,
            itemBuilder: (context, index) {
              final item = overviewData[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorRes.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (item["color"] as Color).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (item["color"] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item["icon"] as IconData,
                        size: 18,
                        color: item["color"] as Color,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item["value"]!,
                          style: TextStyle(
                            fontSize: AppFontSizes.medium,
                            height: 1,
                            fontWeight: AppFontWeights.extraBold,
                            color: item["color"] as Color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item["title"]!,
                          style: TextStyle(
                            fontSize: AppFontSizes.extraSmall,
                            height: 1,
                            color: ColorRes.leadGreyColor.shade600,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
