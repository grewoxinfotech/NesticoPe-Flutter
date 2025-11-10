import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/modules/common/lead_components/lead_components.dart';
import 'package:housing_flutter_app/modules/common/lead_components/lead_filter_helper.dart';

import '../../../data/network/property/models/property_model.dart';
import '../../seller/module/lead_screen/model/lead_model.dart';

class BuilderLeads extends StatefulWidget {
  final bool isViewAll;
  const BuilderLeads({super.key, this.isViewAll = false});

  @override
  State<BuilderLeads> createState() => _BuilderLeadsState();
}

class _BuilderLeadsState extends State<BuilderLeads> {
  String searchQuery = '';
  final RxList<String> selectedFilters = <String>[].obs;
  bool isLoading = false;

  // Dummy leads data
  final dummyLeads = [];

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.filter_list, color: ColorRes.primary),
            onPressed: () {
              LeadFilterBottomSheet.show(
                context: context,
                selectedFilters: selectedFilters,
                onApplyFilters: () {
                  setState(() {}); // Refresh UI after filter applied
                  // TODO: Apply filter to API here
                  applyFiltersToAPI();
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          LeadSearchBar(
            onSearchChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          Obx(
            () => LeadFilterChips(
              selectedFilters: selectedFilters.toList(),
              onRemoveFilter: (filter) {
                setState(() {
                  selectedFilters.remove(filter);
                });
                // TODO: Apply filter to API here
                // applyFiltersToAPI();
              },
              onClearAll: () {
                setState(() {
                  selectedFilters.clear();
                });
                // TODO: Clear filters from API here
                // clearFiltersFromAPI();
              },
            ),
          ),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : dummyLeads.isEmpty
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
                        setState(() {
                          isLoading = true;
                        });
                        await Future.delayed(Duration(seconds: 1));
                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: ListView.separated(
                        padding: EdgeInsets.all(getResponsivePadding(context)),
                        itemCount: dummyLeads.length,
                        separatorBuilder:
                            (context, index) =>
                                SizedBox(height: getResponsiveSpacing(context)),
                        itemBuilder: (context, index) {
                          final lead = dummyLeads[index];
                          return LeadCardWidget(
                            lead: lead,
                            isCompact: MediaQuery.of(context).size.width < 600,
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
    );
  }

  // Removed: All old widget building methods are now using shared components

  /// Apply filters to API
  /// Convert selectedFilters to API format and call backend
  void applyFiltersToAPI() {
    // Convert UI filter format to API format using helper
    final filterMap = LeadFilterHelper.convertFiltersToAPIFormat(
      selectedFilters.toList(),
    );

    if (filterMap.isEmpty) {
      // No filters, fetch all leads
      print('No filters applied, fetching all leads');
      // TODO: Implement builder-specific API call
      // builderLeadController.refreshList();
      return;
    }

    print('Applying filters to Builder API: $filterMap');
    // TODO: Call builder lead API with filterMap
    // Example:
    // builderLeadController.applyFilters(filterMap);
    // This will call the service with filters like:
    // {"stage": "new_lead", "status": "contacted"}
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
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('${lead.name} deleted')));
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

// Removed: formatPrice is now in lead_helpers.dart
