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
  final dummyLeads = [
    LeadItem(
      id: "lead_001",
      createdBy: "admin_user",
      name: "John Doe",
      email: "john@example.com",
      phone: "+91 9876543210",
      status: "new",
      source: "Website",
      stage: "contacted",
      notes: "Interested in 2BHK apartment",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      customFields: Items(
        id: "property_001",
        title: "Modern 2BHK Apartment",
        type: "Residential",
        listingType: "Rent",
        propertyType: "Apartment",
        propertyDescription: "Spacious 2BHK flat near city center with all modern amenities.",
        propertyImages: [
          "https://picsum.photos/id/1018/800/400",
          "https://picsum.photos/id/1019/800/400",
        ],
        propertyDetails: PropertyDetails(
          bhk: 2,
          bathroom: 2,
          balcony: 1,
          amenities: ["Gym", "Swimming Pool", "Parking"],
          propertyBuiltUpArea: 1200.0,
          propertyBuiltUpAreaUnit: "sqft",
          propertyFacing: "East",
          floorInfo: FloorInfo(floorNumber: 3, totalFloors: 10),
          furnishInfo: FurnishInfo(
            furnishType: "Semi-Furnished",
            furnishDetails: FurnishDetails(
              modularKitchen: true,
              wardrobes: true,
              acInstalled: false,
            ),
          ),
          financialInfo: FinancialInfo(
            price: 3000000,
            propertyRentPerMonth: 15000,
            maintenance: 1000,
            pricePerSqft: 2500,
            negotiable: true,
          ),
          possessionInfo: PossessionInfo(
            possessionStatus: "Ready to Move",
            propertyAgeInYear: "2",
          ),
        ),
        address: "123 Main Street",
        city: "Pune",
        state: "Maharashtra",
        zipCode: "411001",
        builderName: "Skyline Builders",
        projectName: "Skyline Residency",
        ownerName: "Rahul Mehta",
        ownerPhone: "+91 9988776655",
        isVerified: true,
        createdAt: DateTime.now().toIso8601String(),
      ),
    ),

    LeadItem(
      id: "lead_002",
      createdBy: "agent_01",
      name: "Alice Brown",
      email: "alice.brown@example.com",
      phone: "+91 9123456789",
      status: "interested",
      source: "Agent Referral",
      stage: "site_visit_done",
      notes: "Visited site, requested price negotiation.",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      customFields: Items(
        id: "property_002",
        title: "Luxury Villa with Private Pool",
        type: "Residential",
        listingType: "Sale",
        propertyType: "Villa",
        propertyDescription: "Elegant 4BHK villa with private garden and swimming pool.",
        propertyImages: [
          "https://picsum.photos/id/1025/800/400",
          "https://picsum.photos/id/1026/800/400",
        ],
        propertyDetails: PropertyDetails(
          bhk: 4,
          bathroom: 4,
          balcony: 2,
          amenities: ["Private Pool", "Garden", "CCTV", "Power Backup"],
          propertyBuiltUpArea: 3500.0,
          propertyBuiltUpAreaUnit: "sqft",
          propertyFacing: "North",
          floorInfo: FloorInfo(floorNumber: 1, totalFloors: 2),
          furnishInfo: FurnishInfo(
            furnishType: "Fully-Furnished",
            furnishDetails: FurnishDetails(
              modularKitchen: true,
              wardrobes: true,
              acInstalled: true,
            ),
          ),
          financialInfo: FinancialInfo(
            price: 12000000,
            propertyRentPerMonth: 200,
            maintenance: 2500,
            pricePerSqft: 3400,
            negotiable: false,
          ),
          possessionInfo: PossessionInfo(
            possessionStatus: "Ready to Move",
            propertyAgeInYear: "1",
          ),
        ),
        address: "Palm Meadows, Whitefield",
        city: "Bangalore",
        state: "Karnataka",
        zipCode: "560066",
        builderName: "Prestige Group",
        projectName: "Palm Meadows Estate",
        ownerName: "Amit Sharma",
        ownerPhone: "+91 9898989898",
        isVerified: true,
        createdAt: DateTime.now().toIso8601String(),
      ),
    ),

    LeadItem(
      id: "lead_003",
      createdBy: "sales_team",
      name: "Michael Smith",
      email: "michael.smith@example.com",
      phone: "+91 9988776655",
      status: "new",
      source: "Social Media",
      stage: "new_lead",
      notes: "Generated via Instagram campaign for office space inquiry.",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      customFields: Items(
        id: "property_003",
        title: "Premium Office Space at Connaught Place",
        type: "Commercial",
        listingType: "Lease",
        propertyType: "Office",
        propertyDescription: "Furnished office with 20 workstations and 3 meeting rooms.",
        propertyImages: [
          "https://picsum.photos/id/1031/800/400",
          "https://picsum.photos/id/1032/800/400",
        ],
        propertyDetails: PropertyDetails(
          bhk: null,
          bathroom: 2,
          balcony: null,
          amenities: ["Conference Room", "Security", "Cafeteria", "Wi-Fi"],
          propertyBuiltUpArea: 2500.0,
          propertyBuiltUpAreaUnit: "sqft",
          propertyFacing: "West",
          floorInfo: FloorInfo(floorNumber: 5, totalFloors: 12),
          furnishInfo: FurnishInfo(
            furnishType: "Fully-Furnished",
            furnishDetails: FurnishDetails(
              modularKitchen: false,
              wardrobes: false,
              acInstalled: true,
            ),
          ),
          financialInfo: FinancialInfo(
            price: 2000,
            propertyRentPerMonth: 90000,
            maintenance: 5000,
            pricePerSqft: 5563,
            negotiable: true,
          ),
          possessionInfo: PossessionInfo(
            possessionStatus: "Ready to Move",
            propertyAgeInYear: "3",
          ),
        ),
        address: "Connaught Place",
        city: "New Delhi",
        state: "Delhi NCR",
        zipCode: "110001",
        builderName: "DLF Builders",
        projectName: "DLF Tower",
        ownerName: "Rohit Kapoor",
        ownerPhone: "+91 9000000000",
        isVerified: false,
        createdAt: DateTime.now().toIso8601String(),
      ),
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        leading: (widget.isViewAll)
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
            child: isLoading
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
                separatorBuilder: (context, index) => SizedBox(
                  height: getResponsiveSpacing(context),
                ),
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
                    onDelete: () => showDeleteConfirmation(context, lead),
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
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${lead.name} deleted')),
                );
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


