// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/app/constants/app_font_sizes.dart';
// import 'package:nesticope_app/data/network/builder/model/builder_model.dart';
// import 'package:nesticope_app/modules/builder/view/widget/builder_lead_over_view.dart';
// import 'package:nesticope_app/modules/common/lead_components/lead_components.dart';
// import 'package:nesticope_app/modules/common/lead_components/lead_filter_helper.dart';
//
// import '../../../data/network/property/models/property_model.dart';
// import '../../../widgets/bottom_sheet/lead_filter_bottomsheet.dart';
// import '../../../widgets/bottom_sheet/widgets/lead_filter_chips.dart';
// import '../../../widgets/messages/snack_bar.dart';
// import '../../seller/module/lead_screen/controllers/lead_controller.dart';
// import '../../seller/module/lead_screen/controllers/lead_property_inquiry_controller.dart';
// import '../../seller/module/lead_screen/controllers/lead_property_negotiable_price_controller.dart';
// import '../../seller/module/lead_screen/controllers/lead_visit_controller.dart';
// import '../../seller/module/lead_screen/model/lead_model.dart';
// import '../controller/builder_form_controller.dart';
//
// class BuilderLeads extends StatefulWidget {
//   final bool isViewAll;
//   final String? projectId;
//
//   const BuilderLeads({super.key, this.isViewAll = false, this.projectId});
//
//   @override
//   State<BuilderLeads> createState() => _BuilderLeadState();
// }
//
// class _BuilderLeadState extends State<BuilderLeads> {
//   // late final LeadController leadController;
//
//   // final ProjectWizardController projectController =
//   //     Get.find<ProjectWizardController>(
//   //       tag: "project_detail_${widget.projectId}",
//   //     );
//   //
//   // final LeadPropertyInquiryController propertyInquiryController = Get.put(
//   //   LeadPropertyInquiryController(),
//   // );
//   //
//   // final LeadVisitController leadVisitController = Get.put(
//   //   LeadVisitController(),
//   // );
//   //
//   // final LeadPropertyNegotiablePriceController
//   // leadPropertyNegotiablePriceController = Get.put(
//   //   LeadPropertyNegotiablePriceController(),
//   // );
//   //
//   // final RxBool isLoadingLead = false.obs;
//
//   late final LeadController leadController;
//   late final ProjectWizardController projectController;
//
//   final LeadPropertyInquiryController propertyInquiryController = Get.put(
//     LeadPropertyInquiryController(),
//   );
//
//   final LeadVisitController leadVisitController = Get.put(
//     LeadVisitController(),
//   );
//
//   final LeadPropertyNegotiablePriceController
//   leadPropertyNegotiablePriceController = Get.put(
//     LeadPropertyNegotiablePriceController(),
//   );
//
//   final RxBool isLoadingLead = false.obs;
//   // bool get isProjectView =>
//   //     widget.projectId != null && widget.projectId!.isNotEmpty;
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   leadController =
//   //       Get.isRegistered<LeadController>(tag: "builder")
//   //           ? Get.find<LeadController>(tag: "builder")
//   //           : Get.put(LeadController(), tag: "builder");
//   //   WidgetsBinding.instance.addPostFrameCallback((_) async {
//   //     await _loadData();
//   //   });
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//
//     leadController =
//         Get.isRegistered<LeadController>(tag: "builder")
//             ? Get.find<LeadController>(tag: "builder")
//             : Get.put(LeadController(), tag: "builder");
//
//     /// ✅ SAFE usage of widget.projectId here
//     if (widget.projectId != null && widget.projectId!.isNotEmpty) {
//       projectController = Get.find<ProjectWizardController>(
//         tag: "project_detail_${widget.projectId}",
//       );
//     }
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _loadData();
//     });
//   }
//
//   Future<void> _loadData() async {
//     isLoadingLead.value = true;
//     leadController.items.clear();
//     leadController.leadPropertiesList.clear();
//     leadController.currentPropertyFilterId.value = widget.projectId;
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
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//
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
//
//         backgroundColor: ColorRes.white,
//         elevation: 0,
//
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list, color: ColorRes.primary),
//             onPressed: () {
//               showFilterBottomSheet(
//                 context,
//                 leadController,
//                 propertyId: widget.projectId,
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
//         return Column(
//           children: [
//             buildSelectedFiltersChips(
//               context,
//               leadController,
//               () async {
//                 leadController.filters.clear();
//                 await _loadData();
//               },
//               // propertyId: widget.projectId != null ? widget.projectId : null,
//             ),
//
//             Expanded(
//               child:
//               // leads.isEmpty
//               //     ? buildEmptyState(context)
//               //     :
//               NotificationListener<ScrollEndNotification>(
//                 onNotification: (notification) {
//                   final metrics = notification.metrics;
//                   if (metrics.pixels >= metrics.maxScrollExtent) {
//                     if (widget.projectId != null &&
//                         widget.projectId!.isNotEmpty) {
//                       leadController.loadMorePropertyLeads(widget.projectId!);
//                     } else {
//                       leadController.loadMore();
//                     }
//                   }
//                   return true;
//                 },
//                 child: RefreshIndicator(
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
//                       return LeadCardWidget(
//                         lead: lead,
//                         isCompact: MediaQuery.of(context).size.width < 600,
//                         showDataMasking: false,
//                         onTap: () async {
//                           if (isLoadingLead.value) return;
//
//                           isLoadingLead.value = true;
//                           try {
//                             leadVisitController.getLeadId(lead.id);
//
//                             await leadController.getLeadDetailByID(
//                               lead.id ?? '',
//                             );
//
//                             final newLead =
//                                 leadController.newUpdatedLeadModel.value;
//
//                             if (newLead != null) {
//                               propertyInquiryController.setLeadInquiryId(
//                                 int.tryParse(newLead.inquiryId ?? '0') ?? 0,
//                               );
//                             }
//
//                             final project = projectController.items.firstWhere(
//                               (p) => p.id == lead.propertyId,
//                             );
//
//                             await Get.to(
//                               () => BuilderLeadOverView(
//                                 lead: lead,
//                                 project: project,
//                               ),
//                             );
//                           } catch (e, st) {
//                             log('❌ Builder lead open error: $e\n$st');
//
//                             NesticoPeSnackBar.showAwesomeSnackbar(
//                               title: 'Error',
//                               message: 'Failed to open lead details',
//                               contentType: ContentType.failure,
//                             );
//                           } finally {
//                             isLoadingLead.value = false;
//                           }
//                         },
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
//             'No leads found',
//             style: TextStyle(
//               fontSize: AppFontSizes.large,
//               color: ColorRes.leadGreyColor[600],
//               fontWeight: AppFontWeights.medium,
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
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/data/network/builder/model/builder_model.dart';
import 'package:nesticope_app/modules/builder/view/widget/builder_lead_over_view.dart';
import 'package:nesticope_app/modules/common/lead_components/lead_components.dart';
import 'package:nesticope_app/modules/common/lead_components/lead_filter_helper.dart';
import 'package:nesticope_app/utils/shimmer/common_screen/lead_screen/lead_list_screen_shimmer.dart';

import '../../../data/network/property/models/property_model.dart';
import '../../../widgets/bottom_sheet/lead_filter_bottomsheet.dart';
import '../../../widgets/bottom_sheet/widgets/lead_filter_chips.dart';
import '../../../widgets/messages/snack_bar.dart';
import '../../seller/module/lead_screen/controllers/lead_controller.dart';
import '../../seller/module/lead_screen/controllers/lead_property_inquiry_controller.dart';
import '../../seller/module/lead_screen/controllers/lead_property_negotiable_price_controller.dart';
import '../../seller/module/lead_screen/controllers/lead_visit_controller.dart';
import '../../seller/module/lead_screen/model/lead_model.dart';
import '../controller/builder_form_controller.dart';

// class _BuilderLeadState extends State<BuilderLeads> {
//   late final LeadController leadController;
//   late final ProjectWizardController projectController;
//
//   final LeadPropertyInquiryController propertyInquiryController = Get.put(
//     LeadPropertyInquiryController(),
//   );
//
//   final LeadVisitController leadVisitController = Get.put(
//     LeadVisitController(),
//   );
//
//   final LeadPropertyNegotiablePriceController
//   leadPropertyNegotiablePriceController = Get.put(
//     LeadPropertyNegotiablePriceController(),
//   );
//
//   final RxBool isOpeningLead = false.obs;
//
//   @override
//   void initState() {
//     super.initState();
//
//     leadController =
//         Get.isRegistered<LeadController>(tag: "builder")
//             ? Get.find<LeadController>(tag: "builder")
//             : Get.put(LeadController(), tag: "builder");
//
//     /// ✅ SAFE usage of widget.projectId here
//     if (widget.projectId != null && widget.projectId!.isNotEmpty) {
//       projectController = Get.find<ProjectWizardController>(
//         tag: "project_detail_${widget.projectId}",
//       );
//     }
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
//     leadController.currentPropertyFilterId.value = widget.projectId;
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
//                 propertyId: widget.projectId,
//               );
//             },
//           ),
//         ],
//       ),
//       // body: Obx(() {
//       //   final leads = leadController.items;
//       //   final isLoading = leadController.isLoading.value;
//       //   final isPaging = leadController.isPaging.value;
//       //   final isRefreshing = leadController.isRefreshing.value;
//       //
//       //   // 🔹 INITIAL LOAD (no data yet) - show centered loader
//       //   if (isLoading && leads.isEmpty && !isRefreshing) {
//       //     return LeadListScreenShimmer();
//       //   }
//       //
//       //   return Column(
//       //     children: [
//       //       buildSelectedFiltersChips(context, leadController, () async {
//       //         leadController.filters.clear();
//       //         await _loadData();
//       //       }),
//       //       Expanded(
//       //         child:
//       //             leads.isEmpty
//       //                 ? buildEmptyState(context)
//       //                 : NotificationListener<ScrollEndNotification>(
//       //                   onNotification: (notification) {
//       //                     final metrics = notification.metrics;
//       //                     // ✅ Only trigger if not already loading/paging
//       //                     if (metrics.pixels >= metrics.maxScrollExtent - 100 &&
//       //                         !isLoading &&
//       //                         !isPaging &&
//       //                         leadController.hasMore.value) {
//       //                       if (widget.projectId != null &&
//       //                           widget.projectId!.isNotEmpty) {
//       //                         leadController.loadMorePropertyLeads(
//       //                           widget.projectId!,
//       //                         );
//       //                       } else {
//       //                         leadController.loadMore();
//       //                       }
//       //                     }
//       //                     return false;
//       //                   },
//       //                   child: RefreshIndicator(
//       //                     onRefresh: () async {
//       //                       if (!isRefreshing && !isLoading) {
//       //                         await leadController.refreshList();
//       //                       }
//       //                     },
//       //                     child: ListView.separated(
//       //                       physics: const AlwaysScrollableScrollPhysics(),
//       //                       padding: EdgeInsets.all(
//       //                         getResponsivePadding(context),
//       //                       ),
//       //                       itemCount: leads.length + 1, // 👈 space for footer
//       //                       separatorBuilder:
//       //                           (_, __) => SizedBox(
//       //                             height: getResponsiveSpacing(context),
//       //                           ),
//       //                       itemBuilder: (context, index) {
//       //                         // 🔹 BOTTOM LOADER (pagination)
//       //                         if (index == leads.length) {
//       //                           // Show loader only when paging
//       //                           if (isPaging && leadController.hasMore.value) {
//       //                             return const Padding(
//       //                               padding: EdgeInsets.symmetric(vertical: 16),
//       //                               child: Center(
//       //                                 child: CircularProgressIndicator(
//       //                                   strokeWidth: 2,
//       //                                 ),
//       //                               ),
//       //                             );
//       //                           }
//       //                           // Show "No more data" if we've reached the end
//       //                           if (!leadController.hasMore.value &&
//       //                               leads.isNotEmpty) {
//       //                             return Padding(
//       //                               padding: const EdgeInsets.symmetric(
//       //                                 vertical: 16,
//       //                               ),
//       //                               child: Center(
//       //                                 child: Text(
//       //                                   'No more leads',
//       //                                   style: TextStyle(
//       //                                     color: ColorRes.leadGreyColor[400],
//       //                                     fontSize: AppFontSizes.small,
//       //                                   ),
//       //                                 ),
//       //                               ),
//       //                             );
//       //                           }
//       //                           return const SizedBox.shrink();
//       //                         }
//       //
//       //                         final lead = leads[index];
//       //
//       //                         return LeadCardWidget(
//       //                           lead: lead,
//       //                           isCompact:
//       //                               MediaQuery.of(context).size.width < 600,
//       //                           showDataMasking: false,
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
//         final isPaging = leadController.isPaging.value;
//         final isRefreshing = leadController.isRefreshing.value;
//         final isFilterLoading = leadController.isFilterLoading.value;
//
//         /// 🔹 INITIAL LOAD / FILTER APPLY / FILTER REMOVE
//         if ((isLoading || isFilterLoading) && leads.isEmpty && !isRefreshing) {
//           return const LeadListScreenShimmer();
//         }
//
//         return Column(
//           children: [
//             /// 🔹 FILTER CHIPS
//             buildSelectedFiltersChips(context, leadController, () async {
//               await leadController.clearFiltersAndReload();
//             }),
//
//             /// 🔹 LIST
//             Expanded(
//               child:
//                   leads.isEmpty
//                       ? buildEmptyState(context)
//                       : NotificationListener<ScrollEndNotification>(
//                         onNotification: (notification) {
//                           final metrics = notification.metrics;
//
//                           if (metrics.pixels >= metrics.maxScrollExtent - 100 &&
//                               !isLoading &&
//                               !isPaging &&
//                               leadController.hasMore.value) {
//                             if (widget.projectId != null &&
//                                 widget.projectId!.isNotEmpty) {
//                               leadController.loadMorePropertyLeads(
//                                 widget.projectId!,
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
//                             itemCount: leads.length + 1,
//                             separatorBuilder:
//                                 (_, __) => SizedBox(
//                                   height: getResponsiveSpacing(context),
//                                 ),
//                             itemBuilder: (context, index) {
//                               /// 🔹 FOOTER
//                               if (index == leads.length) {
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
//
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
//
//                                 return const SizedBox.shrink();
//                               }
//
//                               final lead = leads[index];
//
//                               return LeadCardWidget(
//                                 lead: lead,
//                                 isCompact:
//                                     MediaQuery.of(context).size.width < 600,
//                                 showDataMasking: false,
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
//
//       await leadController.getLeadDetailByID(lead.id ?? '');
//
//       final newLead = leadController.newUpdatedLeadModel.value;
//
//       if (newLead != null) {
//         propertyInquiryController.setLeadInquiryId(
//           int.tryParse(newLead.inquiryId ?? '0') ?? 0,
//         );
//       }
//
//       final project = projectController.items.firstWhere(
//         (p) => p.id == lead.propertyId,
//       );
//
//       await Get.to(() => BuilderLeadOverView(lead: lead, project: project));
//     } catch (e, st) {
//       log('❌ Builder lead open error: $e\n$st');
//
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: 'Error',
//         message: 'Failed to open lead details',
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
//             'No leads found',
//             style: TextStyle(
//               fontSize: AppFontSizes.large,
//               color: ColorRes.leadGreyColor[600],
//               fontWeight: AppFontWeights.medium,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Leads will appear here',
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
//
// class BuilderLeads extends StatefulWidget {
//   final bool isViewAll;
//   final String? projectId;
//
//   const BuilderLeads({super.key, this.isViewAll = false, this.projectId});
//
//   @override
//   State<BuilderLeads> createState() => _BuilderLeadState();
// }

// FIXED BuilderLeads Implementation

class BuilderLeads extends StatefulWidget {
  final bool isViewAll;
  final String? projectId;

  const BuilderLeads({super.key, this.isViewAll = false, this.projectId});

  @override
  State<BuilderLeads> createState() => _BuilderLeadState();
}

class _BuilderLeadState extends State<BuilderLeads> {
  late final LeadController leadController;
  ProjectWizardController? projectController; // ✅ Make it nullable

  final LeadPropertyInquiryController propertyInquiryController = Get.put(
    LeadPropertyInquiryController(),
  );

  final LeadVisitController leadVisitController = Get.put(
    LeadVisitController(),
  );

  final LeadPropertyNegotiablePriceController
  leadPropertyNegotiablePriceController = Get.put(
    LeadPropertyNegotiablePriceController(),
  );

  final RxBool isOpeningLead = false.obs;

  @override
  void initState() {
    super.initState();

    leadController =
        Get.isRegistered<LeadController>(tag: "builder")
            ? Get.find<LeadController>(tag: "builder")
            : Get.put(LeadController(), tag: "builder");

    /// ✅ Try to find existing controller, but don't fail if it doesn't exist
    if (widget.projectId != null && widget.projectId!.isNotEmpty) {
      final tag = "project_detail_${widget.projectId}";
      if (Get.isRegistered<ProjectWizardController>(tag: tag)) {
        projectController = Get.find<ProjectWizardController>(tag: tag);
        print("✅ Found existing ProjectWizardController with tag: $tag");
      } else {
        print("⚠️ No ProjectWizardController found with tag: $tag");
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData();
    });
  }

  /// ✅ FIXED: Proper data loading
  Future<void> _loadData() async {
    // Clear previous data
    leadController.items.clear();
    leadController.leadPropertiesList.clear();

    // Set property filter
    leadController.currentPropertyFilterId.value = widget.projectId;

    // ✅ CRITICAL FIX: Only call loadInitial() - don't call refreshList()
    await leadController.loadInitial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
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
                propertyId: widget.projectId,
              );
            },*/
            onPressed: () {
              Get.to(
                () => LeadBuildFilterScreen(
                  controller: leadController,
                  propertyId: widget.projectId,
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
        final isFilterLoading = leadController.isFilterLoading.value;

        /// 🔹 INITIAL LOAD / FILTER APPLY / FILTER REMOVE
        if ((isLoading || isFilterLoading) && leads.isEmpty && !isRefreshing) {
          return const LeadListScreenShimmer();
        }

        return Column(
          children: [
            /// 🔹 FILTER CHIPS
            buildSelectedFiltersChips(context, leadController, () async {
              await leadController.clearFiltersAndReload();
            }),

            /// 🔹 LIST
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
                            if (widget.projectId != null &&
                                widget.projectId!.isNotEmpty) {
                              leadController.loadMorePropertyLeads(
                                widget.projectId!,
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
                              /// 🔹 FOOTER
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

                              return LeadCardWidget(
                                lead: lead,
                                isCompact:
                                    MediaQuery.of(context).size.width < 600,
                                showDataMasking: false,
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

  // ✅ OPTION 1: Fetch project on-demand when opening lead
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

      // ✅ Get or create the project controller
      ProjectItem? project;

      // Try to get from existing controller first
      if (projectController != null) {
        try {
          project = projectController!.items.firstWhereOrNull(
            (p) => p.id == lead.propertyId,
          );
          print("✅ Found project in existing controller");
        } catch (e) {
          print("⚠️ Error finding project in controller: $e");
        }
      }

      // If not found and we have a propertyId, fetch it
      if (project == null && lead.propertyId != null) {
        print("🔍 Fetching project from API: ${lead.propertyId}");

        // Get or create a temporary controller to fetch the project
        final tempController =
            Get.isRegistered<ProjectWizardController>(tag: "temp_lead")
                ? Get.find<ProjectWizardController>(tag: "temp_lead")
                : Get.put(
                  ProjectWizardController(isBuilderView: true),
                  tag: "temp_lead",
                );

        project = await tempController.getProjectById(lead.propertyId!);

        if (project == null) {
          throw Exception("Failed to fetch project details");
        }

        print("✅ Successfully fetched project: ${project.projectName}");
      }

      if (project == null) {
        throw Exception("Project not found for this lead");
      }

      await Get.to(() => BuilderLeadOverView(lead: lead, project: project!));
    } catch (e, st) {
      log('❌ Builder lead open error: $e\n$st');

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to open lead details: ${e.toString()}',
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
            'No leads found',
            style: TextStyle(
              fontSize: AppFontSizes.large,
              color: ColorRes.leadGreyColor[600],
              fontWeight: AppFontWeights.medium,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Leads will appear here',
            style: TextStyle(
              fontSize: AppFontSizes.small,
              color: ColorRes.leadGreyColor[400],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the temp controller if it exists
    if (Get.isRegistered<ProjectWizardController>(tag: "temp_lead")) {
      Get.delete<ProjectWizardController>(tag: "temp_lead");
    }
    super.dispose();
  }
}
