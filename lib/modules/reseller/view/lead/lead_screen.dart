// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:housing_flutter_app/app/constants/color_res.dart';
// // // import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// // // import 'package:housing_flutter_app/app/manager/property/property_pricemanager.dart';
// // // import 'package:housing_flutter_app/modules/common/lead_components/lead_components.dart';
// // // import 'package:housing_flutter_app/modules/common/lead_components/lead_filter_helper.dart';
// // // import 'package:housing_flutter_app/modules/reseller/view/lead/add_lead_screen.dart';
// // // import 'package:housing_flutter_app/modules/seller/module/lead_screen/model/lead_model.dart';
// // // import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_controller.dart';
// // // import 'package:housing_flutter_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
// // // import 'package:housing_flutter_app/modules/reseller/view/lead_overview/lead_detail.dart';
// // //
// // // import '../../../../data/network/property/models/property_model.dart';
// // //
// // // class ResellerLeadScreen extends StatefulWidget {
// // //   final bool isViewAll;
// // //
// // //   const ResellerLeadScreen({super.key, this.isViewAll = false});
// // //
// // //   @override
// // //   State<ResellerLeadScreen> createState() => _ResellerLeadScreenState();
// // // }
// // //
// // // class _ResellerLeadScreenState extends State<ResellerLeadScreen> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     Get.lazyPut(() => LeadController(), tag: "reseller");
// // //     final leadController = Get.find<LeadController>(tag: "reseller");
// // //     final controller = Get.find<DashboardController>();
// // //
// // //     return Scaffold(
// // //       backgroundColor: ColorRes.white,
// // //       appBar: AppBar(
// // //         leading:
// // //             (widget.isViewAll)
// // //                 ? IconButton(
// // //                   onPressed: () {
// // //                     Navigator.of(context).pop();
// // //                   },
// // //                   icon: Icon(Icons.arrow_back),
// // //                 )
// // //                 : null,
// // //         title: Text(
// // //           'Property Buyer Leads',
// // //           style: TextStyle(fontWeight: AppFontWeights.bold),
// // //         ),
// // //         automaticallyImplyLeading: (widget.isViewAll),
// // //         backgroundColor: ColorRes.white,
// // //         elevation: 0,
// // //         actions: [
// // //           IconButton(
// // //             icon: const Icon(Icons.add),
// // //             onPressed: () {
// // //               FocusScope.of(context).unfocus();
// // //               leadController.resetForm();
// // //               Get.to(
// // //                 () => AddLeadScreen(),
// // //                 binding: BindingsBuilder(() {
// // //                   Get.lazyPut(() => LeadController(), tag: "reseller");
// // //                 }),
// // //               );
// // //             },
// // //           ),
// // //           IconButton(
// // //             icon: const Icon(Icons.filter_list, color: ColorRes.primary),
// // //             onPressed: () {
// // //               LeadFilterBottomSheet.show(
// // //                 context: context,
// // //                 selectedFilters: controller.selectedLeadFilters,
// // //                 onApplyFilters: () {
// // //                   // Convert filters to API format and apply
// // //                   final filterMap = LeadFilterHelper.convertFiltersToAPIFormat(
// // //                     controller.selectedLeadFilters.toList(),
// // //                   );
// // //                   leadController.applyFilters(filterMap);
// // //                 },
// // //               );
// // //             },
// // //           ),
// // //         ],
// // //       ),
// // //
// // //       body: Obx(() {
// // //         // Loading state
// // //         if (leadController.isLoading.value && leadController.items.isEmpty) {
// // //           return const Center(child: CircularProgressIndicator());
// // //         }
// // //
// // //         final filteredLeads = leadController.items.value;
// // //
// // //         return Column(
// // //           children: [
// // //             // Search bar
// // //             // LeadSearchBar(
// // //             //   onSearchChanged: controller.updateSearch,
// // //             // ),
// // //
// // //             // Filter chips
// // //             Obx(
// // //               () => LeadFilterChips(
// // //                 selectedFilters: controller.selectedLeadFilters.toList(),
// // //                 onRemoveFilter: (filter) {
// // //                   controller.removeLeadFilter(filter);
// // //                   // Re-apply remaining filters to API
// // //                   final filterMap = LeadFilterHelper.convertFiltersToAPIFormat(
// // //                     controller.selectedLeadFilters.toList(),
// // //                   );
// // //                   leadController.applyFilters(filterMap);
// // //                 },
// // //                 onClearAll: () {
// // //                   controller.clearLeadFilters();
// // //                   // Clear filters in API
// // //                   leadController.applyFilters({});
// // //                 },
// // //               ),
// // //             ),
// // //
// // //             // Main content
// // //             Expanded(
// // //               child:
// // //                   filteredLeads.isEmpty
// // //                       ? Center(
// // //                         child: Text(
// // //                           'No leads available. Tap + to add a new lead.',
// // //                           style: TextStyle(
// // //                             fontSize: AppFontSizes.medium,
// // //                             color: ColorRes.leadGreyColor[600],
// // //                             fontWeight: AppFontWeights.medium,
// // //                           ),
// // //                         ),
// // //                       )
// // //                       : RefreshIndicator(
// // //                         onRefresh: leadController.refreshList,
// // //                         child: ListView.separated(
// // //                           padding: EdgeInsets.all(
// // //                             getResponsivePadding(context),
// // //                           ),
// // //                           itemCount: filteredLeads.length,
// // //                           separatorBuilder:
// // //                               (context, index) => SizedBox(
// // //                                 height: getResponsiveSpacing(context),
// // //                               ),
// // //                           itemBuilder: (context, index) {
// // //                             LeadItem lead = filteredLeads[index];
// // //
// // //                             // Find matching property price
// // //                             String? propertyPrice;
// // //                             if (lead.propertyId != null) {
// // //                               final matchingProperty = leadController
// // //                                   .leadPropertiesList
// // //                                   .firstWhereOrNull(
// // //                                     (p) => p.id == lead.propertyId,
// // //                                   );
// // //                               if (matchingProperty != null &&
// // //                                   matchingProperty
// // //                                           .propertyDetails
// // //                                           ?.financialInfo
// // //                                           ?.price !=
// // //                                       null) {
// // //                                 propertyPrice =
// // //                                     PropertyPriceManager(
// // //                                       listingType:
// // //                                           matchingProperty.listingType ?? '',
// // //                                       financialInfo:
// // //                                           matchingProperty
// // //                                               .propertyDetails
// // //                                               ?.financialInfo,
// // //                                     ).displayPrice;
// // //                               }
// // //                             }
// // //
// // //                             return LeadCardWidget(
// // //                               lead: lead,
// // //                               isCompact:
// // //                                   MediaQuery.of(context).size.width < 600,
// // //                               showDataMasking: true, // Reseller needs masking
// // //                               propertyPrice: propertyPrice,
// // //                               leadPropertiesList:
// // //                                   leadController.leadPropertiesList,
// // //                               onTap: () {
// // //                                 Get.to(
// // //                                   () => LeadDetailScreen(
// // //                                     lead: lead,
// // //                                     isFromLead: true,
// // //                                   ),
// // //                                 );
// // //                               },
// // //                               // onEdit: () {
// // //                               //   leadController.resetForm();
// // //                               //   Get.to(
// // //                               //     () => AddLeadScreen(
// // //                               //       lead: lead,
// // //                               //       isEditMode: true,
// // //                               //     ),
// // //                               //   );
// // //                               // },
// // //                               // onDelete: () => _showDeleteConfirmation(
// // //                               //   context,
// // //                               //   lead,
// // //                               //   leadController,
// // //                               // ),
// // //                             );
// // //                           },
// // //                         ),
// // //                       ),
// // //             ),
// // //           ],
// // //         );
// // //       }),
// // //     );
// // //   }
// // //
// // //   void _showDeleteConfirmation(
// // //     BuildContext context,
// // //     LeadItem lead,
// // //     LeadController leadController,
// // //   ) {
// // //     showDialog(
// // //       context: context,
// // //       builder: (BuildContext context) {
// // //         return AlertDialog(
// // //           backgroundColor: ColorRes.white,
// // //           shape: RoundedRectangleBorder(
// // //             borderRadius: BorderRadius.circular(16),
// // //           ),
// // //           title: Text(
// // //             'Delete Buyer Lead',
// // //             style: TextStyle(
// // //               fontSize: AppFontSizes.large,
// // //               fontWeight: AppFontWeights.bold,
// // //             ),
// // //           ),
// // //           content: Text(
// // //             'Are you sure you want to delete ${lead.name}?',
// // //             style: TextStyle(
// // //               fontSize: AppFontSizes.medium,
// // //               color: ColorRes.leadGreyColor[700],
// // //             ),
// // //           ),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () => Navigator.of(context).pop(),
// // //               child: Text(
// // //                 'Cancel',
// // //                 style: TextStyle(
// // //                   fontSize: AppFontSizes.medium,
// // //                   fontWeight: AppFontWeights.medium,
// // //                   color: ColorRes.leadGreyColor[600],
// // //                 ),
// // //               ),
// // //             ),
// // //             TextButton(
// // //               onPressed: () {
// // //                 leadController.deleteLead(lead.id ?? '');
// // //                 Navigator.of(context).pop();
// // //               },
// // //               child: Text(
// // //                 'Delete',
// // //                 style: TextStyle(
// // //                   fontSize: AppFontSizes.medium,
// // //                   fontWeight: AppFontWeights.bold,
// // //                   color: ColorRes.error,
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         );
// // //       },
// // //     );
// // //   }
// // // }
// //
// // import 'dart:developer';
// //
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// // import 'package:housing_flutter_app/app/constants/color_res.dart';
// // import 'package:housing_flutter_app/modules/common/lead_components/lead_components.dart';
// // // Assuming this is where showFilterBottomSheet and buildSelectedFiltersChips are defined
// // // If they are in a different file, please import that file.
// // import 'package:housing_flutter_app/modules/common/lead_components/lead_filter_helper.dart';
// // import 'package:housing_flutter_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
// // import 'package:housing_flutter_app/modules/reseller/view/lead/add_lead_screen.dart';
// // import 'package:housing_flutter_app/modules/reseller/view/lead_overview/lead_detail.dart';
// // import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_controller.dart';
// // import 'package:housing_flutter_app/modules/seller/module/lead_screen/model/lead_model.dart';
// //
// // // Additional controllers needed for the logic copied from BuilderLeads
// // import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_property_inquiry_controller.dart';
// // import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_visit_controller.dart';
// //
// // import '../../../../widgets/bottom_sheet/widgets/lead_filter_chips.dart';
// // import '../../../../widgets/messages/snack_bar.dart';
// //
// // class ResellerLeadScreen extends StatefulWidget {
// //   final bool isViewAll;
// //   final String? propertyId;
// //
// //   const ResellerLeadScreen({
// //     super.key,
// //     this.isViewAll = false,
// //     this.propertyId,
// //   });
// //
// //   @override
// //   State<ResellerLeadScreen> createState() => _ResellerLeadScreenState();
// // }
// //
// // class _ResellerLeadScreenState extends State<ResellerLeadScreen> {
// //   late final LeadController leadController;
// //   final DashboardController dashboardController =
// //       Get.find<DashboardController>();
// //
// //   // Controllers required for detail fetching logic
// //   final LeadPropertyInquiryController propertyInquiryController = Get.put(
// //     LeadPropertyInquiryController(),
// //   );
// //
// //   final LeadVisitController leadVisitController = Get.put(
// //     LeadVisitController(),
// //   );
// //
// //   final RxBool isLoadingLead = false.obs;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Initialize or Find controller with "reseller" tag
// //     leadController =
// //         Get.isRegistered<LeadController>(tag: "reseller")
// //             ? Get.find<LeadController>(tag: "reseller")
// //             : Get.put(LeadController(), tag: "reseller");
// //
// //     WidgetsBinding.instance.addPostFrameCallback((_) async {
// //       await _loadData();
// //     });
// //   }
// //
// //   Future<void> _loadData() async {
// //     isLoadingLead.value = true;
// //     leadController.items.clear();
// //     leadController.leadPropertiesList.clear();
// //
// //     // Set filter if property specific
// //     leadController.currentPropertyFilterId.value = widget.propertyId;
// //
// //     // Apply existing dashboard filters if any
// //     if (dashboardController.selectedLeadFilters.isNotEmpty) {
// //       final filterMap = LeadFilterHelper.convertFiltersToAPIFormat(
// //         dashboardController.selectedLeadFilters.toList(),
// //       );
// //       // We set internal filters but refreshList calls the API
// //       leadController.filters.addAll(filterMap);
// //     }
// //
// //     await leadController.refreshList();
// //     isLoadingLead.value = false;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: ColorRes.white,
// //       appBar: AppBar(
// //         leading:
// //             !widget.isViewAll
// //                 ? IconButton(
// //                   onPressed: () => Navigator.pop(context),
// //                   icon: const Icon(Icons.arrow_back),
// //                 )
// //                 : null,
// //         title: const Text(
// //           'Property Buyer Leads',
// //           style: TextStyle(fontWeight: AppFontWeights.bold),
// //         ),
// //         backgroundColor: ColorRes.white,
// //         automaticallyImplyLeading: widget.isViewAll,
// //         elevation: 0,
// //         actions: [
// //           // Preserve the Add Lead functionality for Reseller
// //           IconButton(
// //             icon: const Icon(Icons.add),
// //             onPressed: () {
// //               FocusScope.of(context).unfocus();
// //               leadController.resetForm();
// //               Get.to(
// //                 () => AddLeadScreen(),
// //                 binding: BindingsBuilder(() {
// //                   Get.lazyPut(() => LeadController(), tag: "reseller");
// //                 }),
// //               );
// //             },
// //           ),
// //           IconButton(
// //             icon: const Icon(Icons.filter_list, color: ColorRes.primary),
// //             onPressed: () {
// //               // Using the common filter bottom sheet structure
// //               // Adapt showFilterBottomSheet args based on your LeadFilterHelper definition
// //               /* If you have a generic showFilterBottomSheet, use that.
// //                  Otherwise, use the Reseller specific logic but strictly inside the callback.
// //               */
// //               LeadFilterBottomSheet.show(
// //                 context: context,
// //                 selectedFilters: dashboardController.selectedLeadFilters,
// //                 onApplyFilters: () async {
// //                   final filterMap = LeadFilterHelper.convertFiltersToAPIFormat(
// //                     dashboardController.selectedLeadFilters.toList(),
// //                   );
// //                   leadController.applyFilters(filterMap);
// //                   await _loadData(); // Reload with new filters
// //                 },
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //
// //       body: Obx(() {
// //         // Initial Full Page Loading
// //         if (leadController.isLoading.value &&
// //             leadController.items.isEmpty &&
// //             isLoadingLead.value) {
// //           return const Center(child: CircularProgressIndicator());
// //         }
// //
// //         final leads = leadController.items;
// //
// //         return Column(
// //           children: [
// //             // Filter Chips Section
// //             buildSelectedFiltersChips(context, leadController, () async {
// //               leadController.filters.clear();
// //               dashboardController
// //                   .clearLeadFilters(); // Sync with dashboard controller
// //               await _loadData();
// //             }),
// //
// //             Expanded(
// //               child:
// //                   leads.isEmpty && !leadController.isLoading.value
// //                       ? buildEmptyState(context)
// //                       : NotificationListener<ScrollEndNotification>(
// //                         onNotification: (notification) {
// //                           final metrics = notification.metrics;
// //                           // Pagination Logic
// //                           if (metrics.pixels >= metrics.maxScrollExtent) {
// //                             if (widget.propertyId != null &&
// //                                 widget.propertyId!.isNotEmpty) {
// //                               leadController.loadMorePropertyLeads(
// //                                 widget.propertyId!,
// //                               );
// //                             } else {
// //                               leadController.loadMore();
// //                             }
// //                           }
// //                           return true;
// //                         },
// //                         child: RefreshIndicator(
// //                           onRefresh: _loadData,
// //                           child: ListView.separated(
// //                             padding: EdgeInsets.all(
// //                               getResponsivePadding(context),
// //                             ),
// //                             itemCount: leads.length,
// //                             separatorBuilder:
// //                                 (_, __) => SizedBox(
// //                                   height: getResponsiveSpacing(context),
// //                                 ),
// //                             itemBuilder: (context, index) {
// //                               final lead = leads[index];
// //
// //                               return LeadCardWidget(
// //                                 lead: lead,
// //                                 isCompact:
// //                                     MediaQuery.of(context).size.width < 600,
// //                                 showDataMasking:
// //                                     true, // Resellers usually have data masking
// //                                 onTap: () async {
// //                                   if (isLoadingLead.value) return;
// //
// //                                   isLoadingLead.value = true;
// //                                   try {
// //                                     // 1. Set Visit ID
// //                                     leadVisitController.getLeadId(lead.id);
// //
// //                                     // 2. Fetch Full Details from API before navigating
// //                                     await leadController.getLeadDetailByID(
// //                                       lead.id ?? '',
// //                                     );
// //
// //                                     final newLead =
// //                                         leadController
// //                                             .newUpdatedLeadModel
// //                                             .value;
// //
// //                                     // 3. Set Inquiry ID if available
// //                                     if (newLead != null) {
// //                                       propertyInquiryController
// //                                           .setLeadInquiryId(
// //                                             int.tryParse(
// //                                                   newLead.inquiryId ?? '0',
// //                                                 ) ??
// //                                                 0,
// //                                           );
// //                                     }
// //
// //                                     // 4. Navigate
// //                                     await Get.to(
// //                                       () => LeadDetailScreen(
// //                                         lead: lead,
// //                                         isFromLead: true,
// //                                       ),
// //                                     );
// //                                   } catch (e, st) {
// //                                     log('❌ Reseller lead open error: $e\n$st');
// //
// //                                     NesticoPeSnackBar.showAwesomeSnackbar(
// //                                       title: 'Error',
// //                                       message: 'Failed to pick images: $e',
// //                                       contentType: ContentType.failure,
// //                                     );
// //                                   } finally {
// //                                     isLoadingLead.value = false;
// //                                   }
// //                                 },
// //                               );
// //                             },
// //                           ),
// //                         ),
// //                       ),
// //             ),
// //           ],
// //         );
// //       }),
// //     );
// //   }
// //
// //   Widget buildEmptyState(BuildContext context) {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Icon(
// //             Icons.real_estate_agent,
// //             size: 64,
// //             color: ColorRes.leadGreyColor[400],
// //           ),
// //           const SizedBox(height: 16),
// //           Text(
// //             'No leads found',
// //             style: TextStyle(
// //               fontSize: AppFontSizes.large,
// //               color: ColorRes.leadGreyColor[600],
// //               fontWeight: AppFontWeights.medium,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             'Tap + to add a new lead',
// //             style: TextStyle(
// //               fontSize: AppFontSizes.small,
// //               color: ColorRes.leadGreyColor[400],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
//
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
//
// import 'package:housing_flutter_app/modules/common/lead_components/lead_components.dart';
// import 'package:housing_flutter_app/modules/common/lead_components/lead_filter_helper.dart';
//
// import 'package:housing_flutter_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
// import 'package:housing_flutter_app/modules/reseller/view/lead/add_lead_screen.dart';
// import 'package:housing_flutter_app/modules/reseller/view/lead_overview/lead_detail.dart';
//
// import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_controller.dart';
// import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_property_inquiry_controller.dart';
// import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_visit_controller.dart';
// import 'package:housing_flutter_app/modules/seller/module/lead_screen/model/lead_model.dart';
//
// import '../../../../widgets/bottom_sheet/widgets/lead_filter_chips.dart';
// import '../../../../widgets/messages/snack_bar.dart';
//
// /// ------------------------------------------------------------
// /// COMMON LEAD SCREEN (PROPERTY / PROJECT / BUILDER)
// /// ------------------------------------------------------------
// class CommonLeadScreen extends StatefulWidget {
//   final bool isViewAll;
//   final String? entityId; // propertyId / projectId
//   final String title;
//   final String controllerTag;
//   final bool showDataMasking;
//
//   /// Pagination handler
//   final Future<void> Function(LeadController controller, String? entityId)
//   onLoadMore;
//
//   const CommonLeadScreen({
//     super.key,
//     required this.title,
//     required this.controllerTag,
//     required this.onLoadMore,
//     this.isViewAll = false,
//     this.entityId,
//     this.showDataMasking = false,
//   });
//
//   @override
//   State<CommonLeadScreen> createState() => _CommonLeadScreenState();
// }
//
// class _CommonLeadScreenState extends State<CommonLeadScreen> {
//   late final LeadController leadController;
//   final DashboardController dashboardController = Get.put(
//     DashboardController(),
//   );
//
//   final LeadPropertyInquiryController propertyInquiryController = Get.put(
//     LeadPropertyInquiryController(),
//   );
//
//   final LeadVisitController leadVisitController = Get.put(
//     LeadVisitController(),
//   );
//
//   final RxBool isOpeningLead = false.obs;
//
//   @override
//   void initState() {
//     super.initState();
//
//     leadController =
//         Get.isRegistered<LeadController>(tag: widget.controllerTag)
//             ? Get.find<LeadController>(tag: widget.controllerTag)
//             : Get.put(LeadController(), tag: widget.controllerTag);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
//   }
//
//   Future<void> _loadData() async {
//     leadController.items.clear();
//     leadController.filters.clear();
//
//     /// Apply entity filter (property / project)
//     ///
//     leadController.currentPropertyFilterId.value = widget.entityId;
//
//     log(
//       "Controller Lead Project ${leadController.currentPropertyFilterId.value}   ==================${widget.entityId}",
//     );
//
//     /// Apply dashboard filters
//     if (dashboardController.selectedLeadFilters.isNotEmpty) {
//       final filterMap = LeadFilterHelper.convertFiltersToAPIFormat(
//         dashboardController.selectedLeadFilters.toList(),
//       );
//       leadController.filters.addAll(filterMap);
//     }
//
//     await leadController.refreshList();
//     await leadController.loadInitial();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//       appBar: AppBar(
//         backgroundColor: ColorRes.white,
//         elevation: 0,
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
//         title: Text(
//           widget.title,
//           style: const TextStyle(fontWeight: AppFontWeights.bold),
//         ),
//         actions: [
//           /// Add Lead
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               FocusScope.of(context).unfocus();
//               leadController.resetForm();
//               Get.to(
//                 () => AddLeadScreen(),
//                 binding: BindingsBuilder(() {
//                   Get.lazyPut(
//                     () => LeadController(),
//                     tag: widget.controllerTag,
//                   );
//                 }),
//               );
//             },
//           ),
//
//           /// Filter
//           IconButton(
//             icon: const Icon(Icons.filter_list, color: ColorRes.primary),
//             onPressed: () {
//               LeadFilterBottomSheet.show(
//                 context: context,
//                 selectedFilters: dashboardController.selectedLeadFilters,
//                 onApplyFilters: () async {
//                   await _loadData();
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       // body: Obx(() {
//       //   final leads = leadController.items;
//       //
//       //   if (leadController.isLoading.value && leads.isEmpty) {
//       //     return const Center(child: CircularProgressIndicator());
//       //   }
//       //
//       //   return Column(
//       //     children: [
//       //       /// Selected Filter Chips
//       //       buildSelectedFiltersChips(context, leadController, () async {
//       //         leadController.filters.clear();
//       //         dashboardController.clearLeadFilters();
//       //         await _loadData();
//       //       }),
//       //
//       //       Expanded(
//       //         child:
//       //             leads.isEmpty
//       //                 ? _buildEmptyState()
//       //                 : NotificationListener<ScrollEndNotification>(
//       //                   onNotification: (notification) {
//       //                     if (notification.metrics.pixels >=
//       //                         notification.metrics.maxScrollExtent) {
//       //                       widget.onLoadMore(leadController, widget.entityId);
//       //                     }
//       //                     return true;
//       //                   },
//       //                   child: RefreshIndicator(
//       //                     onRefresh: _loadData,
//       //                     child: ListView.separated(
//       //                       padding: EdgeInsets.all(
//       //                         getResponsivePadding(context),
//       //                       ),
//       //                       itemCount: leads.length,
//       //                       separatorBuilder:
//       //                           (_, __) => SizedBox(
//       //                             height: getResponsiveSpacing(context),
//       //                           ),
//       //                       itemBuilder: (_, index) {
//       //                         final lead = leads[index];
//       //                         return LeadCardWidget(
//       //                           lead: lead,
//       //                           showDataMasking: widget.showDataMasking,
//       //                           isCompact:
//       //                               MediaQuery.of(context).size.width < 600,
//       //                           onTap: () => _openLead(lead),
//       //                         );
//       //                       },
//       //                     ),
//       //                   ),
//       //                 ),
//       //       ),
//       //     ],
//       //   );
//       // }),
//       body: Obx(() {
//         final leads = leadController.items;
//         final isLoading = leadController.isLoading.value;
//         final isRefreshing = leadController.isRefreshing.value;
//
//         // 🔹 INITIAL LOAD (no data yet)
//         if (isLoading && leads.isEmpty) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         return Column(
//           children: [
//             /// Selected Filter Chips
//             buildSelectedFiltersChips(context, leadController, () async {
//               leadController.filters.clear();
//               dashboardController.clearLeadFilters();
//               await _loadData();
//             }),
//
//             Expanded(
//               child:
//                   leads.isEmpty
//                       ? _buildEmptyState()
//                       : NotificationListener<ScrollEndNotification>(
//                         onNotification: (notification) {
//                           if (notification.metrics.pixels >=
//                                   notification.metrics.maxScrollExtent &&
//                               !isLoading) {
//                             widget.onLoadMore(leadController, widget.entityId);
//                           }
//                           return false;
//                         },
//                         child: RefreshIndicator(
//                           onRefresh: () async {
//                             if (!isRefreshing) {
//                               await _loadData();
//                             }
//                           },
//                           child: ListView.separated(
//                             physics: const AlwaysScrollableScrollPhysics(),
//                             padding: EdgeInsets.all(
//                               getResponsivePadding(context),
//                             ),
//                             itemCount:
//                                 leads.length + 1, // 👈 space for footer loader
//                             separatorBuilder:
//                                 (_, __) => SizedBox(
//                                   height: getResponsiveSpacing(context),
//                                 ),
//                             itemBuilder: (_, index) {
//                               // 🔹 BOTTOM LOADER (pagination)
//                               if (index == leads.length) {
//                                 return isLoading
//                                     ? const Padding(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: 16,
//                                       ),
//                                       child: Center(
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                         ),
//                                       ),
//                                     )
//                                     : const SizedBox.shrink();
//                               }
//
//                               final lead = leads[index];
//                               return LeadCardWidget(
//                                 lead: lead,
//                                 showDataMasking: widget.showDataMasking,
//                                 isCompact:
//                                     MediaQuery.of(context).size.width < 600,
//                                 onTap: () => _openLead(lead),
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
//       leadVisitController.getLeadId(lead.id);
//       await leadController.getLeadDetailByID(lead.id ?? '');
//
//       final updatedLead = leadController.newUpdatedLeadModel.value;
//
//       if (updatedLead != null) {
//         propertyInquiryController.setLeadInquiryId(
//           int.tryParse(updatedLead.inquiryId ?? '0') ?? 0,
//         );
//       }
//
//       await Get.to(() => LeadDetailScreen(lead: lead, isFromLead: true));
//     } catch (e, st) {
//       log('❌ Lead open error: $e\n$st');
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: 'Error',
//         message: 'Unable to open lead',
//         contentType: ContentType.failure,
//       );
//     } finally {
//       isOpeningLead.value = false;
//     }
//   }
//
//   Widget _buildEmptyState() {
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
//             'No leads found',
//             style: TextStyle(
//               fontSize: AppFontSizes.large,
//               color: ColorRes.leadGreyColor[600],
//               fontWeight: AppFontWeights.medium,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Tap + to add a new lead',
//             style: TextStyle(
//               fontSize: AppFontSizes.small,
//               color: ColorRes.leadGreyColor[400],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import 'package:housing_flutter_app/modules/common/lead_components/lead_components.dart';
import 'package:housing_flutter_app/modules/common/lead_components/lead_filter_helper.dart';

import 'package:housing_flutter_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
import 'package:housing_flutter_app/modules/reseller/view/lead/add_lead_screen.dart';
import 'package:housing_flutter_app/modules/reseller/view/lead_overview/lead_detail.dart';

import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_controller.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_property_inquiry_controller.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_visit_controller.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/model/lead_model.dart';
import 'package:housing_flutter_app/utils/shimmer/common_screen/lead_screen/lead_list_screen_shimmer.dart';

import '../../../../widgets/bottom_sheet/widgets/lead_filter_chips.dart';
import '../../../../widgets/messages/snack_bar.dart';

/// ------------------------------------------------------------
/// COMMON LEAD SCREEN (PROPERTY / PROJECT / BUILDER)
/// ------------------------------------------------------------
class CommonLeadScreen extends StatefulWidget {
  final bool isViewAll;
  final String? entityId; // propertyId / projectId
  final String title;
  final String controllerTag;
  final bool showDataMasking;
  final Widget Function(LeadItem lead, VoidCallback onTap)? leadCardBuilder;

  /// Pagination handler
  final Future<void> Function(LeadController controller, String? entityId)
  onLoadMore;

  const CommonLeadScreen({
    super.key,
    required this.title,
    required this.controllerTag,
    required this.onLoadMore,
    this.isViewAll = false,
    this.entityId,
    this.showDataMasking = false,
    this.leadCardBuilder,
  });

  @override
  State<CommonLeadScreen> createState() => _CommonLeadScreenState();
}

class _CommonLeadScreenState extends State<CommonLeadScreen> {
  late final LeadController leadController;
  final DashboardController dashboardController = Get.put(
    DashboardController(),
  );

  final LeadPropertyInquiryController propertyInquiryController = Get.put(
    LeadPropertyInquiryController(),
  );

  final LeadVisitController leadVisitController = Get.put(
    LeadVisitController(),
  );

  final RxBool isOpeningLead = false.obs;

  @override
  void initState() {
    super.initState();

    leadController =
        Get.isRegistered<LeadController>(tag: widget.controllerTag)
            ? Get.find<LeadController>(tag: widget.controllerTag)
            : Get.put(LeadController(), tag: widget.controllerTag);

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  /// ✅ FIXED: Proper data loading without double-calling
  Future<void> _loadData() async {
    // Clear previous data
    leadController.items.clear();
    leadController.filters.clear();

    /// Apply entity filter (property / project)
    leadController.currentPropertyFilterId.value = widget.entityId;

    log(
      "Controller Lead Project ${leadController.currentPropertyFilterId.value} ==================${widget.entityId}",
    );

    /// Apply dashboard filters
    if (dashboardController.selectedLeadFilters.isNotEmpty) {
      final filterMap = LeadFilterHelper.convertFiltersToAPIFormat(
        dashboardController.selectedLeadFilters.toList(),
      );
      leadController.filters.addAll(filterMap);
    }

    /// ✅ CRITICAL FIX: Only call loadInitial() - it handles everything
    /// Don't call refreshList() AND loadInitial() together!
    await leadController.loadInitial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        backgroundColor: ColorRes.white,
        elevation: 0,
        automaticallyImplyLeading: false, // 🚫 disable Flutter auto logic

        leading:
            widget.isViewAll
                ? null
                : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),

        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: AppFontWeights.bold),
        ),
        actions: [
          /// Add Lead
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              FocusScope.of(context).unfocus();
              leadController.resetForm();
              Get.to(
                () => AddLeadScreen(),
                binding: BindingsBuilder(() {
                  Get.lazyPut(
                    () => LeadController(),
                    tag: widget.controllerTag,
                  );
                }),
              );
            },
          ),

          /// Filter
          IconButton(
            icon: const Icon(Icons.filter_list, color: ColorRes.primary),
            onPressed: () {
              LeadFilterBottomSheet.show(
                context: context,
                selectedFilters: dashboardController.selectedLeadFilters,
                onApplyFilters: () async {
                  await _loadData();
                },
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

        // 🔹 INITIAL LOAD (no data yet) - show centered loader
        if (isLoading && leads.isEmpty && !isRefreshing) {
          return LeadListScreenShimmer();
        }

        return Column(
          children: [
            /// Selected Filter Chips
            buildSelectedFiltersChips(context, leadController, () async {
              leadController.filters.clear();
              dashboardController.clearLeadFilters();
              await _loadData();
            }),

            Expanded(
              child:
                  leads.isEmpty
                      ? _buildEmptyState()
                      : NotificationListener<ScrollEndNotification>(
                        onNotification: (notification) {
                          // ✅ Only trigger if not already loading/paging
                          if (notification.metrics.pixels >=
                                  notification.metrics.maxScrollExtent - 100 &&
                              !isLoading &&
                              !isPaging &&
                              leadController.hasMore.value) {
                            widget.onLoadMore(leadController, widget.entityId);
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
                            itemCount: leads.length + 1, // 👈 space for footer
                            separatorBuilder:
                                (_, __) => SizedBox(
                                  height: getResponsiveSpacing(context),
                                ),
                            itemBuilder: (_, index) {
                              // 🔹 BOTTOM LOADER (pagination)
                              if (index == leads.length) {
                                // Show loader only when paging (loading more items)
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
                                // Show "No more data" if we've reached the end
                                if (!leadController.hasMore.value &&
                                    leads.isNotEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'No more leads',
                                        style: TextStyle(
                                          color: ColorRes.leadGreyColor[400],
                                          fontSize: AppFontSizes.small,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }

                              final lead = leads[index];
                              return widget.leadCardBuilder != null
                                  ? widget.leadCardBuilder!(lead, () {})
                                  : LeadCardWidget(
                                    lead: lead,
                                    showDataMasking: widget.showDataMasking,
                                    isCompact:
                                        MediaQuery.of(context).size.width < 600,
                                    onTap: () => _openLead(lead),
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

      final updatedLead = leadController.newUpdatedLeadModel.value;

      if (updatedLead != null) {
        propertyInquiryController.setLeadInquiryId(
          int.tryParse(updatedLead.inquiryId ?? '0') ?? 0,
        );
      }

      await Get.to(() => LeadDetailScreen(lead: lead, isFromLead: true));
    } catch (e, st) {
      log('❌ Lead open error: $e\n$st');
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Unable to open lead',
        contentType: ContentType.failure,
      );
    } finally {
      isOpeningLead.value = false;
    }
  }

  Widget _buildEmptyState() {
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
            'No leads found',
            style: TextStyle(
              fontSize: AppFontSizes.large,
              color: ColorRes.leadGreyColor[600],
              fontWeight: AppFontWeights.medium,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add a new lead',
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.leadGreyColor[400],
            ),
          ),
        ],
      ),
    );
  }
}
