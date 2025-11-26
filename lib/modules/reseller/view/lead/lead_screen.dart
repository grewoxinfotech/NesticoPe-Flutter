import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/manager/property/property_pricemanager.dart';
import 'package:housing_flutter_app/modules/common/lead_components/lead_components.dart';
import 'package:housing_flutter_app/modules/common/lead_components/lead_filter_helper.dart';
import 'package:housing_flutter_app/modules/reseller/view/lead/add_lead_screen.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/model/lead_model.dart';
import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_controller.dart';
import 'package:housing_flutter_app/modules/reseller/controller/dashborad_controller/dashboard_controller.dart';
import 'package:housing_flutter_app/modules/reseller/view/lead_overview/lead_detail.dart';

import '../../../../data/network/property/models/property_model.dart';

class ResellerLeadScreen extends StatefulWidget {
  final bool isViewAll;

  const ResellerLeadScreen({super.key, this.isViewAll = false});

  @override
  State<ResellerLeadScreen> createState() => _ResellerLeadScreenState();
}

class _ResellerLeadScreenState extends State<ResellerLeadScreen> {
  @override

  Widget build(BuildContext context) {
    Get.lazyPut(() => LeadController(), tag: "reseller");
    final leadController = Get.find<LeadController>(tag: "reseller");
    final controller = Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        leading:
            (widget.isViewAll)
                ? IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                )
                : null,
        title: Text(
          'Property Buyer Leads',
          style: TextStyle(fontWeight: AppFontWeights.bold),
        ),
        automaticallyImplyLeading: (widget.isViewAll),
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
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: ColorRes.primary),
            onPressed: () {
              LeadFilterBottomSheet.show(
                context: context,
                selectedFilters: controller.selectedLeadFilters,
                onApplyFilters: () {
                  // Convert filters to API format and apply
                  final filterMap = LeadFilterHelper.convertFiltersToAPIFormat(
                    controller.selectedLeadFilters.toList(),
                  );
                  leadController.applyFilters(filterMap);
                },
              );
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
            // Search bar
            LeadSearchBar(
              onSearchChanged: controller.updateSearch,
            ),

            // Filter chips
            Obx(
              () => LeadFilterChips(
                selectedFilters: controller.selectedLeadFilters.toList(),
                onRemoveFilter: (filter) {
                  controller.removeLeadFilter(filter);
                  // Re-apply remaining filters to API
                  final filterMap = LeadFilterHelper.convertFiltersToAPIFormat(
                    controller.selectedLeadFilters.toList(),
                  );
                  leadController.applyFilters(filterMap);
                },
                onClearAll: () {
                  controller.clearLeadFilters();
                  // Clear filters in API
                  leadController.applyFilters({});
                },
              ),
            ),

            // Main content
            Expanded(
              child:
                  filteredLeads.isEmpty
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
                          padding: EdgeInsets.all(
                            getResponsivePadding(context),
                          ),
                          itemCount: filteredLeads.length,
                          separatorBuilder:
                              (context, index) => SizedBox(
                                height: getResponsiveSpacing(context),
                              ),
                          itemBuilder: (context, index) {
                            LeadItem lead = filteredLeads[index];
                            
                            // Find matching property price
                            String? propertyPrice;
                            if (lead.propertyId != null) {
                              final matchingProperty = leadController.leadPropertiesList
                                  .firstWhereOrNull((p) => p.id == lead.propertyId);
                              if (matchingProperty != null && 
                                  matchingProperty.propertyDetails?.financialInfo?.price != null) {
                                propertyPrice = PropertyPriceManager(
                                  listingType: matchingProperty.listingType ?? '',
                                  financialInfo: matchingProperty.propertyDetails?.financialInfo,
                                ).displayPrice;
                              }
                            }

                            return LeadCardWidget(
                              lead: lead,
                              isCompact: MediaQuery.of(context).size.width < 600,
                              showDataMasking: true, // Reseller needs masking
                              propertyPrice: propertyPrice,
                              leadPropertiesList: leadController.leadPropertiesList,
                              onTap: () {
                                Get.to(
                                  () => LeadDetailScreen(
                                    lead: lead,
                                    isFromLead: true,
                                  ),
                                );
                              },
                              onEdit: () {
                                leadController.resetForm();
                                Get.to(
                                  () => AddLeadScreen(
                                    lead: lead,
                                    isEditMode: true,
                                  ),
                                );
                              },
                              onDelete: () => _showDeleteConfirmation(
                                context,
                                lead,
                                leadController,
                              ),
                            );
                          },
                        ),
                      ),
            ),
          ],
        );
      }),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    LeadItem lead,
    LeadController leadController,
  ) {
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
}
