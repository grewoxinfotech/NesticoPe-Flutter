import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/manager/property/property_pricemanager.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/reseller/view/lead/add_lead_screen.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/model/lead_model.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../utils/global.dart';
import '../../../add_property/view/create_property.dart';
import '../../../seller/module/lead_screen/controllers/lead_controller.dart';
import '../../controller/dashborad_controller/dashboard_controller.dart';
import '../../model/dashboard/dashboard_model.dart';
import '../lead_overview/lead_detail.dart';

class ResellerLeadScreen extends StatelessWidget {
  final bool isViewAll;

  const ResellerLeadScreen({super.key, this.isViewAll = false});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LeadController(), tag: "reseller");
    final leadController = Get.find<LeadController>(tag: "reseller");

    final controller = Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        leading:
        (isViewAll)
            ? IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        )
            : null,
        title: Text(
          'Property Buyer Leads',
          style: TextStyle(
            fontWeight: AppFontWeights.bold,
          ),
        ),
        automaticallyImplyLeading: (isViewAll),
        backgroundColor: ColorRes.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              FocusScope.of(context).unfocus();
              leadController.resetForm();
              Get.to(
                    () => AddLeadScreen(),
                binding: BindingsBuilder(() {
                  Get.lazyPut(() => LeadController(), tag: "reseller");
                }),
              );
              // showLeadForm(context, controller);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: ColorRes.primary),
            onPressed: () {
              showFilterBottomSheet(context, controller);
            },
          ),
        ],
      ),

      body: Obx(() {
        // Loading state
        if (leadController.isLoading.value && leadController.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredLeads = leadController.items.value;

        return Column(
          children: [
            // Search bar and filters always shown
            buildSearchAndFilter(context, controller),
            buildSelectedFiltersChips(context, controller),

            // Main content
            Expanded(
              child: filteredLeads.isEmpty
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
                onRefresh: leadController.refreshList,
                child: ListView.separated(
                  padding: EdgeInsets.all(getResponsivePadding(context)),
                  itemCount: filteredLeads.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(
                        height: getResponsiveSpacing(context),
                      ),
                  itemBuilder: (context, index) {
                    final lead = filteredLeads[index];
                    return buildLeadCard(context, lead, controller);
                  },
                ),
              ),
            ),
          ],
        );
      }),

    );
  }
}

  Widget buildSearchAndFilter(
    BuildContext context,
    DashboardController controller,
  ) {
    return Container(
      margin: EdgeInsets.all(getResponsivePadding(context)),
      padding: EdgeInsets.symmetric(horizontal: getResponsivePadding(context)),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: TextField(
        onChanged: controller.updateSearch,
        style: TextStyle(fontSize: AppFontSizes.medium),
        decoration: InputDecoration(
          hintText: 'Search buyer leads...',
          hintStyle: TextStyle(fontSize: AppFontSizes.medium),
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget buildSelectedFiltersChips(
    BuildContext context,
    DashboardController controller,
  ) {
    return Obx(() {
      final selectedFilters = controller.selectedLeadFilters.value;

      if (selectedFilters.isEmpty) {
        return const SizedBox.shrink();
      }
      print("Selected Filters: $selectedFilters");
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: getResponsivePadding(context),
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Active Filters:',
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.leadGreyColor[700],
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    controller.clearLeadFilters();
                  },
                  label: Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      color: ColorRes.primary,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8,
                // runSpacing: 8,
                children:
                    selectedFilters.map((filter) {
                      // Split filter into type and value
                      final parts = filter.split(':');
                      final filterType = parts[0]; // Stage or Status
                      final filterValue = parts[1]; // New Lead, Contacted, etc.

                      // Get color based on type
                      final chipColor =
                          filterType == 'Stage'
                              ? ColorRes.primary
                              : ColorRes.green;

                      return Container(
                        decoration: BoxDecoration(
                          color: chipColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: chipColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Filter type badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: chipColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  filterType,
                                  style: TextStyle(
                                    fontSize: AppFontSizes.extraSmall,
                                    color: ColorRes.white,
                                    fontWeight: AppFontWeights.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Filter value
                              Text(
                                filterValue,
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  color: chipColor,
                                  fontWeight: AppFontWeights.semiBold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Remove button
                              InkWell(
                                onTap: () {
                                  controller.removeLeadFilter(filter);
                                  ever(controller.selectedLeadFilters, (_) {
                                    controller.filterMaps.value =
                                        controller.selectedLeadFilters.map((filter) {
                                          var parts = filter.split(':');
                                          return {
                                            parts[0].trim().toLowerCase(): parts[1]
                                                .trim()
                                                .toLowerCase()
                                                .replaceAll(" ", "_"),
                                          };
                                        }).toList();

                                    controller.applyFilter(controller.filterMaps.value);
                                  });
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  child: Icon(
                                    Icons.close,
                                    size: 14,
                                    color: chipColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      );
    });
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
    DashboardController controller,
  ) {
    final leadController = Get.find<LeadController>(tag: "reseller");
    final isCompact = MediaQuery.of(context).size.width < 600;
    final cardPadding = isCompact ? 12.0 : 16.0;
    final priceManager = PropertyPriceManager(
      listingType: lead.customFields?.listingType ?? '',
      financialInfo: lead.customFields?.propertyDetails?.financialInfo,
    );

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
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
                        lead.name!,
                        style: TextStyle(
                          fontSize:
                              isCompact
                                  ? AppFontSizes.medium
                                  : AppFontSizes.body,
                          fontWeight: AppFontWeights.bold,
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
                        '${lead.name}',
                        style: TextStyle(
                          fontSize:
                              isCompact
                                  ? AppFontSizes.extraSmall
                                  : AppFontSizes.small,
                          color: ColorRes.leadGreyColor[700],
                          fontWeight: AppFontWeights.regular,
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
                              lead.email!.replaceRange(
                                lead.email!.length < 4 ? lead.email!.length : 4,
                                lead.email!.length,
                                'XXXXXXXXXXX',
                              ),
                              style: TextStyle(
                                fontSize: AppFontSizes.extraSmall,
                                color: ColorRes.leadGreyColor[600],
                                fontWeight: AppFontWeights.regular,
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
                      fontWeight: AppFontWeights.regular,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${priceManager.displayPrice}',
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
                      fontWeight: AppFontWeights.regular,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: isCompact ? 8 : 12),
          Divider(color: ColorRes.leadGreyColor, thickness: 0.5),
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
                  color: getStatusColor(
                    getLeadStatusFromString(lead.status!),
                  ).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: getStatusColor(
                      getLeadStatusFromString(lead.status!),
                    ).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  getStatusText(getLeadStatusFromString(lead.status!)),
                  style: TextStyle(
                    fontSize:
                        isCompact
                            ? AppFontSizes.extraSmall
                            : AppFontSizes.small,
                    color: getStatusColor(
                      getLeadStatusFromString(lead.status!),
                    ),
                    fontWeight: AppFontWeights.bold,
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
                            : AppFontSizes.small,
                    color: getStageColor(getLeadStageFromString(lead.stage)),
                    fontWeight: AppFontWeights.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  buildActionButton(
                    icon: Icons.visibility,
                    color: ColorRes.blueColor,
                    onPressed: () {
                      Get.to(
                        () => LeadDetailScreen(lead: lead, isFromLead: true),
                      );
                    },
                    tooltip: 'View Details',
                    isCompact: isCompact,
                  ),
                  SizedBox(width: 8),
                  buildActionButton(
                    icon: Icons.edit,
                    color: ColorRes.orangeColor,
                    onPressed: () {
                      leadController.resetForm();
                      Get.to(() => AddLeadScreen(lead: lead, isEditMode: true));
                    },

                    tooltip: 'Edit Lead',
                    isCompact: isCompact,
                  ),
                  SizedBox(width: 8),
                  buildActionButton(
                    icon: Icons.delete,
                    color: ColorRes.error,
                    onPressed:
                        () => showDeleteConfirmation(context, lead, controller),
                    tooltip: 'Delete Lead',
                    isCompact: isCompact,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


void showFilterBottomSheet(
  BuildContext context,
  DashboardController controller,
) {
  // Create temporary lists to store selections
  final RxList<String> tempSelectedFilters =
      <String>[...controller.selectedLeadFilters].obs;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: ColorRes.transparentColor,
    builder:
        (context) => StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorRes.leadGreyColor[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter Leads',
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: AppFontWeights.semiBold,
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                tempSelectedFilters.clear();
                                controller.clearLeadFilters();
                                setState(() {});
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: ColorRes.error[400],
                              ),
                              child: Text(
                                'Clear All',
                                style: TextStyle(
                                  fontWeight: AppFontWeights.medium,
                                  fontSize: AppFontSizes.small,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1, color: ColorRes.leadGreyColor[300]),

                  // Filter content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stage Section
                          buildFilterSection(
                            context: context,
                            title: 'Stage',
                            icon: Icons.stairs,
                            filterType: 'Stage',
                            options: [
                              'New Lead',
                              'Contacted',
                              'Interested',
                              'Site Visit',
                              'Sell',
                            ],
                            tempSelectedFilters: tempSelectedFilters,
                            setState: setState,
                          ),

                          const SizedBox(height: 24),

                          // Status Section
                          buildFilterSection(
                            context: context,
                            title: 'Status',
                            icon: Icons.flag,
                            filterType: 'Status',
                            options: [
                              'New',
                              'Contacted',
                              'Qualified',
                              'Negotiating',
                              'Lost',
                              'Converted',
                            ],
                            tempSelectedFilters: tempSelectedFilters,
                            setState: setState,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Apply button
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () {
                          // Apply filters to controller
                          controller.selectedLeadFilters.clear();
                          controller.selectedLeadFilters.addAll(
                            tempSelectedFilters,
                          );
                          controller.filterMaps.value =
                              controller.selectedLeadFilters.map((filter) {
                                var parts = filter.split(':');
                                return {
                                  parts[0].trim().toLowerCase(): parts[1]
                                      .trim()
                                      .toLowerCase()
                                      .replaceAll(" ", "_"),
                                };
                              }).toList();

                          controller.applyFilter(controller.filterMaps.value);

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorRes.primary,
                          foregroundColor: ColorRes.white,
                          padding: const EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Obx(
                          () => Text(
                            'Apply Filters (${tempSelectedFilters.length})',
                            style: TextStyle(
                              fontSize: AppFontSizes.body,
                              fontWeight: AppFontWeights.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
  );
}

// Widget _buildFilterSection({
//   required BuildContext context,
//   required String title,
//   required IconData icon,
//   required String filterType,
//   required List<String> options,
//   required RxList<String> tempSelectedFilters,
//   required StateSetter setState,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       // Section header
//       Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: ColorRes.primary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, size: 18, color: ColorRes.primary),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: AppFontSizes.bodySmall,
//               fontWeight: AppFontWeights.semiBold,
//               color: ColorRes.textColor,
//             ),
//           ),
//         ],
//       ),
//       const SizedBox(height: 16),
//
//       // Filter chips
//       Wrap(
//         spacing: 8,
//         runSpacing: -4,
//         children:
//             options.map((option) {
//               return Obx(() {
//                 final fullFilterKey = '$filterType:$option';
//                 final isSelected = tempSelectedFilters.contains(fullFilterKey);
//
//                 return FilterChip(
//                   label: Text(option),
//                   selected: isSelected,
//                   onSelected: (selected) {
//                     if (selected) {
//                       if (!tempSelectedFilters.contains(fullFilterKey)) {
//                         tempSelectedFilters.add(fullFilterKey);
//                       }
//                     } else {
//                       tempSelectedFilters.remove(fullFilterKey);
//                     }
//                     setState(() {});
//                   },
//                   selectedColor: ColorRes.primary.withOpacity(0.15),
//                   checkmarkColor: ColorRes.primary,
//                   backgroundColor: ColorRes.leadGreyColor[100],
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                     side: BorderSide(
//                       color:
//                           isSelected
//                               ? ColorRes.primary
//                               : ColorRes.leadGreyColor[300]!,
//                       width: isSelected ? 1.5 : 1,
//                     ),
//                   ),
//                   labelStyle: TextStyle(
//                     color:
//                         isSelected ? ColorRes.primary : ColorRes.blackShade87,
//                     fontWeight:
//                         isSelected
//                             ? AppFontWeights.semiBold
//                             : AppFontWeights.regular,
//                     fontSize: AppFontSizes.small,
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                 );
//               });
//             }).toList(),
//       ),
//     ],
//   );
// }
Widget buildFilterSection({
  required BuildContext context,
  required String title,
  required IconData icon,
  required String filterType,
  required List<String> options,
  required RxList<String> tempSelectedFilters,
  required StateSetter setState,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Section header
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorRes.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: ColorRes.primary),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: AppFontSizes.bodySmall,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textColor,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),

      // Filter chips
      Wrap(
        spacing: 8,
        runSpacing: -4,
        children: options.map((option) {
          return Obx(() {
            final fullFilterKey = '$filterType:$option';

            // Only one selected per category
            final isSelected = tempSelectedFilters
                .any((e) => e.startsWith('$filterType:') && e == fullFilterKey);

            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                // Remove any existing filter of this type
                tempSelectedFilters
                    .removeWhere((e) => e.startsWith('$filterType:'));

                // Add new selection if selected
                if (selected) {
                  tempSelectedFilters.add(fullFilterKey);
                }
                setState(() {});
              },
              selectedColor: ColorRes.primary.withOpacity(0.15),
              checkmarkColor: ColorRes.primary,
              backgroundColor: ColorRes.leadGreyColor[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? ColorRes.primary
                      : ColorRes.leadGreyColor[300]!,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              labelStyle: TextStyle(
                color: isSelected ? ColorRes.primary : ColorRes.blackShade87,
                fontWeight:
                isSelected ? AppFontWeights.semiBold : AppFontWeights.regular,
                fontSize: AppFontSizes.small,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          });
        }).toList(),
      ),
    ],
  );
}

// Keep all other functions (showLeadForm, _buildFormField, showLeadDetails, etc.) unchanged


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
        borderSide: BorderSide(width: 1, color: ColorRes.grey.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(width: 1, color: ColorRes.primary),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(width: 1, color: ColorRes.grey.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(width: 1, color: ColorRes.grey.withOpacity(0.3)),
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

void showDeleteConfirmation(
  BuildContext context,
  LeadItem lead,
  DashboardController controller,
) {
  final leadController = Get.find<LeadController>(tag: "reseller");
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
    case LeadStatus.convert:
      return ColorRes.leadTealColor;
    case LeadStatus.all:
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
    case 'convert':
      return LeadStatus.convert;
    case 'all':
      return LeadStatus.all;
    default:
      return LeadStatus.all;
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
    case LeadStatus.all:
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
    case LeadStage.all:
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
    case 'all':
      return LeadStage.all;
    default:
      return LeadStage.all; // fallback
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
    case LeadStage.all:
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
