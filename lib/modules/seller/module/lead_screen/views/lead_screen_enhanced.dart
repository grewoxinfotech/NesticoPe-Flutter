// import 'dart:developer';
//
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/app/manager/property/property_pricemanager.dart';
// import 'package:nesticope_app/app/utils/formater/formater.dart';
// import 'package:nesticope_app/modules/add_property/controller/create_property_controller.dart';
// import 'package:nesticope_app/modules/reseller/view/lead/add_lead_screen.dart';
// import 'package:nesticope_app/modules/seller/module/lead_screen/model/lead_model.dart';
//
// import '../../../../../app/constants/app_font_sizes.dart';
// import '../../../../../app/manager/data_masker.dart';
//
// import '../../../../../widgets/bottom_sheet/lead_filter_bottomsheet.dart';
// import '../../../../../widgets/bottom_sheet/widgets/lead_filter_chips.dart';
// import '../../../../../widgets/messages/snack_bar.dart';
// import '../../../../common/lead_components/lead_card_widget.dart';
// import '../../../../dashboard/views/seller_dashboard_screen.dart';
// import '../../../../reseller/controller/dashborad_controller/dashboard_controller.dart';
// import '../../../../reseller/model/dashboard/dashboard_model.dart';
// import '../../../../reseller/view/lead_overview/lead_detail.dart';
// import '../controllers/lead_controller.dart';
// import '../controllers/lead_property_inquiry_controller.dart';
// import '../controllers/lead_property_negotiable_price_controller.dart';
// import '../controllers/lead_visit_controller.dart';
//
// class SellerLeadScreen extends StatefulWidget {
//   final bool isViewAll;
//   final String? propertyId;
//
//   const SellerLeadScreen({super.key, this.isViewAll = false, this.propertyId});
//
//   @override
//   State<SellerLeadScreen> createState() => _SellerLeadScreenState();
// }
//
// class _SellerLeadScreenState extends State<SellerLeadScreen> {
//   late final LeadController leadController;
//   final LeadPropertyInquiryController propertyInquiryController = Get.put(
//     LeadPropertyInquiryController(),
//     tag: "seller",
//   );
//   final LeadVisitController leadVisitController = Get.put(
//     LeadVisitController(),
//     tag: "seller",
//   );
//
//   final LeadPropertyNegotiablePriceController
//   leadPropertyNegotiablePriceController = Get.put(
//     LeadPropertyNegotiablePriceController(),
//     tag: "seller",
//   );
//   RxBool isLoadingLead = false.obs;
//
//   @override
//   void initState() {
//     leadController =
//         Get.isRegistered<LeadController>(tag: "seller")
//             ? Get.find<LeadController>(tag: "seller")
//             : Get.put(LeadController(), tag: "seller");
//
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _loadData();
//     });
//   }
//
//   Future<void> _loadData() async {
//     isLoadingLead.value = true;
//     leadController.items.clear();
//     leadController.leadPropertiesList.clear();
//     leadController.currentPropertyFilterId.value = widget.propertyId;
//     // Re-fetch fresh leads from API
//     await leadController.refreshList();
//     // if (widget.propertyId != null) {
//     //   _applyPropertyFilter(leadController);
//     // }
//     isLoadingLead.value = false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Get.lazyPut(() => LeadController(), tag: "seller");
//     // final leadController = Get.find<LeadController>(tag: "seller");
//
//     // /// FETCH + FILTER LOGIC
//     // WidgetsBinding.instance.addPostFrameCallback((_) async {
//     //   // 🔥 IMPORTANT: Remove all previous stored leads
//     //   leadController.items.clear();
//     //   leadController.leadPropertiesList.clear();
//     //
//     //   // Re-fetch fresh leads from API
//     //   await leadController.refreshList();
//     //
//     //   // If propertyId provided → filter freshly loaded list
//     //   if (widget.propertyId != null) {
//     //     _applyPropertyFilter(leadController);
//     //   }
//     // });
//
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false, // 🚫 disable Flutter auto logic
//
//         leading:
//             widget.isViewAll
//                 ? null
//                 : IconButton(
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () => Get.back(),
//                 ),
//
//         title: const Text(
//           'Leads',
//           style: TextStyle(fontWeight: AppFontWeights.bold),
//         ),
//         backgroundColor: ColorRes.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list, color: ColorRes.primary),
//             onPressed: () {
//               showFilterBottomSheet(
//                 context,
//                 leadController,
//                 propertyId:
//                     widget.propertyId != null ? widget.propertyId : null,
//               );
//             },
//           ),
//         ],
//       ),
//
//       body: Obx(() {
//         if (leadController.isLoading.value &&
//             leadController.items.isEmpty &&
//             isLoadingLead.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         final leads = leadController.items;
//
//         return Column(
//           children: [
//             buildSelectedFiltersChips(context, leadController, () async {
//               leadController.filters.clear();
//               await _loadData();
//             }),
//
//             Expanded(
//               child:
//               // leads.isEmpty
//               //     ? Center(
//               //       child: Text(
//               //         'No leads available.',
//               //         style: TextStyle(
//               //           fontSize: AppFontSizes.medium,
//               //           color: ColorRes.leadGreyColor[600],
//               //         ),
//               //       ),
//               //     )
//               //     :
//               NotificationListener<ScrollEndNotification>(
//                 onNotification: (notification) {
//                   final metrics = notification.metrics;
//                   if (metrics.pixels >= metrics.maxScrollExtent) {
//                     if (widget.propertyId != null &&
//                         widget.propertyId!.isNotEmpty) {
//                       leadController.loadMorePropertyLeads(widget.propertyId!);
//                     } else {
//                       leadController.loadMore();
//                     }
//                   }
//                   return true;
//                 },
//                 child: RefreshIndicator(
//                   // onRefresh: () async {
//                   //   // Same logic on pull-to-refresh
//                   //   leadController.items.clear();
//                   //   leadController.leadPropertiesList.clear();
//                   //
//                   //   await leadController.refreshList();
//                   //   if (widget.propertyId != null) {
//                   //     _applyPropertyFilter(leadController);
//                   //   }
//                   // },
//                   onRefresh: _loadData,
//                   child: ListView.separated(
//                     padding: EdgeInsets.all(getResponsivePadding(context)),
//                     itemCount: leads.length,
//                     separatorBuilder:
//                         (_, __) =>
//                             SizedBox(height: getResponsiveSpacing(context)),
//                     itemBuilder: (context, index) {
//                       final lead = leads[index];
//
//                       String? propertyPrice;
//                       if (lead.propertyId != null) {
//                         final matchingProperty = leadController
//                             .leadPropertiesList
//                             .firstWhereOrNull((p) => p.id == lead.propertyId);
//
//                         if (matchingProperty
//                                 ?.propertyDetails
//                                 ?.financialInfo
//                                 ?.price !=
//                             null) {
//                           propertyPrice =
//                               PropertyPriceManager(
//                                 listingType:
//                                     matchingProperty?.listingType ?? '',
//                                 financialInfo:
//                                     matchingProperty
//                                         ?.propertyDetails
//                                         ?.financialInfo,
//                               ).displayPrice;
//                         }
//                       }
//
//                       return GestureDetector(
//                         onTap: () async {
//                           // Avoid multiple taps
//                           if (isLoadingLead.value) return;
//
//                           // Show loader
//                           isLoadingLead.value = true;
//
//                           try {
//                             log('Fetching lead details for ${lead.id}');
//                             leadVisitController.getLeadId(lead.id);
//                             // Fetch full lead detail
//                             await leadController.getLeadDetailByID(
//                               lead.id ?? '',
//                             );
//
//                             final newLead =
//                                 leadController.newUpdatedLeadModel.value;
//                             if (newLead != null) {
//                               // Set inquiry id
//                               propertyInquiryController.setLeadInquiryId(
//                                 int.tryParse(newLead.inquiryId ?? '0') ?? 0,
//                               );
//                               log(
//                                 'Inquiry ID set: ${propertyInquiryController.items.map((e) => e.toMap())}',
//                               );
//                             }
//
//                             // Navigate only after all data loaded
//                             await Get.to(
//                               () => LeadDetailScreen(
//                                 lead: lead,
//                                 isFromLead: true,
//                                 leadPropertyInquiryController:
//                                     propertyInquiryController,
//                                 leadVisitController: leadVisitController,
//                                 leadPropertyNegotiablePriceController:
//                                     leadPropertyNegotiablePriceController,
//                               ),
//                             );
//                           } catch (e, st) {
//                             log('Error while opening lead: $e\n$st');
//                             NesticoPeSnackBar.showAwesomeSnackbar(
//                               title: 'Error',
//                               message: 'Failed to open lead details.',
//                               contentType: ContentType.failure,
//                             );
//                           } finally {
//                             // Hide loader
//                             isLoadingLead.value = false;
//                           }
//                         },
//
//                         // onTap: () {
//                         //   Get.to(
//                         //         () =>
//                         //         LeadDetailScreen(lead: lead, isFromLead: true),
//                         //   );
//                         //   log(
//                         //     'LeadDetailScreen initState called ${lead?.toJson()}',
//                         //   );
//                         //
//                         //   leadController.getLeadDetailByID(lead?.id ?? '');
//                         //
//                         //   if (leadController?.newUpdatedLeadModel.value !=
//                         //       null) {
//                         //     propertyInquiryController.setLeadInquiryId(
//                         //       int.tryParse(
//                         //             leadController
//                         //                     .newUpdatedLeadModel
//                         //                     .value
//                         //                     ?.inquiryId ??
//                         //                 '0',
//                         //           ) ??
//                         //           0,
//                         //     );
//                         //     log(
//                         //       'LeadDetailScreen initState called inquiry id ${propertyInquiryController.items.map((element) => element.toMap())}',
//                         //     );
//                         //     if (propertyInquiryController
//                         //             .selectedInquiry
//                         //             .value !=
//                         //         null) {
//                         //       log(
//                         //         'LeadDetailScreen initState called selected inquiry ${propertyInquiryController.selectedInquiry.value?.toMap()}',
//                         //       );
//                         //       leadVisitController.setLeadVisitId(
//                         //         propertyInquiryController
//                         //             .selectedInquiry
//                         //             .value
//                         //             ?.userId,
//                         //         propertyInquiryController
//                         //             .selectedInquiry
//                         //             .value
//                         //             ?.propertyId,
//                         //       );
//                         //       log(
//                         //         'LeadDetailScreen initState called visit id ${leadVisitController.items.map((element) => element.toMap())}',
//                         //       );
//                         //     }
//                         //   }
//                         //
//                         //
//                         // },
//                         child: buildLeadCard(
//                           context,
//                           lead,
//                           propertyPrice ?? '',
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
//
//   /// Filters leads based on propertyId (No controller modification)
//   void _applyPropertyFilter(LeadController controller) {
//     if (widget.propertyId == null) return;
//
//     final filtered =
//         controller.items
//             .where((lead) => lead.propertyId == widget.propertyId)
//             .toList();
//
//     controller.items.assignAll(filtered);
//   }
//
//   Widget buildSearchAndFilter(
//     BuildContext context,
//     DashboardController controller,
//   ) {
//     return Container(
//       margin: EdgeInsets.all(getResponsivePadding(context)),
//       padding: EdgeInsets.symmetric(horizontal: getResponsivePadding(context)),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
//       ),
//       child: TextField(
//         onChanged: controller.updateSearch,
//         style: TextStyle(fontSize: AppFontSizes.medium),
//         decoration: InputDecoration(
//           hintText: 'Search buyer leads...',
//           hintStyle: TextStyle(fontSize: AppFontSizes.medium),
//           prefixIcon: const Icon(Icons.search),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(vertical: 16),
//         ),
//       ),
//     );
//   }
//
//   // Widget buildSelectedFiltersChips(
//   //   BuildContext context,
//   //   LeadController controller,
//   // ) {
//   //   return Obx(() {
//   //     final filters = controller.filters;
//   //
//   //     if (filters.isEmpty) {
//   //       return const SizedBox.shrink();
//   //     }
//   //
//   //     return Container(
//   //       padding: EdgeInsets.symmetric(
//   //         horizontal: getResponsivePadding(context),
//   //         vertical: 8,
//   //       ),
//   //       child: Column(
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           // Header
//   //           Row(
//   //             children: [
//   //               Text(
//   //                 'Active Filters:',
//   //                 style: TextStyle(
//   //                   fontSize: AppFontSizes.small,
//   //                   fontWeight: AppFontWeights.semiBold,
//   //                   color: ColorRes.leadGreyColor[700],
//   //                 ),
//   //               ),
//   //               const Spacer(),
//   //               TextButton.icon(
//   //                 onPressed: () async {
//   //                   controller.filters.clear();
//   //                   await _loadData();
//   //                 },
//   //                 icon: const Icon(
//   //                   Icons.clear,
//   //                   size: 16,
//   //                   color: ColorRes.primary,
//   //                 ),
//   //                 label: Text(
//   //                   'Clear All',
//   //                   style: TextStyle(
//   //                     fontSize: AppFontSizes.small,
//   //                     color: ColorRes.primary,
//   //                     fontWeight: AppFontWeights.medium,
//   //                   ),
//   //                 ),
//   //                 style: TextButton.styleFrom(
//   //                   padding: EdgeInsets.zero,
//   //                   minimumSize: Size.zero,
//   //                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //
//   //           const SizedBox(height: 8),
//   //
//   //           // Filter Chips
//   //           SingleChildScrollView(
//   //             scrollDirection: Axis.horizontal,
//   //             child: Row(
//   //               children:
//   //                   filters.entries.map((entry) {
//   //                     final filterType = entry.key; // e.g. "status"
//   //                     final filterValue = entry.value; // e.g. "contacted"
//   //
//   //                     final chipColor =
//   //                         (filterType.toLowerCase() == 'stage')
//   //                             ? ColorRes.primary
//   //                             : (filterType.toLowerCase() == 'status')
//   //                             ? ColorRes.green
//   //                             : ColorRes.blueGrey;
//   //
//   //                     return Container(
//   //                       margin: const EdgeInsets.only(right: 8),
//   //                       decoration: BoxDecoration(
//   //                         color: ColorRes.success.withOpacity(0.08),
//   //                         borderRadius: BorderRadius.circular(10),
//   //                         border: Border.all(
//   //                           color: ColorRes.success.withOpacity(0.3),
//   //                           width: 1,
//   //                         ),
//   //                       ),
//   //                       child: Padding(
//   //                         padding: const EdgeInsets.symmetric(
//   //                           horizontal: 12,
//   //                           vertical: 6,
//   //                         ),
//   //                         child: Row(
//   //                           mainAxisSize: MainAxisSize.min,
//   //                           children: [
//   //                             // Filter Type Badge
//   //                             Container(
//   //                               padding: const EdgeInsets.symmetric(
//   //                                 horizontal: 6,
//   //                                 vertical: 2,
//   //                               ),
//   //                               decoration: BoxDecoration(
//   //                                 color: chipColor,
//   //                                 borderRadius: BorderRadius.circular(4),
//   //                               ),
//   //                               child: Text(
//   //                                 filterType.capitalizeFirst ?? '',
//   //                                 style: TextStyle(
//   //                                   fontSize: AppFontSizes.extraSmall,
//   //                                   color: ColorRes.white,
//   //                                   fontWeight: AppFontWeights.bold,
//   //                                 ),
//   //                               ),
//   //                             ),
//   //                             const SizedBox(width: 6),
//   //
//   //                             // Filter Value
//   //                             Text(
//   //                               filterValue
//   //                                       .replaceAll("_", " ")
//   //                                       .capitalizeFirst ??
//   //                                   '',
//   //                               style: TextStyle(
//   //                                 fontSize: AppFontSizes.small,
//   //                                 color: chipColor,
//   //                                 fontWeight: AppFontWeights.semiBold,
//   //                               ),
//   //                             ),
//   //                             const SizedBox(width: 6),
//   //
//   //                             // Remove Button
//   //                             InkWell(
//   //                               onTap: () async {
//   //                                 final updatedFilters =
//   //                                     Map<String, String>.from(
//   //                                       controller.filters,
//   //                                     );
//   //                                 updatedFilters.remove(filterType);
//   //                                 await controller.applyFilters(updatedFilters);
//   //                               },
//   //                               borderRadius: BorderRadius.circular(12),
//   //                               child: const Padding(
//   //                                 padding: EdgeInsets.all(2),
//   //                                 child: Icon(
//   //                                   Icons.close,
//   //                                   size: 14,
//   //                                   color: ColorRes.error,
//   //                                 ),
//   //                               ),
//   //                             ),
//   //                           ],
//   //                         ),
//   //                       ),
//   //                     );
//   //                   }).toList(),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     );
//   //   });
//   // }
//
//   Widget buildEmptyState(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.real_estate_agent,
//             size: 64,
//             color: ColorRes.leadGreyColor[400],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No buyer leads found',
//             style: TextStyle(
//               fontSize: AppFontSizes.large,
//               color: ColorRes.leadGreyColor[600],
//               fontWeight: AppFontWeights.medium,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               'Add your first property buyer to get started',
//               style: TextStyle(
//                 fontSize: AppFontSizes.medium,
//                 color: ColorRes.leadGreyColor[500],
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildLeadCard(
//     BuildContext context,
//     LeadItem lead,
//     String displayPrice,
//     // SellerDashboardScreen controller,
//   ) {
//     final leadController = Get.find<LeadController>(tag: "seller");
//     final isCompact = MediaQuery.of(context).size.width < 600;
//     final cardPadding = isCompact ? 12.0 : 16.0;
//
//     return Container(
//       padding: EdgeInsets.all(cardPadding),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: isCompact ? 18 : 20,
//                 backgroundColor: ColorRes.primary.withOpacity(0.2),
//                 child: Text(
//                   getInitials(lead.name!),
//                   style: TextStyle(
//                     color: ColorRes.primary,
//                     fontWeight: AppFontWeights.bold,
//                     fontSize:
//                         isCompact ? AppFontSizes.small : AppFontSizes.medium,
//                   ),
//                 ),
//               ),
//               SizedBox(width: isCompact ? 8 : 12),
//               Expanded(
//                 flex: 2,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       width: 180,
//                       child: Text(
//                         DataMasker.maskName(lead.name!),
//
//                         style: TextStyle(
//                           fontSize:
//                               isCompact
//                                   ? AppFontSizes.medium
//                                   : AppFontSizes.body,
//                           fontWeight: AppFontWeights.bold,
//                           color: ColorRes.textColor,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     SizedBox(height: 2),
//                     SizedBox(
//                       width: 180,
//                       child: Text(
//                         DataMasker.maskPhone(lead.phone!),
//                         style: TextStyle(
//                           fontSize:
//                               isCompact
//                                   ? AppFontSizes.extraSmall
//                                   : AppFontSizes.small,
//                           color: ColorRes.leadGreyColor[700],
//                           fontWeight: AppFontWeights.regular,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     if (lead.email != null && lead.email!.isNotEmpty) ...[
//                       SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               DataMasker.maskEmail(lead.email!),
//
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.extraSmall,
//                                 color: ColorRes.leadGreyColor[600],
//                                 fontWeight: AppFontWeights.regular,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     'Budget',
//                     style: TextStyle(
//                       fontSize: AppFontSizes.extraSmall,
//                       color: ColorRes.leadGreyColor[800],
//                       fontWeight: AppFontWeights.regular,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     '${displayPrice}',
//                     style: TextStyle(
//                       fontSize:
//                           isCompact ? AppFontSizes.medium : AppFontSizes.body,
//                       fontWeight: AppFontWeights.semiBold,
//                       color: ColorRes.success,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     formatTime(lead.createdAt!),
//                     style: TextStyle(
//                       fontSize: AppFontSizes.caption,
//                       color: ColorRes.leadGreyColor[600],
//                       fontWeight: AppFontWeights.regular,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: isCompact ? 8 : 12),
//           Divider(color: ColorRes.leadGreyColor, thickness: 0.5),
//           SizedBox(height: isCompact ? 8 : 12),
//
//           Row(
//             children: [
//               // Status Badge
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: isCompact ? 10 : 14,
//                   vertical: isCompact ? 6 : 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color:
//                       (lead.isFake ?? false)
//                           ? ColorRes.error.withOpacity(0.08)
//                           : getStatusColor(
//                             getLeadStatusFromString(lead.status!),
//                           ).withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color:
//                         (lead.isFake ?? false)
//                             ? ColorRes.error.shade300
//                             : getStatusColor(
//                               getLeadStatusFromString(lead.status!),
//                             ).withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: Text(
//                   (lead.isFake ?? false)
//                       ? "Fake"
//                       : getStatusText(getLeadStatusFromString(lead.status!)),
//                   style: TextStyle(
//                     fontSize:
//                         isCompact
//                             ? AppFontSizes.extraSmall
//                             : AppFontSizes.small,
//                     color:
//                         (lead.isFake ?? false)
//                             ? ColorRes.error
//                             : getStatusColor(
//                               getLeadStatusFromString(lead.status!),
//                             ),
//                     fontWeight: AppFontWeights.bold,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               SizedBox(width: 8),
//               // Stage Badge
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: isCompact ? 10 : 14,
//                   vertical: isCompact ? 6 : 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: getStageColor(
//                     getLeadStageFromString(lead.stage),
//                   ).withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color: getStageColor(
//                       getLeadStageFromString(lead.stage),
//                     ).withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: Text(
//                   getStageText(getLeadStageFromString(lead.stage)),
//                   style: TextStyle(
//                     fontSize:
//                         isCompact
//                             ? AppFontSizes.extraSmall
//                             : AppFontSizes.small,
//                     color: getStageColor(getLeadStageFromString(lead.stage)),
//                     fontWeight: AppFontWeights.bold,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               SizedBox(width: 8),
//               // Stage Badge
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: isCompact ? 10 : 14,
//                   vertical: isCompact ? 6 : 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: getSourceColor(
//                     getSourceFromString(lead.source ?? ''),
//                   ).withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color: getSourceColor(
//                       getSourceFromString(lead.source ?? ''),
//                     ).withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: Text(
//                   getSourceText(getSourceFromString(lead.source ?? '')),
//                   style: TextStyle(
//                     fontSize:
//                         isCompact
//                             ? AppFontSizes.extraSmall
//                             : AppFontSizes.small,
//                     color: getSourceColor(
//                       getSourceFromString(lead.source ?? ''),
//                     ),
//
//                     fontWeight: AppFontWeights.bold,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: isCompact ? 8 : 12),
//           if (lead.status != null &&
//               lead.stage != null &&
//               lead.status!.toLowerCase() == 'converted' &&
//               lead.stage!.toLowerCase() == 'sell') ...[
//             if (lead.commissionStatus != null &&
//                 lead.commissionStatus!.isNotEmpty) ...[
//               buildCommissionStatus(isPaid: true),
//             ] else ...[
//               buildCommissionStatus(isPaid: false),
//             ],
//           ],
//         ],
//       ),
//     );
//   }
//
//   // Keep all other functions (showLeadForm, _buildFormField, showLeadDetails, etc.) unchanged
//   Widget buildFormField({
//     required BuildContext context,
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//     int maxLines = 1,
//     bool isEnable = true,
//   }) {
//     return TextFormField(
//       minLines: 1,
//       enabled: isEnable,
//       controller: controller,
//       style: TextStyle(fontSize: AppFontSizes.small),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(fontSize: AppFontSizes.small),
//         prefixIcon: Icon(icon, size: 18),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             width: 1,
//             color: ColorRes.grey.withOpacity(0.3),
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(width: 1, color: ColorRes.primary),
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             width: 1,
//             color: ColorRes.grey.withOpacity(0.3),
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             width: 1,
//             color: ColorRes.grey.withOpacity(0.3),
//           ),
//         ),
//       ),
//       keyboardType: keyboardType,
//       validator: validator,
//       maxLines: maxLines,
//     );
//   }
//
//   void showLeadDetails(BuildContext context, Lead lead) {
//     showDialog(
//       context: context,
//
//       builder:
//           (context) => AlertDialog(
//             backgroundColor: ColorRes.white,
//             title: Text(
//               lead.name,
//               style: TextStyle(
//                 fontSize: AppFontSizes.large,
//                 fontWeight: AppFontWeights.bold,
//               ),
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildDetailRow(context, 'Location', lead.company),
//                 buildDetailRow(context, 'Email', lead.email),
//                 buildDetailRow(context, 'Phone', lead.phone),
//                 buildDetailRow(
//                   context,
//                   'Budget',
//                   '${Formatter.formatPrice(lead.estimatedValue)}',
//                 ),
//                 buildDetailRow(context, 'Status', getStatusText(lead.status)),
//                 buildDetailRow(context, 'Added', formatTime(lead.createdAt)),
//                 if (lead.notes.isNotEmpty)
//                   buildDetailRow(context, 'Notes', lead.notes),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text(
//                   'Close',
//                   style: TextStyle(fontSize: AppFontSizes.medium),
//                 ),
//               ),
//             ],
//           ),
//     );
//   }
//
//   Widget buildDetailRow(BuildContext context, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 70,
//             child: Text(
//               '$label:',
//               style: TextStyle(
//                 fontWeight: AppFontWeights.bold,
//                 fontSize: AppFontSizes.small,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(value, style: TextStyle(fontSize: AppFontSizes.small)),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/manager/property/property_pricemanager.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/modules/add_property/controller/create_property_controller.dart';
import 'package:nesticope_app/modules/reseller/view/lead/add_lead_screen.dart';
import 'package:nesticope_app/modules/seller/module/lead_screen/model/lead_model.dart';
import 'package:nesticope_app/utils/shimmer/common_screen/lead_screen/lead_list_screen_shimmer.dart';

import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/manager/data_masker.dart';

import '../../../../../widgets/bottom_sheet/lead_filter_bottomsheet.dart';
import '../../../../../widgets/bottom_sheet/widgets/lead_filter_chips.dart';
import '../../../../../widgets/messages/snack_bar.dart';
import '../../../../common/lead_components/lead_card_widget.dart';
import '../../../../dashboard/views/seller_dashboard_screen.dart';
import '../../../../reseller/controller/dashborad_controller/dashboard_controller.dart';
import '../../../../reseller/model/dashboard/dashboard_model.dart';
import '../../../../reseller/view/lead_overview/lead_detail.dart';
import '../controllers/lead_controller.dart';
import '../controllers/lead_property_inquiry_controller.dart';
import '../controllers/lead_property_negotiable_price_controller.dart';
import '../controllers/lead_visit_controller.dart';

// class SellerLeadScreen extends StatefulWidget {
//   final bool isViewAll;
//   final String? propertyId;
//
//   const SellerLeadScreen({super.key, this.isViewAll = false, this.propertyId});
//
//   @override
//   State<SellerLeadScreen> createState() => _SellerLeadScreenState();
// }
//
// class _SellerLeadScreenState extends State<SellerLeadScreen> {
//   late final LeadController leadController;
//   final LeadPropertyInquiryController propertyInquiryController = Get.put(
//     LeadPropertyInquiryController(),
//     tag: "seller",
//   );
//   final LeadVisitController leadVisitController = Get.put(
//     LeadVisitController(),
//     tag: "seller",
//   );
//
//   final LeadPropertyNegotiablePriceController
//   leadPropertyNegotiablePriceController = Get.put(
//     LeadPropertyNegotiablePriceController(),
//     tag: "seller",
//   );
//   final RxBool isOpeningLead = false.obs;
//
//   @override
//   void initState() {
//     super.initState();
//
//     leadController =
//         Get.isRegistered<LeadController>(tag: "seller")
//             ? Get.find<LeadController>(tag: "seller")
//             : Get.put(LeadController(), tag: "seller");
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _loadData();
//     });
//   }
//
//   /// ✅ FIXED: Proper data loading
//   Future<void> _loadData() async {
//     // Clear previous data
//     leadController.items.clear();
//     leadController.leadPropertiesList.clear();
//
//     // Set property filter
//     leadController.currentPropertyFilterId.value = widget.propertyId;
//
//     // ✅ CRITICAL FIX: Only call loadInitial() - don't call refreshList()
//     await leadController.loadInitial();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leading:
//             widget.isViewAll
//                 ? null
//                 : IconButton(
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () => Get.back(),
//                 ),
//         title: const Text(
//           'Leads',
//           style: TextStyle(fontWeight: AppFontWeights.bold),
//         ),
//         backgroundColor: ColorRes.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list, color: ColorRes.primary),
//             onPressed: () {
//               showFilterBottomSheet(
//                 context,
//                 leadController,
//                 propertyId:
//                     widget.propertyId != null ? widget.propertyId : null,
//               );
//             },
//           ),
//         ],
//       ),
//       body: Obx(() {
//         final leads = leadController.items;
//         final isLoading = leadController.isLoading.value;
//         final isPaging = leadController.isPaging.value;
//         final isRefreshing = leadController.isRefreshing.value;
//
//         // 🔹 INITIAL LOAD (no data yet) - show centered loader
//         if (isLoading && leads.isEmpty && !isRefreshing) {
//           return LeadListScreenShimmer();
//         }
//
//         return Column(
//           children: [
//             buildSelectedFiltersChips(context, leadController, () async {
//               leadController.filters.clear();
//               await _loadData();
//             }),
//             Expanded(
//               child:
//                   leads.isEmpty
//                       ? buildEmptyState(context)
//                       : NotificationListener<ScrollEndNotification>(
//                         onNotification: (notification) {
//                           final metrics = notification.metrics;
//                           // ✅ Only trigger if not already loading/paging
//                           if (metrics.pixels >= metrics.maxScrollExtent - 100 &&
//                               !isLoading &&
//                               !isPaging &&
//                               leadController.hasMore.value) {
//                             if (widget.propertyId != null &&
//                                 widget.propertyId!.isNotEmpty) {
//                               leadController.loadMorePropertyLeads(
//                                 widget.propertyId!,
//                               );
//                             } else {
//                               leadController.loadMore();
//                             }
//                           }
//                           return false;
//                         },
//                         child: RefreshIndicator(
//                           onRefresh: () async {
//                             if (!isRefreshing && !isLoading) {
//                               await leadController.refreshList();
//                             }
//                           },
//                           child: ListView.separated(
//                             physics: const AlwaysScrollableScrollPhysics(),
//                             padding: EdgeInsets.all(
//                               getResponsivePadding(context),
//                             ),
//                             itemCount: leads.length + 1, // 👈 space for footer
//                             separatorBuilder:
//                                 (_, __) => SizedBox(
//                                   height: getResponsiveSpacing(context),
//                                 ),
//                             itemBuilder: (context, index) {
//                               // 🔹 BOTTOM LOADER (pagination)
//                               if (index == leads.length) {
//                                 // Show loader only when paging
//                                 if (isPaging && leadController.hasMore.value) {
//                                   return const Padding(
//                                     padding: EdgeInsets.symmetric(vertical: 16),
//                                     child: Center(
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                       ),
//                                     ),
//                                   );
//                                 }
//                                 // Show "No more data" if we've reached the end
//                                 if (!leadController.hasMore.value &&
//                                     leads.isNotEmpty) {
//                                   return Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 16,
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         'No more leads',
//                                         style: TextStyle(
//                                           color: ColorRes.leadGreyColor[400],
//                                           fontSize: AppFontSizes.small,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }
//                                 return const SizedBox.shrink();
//                               }
//
//                               final lead = leads[index];
//
//                               String? propertyPrice;
//                               if (lead.propertyId != null) {
//                                 final matchingProperty = leadController
//                                     .leadPropertiesList
//                                     .firstWhereOrNull(
//                                       (p) => p.id == lead.propertyId,
//                                     );
//
//                                 if (matchingProperty
//                                         ?.propertyDetails
//                                         ?.financialInfo
//                                         ?.price !=
//                                     null) {
//                                   propertyPrice =
//                                       PropertyPriceManager(
//                                         listingType:
//                                             matchingProperty?.listingType ?? '',
//                                         financialInfo:
//                                             matchingProperty
//                                                 ?.propertyDetails
//                                                 ?.financialInfo,
//                                       ).displayPrice;
//                                 }
//                               }
//
//                               return GestureDetector(
//                                 onTap: () => _openLead(lead),
//                                 child: buildLeadCard(
//                                   context,
//                                   lead,
//                                   propertyPrice ?? '',
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
//
//   Future<void> _openLead(LeadItem lead) async {
//     if (isOpeningLead.value) return;
//
//     isOpeningLead.value = true;
//     try {
//       log('Fetching lead details for ${lead.id}');
//       leadVisitController.getLeadId(lead.id);
//
//       // Fetch full lead detail
//       await leadController.getLeadDetailByID(lead.id ?? '');
//
//       final newLead = leadController.newUpdatedLeadModel.value;
//       if (newLead != null) {
//         // Set inquiry id
//         propertyInquiryController.setLeadInquiryId(
//           int.tryParse(newLead.inquiryId ?? '0') ?? 0,
//         );
//         log(
//           'Inquiry ID set: ${propertyInquiryController.items.map((e) => e.toMap())}',
//         );
//       }
//
//       // Navigate only after all data loaded
//       await Get.to(
//         () => LeadDetailScreen(
//           lead: lead,
//           isFromLead: true,
//           leadPropertyInquiryController: propertyInquiryController,
//           leadVisitController: leadVisitController,
//           leadPropertyNegotiablePriceController:
//               leadPropertyNegotiablePriceController,
//         ),
//       );
//     } catch (e, st) {
//       log('Error while opening lead: $e\n$st');
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: 'Error',
//         message: 'Failed to open lead details.',
//         contentType: ContentType.failure,
//       );
//     } finally {
//       isOpeningLead.value = false;
//     }
//   }
//
//   Widget buildEmptyState(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.real_estate_agent,
//             size: 64,
//             color: ColorRes.leadGreyColor[400],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No buyer leads found',
//             style: TextStyle(
//               fontSize: AppFontSizes.large,
//               color: ColorRes.leadGreyColor[600],
//               fontWeight: AppFontWeights.medium,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               'Add your first property buyer to get started',
//               style: TextStyle(
//                 fontSize: AppFontSizes.medium,
//                 color: ColorRes.leadGreyColor[500],
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildLeadCard(
//     BuildContext context,
//     LeadItem lead,
//     String displayPrice,
//   ) {
//     final isCompact = MediaQuery.of(context).size.width < 600;
//     final cardPadding = isCompact ? 12.0 : 16.0;
//
//     return Container(
//       padding: EdgeInsets.all(cardPadding),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: isCompact ? 18 : 20,
//                 backgroundColor: ColorRes.primary.withOpacity(0.2),
//                 child: Text(
//                   getInitials(lead.name!),
//                   style: TextStyle(
//                     color: ColorRes.primary,
//                     fontWeight: AppFontWeights.bold,
//                     fontSize:
//                         isCompact ? AppFontSizes.small : AppFontSizes.medium,
//                   ),
//                 ),
//               ),
//               SizedBox(width: isCompact ? 8 : 12),
//               Expanded(
//                 flex: 2,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       width: 180,
//                       child: Text(
//                         DataMasker.maskName(lead.name!),
//                         style: TextStyle(
//                           fontSize:
//                               isCompact
//                                   ? AppFontSizes.medium
//                                   : AppFontSizes.body,
//                           fontWeight: AppFontWeights.bold,
//                           color: ColorRes.textColor,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     SizedBox(height: 2),
//                     SizedBox(
//                       width: 180,
//                       child: Text(
//                         DataMasker.maskPhone(lead.phone!),
//                         style: TextStyle(
//                           fontSize:
//                               isCompact
//                                   ? AppFontSizes.extraSmall
//                                   : AppFontSizes.small,
//                           color: ColorRes.leadGreyColor[700],
//                           fontWeight: AppFontWeights.regular,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     if (lead.email != null && lead.email!.isNotEmpty) ...[
//                       SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               DataMasker.maskEmail(lead.email!),
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.extraSmall,
//                                 color: ColorRes.leadGreyColor[600],
//                                 fontWeight: AppFontWeights.regular,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     'Budget',
//                     style: TextStyle(
//                       fontSize: AppFontSizes.extraSmall,
//                       color: ColorRes.leadGreyColor[800],
//                       fontWeight: AppFontWeights.regular,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     displayPrice,
//                     style: TextStyle(
//                       fontSize:
//                           isCompact ? AppFontSizes.medium : AppFontSizes.body,
//                       fontWeight: AppFontWeights.semiBold,
//                       color: ColorRes.success,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     formatTime(lead.createdAt!),
//                     style: TextStyle(
//                       fontSize: AppFontSizes.caption,
//                       color: ColorRes.leadGreyColor[600],
//                       fontWeight: AppFontWeights.regular,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: isCompact ? 8 : 12),
//           Divider(color: ColorRes.leadGreyColor, thickness: 0.5),
//           SizedBox(height: isCompact ? 8 : 12),
//           Row(
//             children: [
//               // Status Badge
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: isCompact ? 10 : 14,
//                   vertical: isCompact ? 6 : 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color:
//                       (lead.isFake ?? false)
//                           ? ColorRes.error.withOpacity(0.08)
//                           : getStatusColor(
//                             getLeadStatusFromString(lead.status!),
//                           ).withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color:
//                         (lead.isFake ?? false)
//                             ? ColorRes.error.shade300
//                             : getStatusColor(
//                               getLeadStatusFromString(lead.status!),
//                             ).withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: Text(
//                   (lead.isFake ?? false)
//                       ? "Fake"
//                       : getStatusText(getLeadStatusFromString(lead.status!)),
//                   style: TextStyle(
//                     fontSize:
//                         isCompact
//                             ? AppFontSizes.extraSmall
//                             : AppFontSizes.small,
//                     color:
//                         (lead.isFake ?? false)
//                             ? ColorRes.error
//                             : getStatusColor(
//                               getLeadStatusFromString(lead.status!),
//                             ),
//                     fontWeight: AppFontWeights.bold,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               SizedBox(width: 8),
//               // Stage Badge
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: isCompact ? 10 : 14,
//                   vertical: isCompact ? 6 : 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: getStageColor(
//                     getLeadStageFromString(lead.stage),
//                   ).withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color: getStageColor(
//                       getLeadStageFromString(lead.stage),
//                     ).withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: Text(
//                   getStageText(getLeadStageFromString(lead.stage)),
//                   style: TextStyle(
//                     fontSize:
//                         isCompact
//                             ? AppFontSizes.extraSmall
//                             : AppFontSizes.small,
//                     color: getStageColor(getLeadStageFromString(lead.stage)),
//                     fontWeight: AppFontWeights.bold,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               SizedBox(width: 8),
//               // Source Badge
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: isCompact ? 10 : 14,
//                   vertical: isCompact ? 6 : 8,
//                 ),
//                 decoration: BoxDecoration(
//                   color: getSourceColor(
//                     getSourceFromString(lead.source ?? ''),
//                   ).withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color: getSourceColor(
//                       getSourceFromString(lead.source ?? ''),
//                     ).withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: Text(
//                   getSourceText(getSourceFromString(lead.source ?? '')),
//                   style: TextStyle(
//                     fontSize:
//                         isCompact
//                             ? AppFontSizes.extraSmall
//                             : AppFontSizes.small,
//                     color: getSourceColor(
//                       getSourceFromString(lead.source ?? ''),
//                     ),
//                     fontWeight: AppFontWeights.bold,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: isCompact ? 8 : 12),
//           if (lead.status != null &&
//               lead.stage != null &&
//               lead.status!.toLowerCase() == 'converted' &&
//               lead.stage!.toLowerCase() == 'sell') ...[
//             if (lead.commissionStatus != null &&
//                 lead.commissionStatus!.isNotEmpty) ...[
//               buildCommissionStatus(isPaid: true),
//             ] else ...[
//               buildCommissionStatus(isPaid: false),
//             ],
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget buildFormField({
//     required BuildContext context,
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//     int maxLines = 1,
//     bool isEnable = true,
//   }) {
//     return TextFormField(
//       minLines: 1,
//       enabled: isEnable,
//       controller: controller,
//       style: TextStyle(fontSize: AppFontSizes.small),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(fontSize: AppFontSizes.small),
//         prefixIcon: Icon(icon, size: 18),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             width: 1,
//             color: ColorRes.grey.withOpacity(0.3),
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(width: 1, color: ColorRes.primary),
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             width: 1,
//             color: ColorRes.grey.withOpacity(0.3),
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(
//             width: 1,
//             color: ColorRes.grey.withOpacity(0.3),
//           ),
//         ),
//       ),
//       keyboardType: keyboardType,
//       validator: validator,
//       maxLines: maxLines,
//     );
//   }
//
//   void showLeadDetails(BuildContext context, Lead lead) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             backgroundColor: ColorRes.white,
//             title: Text(
//               lead.name,
//               style: TextStyle(
//                 fontSize: AppFontSizes.large,
//                 fontWeight: AppFontWeights.bold,
//               ),
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildDetailRow(context, 'Location', lead.company),
//                 buildDetailRow(context, 'Email', lead.email),
//                 buildDetailRow(context, 'Phone', lead.phone),
//                 buildDetailRow(
//                   context,
//                   'Budget',
//                   '${Formatter.formatPrice(lead.estimatedValue)}',
//                 ),
//                 buildDetailRow(context, 'Status', getStatusText(lead.status)),
//                 buildDetailRow(context, 'Added', formatTime(lead.createdAt)),
//                 if (lead.notes.isNotEmpty)
//                   buildDetailRow(context, 'Notes', lead.notes),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text(
//                   'Close',
//                   style: TextStyle(fontSize: AppFontSizes.medium),
//                 ),
//               ),
//             ],
//           ),
//     );
//   }
//
//   Widget buildDetailRow(BuildContext context, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 70,
//             child: Text(
//               '$label:',
//               style: TextStyle(
//                 fontWeight: AppFontWeights.bold,
//                 fontSize: AppFontSizes.small,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(value, style: TextStyle(fontSize: AppFontSizes.small)),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SellerLeadScreen extends StatefulWidget {
  final bool isViewAll;
  final String? propertyId;

  const SellerLeadScreen({super.key, this.isViewAll = false, this.propertyId});

  @override
  State<SellerLeadScreen> createState() => _SellerLeadScreenState();
}

class _SellerLeadScreenState extends State<SellerLeadScreen> {
  // 🔐 UNIQUE TAG PER SCREEN INSTANCE
  late final String _tag;

  // 🔒 SCREEN-SCOPED CONTROLLERS
  late final LeadController leadController;
  late final LeadPropertyInquiryController propertyInquiryController;
  late final LeadVisitController leadVisitController;
  late final LeadPropertyNegotiablePriceController
  leadPropertyNegotiablePriceController;

  final RxBool isOpeningLead = false.obs;

  @override
  void initState() {
    super.initState();

    // ✅ UNIQUE TAG (NO COLLISION EVER)
    _tag = 'seller_lead_screen_${UniqueKey()}';

    leadController = Get.put(LeadController(), tag: _tag);

    propertyInquiryController = Get.put(
      LeadPropertyInquiryController(),
      tag: _tag,
    );

    leadVisitController = Get.put(LeadVisitController(), tag: _tag);

    leadPropertyNegotiablePriceController = Get.put(
      LeadPropertyNegotiablePriceController(),
      tag: _tag,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  /// ✅ CLEAN INITIAL LOAD (NO SHARED STATE)
  Future<void> _loadData() async {
    leadController.items.clear();
    leadController.leadPropertiesList.clear();

    leadController.currentPropertyFilterId.value = widget.propertyId;

    await leadController.loadInitial();
  }

  @override
  void dispose() {
    // 🧹 HARD CLEANUP (CRITICAL)
    Get.delete<LeadController>(tag: _tag);
    Get.delete<LeadPropertyInquiryController>(tag: _tag);
    Get.delete<LeadVisitController>(tag: _tag);
    Get.delete<LeadPropertyNegotiablePriceController>(tag: _tag);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorRes.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading:
            widget.isViewAll
                ? null
                : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
        title: const Text(
          'Leads',
          style: TextStyle(fontWeight: AppFontWeights.bold),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: ColorRes.primary),
            /* onPressed: () {
              showFilterBottomSheet(
                context,
                leadController,
                propertyId: widget.propertyId,
              );
            },*/
            onPressed: () {
              Get.to(
                () => LeadBuildFilterScreen(
                  controller: leadController,
                  propertyId: widget.propertyId,
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        final leads = leadController.items;
        final isLoading = leadController.isLoading.value;
        final isPaging = leadController.isPaging.value;
        final isRefreshing = leadController.isRefreshing.value;

        // 🔹 INITIAL LOADING
        if (isLoading && leads.isEmpty && !isRefreshing) {
          return const LeadListScreenShimmer();
        }

        return Column(
          children: [
            buildSelectedFiltersChips(context, leadController, () async {
              leadController.filters.clear();
              await _loadData();
            }),
            Expanded(
              child:
                  leads.isEmpty
                      ? buildEmptyState(context)
                      : NotificationListener<ScrollEndNotification>(
                        onNotification: (notification) {
                          final metrics = notification.metrics;

                          if (metrics.pixels >= metrics.maxScrollExtent - 100 &&
                              !isLoading &&
                              !isPaging &&
                              leadController.hasMore.value) {
                            if (widget.propertyId != null &&
                                widget.propertyId!.isNotEmpty) {
                              leadController.loadMorePropertyLeads(
                                widget.propertyId!,
                              );
                            } else {
                              leadController.loadMore();
                            }
                          }
                          return false;
                        },
                        child: RefreshIndicator(
                          onRefresh: () async {
                            if (!isRefreshing && !isLoading) {
                              await leadController.refreshList();
                            }
                          },
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.all(
                              getResponsivePadding(context),
                            ),
                            itemCount: leads.length + 1,
                            separatorBuilder:
                                (_, __) => SizedBox(
                                  height: getResponsiveSpacing(context),
                                ),
                            itemBuilder: (context, index) {
                              // 🔹 PAGINATION FOOTER
                              if (index == leads.length) {
                                if (isPaging && leadController.hasMore.value) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                }

                                if (!leadController.hasMore.value &&
                                    leads.isNotEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'No more leads to display',
                                        style: TextStyle(
                                          fontSize: AppFontSizes.small,
                                          color: ColorRes.leadGreyColor[600],
                                          fontWeight: AppFontWeights.medium,
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                return const SizedBox.shrink();
                              }

                              final lead = leads[index];

                              String propertyPrice = '';
                              if (lead.propertyId != null) {
                                final property = leadController
                                    .leadPropertiesList
                                    .firstWhereOrNull(
                                      (p) => p.id == lead.propertyId,
                                    );

                                if (property
                                        ?.propertyDetails
                                        ?.financialInfo
                                        ?.price !=
                                    null) {
                                  propertyPrice =
                                      PropertyPriceManager(
                                        listingType:
                                            property?.listingType ?? '',
                                        financialInfo:
                                            property
                                                ?.propertyDetails
                                                ?.financialInfo,
                                      ).displayPrice;
                                }
                              }

                              return GestureDetector(
                                onTap: () => _openLead(lead),
                                child: buildLeadCard(
                                  context,
                                  lead,
                                  propertyPrice,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _openLead(LeadItem lead) async {
    if (isOpeningLead.value) return;

    isOpeningLead.value = true;
    try {
      leadVisitController.getLeadId(lead.id);

      await leadController.getLeadDetailByID(lead.id ?? '');

      final newLead = leadController.newUpdatedLeadModel.value;
      if (newLead != null) {
        propertyInquiryController.setLeadInquiryId(
          int.tryParse(newLead.inquiryId ?? '0') ?? 0,
        );
      }

      await Get.to(
        () => LeadDetailScreen(
          lead: lead,
          isFromLead: true,
          leadPropertyInquiryController: propertyInquiryController,
          leadVisitController: leadVisitController,
          leadPropertyNegotiablePriceController:
              leadPropertyNegotiablePriceController,
        ),
      );
    } catch (e, st) {
      log('Error opening lead: $e\n$st');
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to open lead details.',
        contentType: ContentType.failure,
      );
    } finally {
      isOpeningLead.value = false;
    }
  }

  Widget buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.real_estate_agent,
            size: 64,
            color: ColorRes.leadGreyColor[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No buyer leads found',
            style: TextStyle(
              fontSize: AppFontSizes.large,
              color: ColorRes.leadGreyColor[600],
              fontWeight: AppFontWeights.medium,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Add your first property buyer to get started',
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                color: ColorRes.leadGreyColor[500],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLeadCard(
    BuildContext context,
    LeadItem lead,
    String displayPrice,
  ) {
    final isCompact = MediaQuery.of(context).size.width < 600;
    final cardPadding = isCompact ? 12.0 : 16.0;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: ColorRes.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: isCompact ? 18 : 20,
                backgroundColor: ColorRes.primary.withOpacity(0.2),
                child: Text(
                  getInitials(lead.name!),
                  style: TextStyle(
                    color: ColorRes.primary,
                    fontWeight: AppFontWeights.bold,
                    fontSize:
                        isCompact ? AppFontSizes.small : AppFontSizes.medium,
                  ),
                ),
              ),
              SizedBox(width: isCompact ? 8 : 12),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 180,
                      child: Text(
                        DataMasker.maskName(lead.name!),
                        style: TextStyle(
                          fontSize:
                              isCompact
                                  ? AppFontSizes.medium
                                  : AppFontSizes.body,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 2),
                    SizedBox(
                      width: 180,
                      child: Text(
                        DataMasker.maskPhone(lead.phone!),
                        style: TextStyle(
                          fontSize:
                              isCompact
                                  ? AppFontSizes.caption
                                  : AppFontSizes.small,

                          color: ColorRes.leadGreyColor[700],
                          fontWeight: AppFontWeights.medium,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (lead.email != null && lead.email!.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              DataMasker.maskEmail(lead.email!),
                              style: TextStyle(
                                fontSize: AppFontSizes.caption,
                                color: ColorRes.leadGreyColor[600],
                                fontWeight: AppFontWeights.medium,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Budget',
                    style: TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      color: ColorRes.leadGreyColor[800],
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    displayPrice,
                    style: TextStyle(
                      fontSize:
                          isCompact ? AppFontSizes.medium : AppFontSizes.body,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.success,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    formatTime(lead.createdAt!),
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      color: ColorRes.leadGreyColor[600],
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: isCompact ? 8 : 12),
          Divider(color: ColorRes.leadGreyColor.shade300, thickness: 0.5),

          SizedBox(height: isCompact ? 8 : 12),
          Row(
            children: [
              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 10 : 14,
                  vertical: isCompact ? 6 : 8,
                ),
                decoration: BoxDecoration(
                  color:
                      (lead.isFake ?? false)
                          ? ColorRes.error.withOpacity(0.08)
                          : getStatusColor(
                            getLeadStatusFromString(lead.status!),
                          ).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),

                  border: Border.all(
                    color:
                        (lead.isFake ?? false)
                            ? ColorRes.error.shade300
                            : getStatusColor(
                              getLeadStatusFromString(lead.status!),
                            ).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  (lead.isFake ?? false)
                      ? "Fake"
                      : getStatusText(getLeadStatusFromString(lead.status!)),
                  style: TextStyle(
                    fontSize:
                        isCompact
                            ? AppFontSizes.extraSmall
                            : AppFontSizes.caption,
                    color:
                        (lead.isFake ?? false)
                            ? ColorRes.error
                            : getStatusColor(
                              getLeadStatusFromString(lead.status!),
                            ),
                    fontWeight: AppFontWeights.semiBold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              // Stage Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 10 : 14,
                  vertical: isCompact ? 6 : 8,
                ),
                decoration: BoxDecoration(
                  color: getStageColor(
                    getLeadStageFromString(lead.stage),
                  ).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: getStageColor(
                      getLeadStageFromString(lead.stage),
                    ).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  getStageText(getLeadStageFromString(lead.stage)),
                  style: TextStyle(
                    fontSize:
                        isCompact
                            ? AppFontSizes.extraSmall
                            : AppFontSizes.caption,
                    color: getStageColor(getLeadStageFromString(lead.stage)),
                    fontWeight: AppFontWeights.semiBold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              // Source Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 10 : 14,
                  vertical: isCompact ? 6 : 8,
                ),
                decoration: BoxDecoration(
                  color: getSourceColor(
                    getSourceFromString(lead.source ?? ''),
                  ).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: getSourceColor(
                      getSourceFromString(lead.source ?? ''),
                    ).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  getSourceText(getSourceFromString(lead.source ?? '')),
                  style: TextStyle(
                    fontSize:
                        isCompact
                            ? AppFontSizes.extraSmall
                            : AppFontSizes.caption,
                    color: getSourceColor(
                      getSourceFromString(lead.source ?? ''),
                    ),
                    fontWeight: AppFontWeights.semiBold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: isCompact ? 8 : 12),
          if (lead.status != null &&
              lead.stage != null &&
              lead.status!.toLowerCase() == 'converted' &&
              lead.stage!.toLowerCase() == 'sell') ...[
            if (lead.commissionStatus != null &&
                lead.commissionStatus!.isNotEmpty) ...[
              buildCommissionStatus(isPaid: true),
            ] else ...[
              buildCommissionStatus(isPaid: false),
            ],
          ],
        ],
      ),
    );
  }

  Widget buildFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool isEnable = true,
  }) {
    return TextFormField(
      minLines: 1,
      enabled: isEnable,
      controller: controller,
      style: TextStyle(fontSize: AppFontSizes.small),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: AppFontSizes.small),
        prefixIcon: Icon(icon, size: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1,
            color: ColorRes.grey.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(width: 1, color: ColorRes.primary),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1,
            color: ColorRes.grey.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1,
            color: ColorRes.grey.withOpacity(0.3),
          ),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
    );
  }

  void showLeadDetails(BuildContext context, Lead lead) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: ColorRes.white,
            title: Text(
              lead.name,
              style: TextStyle(
                fontSize: AppFontSizes.large,
                fontWeight: AppFontWeights.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDetailRow(context, 'Location', lead.company),
                buildDetailRow(context, 'Email', lead.email),
                buildDetailRow(context, 'Phone', lead.phone),
                buildDetailRow(
                  context,
                  'Budget',
                  '${Formatter.formatPrice(lead.estimatedValue)}',
                ),
                buildDetailRow(context, 'Status', getStatusText(lead.status)),
                buildDetailRow(context, 'Added', formatTime(lead.createdAt)),
                if (lead.notes.isNotEmpty)
                  buildDetailRow(context, 'Notes', lead.notes),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: TextStyle(fontSize: AppFontSizes.medium),
                ),
              ),
            ],
          ),
    );
  }

  Widget buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: AppFontWeights.bold,
                fontSize: AppFontSizes.small,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: AppFontSizes.small)),
          ),
        ],
      ),
    );
  }
}

void showDeleteConfirmation(
  BuildContext context,
  LeadItem lead,
  DashboardController controller,
) {
  final leadController = Get.find<LeadController>(tag: "seller");
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: ColorRes.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Buyer Lead',
          style: TextStyle(
            fontSize: AppFontSizes.large,
            fontWeight: AppFontWeights.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${lead.name}?',
          style: TextStyle(
            fontSize: AppFontSizes.medium,
            color: ColorRes.leadGreyColor[700],
          ),
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.leadGreyColor[600],
              ),
            ),
          ),

          // Delete Button
          TextButton(
            onPressed: () {
              leadController.deleteLead(lead.id ?? '');
              Navigator.of(context).pop();
            },
            child: Text(
              'Delete',
              style: TextStyle(
                fontSize: AppFontSizes.medium,
                fontWeight: AppFontWeights.bold,
                color: ColorRes.error,
              ),
            ),
          ),
        ],
      );
    },
  );
}

double getResponsivePadding(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) return 12.0;
  if (width < 900) return 16.0;
  return 20.0;
}

double getResponsiveSpacing(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width < 600 ? 12.0 : 16.0;
}

double getResponsiveFontSize(
  BuildContext context,
  double regular,
  double compact,
) {
  return MediaQuery.of(context).size.width < 600 ? compact : regular;
}

// Status color methods
Color getStatusColor(LeadStatus status) {
  switch (status) {
    case LeadStatus.new_: // 'New'
      return ColorRes.blueColor;
    case LeadStatus.contacted:
      return ColorRes.orangeColor;
    case LeadStatus.qualified:
      return ColorRes.purpleColor;
    case LeadStatus.negotiation:
      return ColorRes.leadIndigoColor;
    case LeadStatus.lost:
      return ColorRes.error;
    case LeadStatus.fake:
      return ColorRes.error;
    case LeadStatus.convert:
      return ColorRes.leadTealColor;
    default:
      return ColorRes.leadGreyColor;
  }
}

LeadStatus getLeadStatusFromString(String status) {
  switch (status.toLowerCase()) {
    case 'new':
      return LeadStatus.new_;
    case 'contacted':
      return LeadStatus.contacted;
    case 'qualified':
      return LeadStatus.qualified;
    case 'negotiation':
      return LeadStatus.negotiation;
    case 'lost':
      return LeadStatus.lost;
    case 'converted':
      return LeadStatus.convert;
    case 'fake':
      return LeadStatus.fake;
    default:
      return LeadStatus.new_;
  }
}

Color getSourceColor(SourceType source) {
  switch (source) {
    case SourceType.app:
      return ColorRes.leadTealColor;
    case SourceType.website:
      return ColorRes.blueColor;
    case SourceType.referral:
      return ColorRes.purpleColor;
    case SourceType.socialMedia:
      return ColorRes.orangeColor;
    case SourceType.direct:
      return ColorRes.leadIndigoColor;
    case SourceType.other:
      return ColorRes.leadGreyColor;
    default:
      return ColorRes.leadGreyColor;
  }
}

SourceType getSourceFromString(String source) {
  switch (source.toLowerCase()) {
    case 'app':
      return SourceType.app;
    case 'website':
      return SourceType.website;
    case 'referral':
      return SourceType.referral;
    case 'social_media':
      return SourceType.socialMedia;
    case 'direct':
      return SourceType.direct;
    case 'other':
      return SourceType.other;
    default:
      return SourceType.other;
  }
}

String getSourceText(SourceType source) {
  switch (source) {
    case SourceType.app:
      return 'App';
    case SourceType.website:
      return 'Website';
    case SourceType.referral:
      return 'Referral';
    case SourceType.socialMedia:
      return 'Social Media';
    case SourceType.direct:
      return 'Direct';
    case SourceType.other:
      return 'Other';
    default:
      return 'Unknown';
  }
}

String getStatusText(LeadStatus status) {
  switch (status) {
    case LeadStatus.new_:
      return 'New';
    case LeadStatus.contacted:
      return 'Contacted';
    case LeadStatus.qualified:
      return 'Qualified';
    case LeadStatus.negotiation:
      return 'Negotiating';
    case LeadStatus.lost:
      return 'Lost';
    case LeadStatus.convert:
      return 'Converted';
    case LeadStatus.fake:
      return "Fake";
    default:
      return 'All';
  }
}

Color getStageColor(LeadStage stage) {
  switch (stage) {
    case LeadStage.newLead: // 'New Lead'
      return ColorRes.blueColor;
    case LeadStage.contacted:
      return ColorRes.orangeColor;
    case LeadStage.interested:
      return ColorRes.purpleColor;
    case LeadStage.siteVisit:
      return ColorRes.leadIndigoColor;
    case LeadStage.sell:
      return ColorRes.success;
    default:
      return ColorRes.leadGreyColor;
  }
}

LeadStage getLeadStageFromString(String? stage) {
  switch (stage?.toLowerCase()) {
    case 'newlead':
    case 'new_lead':
    case 'new lead':
      return LeadStage.newLead;
    case 'contacted':
      return LeadStage.contacted;
    case 'interested':
      return LeadStage.interested;
    case 'sitevisit':
    case 'site_visit':
    case 'site visit':
      return LeadStage.siteVisit;
    case 'sell':
      return LeadStage.sell;
    default:
      return LeadStage.sell;
    // fallback
  }
}

String getStageText(LeadStage stage) {
  switch (stage) {
    case LeadStage.newLead:
      return 'New Lead';
    case LeadStage.contacted:
      return 'Contacted';
    case LeadStage.interested:
      return 'Interested';
    case LeadStage.siteVisit:
      return 'Site Visit';
    case LeadStage.sell:
      return 'Sell';
    default:
      return 'All';
  }
}

String formatTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 0) {
    return '${difference.inDays}d ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h ago';
  } else {
    return '${difference.inMinutes}m ago';
  }
}

Widget buildActionButton({
  required IconData icon,
  required Color color,
  required VoidCallback onPressed,
  required String tooltip,
  required bool isCompact,
}) {
  return Tooltip(
    message: tooltip,
    child: InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Material(
          color: ColorRes.transparentColor,
          child: Icon(icon, size: isCompact ? 15 : 14, color: color),
        ),
      ),
    ),
  );
}

String getInitials(String name) {
  if (name.trim().isEmpty) return ''; // no initials at all
  // Split by whitespace and take first char of first two non-empty parts
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts.first[0].toUpperCase();
  } else {
    final firstInitial = parts[0].isNotEmpty ? parts[0][0] : '';
    final secondInitial = parts[1].isNotEmpty ? parts[1][0] : '';
    return (firstInitial + secondInitial).toUpperCase();
  }
}
