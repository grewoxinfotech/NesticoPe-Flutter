// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../app/constants/app_font_sizes.dart';
// import '../../../../app/constants/color_res.dart';
// import '../../../../data/network/contractor/model/contractot_service_model/contractor_inquiry_model.dart';
// import '../../controller/contractor_inquiry_controller.dart';
//
// // Controller
//
//
// // Main Screen
// class ContractorInquiryScreen extends StatelessWidget {
//   const ContractorInquiryScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ContractorInquiryController());
//
//     return Scaffold(
//       backgroundColor: ColorRes.background,
//       appBar: AppBar(
//         title: const Text('Contractor Inquiries'),
//       ),
//       body: Obx(
//         () {
//           final items = controller.items;
//           if (controller.isLoading.value) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: ColorRes.primary,
//               ),
//             );
//           }
//
//           if (items.isEmpty) {
//             return Center(
//               child: Text(
//                 "No services available",
//                 style: TextStyle(
//                   fontSize: AppFontSizes.body,
//                   color: ColorRes.textSecondary,
//                   fontWeight: AppFontWeights.medium,
//                 ),
//               ),
//             );
//           }
//         return  ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: items.length,
//             itemBuilder: (context, index) {
//               final inquiry = items[index];
//               return InquiryCard(
//                 inquiry: inquiry,
//                 controller: controller,
//               );
//             },
//           );
//         }
//       ),
//     );
//   }
// }
//
// // Inquiry Card Widget
// class InquiryCard extends StatelessWidget {
//   final ContractorInquiryItem inquiry;
//   final ContractorInquiryController controller;
//
//   const InquiryCard({
//     super.key,
//     required this.inquiry,
//     required this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final isExpanded = controller.isExpanded(inquiry.id);
//
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: () => controller.toggleCard(inquiry.id),
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Section
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           inquiry.name,
//                           style: const TextStyle(
//                             fontSize: AppFontSizes.body,
//                             fontWeight: AppFontWeights.semiBold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         _buildStatusBadge(inquiry.status),
//                       ],
//                     ),
//                   ),
//                   Icon(
//                     isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//                     color: ColorRes.textSecondary,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//
//               // Contact Info
//               _buildInfoRow(Icons.phone, inquiry.phone),
//               const SizedBox(height: 8),
//               _buildInfoRow(Icons.email, inquiry.email),
//               const SizedBox(height: 8),
//               _buildInfoRow(Icons.build, inquiry.services.first.serviceName),
//
//               // Expanded Section
//               if (isExpanded) ...[
//                 const SizedBox(height: 16),
//                 const Divider(),
//                 const SizedBox(height: 16),
//
//                 // Property Details
//                 _buildSectionTitle('Property Details'),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildDetailItem('Property Type', inquiry.meta.propertyType),
//                     ),
//                     Expanded(
//                       child: _buildDetailItem('BHK', '${inquiry.meta.bhk ?? "N/A"} BHK'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildDetailItem('Carpet Area', '${inquiry.meta.carpetArea} sq. ft.'),
//                     ),
//                     Expanded(
//                       child: _buildDetailItem('State', inquiry.meta.state),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 _buildDetailItem('Location', inquiry.meta.location),
//
//                 const SizedBox(height: 16),
//                 _buildSectionTitle('Service Description'),
//                 const SizedBox(height: 8),
//                 Text(
//                   inquiry.meta.serviceDescription,
//                   style: const TextStyle(
//                     fontSize: AppFontSizes.small,
//                     color: ColorRes.textSecondary,
//                   ),
//                 ),
//
//                 const SizedBox(height: 16),
//                 const Divider(),
//                 const SizedBox(height: 16),
//
//                 // Action Buttons
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildActionButton(
//                         icon: Icons.swap_horiz,
//                         label: 'Change Status',
//                         color: ColorRes.primary,
//                         onPressed: () => _showStatusMenu(context),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: _buildActionButton(
//                         icon: Icons.transform,
//                         label: 'Lead Convert',
//                         color: ColorRes.success,
//                         onPressed: () => controller.convertToLead(inquiry.id, inquiry.services),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 SizedBox(
//                   width: double.infinity,
//                   child: _buildActionButton(
//                     icon: Icons.delete_outline,
//                     label: 'Delete',
//                     color: ColorRes.error,
//                     onPressed: () => controller.deleteInquiry(inquiry.id, inquiry.name),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatusBadge(String status) {
//     Color color;
//     switch (status.toLowerCase()) {
//       case 'new':
//         color = ColorRes.blueColor;
//         break;
//       case 'in progress':
//         color = ColorRes.orangeColor;
//         break;
//       case 'completed':
//         color = ColorRes.success;
//         break;
//       default:
//         color = ColorRes.grey;
//     }
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           fontSize: AppFontSizes.caption,
//           fontWeight: AppFontWeights.medium,
//           color: color,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, size: 16, color: ColorRes.primary),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             text,
//             style: const TextStyle(
//               fontSize: AppFontSizes.small,
//               color: ColorRes.textSecondary,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: AppFontSizes.bodySmall,
//         fontWeight: AppFontWeights.semiBold,
//         color: ColorRes.textPrimary,
//       ),
//     );
//   }
//
//   Widget _buildDetailItem(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: AppFontSizes.caption,
//             color: ColorRes.textSecondary,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: AppFontSizes.small,
//             fontWeight: AppFontWeights.medium,
//             color: ColorRes.textPrimary,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return OutlinedButton.icon(
//       onPressed: onPressed,
//       icon: Icon(icon, size: 18),
//       label: Text(label),
//       style: OutlinedButton.styleFrom(
//         foregroundColor: color,
//         side: BorderSide(color: color),
//         padding: const EdgeInsets.symmetric(vertical: 12),
//       ),
//     );
//   }
//
//   void _showStatusMenu(BuildContext context) {
//     final statuses = ['New', 'In Progress', 'Completed', 'Cancelled'];
//
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Change Status',
//               style: TextStyle(
//                 fontSize: AppFontSizes.body,
//                 fontWeight: AppFontWeights.semiBold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ...statuses.map((status) => ListTile(
//               title: Text(status),
//               leading: Radio<String>(
//                 value: status,
//                 groupValue: controller.selectedStatus[inquiry.id] ?? inquiry.status,
//                 onChanged: (value) {
//                   if (value != null) {
//                     controller.changeStatus(inquiry.id, value);
//                     Navigator.pop(context);
//                   }
//                 },
//               ),
//               onTap: () {
//                 controller.changeStatus(inquiry.id, status);
//                 Navigator.pop(context);
//               },
//             )),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../data/network/contractor/model/contractot_service_model/contractor_inquiry_model.dart';
import '../../../../utils/shimmer/contractor/inquiry/contractor_inquiry_list_screen_shimmer.dart';
import '../../../../widgets/New folder/inputs/dropdown_field.dart';
import '../../../../widgets/bar/filter_bar/filter_chip_bar.dart';
import '../../controller/contractor_dashboard_controller.dart';
import '../../controller/contractor_inquiry_controller.dart';
import '../../controller/contractor_referral_controller.dart';
import '../filter/contractor_inquiry_filter.dart';
import 'contractor_inquiry_quotation_screen.dart';

class ContractorInquiryScreen extends StatefulWidget {
  const ContractorInquiryScreen({super.key});

  @override
  State<ContractorInquiryScreen> createState() =>
      _ContractorInquiryScreenState();
}

class _ContractorInquiryScreenState extends State<ContractorInquiryScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContractorInquiryController());
    RxMap<String, String> selectedFilters = <String, String>{}.obs;

    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        backgroundColor: ColorRes.surface,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Contractor Inquiries',
          style: TextStyle(
            // fontSize: AppFontSizes.title,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
        actions: [
          // IconButton(onPressed: () {
          //   Get.to(()=>ContractorInquiryFilter());
          // }, icon: Icon(Icons.filter_list))
          TextButton.icon(
            onPressed: () async {
              final result = await Get.dialog<Map<String, String>>(
                const ContractorInquiryFilter(),
                barrierDismissible: true,
              );

              if (result != null) {
                log("Selected Filters → $result");
                if (result != null) {
                  selectedFilters.value = result;
                  controller.applyFilters(result);
                }
                // You can now apply filters to your list, API call, etc.
                // controller.fetchFilteredInquiries(result);
              }
            },
            icon: const Icon(Icons.filter_list, color: ColorRes.primary),
            label: const Text(
              "Filter",
              style: TextStyle(
                color: ColorRes.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              return FilterChipsBar(
                filters: selectedFilters.value,
                onClearAll: () {
                  selectedFilters.clear();
                  controller.resetFilters();
                  controller.applyFilters(<String, String>{});
                },
                onRemoveFilter: (key) {
                  selectedFilters.remove(key);
                  controller.applyFilters(
                    Map<String, String>.from(selectedFilters),
                  );
                },
              );
            }),
            Expanded(
              child: Obx(() {
                final items = controller.items;
                if (controller.isLoading.value) {
                  return ContractorInquiryListScreenShimmer();
                }

                if (controller.items.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: controller.refreshInquiry,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: double.infinity,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "No inquiries available",
                                style: TextStyle(
                                  fontSize: AppFontSizes.body,
                                  color: ColorRes.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: controller.refreshInquiry,
                                // icon: const Icon(Icons.refresh, size: 16),
                                
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorRes.primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child:  Text('Refresh'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshInquiry,
                  color: ColorRes.primary,
                  child:
                      items.isEmpty
                          ? SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Center(
                                child: Text(
                                  "No services available",
                                  style: TextStyle(
                                    fontSize: AppFontSizes.body,
                                    color: ColorRes.textSecondary,
                                    fontWeight: AppFontWeights.medium,
                                  ),
                                ),
                              ),
                            ),
                          )
                          : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: controller.itemInquiryList.length,
                            itemBuilder: (context, index) {
                              final inquiry = controller.itemInquiryList[index];
                              return Obx(
                                () => InquiryCard(
                                  inquiry: inquiry,
                                  isExpanded: controller.isExpanded(inquiry.id),
                                  onToggle:
                                      () => controller.toggleCard(inquiry.id),
                                  onChangeStatus:
                                      () => _showStatusDialog(
                                        context,
                                        controller,
                                        inquiry,
                                      ),
                                  onLeadConvert:
                                  // () => controller.convertToLead(inquiry, inquiry.services,inquiry.convertedServices),
                                  () {
                                    // final controller = Get.put(
                                    //   ContractorReferralController(
                                    //     userId: inquiry.userId,
                                    //   ),
                                    // );
                                    // controller.resetAllData();
                                    Get.to(
                                      () => ContractorInquiryQuotationScreen(
                                        inquiry: inquiry,
                                      ),
                                    );
                                  },
                                  onDelete:
                                      () => controller.deleteInquiry(
                                        inquiry.id,
                                        inquiry.name,
                                      ),
                                ),
                              );
                            },
                          ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusDialog(
    BuildContext context,
    ContractorInquiryController controller,
    ContractorInquiryItem inquiry,
  ) {
    final statuses = [
      'Pending',
      'Contacted',
      'In Progress',
      'Converted',
      'Rejected',
      'Closed',
    ];

    Get.dialog(
      Dialog(
        backgroundColor: ColorRes.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: ColorRes.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
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
                        "Change Status",
                        style: TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.white,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
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

              // Dropdown Field (instead of radio buttons)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() {
                  return NesticoPeDropdownField<String>(
                    isRequired: true,
                    value:
                        controller.selectedStatus[inquiry.id] ??
                        inquiry.status, // pre-selected value
                    hintText: "Select Status",
                    prefixIcon: Icons.schedule,
                    items:
                        statuses
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        controller.setValue(
                          controller.inquiryStatus,
                          val,
                        ); // reactive update
                        log(
                          "Contractor_status ${controller.inquiryStatus.value}",
                        );
                      }
                    },
                    darkText: true,
                  );
                }),
              ),

              // Footer Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: ColorRes.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: AppFontSizes.medium,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          final val = controller.inquiryStatus.value;

                          controller.changeStatus(inquiry.id, val);
                          Get.back();
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
                              'Change Status',
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
      barrierDismissible: true,
    );
  }
}

class InquiryCard extends StatelessWidget {
  final ContractorInquiryItem inquiry;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onChangeStatus;
  final VoidCallback onLeadConvert;
  final VoidCallback onDelete;

  const InquiryCard({
    super.key,
    required this.inquiry,
    required this.isExpanded,
    required this.onToggle,
    required this.onChangeStatus,
    required this.onLeadConvert,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    ContractorInquiryController controller =
        Get.find<ContractorInquiryController>();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      inquiry.name.capitalize?.replaceAll("_", " ") ?? " ",
                      style: const TextStyle(
                        fontSize: AppFontSizes.medium,
                        color: ColorRes.textColor,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  _buildStatusBadge(inquiry.status),
                  const SizedBox(width: 12),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: ColorRes.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Basic Info
              _buildInfoRow(Icons.phone, inquiry.phone),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.email, inquiry.email),
              // const SizedBox(height: 8),
              // _buildInfoRow(Icons.build, inquiry.services.first.serviceName),

              // Expanded Section
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: ColorRes.leadGreyColor.shade200),

                      /// 🏠 Property Details Section
                      if ((inquiry.meta.propertyType?.isNotEmpty ?? false) ||
                          (inquiry.meta.bhk != null &&
                              inquiry.meta.bhk != null) ||
                          (inquiry.meta.carpetArea != null ?? false) ||
                          (inquiry.meta.state?.isNotEmpty ?? false) ||
                          (inquiry.meta.location?.isNotEmpty ?? false)) ...[
                        const SizedBox(height: 12),
                        _buildSectionTitle('Property Details'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (inquiry.meta.propertyType?.isNotEmpty ?? false)
                              Expanded(
                                child: _buildDetailItem(
                                  'Property Type',
                                  inquiry.meta.propertyType!,
                                ),
                              ),
                            if (inquiry.meta.bhk != null)
                              Expanded(
                                child: _buildDetailItem(
                                  'BHK',
                                  '${inquiry.meta.bhk} BHK',
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (inquiry.meta.carpetArea != null ?? false)
                              Expanded(
                                child: _buildDetailItem(
                                  'Carpet Area',
                                  '${inquiry.meta.carpetArea} sq. ft.',
                                ),
                              ),
                            if (inquiry.meta.state?.isNotEmpty ?? false)
                              Expanded(
                                child: _buildDetailItem(
                                  'State',
                                  inquiry.meta.state!,
                                ),
                              ),
                          ],
                        ),
                        if (inquiry.meta.location?.isNotEmpty ?? false) ...[
                          const SizedBox(height: 8),
                          _buildDetailItem('Location', inquiry.meta.location!),
                        ],
                      ],

                      /// 🛠 Required Services Section
                      if (inquiry.services.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildSectionTitle('Required Services'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(inquiry.services.length, (
                            index,
                          ) {
                            final service = inquiry.services[index];
                            final bool isConverted = inquiry.convertedServices
                                .contains(service.serviceId);

                            return _chip(
                              service.serviceName.capitalize?.replaceAll(
                                    "_",
                                    ' ',
                                  ) ??
                                  service.serviceName,
                              isConverted
                                  ? ColorRes.success
                                  : ColorRes.leadGreyColor.shade400,
                            );
                          }),
                        ),
                      ],

                      /// 📝 Service Description Section
                      if (inquiry.meta.serviceDescription?.trim().isNotEmpty ??
                          false) ...[
                        const SizedBox(height: 12),
                        _buildSectionTitle('Service Description'),
                        const SizedBox(height: 8),
                        Text(
                          inquiry.meta.serviceDescription!,
                          style: const TextStyle(
                            fontSize: AppFontSizes.caption,
                            color: ColorRes.textSecondary,
                          ),
                        ),
                      ],

                      const SizedBox(height: 10),
                      Divider(color: ColorRes.leadGreyColor.shade200),

                      /// 🔘 Action Buttons
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          if (!inquiry.isConvertedToQuotation) ...[
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.swap_horiz,
                                label: 'Change Status',
                                color: ColorRes.primary,
                                onPressed: onChangeStatus,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.delete_outline,
                                label: 'Delete',
                                color: ColorRes.error,
                                onPressed: onDelete,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      (inquiry.isConvertedToQuotation)
                          ? GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: ColorRes.green.withOpacity(0.3),
                                  width: 1,
                                ),
                                color: ColorRes.green.withOpacity(0.08),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Converted',
                                style: TextStyle(
                                  color: ColorRes.green,
                                  fontSize: AppFontSizes.bodySmall,
                                  fontWeight: AppFontWeights.semiBold,
                                ),
                              ),
                            ),
                          )
                          : _buildActionButton(
                            icon: Icons.transform,
                            label: 'Convert to Quotation',
                            color: ColorRes.success,
                            onPressed: () {
                              final dashboardController =
                                  Get.find<ContractorDashboardController>();
                              final limitReached =
                                  dashboardController
                                      .activeSubscription
                                      .value
                                      ?.isServiceLimitReached ??
                                  true;

                              if (limitReached) {
                                dashboardController.showUpgradePlanDialog(
                                  title: 'Limit Reached',
                                  message:
                                      'Limit Reached, please upgrade your plan.',
                                      buttonText: 'Upgrade Plan'
                                );
                                return;
                              }

                              onLeadConvert();
                            },
                          ),
                      // const SizedBox(height: 8),
                      //
                      // // Submit Quotation Button
                      // SizedBox(
                      //   width: double.infinity,
                      //   child: _buildActionButton(
                      //     icon: Icons.request_quote_outlined,
                      //     label: 'Submit Quotation',
                      //     color: ColorRes.blueColor,
                      //     onPressed: () {
                      //       Get.to(
                      //         () => ContractorInquiryQuotationScreen(
                      //           inquiry: inquiry,
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 16, color: ColorRes.primary),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            color: ColorRes.textSecondary,
            fontWeight: AppFontWeights.medium,
          ),
        ),
      ),
    ],
  );

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: AppFontSizes.medium,
      fontWeight: AppFontWeights.semiBold,
      color: ColorRes.textPrimary,
    ),
  );

  Widget _buildDetailItem(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: AppFontSizes.caption,
          color: ColorRes.textSecondary,
          fontWeight: AppFontWeights.medium,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          fontSize: AppFontSizes.small,
          color: ColorRes.textPrimary,
          fontWeight: AppFontWeights.semiBold,
        ),
      ),
    ],
  );

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'converted':
        color = ColorRes.green;
        break;
      case 'in_progress':
        color = ColorRes.orangeColor;
        break;
      case 'contacted':
        color = ColorRes.primary;
        break;
      case 'rejected':
        color = ColorRes.error;
        break;
      default:
        color = ColorRes.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status
            .split('_') // split by underscore
            .map(
              (word) => word[0].toUpperCase() + word.substring(1),
            ) // capitalize each word
            .join(' '), // join back with space
        style: TextStyle(
          fontSize: AppFontSizes.caption,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: ColorRes.white,
            fontSize: AppFontSizes.bodySmall,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
      ),
    );
  }
}

Widget _chip(String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: ColorRes.white,
        fontSize: AppFontSizes.caption,
        fontWeight: AppFontWeights.medium,
      ),
    ),
  );
}
