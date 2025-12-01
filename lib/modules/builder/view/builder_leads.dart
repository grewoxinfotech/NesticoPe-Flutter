import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/modules/common/lead_components/lead_components.dart';
import 'package:housing_flutter_app/modules/common/lead_components/lead_filter_helper.dart';

import '../../../data/network/property/models/property_model.dart';
import '../../../widgets/bottom_sheet/lead_filter_bottomsheet.dart';
import '../../../widgets/bottom_sheet/widgets/lead_filter_chips.dart';
import '../../seller/module/lead_screen/controllers/lead_controller.dart';
import '../../seller/module/lead_screen/model/lead_model.dart';

class BuilderLeads extends StatefulWidget {
  final bool isViewAll;

  const BuilderLeads({super.key, this.isViewAll = false});

  @override
  State<BuilderLeads> createState() => _BuilderLeadsState();
}

class _BuilderLeadsState extends State<BuilderLeads> {
  late final LeadController leadController;
  RxBool isLoadingLead = false.obs;
  String searchQuery = '';
  final RxList<String> selectedFilters = <String>[].obs;
  bool isLoading = false;

  @override
  void initState() {
    leadController =
        Get.isRegistered<LeadController>(tag: "seller")
            ? Get.find<LeadController>(tag: "seller")
            : Get.put(LeadController(), tag: "seller");

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData();
    });
  }

  Future<void> _loadData() async {
    isLoadingLead.value = true;
    leadController.items.clear();
    leadController.leadPropertiesList.clear();

    // Re-fetch fresh leads from API
    await leadController.refreshList();
    // if (widget.propertyId != null) {
    //   _applyPropertyFilter(leadController);
    // }
    isLoadingLead.value = false;
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
        title: const Text(
          'Leads',
          style: TextStyle(fontWeight: AppFontWeights.bold),
        ),
        automaticallyImplyLeading: widget.isViewAll,
        backgroundColor: ColorRes.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: ColorRes.primary),
            onPressed: () => showFilterBottomSheet(context, leadController),
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            buildSelectedFiltersChips(context, leadController, () async {
              leadController.filters.clear();
              await _loadData();
            }),
            Expanded(
              child:
                  leadController.isLoading.value && isLoadingLead.value
                      ? const Center(child: CircularProgressIndicator())
                      : leadController.items.isEmpty
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
                          padding: EdgeInsets.all(
                            getResponsivePadding(context),
                          ),
                          itemCount: leadController.items.length,
                          separatorBuilder:
                              (context, index) => SizedBox(
                                height: getResponsiveSpacing(context),
                              ),
                          itemBuilder: (context, index) {
                            final lead = leadController.items[index];
                            return LeadCardWidget(
                              lead: lead,
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
