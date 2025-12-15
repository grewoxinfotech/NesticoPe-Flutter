// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// import 'package:housing_flutter_app/modules/common/lead_components/lead_components.dart';
// import 'package:housing_flutter_app/modules/common/lead_components/lead_filter_helper.dart';
//
// import '../../../data/network/property/models/property_model.dart';
// import '../../../widgets/bottom_sheet/lead_filter_bottomsheet.dart';
// import '../../../widgets/bottom_sheet/widgets/lead_filter_chips.dart';
// import '../../seller/module/lead_screen/controllers/lead_controller.dart';
// import '../../seller/module/lead_screen/model/lead_model.dart';
//
// class BuilderLeads extends StatefulWidget {
//   final bool isViewAll;
//   final String? projectId; // Added projectId parameter
//
//   const BuilderLeads({
//     super.key,
//     this.isViewAll = false,
//     this.projectId, // Added to constructor
//   });
//
//   @override
//   State<BuilderLeads> createState() => _BuilderLeadsState();
// }
//
// class _BuilderLeadsState extends State<BuilderLeads> {
//   late final LeadController leadController;
//   RxBool isLoadingLead = false.obs;
//   String searchQuery = '';
//   final RxList<String> selectedFilters = <String>[].obs;
//   bool isLoading = false;
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
//
//     // Apply project filter if projectId is provided
//     if (widget.projectId != null && widget.projectId!.isNotEmpty) {
//       // Add property_id filter to the controller's filters
//       leadController.filters['property_id'] = widget.projectId!;
//     }
//
//     // Re-fetch fresh leads from API with filters
//     await leadController.refreshList();
//
//     isLoadingLead.value = false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//       appBar: AppBar(
//         leading:
//             widget.isViewAll
//                 ? IconButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   icon: const Icon(Icons.arrow_back),
//                 )
//                 : null,
//         title: const Text(
//           'Leads',
//           style: TextStyle(fontWeight: AppFontWeights.bold),
//         ),
//         automaticallyImplyLeading: widget.isViewAll,
//         backgroundColor: ColorRes.white,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list, color: ColorRes.primary),
//             onPressed: () => showFilterBottomSheet(context, leadController),
//           ),
//         ],
//       ),
//       body: Obx(
//         () => Column(
//           children: [
//             buildSelectedFiltersChips(context, leadController, () async {
//               leadController.filters.clear();
//               // Re-apply project filter after clearing all filters
//               if (widget.projectId != null && widget.projectId!.isNotEmpty) {
//                 leadController.filters['property_id'] = widget.projectId!;
//               }
//               await _loadData();
//             }),
//             Expanded(
//               child:
//                   leadController.isLoading.value && isLoadingLead.value
//                       ? const Center(child: CircularProgressIndicator())
//                       : leadController.items.isEmpty
//                       ? Center(
//                         child: Text(
//                           'No leads available. Tap + to add a new lead.',
//                           style: TextStyle(
//                             fontSize: AppFontSizes.medium,
//                             color: ColorRes.leadGreyColor[600],
//                             fontWeight: AppFontWeights.medium,
//                           ),
//                         ),
//                       )
//                       : RefreshIndicator(
//                         onRefresh: () async {
//                           setState(() {
//                             isLoading = true;
//                           });
//                           await _loadData();
//                           setState(() {
//                             isLoading = false;
//                           });
//                         },
//                         child: ListView.separated(
//                           padding: EdgeInsets.all(
//                             getResponsivePadding(context),
//                           ),
//                           itemCount: leadController.items.length,
//                           separatorBuilder:
//                               (context, index) => SizedBox(
//                                 height: getResponsiveSpacing(context),
//                               ),
//                           itemBuilder: (context, index) {
//                             final lead = leadController.items[index];
//                             return LeadCardWidget(
//                               lead: lead,
//                               isCompact:
//                                   MediaQuery.of(context).size.width < 600,
//                               showDataMasking: false,
//                               onView: () {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text('View ${lead.name}')),
//                                 );
//                               },
//                               onEdit: () {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text('Edit ${lead.name}')),
//                                 );
//                               },
//                               onDelete:
//                                   () => showDeleteConfirmation(context, lead),
//                             );
//                           },
//                         ),
//                       ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Apply filters to API
//   /// Convert selectedFilters to API format and call backend
//   void applyFiltersToAPI() {
//     // Convert UI filter format to API format using helper
//     final filterMap = LeadFilterHelper.convertFiltersToAPIFormat(
//       selectedFilters.toList(),
//     );
//
//     // Add project filter if projectId exists
//     if (widget.projectId != null && widget.projectId!.isNotEmpty) {
//       filterMap['property_id'] = widget.projectId!;
//     }
//
//     if (filterMap.isEmpty) {
//       // No filters, fetch all leads
//       print('No filters applied, fetching all leads');
//       return;
//     }
//
//     print('Applying filters to Builder API: $filterMap');
//     // TODO: Call builder lead API with filterMap
//     // Example:
//     // builderLeadController.applyFilters(filterMap);
//     // This will call the service with filters like:
//     // {"property_id": "EBJwV96smMoApRyE0sIkr15", "stage": "new_lead", "status": "contacted"}
//   }
//
//   void showDeleteConfirmation(BuildContext context, LeadItem lead) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: ColorRes.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: Text(
//             'Delete Buyer Lead',
//             style: TextStyle(
//               fontSize: AppFontSizes.large,
//               fontWeight: AppFontWeights.bold,
//             ),
//           ),
//           content: Text(
//             'Are you sure you want to delete ${lead.name}?',
//             style: TextStyle(
//               fontSize: AppFontSizes.medium,
//               color: ColorRes.leadGreyColor[700],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(
//                   fontSize: AppFontSizes.medium,
//                   fontWeight: AppFontWeights.medium,
//                   color: ColorRes.leadGreyColor[600],
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text('${lead.name} deleted')));
//               },
//               child: Text(
//                 'Delete',
//                 style: TextStyle(
//                   fontSize: AppFontSizes.medium,
//                   fontWeight: AppFontWeights.bold,
//                   color: ColorRes.error,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/data/network/builder/model/builder_model.dart';
import 'package:housing_flutter_app/modules/builder/view/widget/builder_lead_over_view.dart';
import 'package:housing_flutter_app/modules/common/lead_components/lead_components.dart';
import 'package:housing_flutter_app/modules/common/lead_components/lead_filter_helper.dart';

import '../../../data/network/property/models/property_model.dart';
import '../../../widgets/bottom_sheet/lead_filter_bottomsheet.dart';
import '../../../widgets/bottom_sheet/widgets/lead_filter_chips.dart';
import '../../seller/module/lead_screen/controllers/lead_controller.dart';
import '../../seller/module/lead_screen/model/lead_model.dart';
import '../controller/builder_form_controller.dart';

class BuilderLeads extends StatefulWidget {
  final bool isViewAll;
  final String? projectId;

  const BuilderLeads({super.key, this.isViewAll = false, this.projectId});

  @override
  State<BuilderLeads> createState() => _BuilderLeadsState();
}

class _BuilderLeadsState extends State<BuilderLeads> {
  late final LeadController leadController;
  late final ScrollController _scrollController;
  RxBool isLoadingLead = false.obs;
  String searchQuery = '';
  final RxList<String> selectedFilters = <String>[].obs;
  final controller = Get.find<ProjectWizardController>(tag: "builder");
  bool isLoading = false;

  // Determine if we're showing property-specific leads
  bool get isPropertyView =>
      widget.projectId != null && widget.projectId!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    leadController =
        Get.isRegistered<LeadController>(tag: "seller")
            ? Get.find<LeadController>(tag: "seller")
            : Get.put(LeadController(), tag: "seller");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Scroll listener for pagination
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (isPropertyView) {
        // Load more property-specific leads
        _loadMorePropertyLeads();
      } else {
        // Load more all leads
        _loadMoreAllLeads();
      }
    }
  }

  /// Initial data load
  Future<void> _loadData() async {
    isLoadingLead.value = true;

    if (isPropertyView) {
      // Load property-specific leads
      leadController.propertyLeads.clear();
      await leadController.getLeadsByProperty(widget.projectId!);
    } else {
      // Load all leads with optional filters
      leadController.items.clear();
      leadController.leadPropertiesList.clear();
      await leadController.refreshList();
    }

    isLoadingLead.value = false;
  }

  /// Load more for property view
  Future<void> _loadMorePropertyLeads() async {
    if (!leadController.isLoadingPropertyLeads.value &&
        leadController.propertyLeadsHasMore.value) {
      await leadController.loadMorePropertyLeads(widget.projectId!);
    }
  }

  /// Load more for all leads view
  Future<void> _loadMoreAllLeads() async {
    if (!leadController.isPaging.value && leadController.hasMore.value) {
      await leadController.loadMore();
    }
  }

  /// Get current leads list based on view type
  List<LeadItem> get currentLeads {
    return isPropertyView ? leadController.propertyLeads : leadController.items;
  }

  /// Check if loading
  bool get isCurrentlyLoading {
    return isPropertyView
        ? leadController.isLoadingPropertyLeads.value
        : leadController.isLoading.value;
  }

  /// Check if loading more (pagination)
  bool get isLoadingMore {
    return isPropertyView
        ? false // Property leads use isLoadingPropertyLeads for all loading
        : leadController.isPaging.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        leading:
            widget.isViewAll
                ? IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                )
                : null,
        title: Text(
          isPropertyView ? 'Property Leads' : 'Leads',
          style: const TextStyle(fontWeight: AppFontWeights.bold),
        ),
        automaticallyImplyLeading: widget.isViewAll,
        backgroundColor: ColorRes.white,
        elevation: 0,
        actions: [
          // Only show filter for all leads
          IconButton(
            icon: const Icon(Icons.filter_list, color: ColorRes.primary),
            onPressed:
                () =>
                    (widget.projectId != null && widget.projectId!.isNotEmpty)
                        ? showFilterBottomSheet(
                          context,
                          leadController,
                          propertyId: widget.projectId,
                        )
                        : showFilterBottomSheet(context, leadController),
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            // Only show filter chips for all leads view
            // if (!isPropertyView)
            if (widget.projectId != null && widget.projectId!.isNotEmpty) ...[
              buildSelectedFiltersChips(context, leadController, () async {
                leadController.filters.clear();
                await _loadData();
              }, propertyId: widget.projectId),
            ] else ...[
              buildSelectedFiltersChips(context, leadController, () async {
                leadController.filters.clear();
                await _loadData();
              }),
            ],
            Expanded(
              child:
                  isCurrentlyLoading && isLoadingLead.value
                      ? const Center(child: CircularProgressIndicator())
                      : currentLeads.isEmpty
                      ? Center(
                        child: Text(
                          'No leads available. Tap + to add a new lead.',
                          style: TextStyle(
                            fontSize: AppFontSizes.medium,
                            color: ColorRes.leadGreyColor[600],
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                      )
                      : RefreshIndicator(
                        onRefresh: () async {
                          setState(() => isLoading = true);
                          await _loadData();
                          setState(() => isLoading = false);
                        },
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.all(
                            getResponsivePadding(context),
                          ),
                          itemCount:
                              currentLeads.length + (isLoadingMore ? 1 : 0),
                          separatorBuilder:
                              (context, index) => SizedBox(
                                height: getResponsiveSpacing(context),
                              ),
                          itemBuilder: (context, index) {
                            // Show loading indicator at the bottom
                            if (index == currentLeads.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final lead = currentLeads[index];
                            return LeadCardWidget(
                              lead: lead,
                              onTap: () {
                                log("String builderLead Data ${lead.toJson()}");
                                final project = controller.items.firstWhere(
                                  (prop) => prop.id == lead.propertyId,
                                );
                                Get.to(
                                  () => BuilderLeadOverView(
                                    lead: lead,
                                    project: project,
                                  ),
                                );
                              },
                              isCompact:
                                  MediaQuery.of(context).size.width < 600,
                              showDataMasking: false,
                              onView: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('View ${lead.name}')),
                                );
                              },
                              onEdit: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Edit ${lead.name}')),
                                );
                              },
                              onDelete:
                                  () => showDeleteConfirmation(context, lead),
                            );
                          },
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteConfirmation(BuildContext context, LeadItem lead) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorRes.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final success = await leadController.deleteLead(lead.id ?? '');
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${lead.name} deleted')),
                  );
                  await _loadData(); // Refresh the list
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to delete lead')),
                  );
                }
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
}
