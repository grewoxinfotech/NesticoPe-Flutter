// // import 'dart:developer';
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:get/get.dart';
// // import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// // import 'package:housing_flutter_app/app/constants/color_res.dart';
// // import 'package:housing_flutter_app/data/network/contractor/model/contractot_service_model/contractor_inquiry_model.dart';
// // import 'package:housing_flutter_app/data/network/contractor/model/contractor_quotation/contractor_quotation.dart';
// // import 'package:housing_flutter_app/modules/contractor/controller/contractor_inquiry_controller.dart';
// // import 'package:housing_flutter_app/modules/contractor/controller/contractor_quotation_controller.dart';
// // import 'package:housing_flutter_app/modules/contractor/controller/contractor_referral_controller.dart';
// // import 'package:housing_flutter_app/utils/logger/app_logger.dart';
// // import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
// // import 'package:intl/intl.dart';
// //
// // /// Screen for submitting or editing quotation for a contractor inquiry
// // class ContractorInquiryQuotationScreen extends StatefulWidget {
// //   final ContractorInquiryItem? inquiry;
// //   final ContractorQuotation? quotation;
// //   final bool isEditMode;
// //
// //   const ContractorInquiryQuotationScreen({
// //     super.key,
// //     this.inquiry,
// //     this.quotation,
// //     this.isEditMode = false,
// //   });
// //
// //   @override
// //   State<ContractorInquiryQuotationScreen> createState() =>
// //       _ContractorInquiryQuotationScreenState();
// // }
// //
// // class _ContractorInquiryQuotationScreenState
// //     extends State<ContractorInquiryQuotationScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _quotationController = TextEditingController();
// //   final _quotationNoteController = TextEditingController();
// //   final _isGSTIncluded = false.obs;
// //   final _selectedGSTPercentage = 1.obs;
// //   final TextEditingController _expectedStartDateController =
// //       TextEditingController();
// //
// //   DateTime? _expectedStartDate;
// //
// //   String _selectedStatus = 'Pending';
// //
// //   final List<String> _statusOptions = ['Pending', 'Accepted', 'Rejected'];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Format the status to match dropdown items (Title Case)
// //     AppLogger.structured("Edit quotation and data", widget.quotation?.toMap());
// //     _quotationNoteController.text =
// //         'Generated from inquiry for: ${widget.inquiry?.services.map((e) => e.serviceName).join(', ') ?? ''}';
// //
// //     if (widget.isEditMode && widget.quotation != null) {
// //       // Pre-fill form with existing quotation data
// //       _quotationController.text =
// //           // double.parse(
// //           widget.quotation!.meta.basePrice?.toStringAsFixed(0) ?? '0';
// //       // ).toInt().toString();
// //
// //       _quotationNoteController.text = widget.quotation!.meta.notes ?? '';
// //       _expectedStartDate = widget.quotation?.meta.expectedStartDate;
// //       _expectedStartDateController.text = DateFormat(
// //         'dd MMM yyyy',
// //       ).format(_expectedStartDate ?? DateTime.now());
// //
// //       // Capitalize first letter to match dropdown items
// //       _selectedStatus =
// //           widget.quotation!.status.isNotEmpty
// //               ? widget.quotation!.status[0].toUpperCase() +
// //                   widget.quotation!.status.substring(1).toLowerCase()
// //               : 'Pending';
// //       _isGSTIncluded.value = widget.quotation!.meta.isGstEnabled ?? false;
// //       _selectedGSTPercentage.value =
// //           (widget.quotation!.meta.gstPercentage ?? 0).toInt();
// //     } else {
// //       _selectedStatus = 'Pending';
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     _quotationController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final referralController = Get.find<ContractorReferralController>();
// //     return Scaffold(
// //       backgroundColor: ColorRes.background,
// //       appBar: AppBar(
// //         backgroundColor: ColorRes.surface,
// //         elevation: 0,
// //         title: Text(
// //           widget.isEditMode ? 'Edit Quotation' : 'Submit Quotation',
// //           style: const TextStyle(
// //             fontWeight: AppFontWeights.semiBold,
// //             color: ColorRes.textPrimary,
// //           ),
// //         ),
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back, color: ColorRes.textPrimary),
// //           onPressed: () => Get.back(),
// //         ),
// //       ),
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.all(20.0),
// //           child: Form(
// //             key: _formKey,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 // Customer Details Section
// //                 _buildSectionCard(
// //                   icon: Icons.person_outline,
// //                   title: 'Customer Details',
// //                   children: [
// //                     _buildInfoRow(
// //                       'Name :',
// //                       widget.isEditMode
// //                           ? widget.quotation!.user.name
// //                           : widget.inquiry!.name,
// //                     ),
// //                     const SizedBox(height: 12),
// //                     _buildInfoRow(
// //                       'Phone :',
// //                       widget.isEditMode
// //                           ? widget.quotation!.user.phone
// //                           : widget.inquiry!.phone,
// //                     ),
// //                     const SizedBox(height: 12),
// //                     _buildInfoRow(
// //                       'Email :',
// //                       widget.isEditMode
// //                           ? widget.quotation!.user.email
// //                           : widget.inquiry!.email,
// //                     ),
// //                   ],
// //                 ),
// //
// //                 const SizedBox(height: 16),
// //
// //                 // Property Details Section
// //                 _buildSectionCard(
// //                   icon: Icons.home_outlined,
// //                   title: 'Property Details',
// //                   children: [
// //                     _buildInfoRow(
// //                       'Type :',
// //                       widget.isEditMode
// //                           ? widget
// //                                   .quotation!
// //                                   .meta
// //                                   .propertyDetails
// //                                   ?.propertyType ??
// //                               ''
// //                           : widget.inquiry!.meta.propertyType,
// //                     ),
// //                     const SizedBox(height: 12),
// //                     _buildInfoRow(
// //                       'City :',
// //                       widget.isEditMode
// //                           ? widget.quotation!.meta.propertyDetails?.city ?? ''
// //                           : widget.inquiry!.meta.city,
// //                     ),
// //                     const SizedBox(height: 12),
// //                     if (widget.isEditMode
// //                         ? widget.quotation!.meta.propertyDetails?.bhk != null
// //                         : widget.inquiry!.meta.bhk != null)
// //                       _buildInfoRow(
// //                         'BHK :',
// //                         widget.isEditMode
// //                             ? '${widget.quotation!.meta.propertyDetails?.bhk}'
// //                             : '${widget.inquiry!.meta.bhk}',
// //                       ),
// //                   ],
// //                 ),
// //
// //                 const SizedBox(height: 16),
// //
// //                 // Required Services Section
// //                 _buildSectionCard(
// //                   icon: Icons.build_outlined,
// //                   title: 'Required Services:',
// //                   children: [
// //                     if (widget.isEditMode)
// //                       Text(
// //                         widget.quotation!.meta.serviceNames ?? '',
// //                         style: const TextStyle(
// //                           fontSize: AppFontSizes.small,
// //                           color: ColorRes.textPrimary,
// //                           fontWeight: AppFontWeights.medium,
// //                         ),
// //                       )
// //                     else
// //                       Wrap(
// //                         spacing: 8,
// //                         runSpacing: 8,
// //                         children:
// //                             widget.inquiry!.services
// //                                 .map(
// //                                   (service) => Container(
// //                                     padding: const EdgeInsets.symmetric(
// //                                       horizontal: 12,
// //                                       vertical: 6,
// //                                     ),
// //                                     decoration: BoxDecoration(
// //                                       color: ColorRes.primary.withOpacity(0.1),
// //                                       borderRadius: BorderRadius.circular(16),
// //                                       border: Border.all(
// //                                         color: ColorRes.primary.withOpacity(
// //                                           0.3,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                     child: Text(
// //                                       service.serviceName,
// //                                       style: const TextStyle(
// //                                         fontSize: AppFontSizes.small,
// //                                         color: ColorRes.primary,
// //                                         fontWeight: AppFontWeights.medium,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 )
// //                                 .toList(),
// //                       ),
// //                   ],
// //                 ),
// //
// //                 const SizedBox(height: 24),
// //                 Obx(() {
// //                   return _buildInputField(
// //                     label: 'GST (Include GST?)',
// //                     child: Row(
// //                       crossAxisAlignment: CrossAxisAlignment.center,
// //                       children: [
// //                         Switch(
// //                           value: _isGSTIncluded.value,
// //                           onChanged: (value) {
// //                             _isGSTIncluded.value = value;
// //                           },
// //                           activeColor: ColorRes.primary,
// //                         ),
// //                         if (_isGSTIncluded.value) ...[
// //                           SizedBox(width: 12),
// //                           Expanded(
// //                             child: NesticoPeDropdownField(
// //                               value: _selectedGSTPercentage.value,
// //                               items:
// //                                   [1, 5, 18].map((e) {
// //                                     return DropdownMenuItem(
// //                                       child: Text('${e}%'),
// //                                       value: e,
// //                                     );
// //                                   }).toList(),
// //                               onChanged: (onChange) {
// //                                 _selectedGSTPercentage.value = onChange;
// //                               },
// //                             ),
// //                           ),
// //                         ],
// //                       ],
// //                     ),
// //                   );
// //                 }),
// //                 const SizedBox(height: 20),
// //
// //                 // Quotation Price Input
// //                 _buildInputField(
// //                   label: 'Base Quotation Price',
// //                   isRequired: true,
// //                   child: TextFormField(
// //                     controller: _quotationController,
// //                     keyboardType: TextInputType.number,
// //                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
// //                     onChanged: (value) {
// //                       final price = int.tryParse(value) ?? 0;
// //                       referralController.calculateDiscount(price);
// //                     },
// //                     decoration: InputDecoration(
// //                       hintText: '0',
// //                       hintStyle: TextStyle(
// //                         color: ColorRes.textSecondary.withOpacity(0.5),
// //                         fontSize: AppFontSizes.medium,
// //                       ),
// //                       prefixIcon: const Icon(
// //                         Icons.currency_rupee,
// //                         color: ColorRes.primary,
// //                         size: 20,
// //                       ),
// //                       filled: true,
// //                       fillColor: ColorRes.white,
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: BorderSide(
// //                           color: ColorRes.leadGreyColor.shade300,
// //                           width: 1.5,
// //                         ),
// //                       ),
// //                       enabledBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: BorderSide(
// //                           color: ColorRes.leadGreyColor.shade300,
// //                           width: 1.5,
// //                         ),
// //                       ),
// //                       focusedBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: const BorderSide(
// //                           color: ColorRes.primary,
// //                           width: 2,
// //                         ),
// //                       ),
// //                       errorBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: const BorderSide(
// //                           color: ColorRes.error,
// //                           width: 1.5,
// //                         ),
// //                       ),
// //                       focusedErrorBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: const BorderSide(
// //                           color: ColorRes.error,
// //                           width: 2,
// //                         ),
// //                       ),
// //                       contentPadding: const EdgeInsets.symmetric(
// //                         horizontal: 16,
// //                         vertical: 16,
// //                       ),
// //                     ),
// //                     style: const TextStyle(
// //                       fontSize: AppFontSizes.medium,
// //                       fontWeight: AppFontWeights.medium,
// //                       color: ColorRes.textPrimary,
// //                     ),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter quotation price';
// //                       }
// //                       if (int.tryParse(value) == null) {
// //                         return 'Please enter a valid number';
// //                       }
// //                       if (int.parse(value) <= 0) {
// //                         return 'Price must be greater than 0';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                 ),
// //
// //                 // Obx(() {
// //                 //   if (referralController
// //                 //           .referralResponse
// //                 //           .value
// //                 //           ?.data
// //                 //           .pointsEarned ==
// //                 //       0) {
// //                 //     return SizedBox.shrink();
// //                 //   }
// //                 //   return (referralController.discountPercentage <= 0)
// //                 //       ? SizedBox.shrink()
// //                 //       : Column(
// //                 //         crossAxisAlignment: CrossAxisAlignment.start,
// //                 //         children: [
// //                 //           SizedBox(height: 8),
// //                 //           RichText(
// //                 //             text: TextSpan(
// //                 //               style: TextStyle(
// //                 //                 fontSize: AppFontSizes.small,
// //                 //                 color: ColorRes.textPrimary, // default color
// //                 //               ),
// //                 //               children: [
// //                 //                 const TextSpan(
// //                 //                   text: 'Calculated Price after ',
// //                 //                   style: TextStyle(
// //                 //                     fontWeight: FontWeight.w600,
// //                 //                     color: ColorRes.primary,
// //                 //                   ),
// //                 //                 ),
// //                 //                 TextSpan(
// //                 //                   text:
// //                 //                       '${referralController.discountPercentage}% ',
// //                 //                   style: TextStyle(
// //                 //                     fontWeight: FontWeight.bold,
// //                 //                     color: ColorRes.primary,
// //                 //                   ),
// //                 //                 ),
// //                 //                 const TextSpan(
// //                 //                   text: 'discount: ',
// //                 //                   style: TextStyle(
// //                 //                     fontWeight: FontWeight.w600,
// //                 //                     color: ColorRes.primary,
// //                 //                   ),
// //                 //                 ),
// //                 //                 TextSpan(
// //                 //                   text:
// //                 //                       '₹${referralController.originalPrice.value} ',
// //                 //                   style: TextStyle(
// //                 //                     decoration: TextDecoration.lineThrough,
// //                 //                     color: ColorRes.grey,
// //                 //                   ),
// //                 //                 ),
// //                 //                 const TextSpan(text: ' → '),
// //                 //                 TextSpan(
// //                 //                   text:
// //                 //                       '₹${referralController.discountedPriceObs.value} ',
// //                 //                   style: TextStyle(
// //                 //                     fontWeight: FontWeight.bold,
// //                 //                     color: ColorRes.success,
// //                 //                   ),
// //                 //                 ),
// //                 //                 // TextSpan(
// //                 //                 //   text:
// //                 //                 //       '(Save ₹${referralController.savedPriceObs.value})',
// //                 //                 //   style: TextStyle(
// //                 //                 //     fontWeight: FontWeight.w600,
// //                 //                 //     color: ColorRes.success,
// //                 //                 //   ),
// //                 //                 // ),
// //                 //               ],
// //                 //             ),
// //                 //           ),
// //                 //         ],
// //                 //       );
// //                 // }),
// //                 _buildPriceSummary(referralController),
// //
// //                 const SizedBox(height: 20),
// //                 _buildInputField(
// //                   label: 'Expected Start Date',
// //                   isRequired: true,
// //                   child: TextFormField(
// //                     controller: _expectedStartDateController,
// //                     readOnly: true,
// //                     onTap: () async {
// //                       FocusScope.of(context).unfocus();
// //
// //                       final DateTime? pickedDate = await showDatePicker(
// //                         context: context,
// //                         initialDate: DateTime.now(),
// //                         firstDate: DateTime.now(),
// //                         lastDate: DateTime(2100),
// //                       );
// //
// //                       if (pickedDate != null) {
// //                         _expectedStartDate = pickedDate;
// //
// //                         _expectedStartDateController.text = DateFormat(
// //                           'dd MMM yyyy',
// //                         ).format(pickedDate);
// //                       }
// //                     },
// //                     decoration: InputDecoration(
// //                       hintText: 'Select date',
// //                       prefixIcon: const Icon(
// //                         Icons.calendar_today,
// //                         color: ColorRes.primary,
// //                         size: 20,
// //                       ),
// //                       filled: true,
// //                       fillColor: ColorRes.white,
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: BorderSide(
// //                           color: ColorRes.leadGreyColor.shade300,
// //                           width: 1.5,
// //                         ),
// //                       ),
// //                       enabledBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: BorderSide(
// //                           color: ColorRes.leadGreyColor.shade300,
// //                           width: 1.5,
// //                         ),
// //                       ),
// //                       focusedBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: const BorderSide(
// //                           color: ColorRes.primary,
// //                           width: 2,
// //                         ),
// //                       ),
// //                       errorBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: const BorderSide(
// //                           color: ColorRes.error,
// //                           width: 1.5,
// //                         ),
// //                       ),
// //                       focusedErrorBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: const BorderSide(
// //                           color: ColorRes.error,
// //                           width: 2,
// //                         ),
// //                       ),
// //                       contentPadding: const EdgeInsets.symmetric(
// //                         horizontal: 16,
// //                         vertical: 16,
// //                       ),
// //                     ),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please select expected start date';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                 ),
// //
// //                 const SizedBox(height: 20),
// //                 _buildInputField(
// //                   label: 'Status',
// //                   isRequired: true,
// //                   child: DropdownButtonFormField<String>(
// //                     value: _selectedStatus,
// //                     decoration: InputDecoration(
// //                       filled: true,
// //                       fillColor: ColorRes.white,
// //                       prefixIcon: const Icon(
// //                         Icons.schedule,
// //                         color: ColorRes.primary,
// //                         size: 20,
// //                       ),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: BorderSide(
// //                           color: ColorRes.leadGreyColor.shade300,
// //                           width: 1.5,
// //                         ),
// //                       ),
// //                       enabledBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: BorderSide(
// //                           color: ColorRes.leadGreyColor.shade300,
// //                           width: 1.5,
// //                         ),
// //                       ),
// //                       focusedBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: const BorderSide(
// //                           color: ColorRes.primary,
// //                           width: 2,
// //                         ),
// //                       ),
// //                       contentPadding: const EdgeInsets.symmetric(
// //                         horizontal: 16,
// //                         vertical: 16,
// //                       ),
// //                     ),
// //                     icon: const Icon(
// //                       Icons.keyboard_arrow_down,
// //                       color: ColorRes.textSecondary,
// //                     ),
// //                     style: const TextStyle(
// //                       fontSize: AppFontSizes.medium,
// //                       fontWeight: AppFontWeights.medium,
// //                       color: ColorRes.textPrimary,
// //                     ),
// //                     dropdownColor: ColorRes.white,
// //                     items:
// //                         _statusOptions.map((String status) {
// //                           return DropdownMenuItem<String>(
// //                             value: status,
// //                             child: Text(status),
// //                           );
// //                         }).toList(),
// //                     onChanged: (String? newValue) {
// //                       if (newValue != null) {
// //                         setState(() {
// //                           _selectedStatus = newValue;
// //                         });
// //                       }
// //                     },
// //                   ),
// //                 ),
// //
// //                 const SizedBox(height: 20),
// //                 _buildInputField(
// //                   label: 'Note',
// //                   isRequired: true,
// //                   child: TextFormField(
// //                     controller: _quotationNoteController,
// //                     minLines: 3,
// //                     maxLines: 5,
// //                     keyboardType: TextInputType.text,
// //                     decoration: InputDecoration(
// //                       hintText: 'Enter Note',
// //                       hintStyle: TextStyle(
// //                         color: ColorRes.textSecondary.withOpacity(0.5),
// //                         fontSize: AppFontSizes.medium,
// //                       ),
// //                       prefixIcon: const Icon(
// //                         Icons.note,
// //                         color: ColorRes.primary,
// //                         size: 20,
// //                       ),
// //                       filled: true,
// //                       fillColor: ColorRes.white,
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: BorderSide(
// //                           color: ColorRes.leadGreyColor.shade300,
// //                           width: 1.5,
// //                         ),
// //                       ),
// //                       enabledBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: BorderSide(
// //                           color: ColorRes.leadGreyColor.shade300,
// //                           width: 1.5,
// //                         ),
// //                       ),
// //                       focusedBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: const BorderSide(
// //                           color: ColorRes.primary,
// //                           width: 2,
// //                         ),
// //                       ),
// //                       errorBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: const BorderSide(
// //                           color: ColorRes.error,
// //                           width: 1.5,
// //                         ),
// //                       ),
// //                       focusedErrorBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                         borderSide: const BorderSide(
// //                           color: ColorRes.error,
// //                           width: 2,
// //                         ),
// //                       ),
// //                       contentPadding: const EdgeInsets.symmetric(
// //                         horizontal: 16,
// //                         vertical: 16,
// //                       ),
// //                     ),
// //                     style: const TextStyle(
// //                       fontSize: AppFontSizes.medium,
// //                       fontWeight: AppFontWeights.medium,
// //                       color: ColorRes.textPrimary,
// //                     ),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter quotation note';
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                 ),
// //
// //                 const SizedBox(height: 32),
// //
// //                 // Status Dropdown
// //
// //                 // Save Button
// //                 SizedBox(
// //                   width: double.infinity,
// //                   child: ElevatedButton(
// //                     onPressed:
// //                         () => _submitQuotation(
// //                           referralController.discountedPriceObs.value,
// //                           referralController.discountPercentage,
// //                           referralController.originalPrice.value,
// //                         ),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: ColorRes.primary,
// //                       padding: const EdgeInsets.symmetric(vertical: 16),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       elevation: 0,
// //                     ),
// //                     child: Text(
// //                       widget.isEditMode ? 'Update Quotation' : 'Save Quotation',
// //                       style: const TextStyle(
// //                         fontSize: AppFontSizes.medium,
// //                         fontWeight: AppFontWeights.semiBold,
// //                         color: ColorRes.white,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildPriceSummary(ContractorReferralController referralController) {
// //     return Obx(() {
// //       final int basePrice = int.tryParse(_quotationController.text) ?? 0;
// //
// //       final int discountedPrice = referralController.discountedPriceObs.value;
// //
// //       final int discountPercentage = referralController.discountPercentage;
// //
// //       final int discountAmount = basePrice - discountedPrice;
// //
// //       final int gstPercent =
// //           _isGSTIncluded.value ? _selectedGSTPercentage.value : 0;
// //
// //       final int gstAmount = ((discountedPrice * gstPercent) / 100).round();
// //
// //       final int totalPrice = discountedPrice + gstAmount;
// //
// //       if (basePrice == 0) return const SizedBox.shrink();
// //
// //       return Container(
// //         margin: const EdgeInsets.only(top: 12),
// //         padding: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: ColorRes.white,
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(color: ColorRes.border),
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             _priceRow("Base Price:", basePrice),
// //
// //             if (discountPercentage > 0) ...[
// //               const SizedBox(height: 6),
// //               _priceRow(
// //                 "Discount ($discountPercentage%):",
// //                 -discountAmount,
// //                 color: ColorRes.success,
// //               ),
// //               const SizedBox(height: 4),
// //               const Text(
// //                 "* Buyer's referral points benefit applied",
// //                 style: TextStyle(fontSize: 11, color: ColorRes.textSecondary),
// //               ),
// //             ],
// //
// //             if (_isGSTIncluded.value) ...[
// //               const SizedBox(height: 6),
// //               _priceRow(
// //                 "GST ($gstPercent%):",
// //                 gstAmount,
// //                 color: ColorRes.primary,
// //               ),
// //             ],
// //
// //             const Divider(height: 20),
// //
// //             _priceRow(
// //               "Total Price:",
// //               totalPrice,
// //               isBold: true,
// //               color: ColorRes.primary,
// //             ),
// //           ],
// //         ),
// //       );
// //     });
// //   }
// //
// //   Widget _priceRow(
// //     String label,
// //     int amount, {
// //     Color? color,
// //     bool isBold = false,
// //   }) {
// //     final formatter = NumberFormat.currency(
// //       locale: 'en_IN',
// //       symbol: '₹',
// //       decimalDigits: 0,
// //     );
// //
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text(
// //           label,
// //           style: TextStyle(
// //             fontSize: 13,
// //             fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
// //             color: color ?? ColorRes.textPrimary,
// //           ),
// //         ),
// //         Text(
// //           "${amount >= 0 ? '+' : '-'} ${formatter.format(amount.abs())}",
// //           style: TextStyle(
// //             fontSize: 13,
// //             fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
// //             color: color ?? ColorRes.textPrimary,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildSectionCard({
// //     required IconData icon,
// //     required String title,
// //     required List<Widget> children,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: ColorRes.white,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: ColorRes.border, width: 1),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Icon(icon, size: 20, color: ColorRes.textSecondary),
// //               const SizedBox(width: 8),
// //               Text(
// //                 title,
// //                 style: const TextStyle(
// //                   fontSize: AppFontSizes.medium,
// //                   fontWeight: AppFontWeights.semiBold,
// //                   color: ColorRes.textPrimary,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 16),
// //           ...children,
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildInfoRow(String label, String value) {
// //     return Row(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         SizedBox(
// //           width: 80,
// //           child: Text(
// //             label,
// //             style: const TextStyle(
// //               fontSize: AppFontSizes.small,
// //               color: ColorRes.textSecondary,
// //               fontWeight: AppFontWeights.medium,
// //             ),
// //           ),
// //         ),
// //         const SizedBox(width: 12),
// //         Expanded(
// //           child: Text(
// //             value,
// //             style: const TextStyle(
// //               fontSize: AppFontSizes.small,
// //               color: ColorRes.textPrimary,
// //               fontWeight: AppFontWeights.medium,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildInputField({
// //     required String label,
// //     required Widget child,
// //     bool isRequired = false,
// //   }) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           children: [
// //             Text(
// //               label,
// //               style: const TextStyle(
// //                 fontSize: AppFontSizes.small,
// //                 fontWeight: AppFontWeights.medium,
// //                 color: ColorRes.textPrimary,
// //               ),
// //             ),
// //             if (isRequired)
// //               const Text(
// //                 ' *',
// //                 style: TextStyle(
// //                   fontSize: AppFontSizes.small,
// //                   fontWeight: AppFontWeights.semiBold,
// //                   color: ColorRes.error,
// //                 ),
// //               ),
// //           ],
// //         ),
// //         const SizedBox(height: 8),
// //         child,
// //       ],
// //     );
// //   }
// //
// //   void _submitQuotation(
// //     int discountPrice,
// //     int discountPercentage,
// //     int originalPrice,
// //   ) {
// //     if (_formKey.currentState!.validate()) {
// //       final quotationPrice = int.tryParse(_quotationController.text);
// //       String? expectedStartDateForApi;
// //
// //       if (_expectedStartDate != null) {
// //         expectedStartDateForApi = _expectedStartDate!.toUtc().toIso8601String();
// //       }
// //
// //       if (widget.isEditMode && widget.quotation != null) {
// //         // Update existing quotation
// //         final quotationController = Get.find<ContractorQuotationController>();
// //         quotationController.updateQuotation(
// //           quotationId: widget.quotation ?? ContractorQuotation.fromMap({}),
// //           price: quotationPrice ?? 0,
// //           status: _selectedStatus,
// //           note: _quotationNoteController.text,
// //           userId: widget.inquiry?.userId ?? '',
// //           discountedPrice: discountPrice,
// //           date: expectedStartDateForApi ?? '',
// //         );
// //       } else {
// //         // Create new quotation
// //         final controller = Get.find<ContractorInquiryController>();
// //         controller.submitQuotation(
// //           inquiryId: widget.inquiry!.id,
// //           quotationPrice: quotationPrice ?? 0,
// //           status: _selectedStatus,
// //           inquiry: widget.inquiry!,
// //           note: _quotationNoteController.text,
// //           userId: widget.inquiry!.userId,
// //           discountedPrice:
// //               (discountPrice +
// //                       (discountPrice * _selectedGSTPercentage.value / 100))
// //                   .toInt(),
// //           date: expectedStartDateForApi ?? '',
// //           gstEnabled: _isGSTIncluded.value,
// //           gst: _isGSTIncluded.value ? _selectedGSTPercentage.value : null,
// //           afterGstPrice:
// //               _isGSTIncluded.value
// //                   ? ((discountPrice * _selectedGSTPercentage.value / 100))
// //                       .toInt()
// //                   : null,
// //           discountAmount: originalPrice - discountPrice,
// //           discountPercentage: discountPercentage,
// //         );
// //       }
// //
// //       Get.back();
// //     }
// //   }
// // }
//
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/data/network/contractor/model/contractot_service_model/contractor_inquiry_model.dart';
// import 'package:housing_flutter_app/data/network/contractor/model/contractor_quotation/contractor_quotation.dart';
// import 'package:housing_flutter_app/modules/contractor/controller/contractor_inquiry_controller.dart';
// import 'package:housing_flutter_app/modules/contractor/controller/contractor_quotation_controller.dart';
// import 'package:housing_flutter_app/modules/contractor/controller/contractor_referral_controller.dart';
// import 'package:housing_flutter_app/utils/logger/app_logger.dart';
// import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
// import 'package:intl/intl.dart';
//
// /// Screen for submitting or editing quotation for a contractor inquiry
// class ContractorInquiryQuotationScreen extends StatefulWidget {
//   final ContractorInquiryItem? inquiry;
//   final ContractorQuotation? quotation;
//   final bool isEditMode;
//
//   const ContractorInquiryQuotationScreen({
//     super.key,
//     this.inquiry,
//     this.quotation,
//     this.isEditMode = false,
//   });
//
//   @override
//   State<ContractorInquiryQuotationScreen> createState() =>
//       _ContractorInquiryQuotationScreenState();
// }
//
// class _ContractorInquiryQuotationScreenState
//     extends State<ContractorInquiryQuotationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _quotationController = TextEditingController();
//   final _quotationNoteController = TextEditingController();
//   final _isGSTIncluded = false.obs;
//   final _selectedGSTPercentage = 1.obs;
//   final TextEditingController _expectedStartDateController =
//       TextEditingController();
//
//   DateTime? _expectedStartDate;
//
//   String _selectedStatus = 'Pending';
//
//   final List<String> _statusOptions = ['Pending', 'Accepted', 'Rejected'];
//
//   // Controller tag for this instance
//   static const String _controllerTag = 'contractor_referral_quotation';
//
//   @override
//   void initState() {
//     super.initState();
//
//     _initializeReferralController();
//     _initializeFormData();
//   }
//
//   /// Initialize referral controller with fresh instance
//   void _initializeReferralController() {
//     // Delete existing instance to ensure clean state
//     if (Get.isRegistered<ContractorReferralController>(tag: _controllerTag)) {
//       Get.delete<ContractorReferralController>(tag: _controllerTag);
//     }
//
//     // Get userId from either inquiry or quotation
//     final String userId =
//         widget.inquiry?.userId ?? widget.quotation?.user.id ?? '';
//
//     // Create fresh controller instance
//     Get.put(ContractorReferralController(userId: userId), tag: _controllerTag);
//   }
//
//   /// Initialize form data
//   void _initializeFormData() {
//     AppLogger.structured("Edit quotation and data", widget.quotation?.toMap());
//     _quotationNoteController.text =
//         'Generated from inquiry for: ${widget.inquiry?.services.map((e) => e.serviceName).join(', ') ?? ''}';
//
//     if (widget.isEditMode && widget.quotation != null) {
//       // Pre-fill form with existing quotation data
//       _quotationController.text =
//           widget.quotation!.meta.basePrice?.toStringAsFixed(0) ?? '0';
//
//       _quotationNoteController.text = widget.quotation!.meta.notes ?? '';
//       _expectedStartDate = widget.quotation?.meta.expectedStartDate;
//       _expectedStartDateController.text = DateFormat(
//         'dd MMM yyyy',
//       ).format(_expectedStartDate ?? DateTime.now());
//
//       // Capitalize first letter to match dropdown items
//       _selectedStatus =
//           widget.quotation!.status.isNotEmpty
//               ? widget.quotation!.status[0].toUpperCase() +
//                   widget.quotation!.status.substring(1).toLowerCase()
//               : 'Pending';
//       _isGSTIncluded.value = widget.quotation!.meta.isGstEnabled ?? false;
//       _selectedGSTPercentage.value =
//           (widget.quotation!.meta.gstPercentage ?? 0).toInt();
//       _referralController.discountPercentageObs.value =
//           (widget.quotation!.meta.discountPercentage ?? 0).toInt();
//       _referralController.originalPrice.value =
//           (widget.quotation!.meta.basePrice ?? 0).toInt();
//       _referralController.discountedPriceObs.value =
//           (widget.quotation!.meta.discountAmount ?? 0).toInt();
//       _referralController.calculateDiscount(
//         _referralController.originalPrice.value,
//       );
//     } else {
//       _selectedStatus = 'Pending';
//     }
//   }
//
//   @override
//   void dispose() {
//     // Dispose text controllers
//     _quotationController.dispose();
//     _quotationNoteController.dispose();
//     _expectedStartDateController.dispose();
//
//     // Clean up referral controller
//     if (Get.isRegistered<ContractorReferralController>(tag: _controllerTag)) {
//       Get.delete<ContractorReferralController>(tag: _controllerTag);
//     }
//
//     super.dispose();
//   }
//
//   /// Get referral controller instance
//   ContractorReferralController get _referralController =>
//       Get.find<ContractorReferralController>(tag: _controllerTag);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorRes.background,
//       appBar: AppBar(
//         backgroundColor: ColorRes.surface,
//         elevation: 0,
//         title: Text(
//           widget.isEditMode ? 'Edit Quotation' : 'Submit Quotation',
//           style: const TextStyle(
//             fontWeight: AppFontWeights.semiBold,
//             color: ColorRes.textPrimary,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: ColorRes.textPrimary),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Customer Details Section
//                 _buildSectionCard(
//                   icon: Icons.person_outline,
//                   title: 'Customer Details',
//                   children: [
//                     _buildInfoRow(
//                       'Name :',
//                       widget.isEditMode
//                           ? widget.quotation!.user.name
//                           : widget.inquiry!.name,
//                     ),
//                     const SizedBox(height: 12),
//                     _buildInfoRow(
//                       'Phone :',
//                       widget.isEditMode
//                           ? widget.quotation!.user.phone
//                           : widget.inquiry!.phone,
//                     ),
//                     const SizedBox(height: 12),
//                     _buildInfoRow(
//                       'Email :',
//                       widget.isEditMode
//                           ? widget.quotation!.user.email
//                           : widget.inquiry!.email,
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 // Property Details Section
//                 _buildSectionCard(
//                   icon: Icons.home_outlined,
//                   title: 'Property Details',
//                   children: [
//                     _buildInfoRow(
//                       'Type :',
//                       widget.isEditMode
//                           ? widget
//                                   .quotation!
//                                   .meta
//                                   .propertyDetails
//                                   ?.propertyType ??
//                               ''
//                           : widget.inquiry!.meta.propertyType,
//                     ),
//                     const SizedBox(height: 12),
//                     _buildInfoRow(
//                       'City :',
//                       widget.isEditMode
//                           ? widget.quotation!.meta.propertyDetails?.city ?? ''
//                           : widget.inquiry!.meta.city,
//                     ),
//                     const SizedBox(height: 12),
//                     if (widget.isEditMode
//                         ? widget.quotation!.meta.propertyDetails?.bhk != null
//                         : widget.inquiry!.meta.bhk != null)
//                       _buildInfoRow(
//                         'BHK :',
//                         widget.isEditMode
//                             ? '${widget.quotation!.meta.propertyDetails?.bhk}'
//                             : '${widget.inquiry!.meta.bhk}',
//                       ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 // Required Services Section
//                 _buildSectionCard(
//                   icon: Icons.build_outlined,
//                   title: 'Required Services:',
//                   children: [
//                     if (widget.isEditMode)
//                       Text(
//                         widget.quotation!.meta.serviceNames ?? '',
//                         style: const TextStyle(
//                           fontSize: AppFontSizes.small,
//                           color: ColorRes.textPrimary,
//                           fontWeight: AppFontWeights.medium,
//                         ),
//                       )
//                     else
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children:
//                             widget.inquiry!.services
//                                 .map(
//                                   (service) => Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 6,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: ColorRes.primary.withOpacity(0.1),
//                                       borderRadius: BorderRadius.circular(16),
//                                       border: Border.all(
//                                         color: ColorRes.primary.withOpacity(
//                                           0.3,
//                                         ),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       service.serviceName,
//                                       style: const TextStyle(
//                                         fontSize: AppFontSizes.small,
//                                         color: ColorRes.primary,
//                                         fontWeight: AppFontWeights.medium,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                       ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 24),
//                 Obx(() {
//                   return _buildInputField(
//                     label: 'GST (Include GST?)',
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Switch(
//                           value: _isGSTIncluded.value,
//                           onChanged: (value) {
//                             _isGSTIncluded.value = value;
//                           },
//                           activeColor: ColorRes.primary,
//                         ),
//                         if (_isGSTIncluded.value) ...[
//                           SizedBox(width: 12),
//                           Expanded(
//                             child: NesticoPeDropdownField(
//                               value: _selectedGSTPercentage.value,
//                               items:
//                                   [1, 5, 18].map((e) {
//                                     return DropdownMenuItem(
//                                       child: Text('${e}%'),
//                                       value: e,
//                                     );
//                                   }).toList(),
//                               onChanged: (onChange) {
//                                 _selectedGSTPercentage.value = onChange;
//                               },
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 20),
//
//                 // Quotation Price Input
//                 _buildInputField(
//                   label: 'Base Quotation Price',
//                   isRequired: true,
//                   child: TextFormField(
//                     controller: _quotationController,
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     onChanged: (value) {
//                       final price = int.tryParse(value) ?? 0;
//                       _referralController.calculateDiscount(price);
//                     },
//                     decoration: InputDecoration(
//                       hintText: '0',
//                       hintStyle: TextStyle(
//                         color: ColorRes.textSecondary.withOpacity(0.5),
//                         fontSize: AppFontSizes.medium,
//                       ),
//                       prefixIcon: const Icon(
//                         Icons.currency_rupee,
//                         color: ColorRes.primary,
//                         size: 20,
//                       ),
//                       filled: true,
//                       fillColor: ColorRes.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: ColorRes.leadGreyColor.shade300,
//                           width: 1.5,
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: ColorRes.leadGreyColor.shade300,
//                           width: 1.5,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(
//                           color: ColorRes.primary,
//                           width: 2,
//                         ),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(
//                           color: ColorRes.error,
//                           width: 1.5,
//                         ),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(
//                           color: ColorRes.error,
//                           width: 2,
//                         ),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 16,
//                       ),
//                     ),
//                     style: const TextStyle(
//                       fontSize: AppFontSizes.medium,
//                       fontWeight: AppFontWeights.medium,
//                       color: ColorRes.textPrimary,
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter quotation price';
//                       }
//                       if (int.tryParse(value) == null) {
//                         return 'Please enter a valid number';
//                       }
//                       if (int.parse(value) <= 0) {
//                         return 'Price must be greater than 0';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//
//                 _buildPriceSummary(),
//
//                 const SizedBox(height: 20),
//                 _buildInputField(
//                   label: 'Expected Start Date',
//                   isRequired: true,
//                   child: TextFormField(
//                     controller: _expectedStartDateController,
//                     readOnly: true,
//                     onTap: () async {
//                       FocusScope.of(context).unfocus();
//
//                       final DateTime? pickedDate = await showDatePicker(
//                         context: context,
//                         initialDate: DateTime.now(),
//                         firstDate: DateTime.now(),
//                         lastDate: DateTime(2100),
//                       );
//
//                       if (pickedDate != null) {
//                         _expectedStartDate = pickedDate;
//
//                         _expectedStartDateController.text = DateFormat(
//                           'dd MMM yyyy',
//                         ).format(pickedDate);
//                       }
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Select date',
//                       prefixIcon: const Icon(
//                         Icons.calendar_today,
//                         color: ColorRes.primary,
//                         size: 20,
//                       ),
//                       filled: true,
//                       fillColor: ColorRes.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: ColorRes.leadGreyColor.shade300,
//                           width: 1.5,
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: ColorRes.leadGreyColor.shade300,
//                           width: 1.5,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(
//                           color: ColorRes.primary,
//                           width: 2,
//                         ),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(
//                           color: ColorRes.error,
//                           width: 1.5,
//                         ),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(
//                           color: ColorRes.error,
//                           width: 2,
//                         ),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 16,
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please select expected start date';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//                 _buildInputField(
//                   label: 'Status',
//                   isRequired: true,
//                   child: DropdownButtonFormField<String>(
//                     value: _selectedStatus,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: ColorRes.white,
//                       prefixIcon: const Icon(
//                         Icons.schedule,
//                         color: ColorRes.primary,
//                         size: 20,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: ColorRes.leadGreyColor.shade300,
//                           width: 1.5,
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: ColorRes.leadGreyColor.shade300,
//                           width: 1.5,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(
//                           color: ColorRes.primary,
//                           width: 2,
//                         ),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 16,
//                       ),
//                     ),
//                     icon: const Icon(
//                       Icons.keyboard_arrow_down,
//                       color: ColorRes.textSecondary,
//                     ),
//                     style: const TextStyle(
//                       fontSize: AppFontSizes.medium,
//                       fontWeight: AppFontWeights.medium,
//                       color: ColorRes.textPrimary,
//                     ),
//                     dropdownColor: ColorRes.white,
//                     items:
//                         _statusOptions.map((String status) {
//                           return DropdownMenuItem<String>(
//                             value: status,
//                             child: Text(status),
//                           );
//                         }).toList(),
//                     onChanged: (String? newValue) {
//                       if (newValue != null) {
//                         setState(() {
//                           _selectedStatus = newValue;
//                         });
//                       }
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//                 _buildInputField(
//                   label: 'Note',
//                   isRequired: true,
//                   child: TextFormField(
//                     controller: _quotationNoteController,
//                     minLines: 3,
//                     maxLines: 5,
//                     keyboardType: TextInputType.text,
//                     decoration: InputDecoration(
//                       hintText: 'Enter Note',
//                       hintStyle: TextStyle(
//                         color: ColorRes.textSecondary.withOpacity(0.5),
//                         fontSize: AppFontSizes.medium,
//                       ),
//                       prefixIcon: const Icon(
//                         Icons.note,
//                         color: ColorRes.primary,
//                         size: 20,
//                       ),
//                       filled: true,
//                       fillColor: ColorRes.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: ColorRes.leadGreyColor.shade300,
//                           width: 1.5,
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: ColorRes.leadGreyColor.shade300,
//                           width: 1.5,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(
//                           color: ColorRes.primary,
//                           width: 2,
//                         ),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(
//                           color: ColorRes.error,
//                           width: 1.5,
//                         ),
//                       ),
//                       focusedErrorBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(
//                           color: ColorRes.error,
//                           width: 2,
//                         ),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 16,
//                       ),
//                     ),
//                     style: const TextStyle(
//                       fontSize: AppFontSizes.medium,
//                       fontWeight: AppFontWeights.medium,
//                       color: ColorRes.textPrimary,
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter quotation note';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(height: 32),
//
//                 // Save Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _submitQuotation,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: ColorRes.primary,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: Text(
//                       widget.isEditMode ? 'Update Quotation' : 'Save Quotation',
//                       style: const TextStyle(
//                         fontSize: AppFontSizes.medium,
//                         fontWeight: AppFontWeights.semiBold,
//                         color: ColorRes.white,
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
//   Widget _buildPriceSummary() {
//     return Obx(() {
//       final int basePrice = int.tryParse(_quotationController.text) ?? 0;
//
//       final int discountedPrice = _referralController.discountedPriceObs.value;
//
//       final int discountPercentage = _referralController.discountPercentage;
//
//       final int discountAmount = basePrice - discountedPrice;
//
//       final int gstPercent =
//           _isGSTIncluded.value ? _selectedGSTPercentage.value : 0;
//
//       final int gstAmount = ((discountedPrice * gstPercent) / 100).round();
//
//       final int totalPrice = discountedPrice + gstAmount;
//
//       if (basePrice == 0) return const SizedBox.shrink();
//
//       return Container(
//         margin: const EdgeInsets.only(top: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: ColorRes.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: ColorRes.border),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _priceRow("Base Price:", basePrice),
//
//             if (discountPercentage > 0) ...[
//               const SizedBox(height: 6),
//               _priceRow(
//                 "Discount ($discountPercentage%):",
//                 -discountAmount,
//                 color: ColorRes.success,
//               ),
//               const SizedBox(height: 4),
//               const Text(
//                 "* Buyer's referral points benefit applied",
//                 style: TextStyle(fontSize: 11, color: ColorRes.textSecondary),
//               ),
//             ],
//
//             if (_isGSTIncluded.value) ...[
//               const SizedBox(height: 6),
//               _priceRow(
//                 "GST ($gstPercent%):",
//                 gstAmount,
//                 color: ColorRes.primary,
//               ),
//             ],
//
//             const Divider(height: 20),
//
//             _priceRow(
//               "Total Price:",
//               totalPrice,
//               isBold: true,
//               color: ColorRes.primary,
//             ),
//           ],
//         ),
//       );
//     });
//   }
//
//   Widget _priceRow(
//     String label,
//     int amount, {
//     Color? color,
//     bool isBold = false,
//   }) {
//     final formatter = NumberFormat.currency(
//       locale: 'en_IN',
//       symbol: '₹',
//       decimalDigits: 0,
//     );
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
//             color: color ?? ColorRes.textPrimary,
//           ),
//         ),
//         Text(
//           "${amount >= 0 ? '+' : '-'} ${formatter.format(amount.abs())}",
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
//             color: color ?? ColorRes.textPrimary,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSectionCard({
//     required IconData icon,
//     required String title,
//     required List<Widget> children,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: ColorRes.border, width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, size: 20, color: ColorRes.textSecondary),
//               const SizedBox(width: 8),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: AppFontSizes.medium,
//                   fontWeight: AppFontWeights.semiBold,
//                   color: ColorRes.textPrimary,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ...children,
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 80,
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontSize: AppFontSizes.small,
//               color: ColorRes.textSecondary,
//               fontWeight: AppFontWeights.medium,
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontSize: AppFontSizes.small,
//               color: ColorRes.textPrimary,
//               fontWeight: AppFontWeights.medium,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildInputField({
//     required String label,
//     required Widget child,
//     bool isRequired = false,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: AppFontSizes.small,
//                 fontWeight: AppFontWeights.medium,
//                 color: ColorRes.textPrimary,
//               ),
//             ),
//             if (isRequired)
//               const Text(
//                 ' *',
//                 style: TextStyle(
//                   fontSize: AppFontSizes.small,
//                   fontWeight: AppFontWeights.semiBold,
//                   color: ColorRes.error,
//                 ),
//               ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         child,
//       ],
//     );
//   }
//
//   void _submitQuotation() {
//     if (_formKey.currentState!.validate()) {
//       final quotationPrice = int.tryParse(_quotationController.text);
//       String? expectedStartDateForApi;
//
//       if (_expectedStartDate != null) {
//         expectedStartDateForApi = _expectedStartDate!.toUtc().toIso8601String();
//       }
//
//       // Get values from referral controller
//       final int discountPrice = _referralController.discountedPriceObs.value;
//       final int discountPercentage = _referralController.discountPercentage;
//       final int originalPrice = _referralController.originalPrice.value;
//
//       if (widget.isEditMode && widget.quotation != null) {
//         // Update existing quotation
//         final quotationController = Get.find<ContractorQuotationController>();
//         quotationController.updateQuotation(
//           quotationId: widget.quotation ?? ContractorQuotation.fromMap({}),
//           price: quotationPrice ?? 0,
//           status: _selectedStatus,
//           note: _quotationNoteController.text,
//           userId: widget.inquiry?.userId ?? '',
//           discountedPrice: discountPrice,
//           date: expectedStartDateForApi ?? '',
//         );
//       } else {
//         // Create new quotation
//         final controller = Get.find<ContractorInquiryController>();
//         controller.submitQuotation(
//           inquiryId: widget.inquiry!.id,
//           quotationPrice: quotationPrice ?? 0,
//           status: _selectedStatus,
//           inquiry: widget.inquiry!,
//           note: _quotationNoteController.text,
//           userId: widget.inquiry!.userId,
//           discountedPrice:
//               (discountPrice +
//                       (discountPrice * _selectedGSTPercentage.value / 100))
//                   .toInt(),
//           date: expectedStartDateForApi ?? '',
//           gstEnabled: _isGSTIncluded.value,
//           gst: _isGSTIncluded.value ? _selectedGSTPercentage.value : null,
//           afterGstPrice:
//               _isGSTIncluded.value
//                   ? ((discountPrice * _selectedGSTPercentage.value / 100))
//                       .toInt()
//                   : null,
//           discountAmount: originalPrice - discountPrice,
//           discountPercentage: discountPercentage,
//         );
//       }
//
//       Get.back();
//     }
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractot_service_model/contractor_inquiry_model.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_quotation/contractor_quotation.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_inquiry_controller.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_quotation_controller.dart';
import 'package:housing_flutter_app/modules/contractor/controller/contractor_referral_controller.dart';
import 'package:housing_flutter_app/utils/logger/app_logger.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
import 'package:intl/intl.dart';

/// Screen for submitting or editing quotation for a contractor inquiry
class ContractorInquiryQuotationScreen extends StatefulWidget {
  final ContractorInquiryItem? inquiry;
  final ContractorQuotation? quotation;
  final bool isEditMode;

  const ContractorInquiryQuotationScreen({
    super.key,
    this.inquiry,
    this.quotation,
    this.isEditMode = false,
  });

  @override
  State<ContractorInquiryQuotationScreen> createState() =>
      _ContractorInquiryQuotationScreenState();
}

class _ContractorInquiryQuotationScreenState
    extends State<ContractorInquiryQuotationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quotationController = TextEditingController();
  final _quotationNoteController = TextEditingController();
  final _isGSTIncluded = false.obs;
  final _selectedGSTPercentage = 1.obs;
  final TextEditingController _expectedStartDateController =
      TextEditingController();

  DateTime? _expectedStartDate;

  String _selectedStatus = 'Pending';

  final List<String> _statusOptions = ['Pending', 'Accepted', 'Rejected'];

  // Controller tag for this instance
  static const String _controllerTag = 'contractor_referral_quotation';

  @override
  void initState() {
    super.initState();

    _initializeReferralController();
    _initializeFormData();
  }

  /// Initialize referral controller with fresh instance
  void _initializeReferralController() {
    // Delete existing instance to ensure clean state
    if (Get.isRegistered<ContractorReferralController>(tag: _controllerTag)) {
      Get.delete<ContractorReferralController>(tag: _controllerTag);
    }

    // Get userId from either inquiry or quotation
    final String userId =
        widget.inquiry?.userId ?? widget.quotation?.user.id ?? '';

    // Create fresh controller instance
    Get.put(ContractorReferralController(userId: userId), tag: _controllerTag);
  }

  /// Initialize form data
  void _initializeFormData() {
    AppLogger.structured("Edit quotation and data", widget.quotation?.toMap());
    _quotationNoteController.text =
        'Generated from inquiry for: ${widget.inquiry?.services.map((e) => e.serviceName).join(', ') ?? ''}';

    if (widget.isEditMode && widget.quotation != null) {
      // Pre-fill form with existing quotation data
      final basePrice = (widget.quotation!.meta.basePrice ?? 0).toInt();
      _quotationController.text = basePrice.toString();

      _quotationNoteController.text = widget.quotation!.meta.notes ?? '';
      _expectedStartDate = widget.quotation?.meta.expectedStartDate;
      _expectedStartDateController.text = DateFormat(
        'dd MMM yyyy',
      ).format(_expectedStartDate ?? DateTime.now());

      // Capitalize first letter to match dropdown items
      _selectedStatus =
          widget.quotation!.status.isNotEmpty
              ? widget.quotation!.status[0].toUpperCase() +
                  widget.quotation!.status.substring(1).toLowerCase()
              : 'Pending';
      _isGSTIncluded.value = widget.quotation!.meta.isGstEnabled ?? false;
      _selectedGSTPercentage.value =
          (widget.quotation!.meta.gstPercentage ?? 0).toInt();

      // Pre-populate discount values if they exist
      final discountPercentage =
          (widget.quotation!.meta.discountPercentage ?? 0).toInt();
      final discountAmount =
          (widget.quotation!.meta.discountAmount ?? 0).toInt();

      // Set the controller values
      _referralController.originalPrice.value = basePrice;
      _referralController.discountPercentageObs.value = discountPercentage;

      // Calculate discounted price: basePrice - discountAmount
      final discountedPrice = basePrice - discountAmount;
      _referralController.discountedPriceObs.value = discountedPrice;
      _referralController.savedPriceObs.value = discountAmount;
    } else {
      _selectedStatus = 'Pending';
    }
  }

  @override
  void dispose() {
    // Dispose text controllers
    _quotationController.dispose();
    _quotationNoteController.dispose();
    _expectedStartDateController.dispose();

    // Clean up referral controller
    if (Get.isRegistered<ContractorReferralController>(tag: _controllerTag)) {
      Get.delete<ContractorReferralController>(tag: _controllerTag);
    }

    super.dispose();
  }

  /// Get referral controller instance
  ContractorReferralController get _referralController =>
      Get.find<ContractorReferralController>(tag: _controllerTag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        backgroundColor: ColorRes.surface,
        elevation: 0,
        title: Text(
          widget.isEditMode ? 'Edit Quotation' : 'Submit Quotation',
          style: const TextStyle(
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorRes.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Details Section
                _buildSectionCard(
                  icon: Icons.person_outline,
                  title: 'Customer Details',
                  children: [
                    _buildInfoRow(
                      'Name :',
                      widget.isEditMode
                          ? widget.quotation!.user.name
                          : widget.inquiry!.name,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Phone :',
                      widget.isEditMode
                          ? widget.quotation!.user.phone
                          : widget.inquiry!.phone,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Email :',
                      widget.isEditMode
                          ? widget.quotation!.user.email
                          : widget.inquiry!.email,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Property Details Section
                _buildSectionCard(
                  icon: Icons.home_outlined,
                  title: 'Property Details',
                  children: [
                    _buildInfoRow(
                      'Type :',
                      widget.isEditMode
                          ? widget
                                  .quotation!
                                  .meta
                                  .propertyDetails
                                  ?.propertyType ??
                              ''
                          : widget.inquiry!.meta.propertyType,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'City :',
                      widget.isEditMode
                          ? widget.quotation!.meta.propertyDetails?.city ?? ''
                          : widget.inquiry!.meta.city,
                    ),
                    const SizedBox(height: 12),
                    if (widget.isEditMode
                        ? widget.quotation!.meta.propertyDetails?.bhk != null
                        : widget.inquiry!.meta.bhk != null)
                      _buildInfoRow(
                        'BHK :',
                        widget.isEditMode
                            ? '${widget.quotation!.meta.propertyDetails?.bhk}'
                            : '${widget.inquiry!.meta.bhk}',
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Required Services Section
                _buildSectionCard(
                  icon: Icons.build_outlined,
                  title: 'Required Services:',
                  children: [
                    if (widget.isEditMode)
                      Text(
                        widget.quotation!.meta.serviceNames ?? '',
                        style: const TextStyle(
                          fontSize: AppFontSizes.small,
                          color: ColorRes.textPrimary,
                          fontWeight: AppFontWeights.medium,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            widget.inquiry!.services
                                .map(
                                  (service) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorRes.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: ColorRes.primary.withOpacity(
                                          0.3,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      service.serviceName,
                                      style: const TextStyle(
                                        fontSize: AppFontSizes.small,
                                        color: ColorRes.primary,
                                        fontWeight: AppFontWeights.medium,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                  ],
                ),

                const SizedBox(height: 24),
                Obx(() {
                  return _buildInputField(
                    label: 'GST (Include GST?)',
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Switch(
                          value: _isGSTIncluded.value,
                          onChanged: (value) {
                            _isGSTIncluded.value = value;
                          },
                          activeColor: ColorRes.primary,
                        ),
                        if (_isGSTIncluded.value) ...[
                          SizedBox(width: 12),
                          Expanded(
                            child: NesticoPeDropdownField(
                              value: _selectedGSTPercentage.value,
                              items:
                                  [1, 5, 18].map((e) {
                                    return DropdownMenuItem(
                                      child: Text('${e}%'),
                                      value: e,
                                    );
                                  }).toList(),
                              onChanged: (onChange) {
                                _selectedGSTPercentage.value = onChange;
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 20),

                // Quotation Price Input
                _buildInputField(
                  label: 'Base Quotation Price',
                  isRequired: true,
                  child: TextFormField(
                    controller: _quotationController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      final price = int.tryParse(value) ?? 0;
                      _referralController.calculateDiscount(price);
                    },
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: TextStyle(
                        color: ColorRes.textSecondary.withOpacity(0.5),
                        fontSize: AppFontSizes.medium,
                      ),
                      prefixIcon: const Icon(
                        Icons.currency_rupee,
                        color: ColorRes.primary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: ColorRes.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: ColorRes.leadGreyColor.shade300,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: ColorRes.leadGreyColor.shade300,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: ColorRes.primary,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: ColorRes.error,
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: ColorRes.error,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.medium,
                      color: ColorRes.textPrimary,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter quotation price';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      if (int.parse(value) <= 0) {
                        return 'Price must be greater than 0';
                      }
                      return null;
                    },
                  ),
                ),

                _buildPriceSummary(),

                const SizedBox(height: 20),
                _buildInputField(
                  label: 'Expected Start Date',
                  isRequired: true,
                  child: TextFormField(
                    controller: _expectedStartDateController,
                    readOnly: true,
                    onTap: () async {
                      FocusScope.of(context).unfocus();

                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        _expectedStartDate = pickedDate;

                        _expectedStartDateController.text = DateFormat(
                          'dd MMM yyyy',
                        ).format(pickedDate);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Select date',
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: ColorRes.primary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: ColorRes.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: ColorRes.leadGreyColor.shade300,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: ColorRes.leadGreyColor.shade300,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: ColorRes.primary,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: ColorRes.error,
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: ColorRes.error,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select expected start date';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),
                _buildInputField(
                  label: 'Status',
                  isRequired: true,
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ColorRes.white,
                      prefixIcon: const Icon(
                        Icons.schedule,
                        color: ColorRes.primary,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: ColorRes.leadGreyColor.shade300,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: ColorRes.leadGreyColor.shade300,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: ColorRes.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: ColorRes.textSecondary,
                    ),
                    style: const TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.medium,
                      color: ColorRes.textPrimary,
                    ),
                    dropdownColor: ColorRes.white,
                    items:
                        _statusOptions.map((String status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedStatus = newValue;
                        });
                      }
                    },
                  ),
                ),

                const SizedBox(height: 20),
                _buildInputField(
                  label: 'Note',
                  isRequired: true,
                  child: TextFormField(
                    controller: _quotationNoteController,
                    minLines: 3,
                    maxLines: 5,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter Note',
                      hintStyle: TextStyle(
                        color: ColorRes.textSecondary.withOpacity(0.5),
                        fontSize: AppFontSizes.medium,
                      ),
                      prefixIcon: const Icon(
                        Icons.note,
                        color: ColorRes.primary,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: ColorRes.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: ColorRes.leadGreyColor.shade300,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: ColorRes.leadGreyColor.shade300,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: ColorRes.primary,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: ColorRes.error,
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: ColorRes.error,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.medium,
                      color: ColorRes.textPrimary,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter quotation note';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitQuotation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorRes.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      widget.isEditMode ? 'Update Quotation' : 'Save Quotation',
                      style: const TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Obx(() {
      final int basePrice = int.tryParse(_quotationController.text) ?? 0;

      final int discountedPrice = _referralController.discountedPriceObs.value;

      final int discountPercentage = _referralController.discountPercentage;

      final int discountAmount = basePrice - discountedPrice;

      final int gstPercent =
          _isGSTIncluded.value ? _selectedGSTPercentage.value : 0;

      final int gstAmount = ((discountedPrice * gstPercent) / 100).round();

      final int totalPrice = discountedPrice + gstAmount;

      if (basePrice == 0) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _priceRow("Base Price:", basePrice),

            if (discountPercentage > 0) ...[
              const SizedBox(height: 6),
              _priceRow(
                "Discount ($discountPercentage%):",
                -discountAmount,
                color: ColorRes.success,
              ),
              const SizedBox(height: 4),
              const Text(
                "* Buyer's referral points benefit applied",
                style: TextStyle(fontSize: 11, color: ColorRes.textSecondary),
              ),
            ],

            if (_isGSTIncluded.value) ...[
              const SizedBox(height: 6),
              _priceRow(
                "GST ($gstPercent%):",
                gstAmount,
                color: ColorRes.primary,
              ),
            ],

            const Divider(height: 20),

            _priceRow(
              "Total Price:",
              totalPrice,
              isBold: true,
              color: ColorRes.primary,
            ),
          ],
        ),
      );
    });
  }

  Widget _priceRow(
    String label,
    int amount, {
    Color? color,
    bool isBold = false,
  }) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: color ?? ColorRes.textPrimary,
          ),
        ),
        Text(
          "${amount >= 0 ? '+' : '-'} ${formatter.format(amount.abs())}",
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color ?? ColorRes.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: ColorRes.textSecondary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.textSecondary,
              fontWeight: AppFontWeights.medium,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.textPrimary,
              fontWeight: AppFontWeights.medium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required Widget child,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.textPrimary,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.error,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  void _submitQuotation() {
    if (_formKey.currentState!.validate()) {
      final quotationPrice = int.tryParse(_quotationController.text);
      String? expectedStartDateForApi;

      if (_expectedStartDate != null) {
        expectedStartDateForApi =
            DateTime.utc(
              _expectedStartDate!.year,
              _expectedStartDate!.month,
              _expectedStartDate!.day,
              _expectedStartDate!.hour,
              _expectedStartDate!.minute,
            ).toIso8601String();
        // expectedStartDateForApi = _expectedStartDate!.toUtc().toIso8601String();
      }

      // Get values from referral controller
      final int discountPrice = _referralController.discountedPriceObs.value;
      final int discountPercentage = _referralController.discountPercentage;
      final int originalPrice = _referralController.originalPrice.value;

      if (widget.isEditMode && widget.quotation != null) {
        // Update existing quotation
        final quotationController = Get.find<ContractorQuotationController>();
        quotationController.updateQuotation(
          quotationId: widget.quotation ?? ContractorQuotation.fromMap({}),
          quotationPrice: quotationPrice ?? 0,
          status: _selectedStatus,
          note: _quotationNoteController.text,
          userId: widget.inquiry?.userId ?? '',
          discountedPrice:
              (discountPrice +
                      (discountPrice * _selectedGSTPercentage.value / 100))
                  .toInt(),
          date: expectedStartDateForApi ?? '',
          gstEnabled: _isGSTIncluded.value,
          gst: _isGSTIncluded.value ? _selectedGSTPercentage.value : null,
          afterGstPrice:
              _isGSTIncluded.value
                  ? ((discountPrice * _selectedGSTPercentage.value / 100))
                      .toInt()
                  : null,
          discountAmount: originalPrice - discountPrice,
          discountPercentage: discountPercentage,
        );
      } else {
        // Create new quotation
        final controller = Get.find<ContractorInquiryController>();
        controller.submitQuotation(
          inquiryId: widget.inquiry!.id,
          quotationPrice: quotationPrice ?? 0,
          status: _selectedStatus,
          inquiry: widget.inquiry!,
          note: _quotationNoteController.text,
          userId: widget.inquiry!.userId,
          discountedPrice:
              (discountPrice +
                      (discountPrice * _selectedGSTPercentage.value / 100))
                  .toInt(),
          date: expectedStartDateForApi ?? '',
          gstEnabled: _isGSTIncluded.value,
          gst: _isGSTIncluded.value ? _selectedGSTPercentage.value : null,
          afterGstPrice:
              _isGSTIncluded.value
                  ? ((discountPrice * _selectedGSTPercentage.value / 100))
                      .toInt()
                  : null,
          discountAmount: originalPrice - discountPrice,
          discountPercentage: discountPercentage,
        );
      }

      Get.back();
    }
  }
}
